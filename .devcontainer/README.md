ローカル開発環境の設定ガイド
=========================

`.devcontainer`には、Dev ContainerとVagrantの2つの環境の設定が入っています。
ディレクトリ名からDev Container専用に見えますが、Vagrantの設定もここにあります。
この資料では、どちらか一方だけを使う場合に必要なファイルが分かるように説明します。

Dev Container用の設定
-------------------------

VS CodeのDev Container機能で利用する設定です。
`app`、`database`、`mailpit`の3つのコンテナで構成し、PHPとNode.jsの開発環境を提供します。

### ディレクトリ構造

```text
.devcontainer/
├ devcontainer.json         # Dev Containerの定義
├ compose.yml               # Dev Containerのサービス構成
├ Dockerfile                # Dev Containerのイメージ定義
├ provision/                # Dev Containerの初期セットアップ
│   ├ post_create.sh       # コンテナ作成時のスクリプト
│   ├ post_create.yml      # コンテナ作成時のプレイブック
│   ├ post_start.sh        # コンテナ起動時のスクリプト
│   ├ post_start.yml       # コンテナ起動時のプレイブック
│   ├ requirements.yml     # 外部ロールの定義
│   └ tasks/               # プロビジョニング用の個別タスク
├ mariadb/                  # MariaDBの設定と初期データ
├ php/                      # PHPの設定
└ log/                      # PHPエラーログの出力先
```

### 関連ファイル

- `devcontainer.json`: Dev Containerの定義ファイルで、利用するサービスや起動時のコマンドを指定します。
- `compose.yml`: コンテナの構成を定義するファイルです。
- `Dockerfile`: PHP、Node.js、開発ツールをインストールするイメージ定義です。
- `provision/`: コンテナの作成時と起動時に実行するセットアップ処理を格納しています。
    - `post_create.sh`: コンテナ作成時に実行されるスクリプトです。
    - `post_create.yml`: 開発ツールとシェル環境を設定するプレイブックです。
    - `post_start.sh`: コンテナ起動時に実行されるスクリプトです。
    - `post_start.yml`: `Taskfile.yml`を初期化するプレイブックです。
    - `requirements.yml`: 外部ロールを定義するファイルです。
    - `tasks/`: プロビジョニング用の個別タスクを格納しています。
- `mariadb/create_db.sql`: 4つのデータベースとユーザーを作成するSQLです。
- `mariadb/z-customize.cnf`: MariaDBの設定ファイルです。
- `php/z-custom.ini`: PHPの設定ファイルです。
- `log/`: PHPのエラーログ出力先です。

### 抽出時の注意

- `.devcontainer`というディレクトリ名を前提にパスを解決しているため、配置先でも同じ名前にしてください。
- `compose.yml`は親ディレクトリを`/workspace`にマウントするため、リポジトリ直下に配置してください。
- `log/`は空のディレクトリでも作成してください。
- `provision/verify.yml`と`provision/custom.yml`は、用意した場合のみ実行される任意の拡張ポイントです。

Vagrant用の設定
-------------------------

リポジトリ直下の`Vagrantfile`から参照される設定です。
仮想マシン上にWebサーバー、データベース、メール、検索などのミドルウェアを構築します。

### ディレクトリ構造

```text
.devcontainer/
├ ansible.cfg              # Ansibleの共通設定
├ playbook.yml             # 仮想マシンのプロビジョニング
├ verify.yml               # 検証プレイブック
├ verify/                  # 検証項目ごとのタスク
├ report.yml               # レポート生成プレイブック
├ requirements.yml         # 外部ロールの定義
├ group_vars/              # Ansibleの共通変数
├ host_vars/               # Ansibleのホスト変数
├ roles/                   # Ansibleのローカルロール
├ custom_scripts/          # プロビジョニング用の独自スクリプト
└ vagrant_trigger/         # Vagrantのトリガースクリプト
```

### 関連ファイル

- `../Vagrantfile`: Vagrantの起点となるファイルで、`.devcontainer`配下の設定を参照します。
- `../provision.sample.yml`: プロビジョニング設定のサンプルファイルです。
- `../provision.yml`: プロビジョニングの実行オプションを定義するファイルです。
- `ansible.cfg`: Ansibleの共通設定ファイルです。
- `playbook.yml`: 仮想マシン全体のプロビジョニングを行うプレイブックです。
- `requirements.yml`: 外部ロールを定義するファイルです。
- `group_vars/all.yml`: PHP、MariaDB、Nginx、Apacheなどの共通変数を定義するファイルです。
- `host_vars/`: ホスト単位の変数を格納するディレクトリです。
    - `default.yml`: ローカル環境向けの変数を定義するファイルです。
- `roles/`: リポジトリ内で管理するAnsibleロールです。
    - `cakephp/`: CakePHPプロジェクトのセットアップ処理です。
    - `lde/`: ローカル開発環境の共通設定です。
    - `phpredisadmin/`: phpRedisAdminのセットアップ処理です。
    - `webfont/`: Webフォントの生成処理です。
- `verify.yml`: 構築結果を検証するプレイブックです。
- `verify/`: 検証項目ごとのタスクファイルを格納しています。
- `report.yml`: 運用情報のレポートを生成するプレイブックです。
- `custom_scripts/`: プロビジョニング時に配置する独自スクリプトです。
- `vagrant_trigger/`: Vagrantの各イベントで実行するトリガースクリプトです。

### 抽出時の注意

- `Vagrantfile`はリポジトリ直下に配置してください。
- `provision.yml`はリポジトリ直下または`.devcontainer`配下に配置できます。
- `ansible.cfg`の`roles_path`はVagrantが管理する`.vagrant`配下を指すため、単独では動作しません。

関連ドキュメント
-------------------------

- [リポジトリのREADME](../README.md): 環境の利用方法と接続情報を記載しています。
- [開発環境の構築方法](../docs/setup_environment.md): Dev ContainerとVagrantの構築手順を記載しています。
