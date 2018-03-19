lde(Local Development Environment)
=========

Ansibleを使ってローカル開発環境(LAMP)を構築します。

必要なもの
------------

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
    * Vagrantのプラグインです。
    * インストールしていなくても動作しますが、  
    その場合はhostsファイルを手動書き換える必要があります。

その他、関連アプリ
------------

* [Vagrant Manager](http://vagrantmanager.com/)
    * 作成済みのローカル開発環境をGUI上から操作することができます。
    * 黒い画面が苦手な人にお勧めです。

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

このファイルが存在する場合セットアップ時に読み込まれます。  
ファイル内に記載された内容はセットアップ用変数として、セットアップ処理に渡すことができます。

また、既に定義されているセットアップ用変数と同じ変数を定義すれば、  
セットアップ用変数を上書きすることができます。

#### サンプル

```yaml
# --------------
# インストールするPHPのパッケージの変更する
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

このファイルが存在する場合、セットアップ時に自動で呼び出されます。  
記載方法は[Ansible](https://www.ansible.com/)のplaybook形式で記載する必要があります。

#### サンプル

```yaml
- name: post task
  hosts: all
  become: yes
  tasks:
    ## ここ以下に追加の処理を記載していきます
    - name: install The Silver Searcher
      yum:
        name: the_silver_searcher
```

### post_task.sh

このファイルが存在する場合、セットアップ時に自動で呼び出されます。  
記載方法はシェルスクリプトと同じです。

#### サンプル

```sh
#!/bin/bash
yum install -y --enablerepo=epel jq
```

License
-------

MIT
