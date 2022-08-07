lde(Local Development Environment)
=========

Ansibleを使ってローカル開発環境(LAMP)を構築します。

必要なもの
------------

* [Ansible](https://www.ansible.com/)
* [Vagrant](https://www.vagrantup.com/)
    * Ver 2.1.0以上
* [VirtualBox](https://www.virtualbox.org/)
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
    * Vagrantのプラグインです。
    * インストールしていなくても動作しますが、その場合はhostsファイルを手動書き換える必要があります。

その他、関連アプリ
------------

* [Vagrant Manager](http://vagrantmanager.com/)
    * 作成済みのローカル開発環境をGUI上から操作できます。
    * 黒い画面が苦手な人にお勧めです。

ディレクトリ構成
------------

ディレクトリ構成は以下の通りです。

```
├── LICENSE
│        ライセンスファイルです。
│        利用する場合はライセンスの内容を把握のうえご利用ください。
├── README.md
│        このファイルです。
├── config.yml
│        ローカル開発環境の設定ファイルです、利用する場合にはこのファイルを編集し利用します。
│        (設定内容の詳細は「設定方法」を参照)
├── src/
│        開発するソースコードを格納するディレクトリです。
│        (ここにソースコードを格納していきます)
├── Vagrantfile
│        Vagrantの設定ファイルです。
│        (※通常は変更する必要はありません)
└── provision/
          ローカル開発環境を構築する設定ファイル一式を格納しています。
          (※通常は変更する必要はありません)
```

設定方法
------------

### config.yml

ローカル開発環境の設定ファイルです。

| 設定項目    | 内容                                            |
| ----------- | ----------------------------------------------- |
| domain      | ローカル開発環境のドメインを設定します          |
| php_version | インストールするPHPのバージョンを指定します     |
| vagrant     | Vagrantで作成する仮想マシンの設定を指定します   |

#### domain

ローカル開発環境に設定するドメインを設定します。  
設定内容に応じて、以下のURLでローカル開発環境にアクセスできます。

* `http://<設定したドメイン>/`：ローカル開発環境の確認用URLです。
* `http://mailhog.<設定したドメイン>/`：[MailHog](https://github.com/mailhog/MailHog)用のURLです。
* `http://db.<設定したドメイン>/`：[phpMyAdmin](https://www.phpmyadmin.net/)用のURLです。
* `http://cache.<設定したドメイン>/`：[phpRedisAdmin](https://github.com/erikdubbelboer/phpRedisAdmin)用のURLです。
* `http://xhprof.<設定したドメイン>/`：[XHProf UI](https://github.com/preinheimer/xhprof)用のURLです。

#### php_version

インストールするPHPのバージョンを指定します。  
設定可能なバージョンは以下の通りです。

* 8.1
* 8.0
* 7.4
* 7.3
* 7.2
* 7.1
* 7.0

### extra_vars.yml

このファイルが存在する場合セットアップ時に読み込まれます。  
ファイル内に記載された内容はセットアップ用変数として、セットアップ処理に渡すことができます。

また、既に定義されているセットアップ用変数と同じ変数を定義すれば、  
セットアップ用変数を上書きできます。

### post_task.yml

このファイルが存在する場合、セットアップ時に自動で呼び出されます。  
記載方法は[Ansible](https://www.ansible.com/)の記載フォーマットで記載します。

ローカル開発環境のサーバー情報
------------

### データベース情報

ローカル開発環境では以下の4つのデータベースが利用できます。

| データベース名 | データベースユーザー名 | データベースパスワード |
| -------------- | ---------------------- | ---------------------- |
| app_dev        | app_dev                | app_dev_P455w0rd       |
| app_test       | app_test               | app_test_P455w0rd      |
| app_staging    | app_staging            | app_staging_P455w0rd   |
| app_prod       | app_prod               | app_prod_P455w0rd      |

### Webサーバー

ドキュメントルートに`/var/www/html`を設定しています。

### 共有ディレクトリの割当先について

ローカル開発環境全体を仮想マシンの`/vagrant`に割り当てています。

また、`app_type`の設定に応じて`src`ディレクトリを仮想マシンのディレクトリとして割り当てています。

ライセンス
-------

MIT
