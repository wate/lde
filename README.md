lde(Local Development Environment)
=========

ローカル開発環境構築用のスケルトンリポジトリです。  
既存プロジェクトにこのリポジトリの内容ダウンロードし利用することを想定しています。

利用環境
------------

Vagrant + Ansibleの利用を想定しているおり、主にmacOSでの利用を想定しています。
※VirtualBoxを利用する関係上、M1/M2 Macの環境は想定していません。

※VSCode + Dockerを前提とした[Devcontainer](https://code.visualstudio.com/docs/devcontainers/containers)にも対応させていますが、  
Vagarnt利用時ほど開発環境としての完成度は見込んでいません。
(非エンジニア向けの動作確認環境としても利用可能という程度の想定です)

必要なもの
------------

以下のいずれかが必要になります

### Vagrantを利用する場合

* [Vagrant](https://www.vagrantup.com/)
    * [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)プラグイン
* [VirtualBox](https://www.virtualbox.org/)
* [Ansible](https://www.ansible.com/)

### devcontainerを利用する場合

* [Visual Studio Code](https://code.visualstudio.com/)
    * 拡張機能：[Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
    * M1/M2 Macを利用している場合は`Apple Chip`版をインストールしてください。
    * Windowsを利用している場合は別途`WSL`が必要になります。

※Remote Developmentの詳細については、以下の公式サイトを参照してください。  
[Visual Studio Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview)

利用方法
------------

このリポジトリのファイル一式をダウンロードし、既存のプロジェクトにファイルを追加後、  
利用するローカル開発環境ごとに応じたセットアップを行います。

利用するローカル開発環境ごとのセットアップ方法は以下のとおりです。

### Vagrantを利用する場合

ターミナルを起動し、以下のコマンドを実行するとローカル開発環境が開始されます。

```
cd ${PROJECT_ROOT}
vagrant up
```

※`${PROJECT_ROOT}`はプロジェクトディレクトリのパスを表しています。

Vagrantの詳細な使い方については公式サイトなどを参照してください。

### dev containersを利用する場合

Visual Studo Codeを起動し、プロジェクトのディレクトリを開きます、  
次に`F1`キーを押し、`Reopen in Container`をクリックするとローカル開発環境の構築が開始されます。

dev containersの詳細な使い方は公式サイトなどを参照してください。

ローカル開発環境のサーバー情報
------------

### データベース情報

ローカル開発環境では以下の4つのデータベースが利用できます。

| データベース名 | データベースユーザー名 | データベースパスワード |
| -------------- | ---------------------- | ---------------------- |
| app_dev        | app_dev                | app_dev_password       |
| app_test       | app_test               | app_test_password      |
| app_staging    | app_staging            | app_staging_password   |
| app_prod       | app_prod               | app_prod_password      |

※デフォルトで`app_dev`を利用するように設定されます。

### 利用環境ごとのデータベースのホスト名

利用している環境ごとのデータベースのホスト名は以下のとおりです。

* Vagrantを利用する場合：`localhost`
* dev containersを利用する場合：`db`

### インストール済み開発関連ツール

* [pre-commit](https://pre-commit.com/)
* [tbls](https://github.com/k1LoW/tbls)
* [pict](https://github.com/microsoft/pict)
    * [ペアワイズ法によるテストケース抽出ツール「PICT」を使ってテストケースを85%削減する](https://qiita.com/odekekepeanuts/items/6eceddc534d87fc797cc)
* [Graphviz](https://graphviz.org/)
* [PlantUML](https://plantuml.com/ja/)
* [d2](https://d2lang.com/)
    * [VSCode extension for D2 files](https://marketplace.visualstudio.com/items?itemName=terrastruct.d2)
* [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
    * [mkdocs-tooltips](https://squidfunk.github.io/mkdocs-material/reference/tooltips/)
    * [mkdocs-git-revision-date-localized-plugin](https://timvink.github.io/mkdocs-git-revision-date-localized-plugin/)
    * [mkdocs-blogging-plugin](https://liang2kl.cn/mkdocs-blogging-plugin/)
    * [mkdocs-exclude](https://github.com/apenwarr/mkdocs-exclude)
* [mycli](https://www.mycli.net/)
* [lizard](http://www.lizard.ws/)
    * [サイクロマティック複雑度の計測ツール「lizard」のセットアップ&使い方](https://qiita.com/uhooi/items/a1a96a2d7f5e081e2049)
* [osv-scanner](https://github.com/google/osv-scanner)
* [Mailpit](https://github.com/axllent/mailpit)
    * ※Vagrant利用時のみ

Tips
------------

### CakePHPのメール送信方法を環境変数で設定する

`config/.env`に以下のようにメール送信方法の環境変数を設定します。

※以下の設定は[mailtrap](https://mailtrap.io/)を使ってメールの送信テストを行う場合の設定例です。  
(`<username>`および`<password>`は適時変更してください。)

```
export EMAIL_TRANSPORT_DEFAULT_URL=smtp://<username>:<password>@smtp.mailtrap.io:2525
```

### 環境変数を利用したVagrantの制御

```
# Webブラウザからこのドメインにアクセスした時に仮想マシンに接続できるようになります
# デフォルトでは`lde.local`に設定さてれています
# ※この設定を有効にするにはvagrant-hostsupdaterプラグインが必要になります
export VAGRAN_VM_DOMAIN="example.com"

# /etc/hostsファイルに設定する追加のホスト名
# ※この設定を有効にするにはvagrant-hostsupdaterプラグインが必要になります
export VAGRANT_VM_HOST_DB="db.example.com"

# ポートフォワード設定
# ※デフォルトではゲストマシンの80番ポートがホストマシンの8080番ポートにマッピングされています
# 「VAGRANT_FORWARD_PORT_」で始まる環境変数が設定として認識されます
# ゲストマシンのポート番号をホストマシンの別のポート番号としてマッピング
export VAGRANT_FORWARD_PORT_MARIADB="3306 => 3307"
# ゲストマシンのポート番号をそのままホストマシンのポート番号にマッピング
export VAGRANT_FORWARD_PORT_XDEBUG="9003"

# 共有ディレクトリの設定を行います
# ※デフォルトではホストマシンの「.(カレントディレクトリ)」がゲストマシンの「/vagrant」にマッピングされています。
# 「VAGRANT_SYNC_FOLDER_」で始まる環境変数が設定として認識されます
export VAGRANT_SYNC_FOLDER_DB_SCHMA_DOC="path/to/scheme => /vagrant/docs/schema"

# プロビジョニング実行時にAnsibleの追加パラメーター
# 「VAGRANT_ANSIBLE_RAW_ARGMENT_」で始まる環境変数が設定として認識されます
export VAGRANT_ANSIBLE_RAW_ARGMENT_DIFF="--diff"

# プロビジョニング実行時に実行するタグ
# 「VAGRANT_ANSIBLE_TAG_」で始まる環境変数が設定として認識されます
export VAGRANT_ANSIBLE_TAG_CAKEPHP="role_cakephp"

# プロビジョニング実行時にスキップするタグ
# 「VAGRANT_ANSIBLE_SKIP_TAG_」で始まる環境変数が設定として認識されます
export VAGRANT_ANSIBLE_SKIP_TAG_COMMON="role_common"
```
