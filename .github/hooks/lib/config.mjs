/**
 * @fileoverview フックの設定値の正規化
 *
 * `config.json`の値は型や空白が不正な場合があるため、読み込み時に正規化する。
 */

/**
 * 文字列配列の設定値を正規化します。
 *
 * 文字列以外を除き、前後の空白を取り除きます。
 * 配列でない場合は`fallback`のコピーを返します。
 *
 * @param {unknown} value 設定値
 * @param {string[]} [fallback] 配列でない場合の既定値
 * @param {{keepEmpty?: boolean}} [options] `true`の場合、空文字を残します(既定は`false`で除去)
 * @returns {string[]} 正規化した文字列配列
 */
export function normalizeStringArray(value, fallback = [], { keepEmpty = false } = {}) {
  if (!Array.isArray(value)) {
    return [...fallback];
  }

  const trimmed = value.filter((item) => typeof item === 'string').map((item) => item.trim());

  return keepEmpty ? trimmed : trimmed.filter(Boolean);
}
