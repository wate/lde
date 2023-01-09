lde(Local Development Environment)
=========

ローカル開発環境の構築用キットです。

必要なもの
------------

以下のいずれかが必要になります

### Vagrantを利用する場合

* [Vagrant](https://www.vagrantup.com/)
    * プラグイン：[vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
* [VirtualBox](https://www.virtualbox.org/)
* [Ansible](https://www.ansible.com/)

### dev containersを利用する場合

* [Visual Studio Code](https://code.visualstudio.com/)
    * 拡張機能：[Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
    * M1/M2 Macを利用している場合は`Apple Chip`版をインストールしてください。
    * Windowsを利用している場合は別途`WSL`が必要になります。

※Remote Developmentの詳細については、以下の公式サイトを参照してください。  
[Visual Studio Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview)

利用方法
------------

このリポジトリのファイル一式をダウンロードし既存のプロジェクトにファイルを追加し、  
ローカル開発環境をセットアップします。

利用するツールごとの利用方法は以下のとおりです。

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

### インストール済み開発関連ツール

* [pre-commit](https://pre-commit.com/)
* [pict](https://github.com/microsoft/pict)
    * [ペアワイズ法によるテストケース抽出ツール「PICT」を使ってテストケースを85%削減する](https://qiita.com/odekekepeanuts/items/6eceddc534d87fc797cc)
* [Graphviz](https://graphviz.org/)
* [PlantUML](https://plantuml.com/ja/)
* [d2](https://d2lang.com/)
* [tbls](https://github.com/k1LoW/tbls)
* [MailHog](https://github.com/mailhog/MailHog)
    * ※Vagrant利用時のみ
* [osv-scanner](https://github.com/google/osv-scanner)
    * ※Vagrant利用時のみ
