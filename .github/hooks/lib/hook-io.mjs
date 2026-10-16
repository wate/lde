/**
 * @fileoverview フック共通の入出力処理
 *
 * 標準入力のペイロード読み取り、判定結果の出力、失敗時のフェイルセーフをまとめる。
 * 失敗時は判定せず、通常の承認フローへ委ねる。
 */

import process from 'node:process';

export const TERMINAL_TOOLS = new Set(['run_in_terminal', 'send_to_terminal']);

// CLAUDE系ツール名: Copilotハーネス(Agent Host / Copilot SDK)は
// Claude互換のツール名でペイロードを送る(2026-10-05実測: Edit, Read は確認済み)。
// Bash: ターミナル実行(tool_input.command は旧ハーネスと同一形状、2026-10-05実測)
export const CLAUDE_TERMINAL_TOOLS = new Set(['Bash']);

/**
 * ツール名がターミナル系ツールか判定します。
 *
 * 旧Localハーネス名とClaude系ツール名の双方に対応する。
 *
 * @param {string} toolName ツール名
 * @returns {boolean} ターミナル系ツールの場合はtrue
 */
export function isTerminalTool(toolName) {
  return TERMINAL_TOOLS.has(toolName) || CLAUDE_TERMINAL_TOOLS.has(toolName);
}

/**
 * 標準入力からフックのJSONペイロードを読み取ります。
 *
 * @returns {Promise<string>} 標準入力の文字列
 */
export function readStdin() {
  return new Promise((resolve, reject) => {
    let data = '';
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', (chunk) => {
      data += chunk;
    });
    process.stdin.on('end', () => resolve(data));
    process.stdin.on('error', reject);
  });
}

/**
 * JSONを標準出力へ書き出します。
 *
 * @param {object} payload 出力するJSONオブジェクト
 * @returns {void}
 */
export function printJson(payload) {
  process.stdout.write(`${JSON.stringify(payload)}\n`);
}

/**
 * 判定を行わず、通常の処理へ委ねます。
 *
 * @param {string} [systemMessage] 任意の補足メッセージ
 * @returns {void}
 */
export function neutral(systemMessage = '') {
  printJson(systemMessage ? { continue: true, systemMessage } : { continue: true });
}

/**
 * PreToolUseの判定を出力します。
 *
 * @param {'allow'|'ask'|'deny'} decision 判定
 * @param {string} reason 判定理由
 * @returns {void}
 */
export function decide(decision, reason) {
  printJson({
    hookSpecificOutput: {
      hookEventName: 'PreToolUse',
      permissionDecision: decision,
      permissionDecisionReason: reason,
    },
  });
}

/**
 * ツール入力から実行コマンド文字列を取り出します。
 *
 * @param {string} toolName ツール名
 * @param {object} toolInput ツール入力
 * @returns {string} 実行コマンド。ターミナル系ツール以外は空文字
 */
export function extractCommand(toolName, toolInput) {
  if (!isTerminalTool(toolName) || !toolInput || typeof toolInput !== 'object') {
    return '';
  }

  return typeof toolInput.command === 'string' ? toolInput.command : '';
}

/**
 * フックを実行します。
 *
 * ペイロードを読み取って`handler`へ渡します。
 * 読み取りや処理で例外が発生した場合は、判定せず警告メッセージ付きで通常の処理へ委ねます。
 *
 * @param {string} hookName フック名(警告メッセージに使用)
 * @param {(payload: object) => Promise<void>|void} handler ペイロードを処理して出力する関数
 * @returns {Promise<void>} 実行結果
 */
export async function runHook(hookName, handler) {
  try {
    const rawInput = await readStdin();
    const payload = rawInput.trim() ? JSON.parse(rawInput) : {};

    await handler(payload);
  } catch (error) {
    neutral(`${hookName} hook warning: ${error instanceof Error ? error.message : String(error)}`);
  }
}

/**
 * ターミナルコマンドを対象とするPreToolUseフックを実行します。
 *
 * ターミナル系以外のツールは判定しません。
 * `judge`が判定を返した場合はそれを出力し、返さない場合は通常の承認フローへ委ねます。
 *
 * @param {string} hookName フック名
 * @param {(command: string, payload: object) => {decision: 'allow'|'ask'|'deny', reason: string}|undefined} judge 判定関数
 * @returns {Promise<void>} 実行結果
 */
export async function runTerminalCommandHook(hookName, judge) {
  await runHook(hookName, (payload) => {
    const toolName = typeof payload.tool_name === 'string' ? payload.tool_name : '';

    if (!isTerminalTool(toolName)) {
      neutral();
      return;
    }

    const result = judge(extractCommand(toolName, payload.tool_input), payload);

    if (result) {
      decide(result.decision, result.reason);
      return;
    }

    neutral();
  });
}
