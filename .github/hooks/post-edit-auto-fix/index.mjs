#!/usr/bin/env node

import { readFileSync } from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { spawnSync } from 'node:child_process';
import { neutral, runHook } from '../lib/hook-io.mjs';
import { normalizeStringArray } from '../lib/config.mjs';

// 旧LocalハーネスとCopilotハーネス(Agent Host / Copilot SDK)ではツール名が異なる。
// CopilotハーネスはClaude互換名(Edit/Write)でペイロードを送るため(2026-10-05実測)、
// config.jsonが無い、またはtoolNamesの指定が無い場合の既定値にも両ハーネス名を含める。
const DEFAULT_TOOL_NAMES = Object.freeze([
  'apply_patch',
  'create_file',
  'replace_string_in_file',
  'multi_replace_string_in_file',
  'insert_edit_into_file',
  'Edit',
  'Write',
]);

const DEFAULT_CONFIG = Object.freeze({
  toolNames: DEFAULT_TOOL_NAMES,
  autoApply: true,
  rules: [],
});

/**
 * 実行対象ルール設定を読み込みます。
 *
 * @returns {{
 *   toolNames: Set<string>,
 *   autoApply: boolean,
 *   rules: Array<{ glob: string, excludeGlobs: string[], command: string, timeoutMs: number, cwd: string, autoApply?: boolean }>
 * }} 正規化済み設定
 */
function loadConfig() {
  const configUrl = new URL('./config.json', import.meta.url);

  try {
    const parsed = JSON.parse(readFileSync(configUrl, 'utf8'));
    const toolNames = normalizeStringArray(parsed.toolNames, DEFAULT_CONFIG.toolNames);
    const autoApply = typeof parsed.autoApply === 'boolean' ? parsed.autoApply : DEFAULT_CONFIG.autoApply;
    const rules = Array.isArray(parsed.rules)
      ? parsed.rules
          .filter((rule) => rule && typeof rule === 'object' && !Array.isArray(rule))
          .map((rule) => ({
            glob: typeof rule.glob === 'string' ? rule.glob.trim() : '',
            excludeGlobs: normalizeStringArray(rule.excludeGlobs),
            command: typeof rule.command === 'string' ? rule.command.trim() : '',
            timeoutMs: Number.isInteger(rule.timeoutMs) ? rule.timeoutMs : 180000,
            cwd: typeof rule.cwd === 'string' ? rule.cwd.trim() : '.',
            autoApply: typeof rule.autoApply === 'boolean' ? rule.autoApply : undefined,
          }))
          .filter((rule) => rule.glob && rule.command)
      : DEFAULT_CONFIG.rules;

    return {
      toolNames: new Set(toolNames),
      autoApply,
      rules,
    };
  } catch {
    return {
      toolNames: new Set(DEFAULT_CONFIG.toolNames),
      autoApply: DEFAULT_CONFIG.autoApply,
      rules: DEFAULT_CONFIG.rules,
    };
  }
}

/**
 * パスをワークスペース相対へ正規化します。
 *
 * @param {string} filePath ファイルパス
 * @param {string} baseDir ワークスペースディレクトリ
 * @returns {string} 正規化済み相対パス
 */
function toRelativePath(filePath, baseDir) {
  const resolved = path.isAbsolute(filePath) ? filePath : path.resolve(baseDir, filePath);
  const relativePath = path.relative(baseDir, resolved).replace(/\\/g, '/');

  if (!relativePath || relativePath.startsWith('..') || path.isAbsolute(relativePath)) {
    return '';
  }

  return relativePath;
}

/**
 * `apply_patch` の入力文字列から対象ファイルを抽出します。
 *
 * @param {string} patchInput apply_patch入力
 * @returns {string[]} 抽出したファイル一覧
 */
function extractFilesFromPatch(patchInput) {
  const lines = patchInput.split(/\r?\n/);
  const files = [];

  for (const line of lines) {
    const match = line.match(/^\*\*\*\s+(?:Add|Update|Delete)\s+File:\s+(.+)$/);
    if (!match) {
      continue;
    }

    const rawPath = match[1].trim();
    const cleanPath = rawPath.replace(/\s+->\s+.*$/, '').trim();
    if (cleanPath) {
      files.push(cleanPath);
    }
  }

  return files;
}

/**
 * フック対象ツール入力から編集ファイルパスを抽出します。
 *
 * create_file, replace_string_in_file, insert_edit_into_file は
 * toolInput.filePath から、multi_replace_string_in_file は
 * toolInput.replacements の各要素から、apply_patch はパッチ本文から抽出します。
 * Claude系ツール名(Edit, Write)はCopilotハーネス(Agent Host / Copilot SDK)が
 * 送る tool_input.path から抽出します(2026-10-05実測)。
 *
 * @param {string} toolName ツール名
 * @param {object} toolInput ツール入力
 * @returns {string[]} ファイルパス一覧
 */
function extractEditedFiles(toolName, toolInput) {
  if (!toolInput || typeof toolInput !== 'object') {
    return [];
  }

  // Claude系ツール名(Copilotハーネス): path / old_str / new_str
  if (toolName === 'Edit' || toolName === 'Write') {
    return typeof toolInput.path === 'string' ? [toolInput.path] : [];
  }

  if (toolName === 'create_file') {
    return extractPathOrFilePath(toolInput);
  }

  if (toolName === 'apply_patch') {
    return typeof toolInput.input === 'string' ? extractFilesFromPatch(toolInput.input) : [];
  }

  if (toolName === 'multi_replace_string_in_file') {
    if (!Array.isArray(toolInput.replacements)) {
      return [];
    }

    return toolInput.replacements
      .filter((replacement) => replacement && typeof replacement === 'object')
      .map((replacement) => replacement.filePath ?? replacement.path)
      .filter((filePath) => typeof filePath === 'string' && filePath.trim() !== '');
  }

  if (toolName === 'replace_string_in_file' || toolName === 'insert_edit_into_file') {
    return extractPathOrFilePath(toolInput);
  }

  return [];
}

/**
 * 編集対象ツールの入力からファイルパスを取り出します。
 *
 * 旧Localハーネスは`filePath`を、コパイロットハーネスは`path`を使うため、
 * ツール名とキーの組み合わせが入れ替わっても取り漏れないように双方を確認する。
 *
 * @param {object} toolInput ツール入力
 * @returns {string[]} ファイルパス一覧
 */
function extractPathOrFilePath(toolInput) {
  const rawPath =
    typeof toolInput.path === 'string' ? toolInput.path
    : typeof toolInput.filePath === 'string' ? toolInput.filePath
    : '';

  return rawPath ? [rawPath] : [];
}

/**
 * globパターンの波括弧展開を行います。
 *
 * @param {string} pattern globパターン
 * @returns {string[]} 展開済みパターン
 */
function expandBraces(pattern) {
  const firstOpen = pattern.indexOf('{');
  if (firstOpen < 0) {
    return [pattern];
  }

  const firstClose = pattern.indexOf('}', firstOpen + 1);
  if (firstClose < 0) {
    return [pattern];
  }

  const prefix = pattern.slice(0, firstOpen);
  const suffix = pattern.slice(firstClose + 1);
  const body = pattern.slice(firstOpen + 1, firstClose);
  const alternatives = body
    .split(',')
    .map((value) => value.trim())
    .filter(Boolean);

  if (alternatives.length === 0) {
    return [pattern];
  }

  const expanded = [];
  for (const alt of alternatives) {
    for (const tail of expandBraces(suffix)) {
      expanded.push(`${prefix}${alt}${tail}`);
    }
  }

  return expanded;
}

/**
 * globパターンを正規表現へ変換します。
 *
 * @param {string} pattern globパターン
 * @returns {RegExp} 変換済み正規表現
 */
function globToRegExp(pattern) {
  let source = '';

  for (let i = 0; i < pattern.length; i += 1) {
    const current = pattern[i];
    const next = pattern[i + 1];

    if (current === '*' && next === '*') {
      const afterDoubleStar = pattern[i + 2];
      if (afterDoubleStar === '/') {
        // **/ matches zero or more directories
        source += '(.*/)?';
        i += 2; // skip ** and /
      } else {
        source += '.*';
        i += 1;
      }
      continue;
    }

    if (current === '*') {
      source += '[^/]*';
      continue;
    }

    if (current === '?') {
      source += '[^/]';
      continue;
    }

    if ('\\^$+.|()[]{}'.includes(current)) {
      source += `\\${current}`;
      continue;
    }

    source += current;
  }

  return new RegExp(`^${source}$`);
}

/**
 * ファイルパスがglobに一致するか判定します。
 *
 * @param {string} filePath 相対ファイルパス
 * @param {string} glob globパターン
 * @returns {boolean} 一致した場合はtrue
 */
function matchesGlob(filePath, glob) {
  const normalizedGlob = glob.replace(/\\/g, '/').replace(/^\.\//, '');
  const expanded = expandBraces(normalizedGlob);

  return expanded.some((pattern) => {
    try {
      return globToRegExp(pattern).test(filePath);
    } catch {
      return false;
    }
  });
}

/**
 * ファイルパスが除外globに一致するか判定します。
 *
 * @param {string} filePath 相対ファイルパス
 * @param {string[]} excludeGlobs 除外glob一覧
 * @returns {boolean} 除外対象の場合はtrue
 */
function matchesAnyExcludeGlob(filePath, excludeGlobs) {
  if (!Array.isArray(excludeGlobs) || excludeGlobs.length === 0) {
    return false;
  }

  return excludeGlobs.some((glob) => matchesGlob(filePath, glob));
}

/**
 * シェル引数として安全に使えるようにエスケープします。
 *
 * @param {string} value 入力文字列
 * @returns {string} シングルクォートで保護した文字列
 */
function shellEscape(value) {
  return `'${String(value).replace(/'/g, `'"'"'`)}'`;
}

/**
 * プレースホルダーを実ファイル一覧で置換します。
 *
 * @param {string} command コマンドテンプレート
 * @param {string[]} files 相対ファイルパス
 * @returns {string} 実行コマンド
 */
function buildCommand(command, files) {
  const escapedFiles = files.map((file) => shellEscape(file));
  const firstFile = escapedFiles[0] ?? '';

  return command.replaceAll('{files}', escapedFiles.join(' ')).replaceAll('{firstFile}', firstFile);
}

/**
 * ルールを実行し、失敗時のメッセージを返します。
 *
 * @param {{ glob: string, excludeGlobs: string[], command: string, timeoutMs: number, cwd: string, autoApply?: boolean }} rule ルール設定
 * @param {string[]} files 対象ファイル
 * @param {string} workspaceCwd ワークスペースのcwd
 * @returns {string} 失敗メッセージ(成功時は空文字)
 */
function runRule(rule, files, workspaceCwd) {
  const command = buildCommand(rule.command, files);
  const targetCwd = path.resolve(workspaceCwd, rule.cwd || '.');
  const result = spawnSync(command, {
    shell: true,
    cwd: targetCwd,
    timeout: rule.timeoutMs,
    encoding: 'utf8',
  });

  if (result.status === 0) {
    return '';
  }

  const stderr = (result.stderr || '').trim();
  const stdout = (result.stdout || '').trim();
  const reason = stderr || stdout || `exit code ${result.status ?? 'unknown'}`;

  return `Rule failed (${rule.glob}): ${reason}`;
}

await runHook('post-edit-auto-fix', async (payload) => {
  const toolName = typeof payload.tool_name === 'string' ? payload.tool_name : '';
  const config = loadConfig();

  if (!config.toolNames.has(toolName)) {
    neutral();
    return;
  }

  const workspaceCwd =
    typeof payload.cwd === 'string' && payload.cwd.trim() ? path.resolve(payload.cwd) : process.cwd();
  const editedFiles = extractEditedFiles(toolName, payload.tool_input)
    .map((filePath) => toRelativePath(filePath, workspaceCwd))
    .filter(Boolean);

  if (editedFiles.length === 0 || config.rules.length === 0) {
    neutral();
    return;
  }

  const uniqueFiles = [...new Set(editedFiles)];
  const errors = [];

  for (const rule of config.rules) {
    const isAutoApply = typeof rule.autoApply === 'boolean' ? rule.autoApply : config.autoApply;
    if (!isAutoApply) {
      continue;
    }

    const matched = uniqueFiles.filter((filePath) => {
      if (!matchesGlob(filePath, rule.glob)) {
        return false;
      }

      return !matchesAnyExcludeGlob(filePath, rule.excludeGlobs);
    });
    if (matched.length === 0) {
      continue;
    }

    const errorMessage = runRule(rule, matched, workspaceCwd);
    if (errorMessage) {
      errors.push(errorMessage);
    }
  }

  if (errors.length > 0) {
    neutral(`post-edit-auto-fix warning: ${errors.join(' | ')}`);
    return;
  }

  neutral();
});
