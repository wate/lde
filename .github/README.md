GitHub Copilot設定ガイド
=========================

このディレクトリは、GitHub Copilotと協働するための設定一式です。  
別プロジェクトへこの仕組みを組み込む手順を、このファイルで説明します。

導入先では、このディレクトリから必要なファイルをコピーして使います。

組み込み方法
-------------------------

組み込みに必要な最小構成は、次の2つだけです。

- `hooks/`: 承認制御、コンテキスト注入、編集後の自動整形を行うフックです。
- `processes/`: 注入する索引と、作業手順書の本体です。

すでに別プロジェクトで`copilot-instructions.md`を運用していても、  
この2つを`.github/`へ置けば組み込めます。

### コピーの注意

- `hooks/`は`lib/`から読み込むため、ディレクトリごとコピーします。
- `hooks/`は`processes/index.md`の実在を前提とします。
- `processes/index.md`が無い場合、フックは警告を返して何も注入しません。
- `processes/`は単体では自動で読まれません。`hooks/`かAGENTS.mdの導線が必要です。

### 任意で追加できるもの

次の2つは必須ではありません。  
既存の運用があるプロジェクトでは、そのまま流用できます。

- `copilot-instructions.md`: 全作業に常時適用される協働方針です。
- `instructions/`: ファイル種別に応じて自動適用される規約です。

各部品の書式や探索ルールはVS Codeが定めています。
参照先のURLは、末尾の「公式ドキュメント」にまとめています。

仕組み
-------------------------

`processes/`はVS Codeの公式機能ではありません。
本リポジトリが独自に用意した作業手順書の置き場です。

### 索引の注入

フックを使い、セッション開始時に索引をシステムプロンプト相当の文脈へ注入します。
注入された索引を起点に、開発時に必要なドキュメントを読み込ませます。

```mermaid
flowchart LR
    A["セッション開始"] --> B["SessionStartフックが発火"]
    B --> C["processes/index.md を読み込む"]
    C --> D["additionalContext として返す"]
    D --> E["会話コンテキストへ注入"]
    E --> F["エージェントが索引を起点に該当プロセスを読み込む"]
```

処理の流れは次のとおりです。

1. Copilotがセッションを開始し、`hooks/session-context-inject.json`の`SessionStart`が発火します。
2. `hooks/session-context-inject/index.mjs`が実行され、設定に従ってファイルを読み込みます。
3. 読み込んだ本文を`additionalContext`として標準出力へ返します。
4. Copilotがその内容を会話コンテキストへ挿入します。
5. エージェントは索引を手がかりに、作業内容へ該当するプロセスを読み込みます。

注入の既定値は`processes/index.md`です。
索引には振り分けの情報だけを置き、ドキュメント本体は必要になってから読ませます。

### 設定の変更

注入する対象は`hooks/session-context-inject/config.json`で指定します。
`config.json`が無い場合は、内蔵の既定値で`processes/index.md`を注入します。
設定項目の詳細は[設定ガイド](hooks/session-context-inject/README.md)を参照してください。

### 動作の前提

フックを動かすには、次の条件を満たす必要があります。

- VS Codeの`chat.useHooks`が有効であること(既定で有効)
- ワークスペースが信頼されていること
- Node.jsの実行環境があり、`node`コマンドが利用できること

編集後の自動整形
-------------------------

`hooks/post-edit-auto-fix.json`は、ファイル編集の直後に整形コマンドを実行するフックです。
`PostToolUse`で起動し、編集されたファイルのうち`glob`に一致するものへコマンドを適用します。

構成は次のとおりです。

- `hooks/post-edit-auto-fix.json`: フック定義ファイルです。
- `hooks/post-edit-auto-fix/index.mjs`: 対象ファイルの抽出とルールの実行を担います。
- `hooks/post-edit-auto-fix/config.sample.json`: 実行ルールの雛形です。
- `hooks/post-edit-auto-fix/README.md`: 設定項目と判定ルールの説明です。

配布するのは`hooks/post-edit-auto-fix/`配下の3ファイル(`index.mjs`、`config.sample.json`、`README.md`)と、フック定義の`hooks/post-edit-auto-fix.json`です。

自動整形を有効にするには、`config.sample.json`を同じディレクトリへ`config.json`としてコピーし、  
導入先のツールに合わせて書き換えてください。

`config.json`が無い場合も、フックは編集のたびに起動します。
ただし適用するルールが0件のため、ファイルを書き換えず、警告も表示しません。

### 設定項目

`config.json`では`toolNames`、`autoApply`、`rules`を指定します。
`rules`の各要素は、`glob`、`excludeGlobs`、`command`、`timeoutMs`、`cwd`、`autoApply`を持ちます。
`command`では`{files}`を一致したファイル一覧へ、`{firstFile}`を先頭のファイルへ置換します。
`toolNames`には、旧LocalハーネスとCopilotハーネスの双方のツール名を既定で含みます。

`config.sample.json`には、次の4つのルールを定義しています。

- `**/*.php`: `composer run cs-fix -- {files}`
- `**/*.md`: `npx textlint --fix {files}`
- `**/*.{md,txt}`: `npx markdownlint-cli --fix {files}`
- `templates/**/*.{js,ts,css,scss}`: `npx prettier --write {files}`

このサンプルは雛形であり、除外設定などの詳細は`hooks/post-edit-auto-fix/README.md`に記載しています。
導入先のツールに合わせて書き換えてください。

### 実行条件

フックを動かすには、次の条件を満たす必要があります。

- `PostToolUse`フックが有効であること
- `node`コマンドが利用できること

コマンドが失敗した場合は警告を返し、処理は継続します。

変更時の注意
-------------------------

**注意**: `processes/index.md`は毎セッション注入されます。
内容を厚くすると、コンテキストを圧迫します。

- 索引には振り分けの情報だけを置き、詳細は各プロセスファイルへ書きます。
- 注入対象を増やす場合は`config.json`で指定します。
- 索引が無いと条件付き参照が働かないため、索引から各プロセスへの導線を維持します。

**注意**: `post-edit-auto-fix`のルールは、編集直後にファイルを書き換えます。
意図しない変更を避けるため、`excludeGlobs`で対象を絞ってください。

関連リンク
-------------------------

### 公式ドキュメント

- [エージェントカスタマイズの概要](https://code.visualstudio.com/docs/agent-customization/overview)
- [カスタムインストラクション](https://code.visualstudio.com/docs/agent-customization/custom-instructions)
- [プロンプトファイル](https://code.visualstudio.com/docs/agent-customization/prompt-files)
- [エージェントフック](https://code.visualstudio.com/docs/agent-customization/hooks)
- [ローカルフックリファレンス](https://code.visualstudio.com/docs/agents/reference/hooks-reference)

### 本リポジトリ内

- [Copilot協働方針](copilot-instructions.md)
- [設定ガイド](hooks/session-context-inject/README.md)
- [post-edit-auto-fix設定ガイド](hooks/post-edit-auto-fix/README.md)
- [プロセス索引](processes/index.md)
