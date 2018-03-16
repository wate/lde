lde(Local Development Environment)
=========

Ansibleを使ってローカル開発環境(LAMP)を構築します。

必要なもの
------------

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
    * Vagrantのプラグインです。
    * インストールしていなくても動作しますが、その場合はhostsファイルの書き換えを手動で行う必要があります。

ディレクトリ構成
------------

ディレクトリ構成は以下の通りです

```
├── LICENSE
│        ライセンスファイルです。
│        利用する場合はライセンスの内容を把握のうえご利用ください。
├── README.md
│        このファイルです。
├── config.yml
│        ローカル開発環境の設定ファイルです、利用する場合にはこのファイルを編集し利用します。
│        (設定内容の詳細は「設定方法」を参照)
├── source/
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

| 設定項目    | 内容                                          |
| ----------- | --------------------------------------------- |
| app_type    | ローカル開発環境の種別を設定します            |
| domain      | ローカル開発環境のドメインを設定します        |
| php_version | インストールするPHPのバージョンを指定します   |
| wordpress   | WordPressのインストール設定を指定します       |
| vagrant     | Vagrantで作成する仮想マシンの設定を指定します |

#### app_type

ローカル開発環境の種別を設定します。

指定できる値は以下の取りです。

* `default`：
    * 汎用的なPHPアプリケーション開発に利用できます。
    * `source`ディレクトリ直下がWebサーバーのドキュメントルートとして設定されます。
* `wordpress_theme`：
    * WordPressのテーマ開発用の環境として利用できます。
    * `source`ディレクトリ直下がWordPressのテーマ用ディレクトリとして設定されます。
* `wordpress_plugin`：
    * WordPressのプラグイン開発用の環境として利用できます。
    * `source`ディレクトリ直下がWordPressのプラグイン用ディレクトリとして設定されます。

#### domain

ローカル開発環境に設定するドメインを設定します。
設定内容に応じて、以下のURLでローカル開発環境にアクセスすることができます。

* www.<独自ドメイン>：ローカル開発環境の確認用URLです。
* mail.<独自ドメイン>：[MailCatcher](https://mailcatcher.me/)用のURLです。
* db.<独自ドメイン>：[phpMyAdmin](https://www.phpmyadmin.net/)用のURLです。
* er.<独自ドメイン>：[WWW SQL Designer](https://github.com/ondras/wwwsqldesigner)用のURLです。

#### php_version

インストールするPHPのバージョンを指定します。
設定可能なバージョンは以下の通りです。

* 5.4
* 5.5
* 5.6
* 7.0
* 7.1
* 7.2

#### wordpress

`app_type`に`wordpress_theme`または`wordpress_plugin`を設定している場合に、
インストールするWordPressの情報を設定します。

設定可能な項目に関しては`config.yml`内にコメントで記載しています。

### extra_vars.yml

このファイルを作成し変数を定義すると、
セットアップ時に利用する変数の内容を上書きすることができます。

```yaml
# --------------
# インストールするPHPのパッケージを指定する
# --------------
php_packages:
  - php
  - php-common
  - php-cli
  - php-devel
  - php-opcache
  - php-mbstring
  - php-mysqlnd
  - php-json
  - php-pdo
  - php-gd
  - php-xml
  - php-pecl-xdebug

# --------------
# PHPの設定を変更する
# --------------
php_cfg:
  display_errors: yes
  sendmail_path: "/usr/bin/env catchmail -f admin@{{ domain }}"

# --------------
# MariaDBのSQLモードを変更する
# --------------
mariadb_cfg:
  mysqld:
    sql_mode: NO_ENGINE_SUBSTITUTION
```


### post_task.yml

このファイルを作成し変数を定義すると、
セットアップ時の変数の内容を上書きすることができます。

```yaml
- hosts: all
  become: yes
  tasks:
    # 以下に実行する追加タスクを記載する
    - debug:
        msg: "some post task"
```

License
-------

MIT
