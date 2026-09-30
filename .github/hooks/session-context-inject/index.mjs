#!/usr/bin/env node

import { readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { neutral, printJson, runHook } from '../lib/hook-io.mjs';
import { normalizeStringArray } from '../lib/config.mjs';

const CONFIG_URL = new URL('./config.json', import.meta.url);

const DEFAULT_CONFIG = Object.freeze({
  files: Object.freeze(['.github/processes/index.md']),
  warnOnMissing: true,
});

/**
 * config.jsonの`files`配列・`warnOnMissing`真偽値を読み込み、正規化します。
 * config.jsonが存在しない、またはパースに失敗した場合はDEFAULT_CONFIGを使用します。
 *
 * @returns {{ files: string[], warnOnMissing: boolean }} 正規化済み設定
 */
function loadConfig() {
  try {
    const parsed = JSON.parse(readFileSync(CONFIG_URL, 'utf8'));
    const files = normalizeStringArray(parsed.files, DEFAULT_CONFIG.files);
    const warnOnMissing =
      typeof parsed.warnOnMissing === 'boolean' ? parsed.warnOnMissing : DEFAULT_CONFIG.warnOnMissing;

    return { files, warnOnMissing };
  } catch {
    return { files: [...DEFAULT_CONFIG.files], warnOnMissing: DEFAULT_CONFIG.warnOnMissing };
  }
}

/**
 * 指定されたファイル群の本文を読み込み、連結します。
 * 存在しない、または空文字のファイルはスキップし、`skippedFiles`に記録します。
 *
 * @param {string[]} files ファイルパス一覧(workspaceCwdからの相対パスまたは絶対パス)
 * @param {string} workspaceCwd ワークスペースのcwd
 * @returns {{ content: string, skippedFiles: string[] }} 連結済みの本文とスキップしたファイル一覧
 */
function collectFileContents(files, workspaceCwd) {
  const sections = [];
  const skippedFiles = [];

  for (const file of files) {
    const resolved = path.isAbsolute(file) ? file : path.resolve(workspaceCwd, file);

    if (!existsSync(resolved)) {
      skippedFiles.push(file);
      continue;
    }

    const content = readFileSync(resolved, 'utf8').trim();
    if (!content) {
      skippedFiles.push(file);
      continue;
    }

    sections.push(`<!-- ${file} -->\n${content}`);
  }

  return { content: sections.join('\n\n'), skippedFiles };
}

/**
 * 連結済みの本文を追加コンテキストとして注入します。
 *
 * @param {string} content 連結済みの本文
 * @param {string} [warning] スキップしたファイルがある場合の警告メッセージ
 * @returns {void}
 */
function injectContext(content, warning = '') {
  const payload = {
    hookSpecificOutput: {
      hookEventName: 'SessionStart',
      additionalContext: content,
    },
  };

  if (warning) {
    payload.systemMessage = warning;
  }

  printJson(payload);
}

await runHook('session-context-inject', async (payload) => {
  const workspaceCwd =
    typeof payload.cwd === 'string' && payload.cwd.trim() ? path.resolve(payload.cwd) : process.cwd();

  const { files, warnOnMissing } = loadConfig();
  if (files.length === 0) {
    neutral();
    return;
  }

  const { content, skippedFiles } = collectFileContents(files, workspaceCwd);
  const warning =
    warnOnMissing && skippedFiles.length > 0
      ? `session-context-inject: skipped missing or empty files: ${skippedFiles.join(', ')}`
      : '';

  if (!content) {
    neutral(warning);
    return;
  }

  injectContext(content, warning);
});
