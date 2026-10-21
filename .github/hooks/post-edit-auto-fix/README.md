post-edit-auto-fix設定ガイド
============================

概要
-------------------------

`post-edit-auto-fix`は、Copilotの`PostToolUse`フックで、編集されたファイルに対してLintの自動修正コマンドを実行するための設定です。

ファイル編集の直後に整形を走らせ、レビュー前に表記ゆれや体裁の崩れを減らすことを目的としています。

構成
-------------------------

- `../post-edit-auto-fix.json`: フック定義ファイル
- `index.mjs`: 対象ファイル抽出とルール実行ロジック
- `config.sample.json`: 実行ルールの雛形
- `README.md`: この設定ガイド

配布するのは`index.mjs`、`config.sample.json`、`README.md`の3ファイルと、  
フック定義の`../post-edit-auto-fix.json`です。

自動整形を有効にするには、`config.sample.json`を同じディレクトリへ`config.json`としてコピーし、  
導入先のツールに合わせて書き換えてください。

`config.json`が無い場合も、フックは起動します。
ただし適用するルールが0件のため、ファイルを書き換えず、警告も表示しません。

設定項目
-------------------------

### toolNames

フックを起動する対象ツール名です。
既定値は次のとおりです。

- `apply_patch`
- `create_file`
- `replace_string_in_file`
- `multi_replace_string_in_file`
- `insert_edit_into_file`
- `Edit`(Copilotハーネス: ファイル編集)
- `Write`(Copilotハーネス: ファイル新規作成)

旧LocalハーネスとCopilotハーネス(Agent Host / Copilot SDK)はツール名が異なります。
`config.json`で`toolNames`を指定する場合も、両ハーネスで動かすには双方の名前を列挙してください。

### autoApply

ルールを自動適用するかどうかの真偽値です。
`false`の場合はどのルールも実行しません。

### rules

実行するコマンドをルール単位で定義します。
各ルールは次の項目を持ちます。

- `glob`: 対象ファイルのglobパターンです(`**/*.md`など)
- `excludeGlobs`: 対象から除外するglobパターンの配列です
- `command`: 実行するコマンドです(プレースホルダーを展開します)
- `timeoutMs`: コマンドのタイムアウト時間です(ミリ秒)
- `cwd`: コマンドを実行するディレクトリです(既定はプロジェクトルート)
- `autoApply`: ルール単位で自動適用を上書きします(省略可)

`command`では`{files}`を一致したファイル一覧へ、`{firstFile}`を先頭のファイルへ置換します。
ファイルパスはシェル向けにエスケープされます。

判定ルール
-------------------------

1. 対象ツールが`toolNames`に含まれること
2. 編集ファイルが`glob`に一致し、`excludeGlobs`に一致しないこと
3. `autoApply`が`true`であること

一致したルールのコマンドを順に実行します。
失敗した場合は`systemMessage`で警告を返し、処理は継続します。
