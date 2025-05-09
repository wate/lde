ディレクトリ構造
=========================

プロジェクトは以下のディレクトリ構造で構成されています。  
各ディレクトリの役割と内容を把握し、適切な場所にファイルを配置してください。

```
├ .devcontainer/            # 開発環境構築用の設定ファイル格納ディレクトリ
├ bin/                      # 各種コマンド格納ディレクトリ
├ docs/                     # システムドキュメント格納ディレクトリ
│   ├ assets/                  # ドキュメントサイト生成時の画像などのリソースの格納ディレクトリ
│   ├ features/                # 機能一覧と各機能の詳細説明の格納ディレクトリ
│   ├ rules/                   # ドキュメントの表記統一ルールの格納ディレクトリ
│   ├ schema/                  # テーブル定義書の格納ディレクトリ
│   └ SUMMARY.md               # ドキュメントサイトのナビゲーション定義を記述するファイル
├ config/                   # システム設定ファイル格納ディレクトリ
│   ├ Migrations/              # マイグレーションファイル格納ディレクトリ
│   └ Seeds/                   # シードデータ格納ディレクトリ
├ src/                      # ソースコード格納ディレクトリ
│   ├ Command/                 # コマンドクラス格納ディレクトリ
│   ├ Controller/              # コントローラクラス格納ディレクトリ
│   │  └ Component/               # コンポーネントクラス格納ディレクトリ
│   ├ Form/                    # フォームクラス格納ディレクトリ
│   ├ Model/                   # モデル格納ディレクトリ
│   │  ├ Behavior/                # ビヘイビアクラス格納ディレクトリ
│   │  ├ Entity/                  # エンティティクラス格納ディレクトリ
│   │  └ Table/                   # テーブルクラス格納ディレクトリ
│   └ View/                    # ビュー格納ディレクトリ
│       └ Helper/                  # ヘルパークラス格納ディレクトリ
├ resources/                # リソースファイル格納ディレクトリ
├ templates/                # テンプレートファイル格納ディレクトリ
│   ├ element/                 # テンプレートの要素格納ディレクトリ
│   ├ layout/                  # テンプレートのレイアウト格納ディレクトリ
│   └ plugins/                 # プラグイン用のテンプレート格納ディレクトリ
├ tests/                    # テストコード格納ディレクトリ
│   ├ Fixture/                 # テスト用データ格納ディレクトリ
│   └ TestCase/                # テストケース格納ディレクトリ
│       ├ Command/                 # コマンドテスト格納ディレクトリ
│       ├ Controller/              # コントローラテスト格納ディレクトリ
│       │  └ Component/               # コンポーネントテスト格納ディレクトリ
│       ├ Model/                 # モデルテスト格納ディレクトリ
│       │  ├ Behavior/                # ビヘイビアテスト格納ディレクトリ
│       │  └ Table/                   # テーブルテスト格納ディレクトリ
│       ├ Form/                  # フォームテスト格納ディレクトリ
│       └ View/                  # ビューテスト格納ディレクトリ
│          └ Helper/                   # ヘルパーテスト格納ディレクトリ
├ tmp/                      # 一時ファイル格納ディレクトリ
│   └ cache/                   # キャッシュファイル格納ディレクトリ
│       ├ models/                  # モデルキャッシュ格納ディレクトリ
│       ├ persistent/              # 永続キャッシュ格納ディレクトリ
│       └ views/                   # ビューキャッシュ格納ディレクトリ
├ logs/                     # システムログ格納ディレクトリ
├ vendor/                   # 外部ライブラリ格納ディレクトリ
└ webroot/                  # ドキュメントルートディレクトリ
    ├ css/                      # CSSファイル格納ディレクトリ
    ├ js/                       # JavaScriptファイル格納ディレクトリ
    ├ img/                      # 画像ファイル格納ディレクトリ
    └ index.php                 # WebサーバのルートURLにアクセスした際に実行されるファイル
```
