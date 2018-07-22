lde(Local Development Environment)
=========

Ansibleを使ってローカル開発環境(LAMP)を構築します。

必要なもの
------------

* [Vagrant](https://www.vagrantup.com/)
    * Ver 2.1.0以上
* [VirtualBox](https://www.virtualbox.org/)
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
    * Vagrantのプラグインです。
    * インストールしていなくても動作しますが、  
    その場合はhostsファイルを手動書き換える必要があります。

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
    * `source`ディレクトリ直下がドキュメントルートとして設定されます。
* `wordpress`：
    * WordPress開発用の環境として利用できます。
    * `source`ディレクトリ直下がドキュメントルートとして設定されます。
* `wordpress_theme`：
    * WordPressのテーマ開発用の環境として利用できます。
    * `source`ディレクトリ直下がWordPressのテーマ用ディレクトリとして設定されます。
* `wordpress_plugin`：
    * WordPressのプラグイン開発用の環境として利用できます。
    * `source`ディレクトリ直下がWordPressのプラグイン用ディレクトリとして設定されます。

#### domain

ローカル開発環境に設定するドメインを設定します。  
設定内容に応じて、以下のURLでローカル開発環境にアクセスできます。

* `http://<設定したドメイン>/`：ローカル開発環境の確認用URLです。
* `http://mail.<設定したドメイン>/`：[MailHog](https://github.com/mailhog/MailHog)用のURLです。
* `http://db.<設定したドメイン>/`：[phpMyAdmin](https://www.phpmyadmin.net/)用のURLです。
* `http://er.<設定したドメイン>/`：[WWW SQL Designer](https://github.com/ondras/wwwsqldesigner)用のURLです。
* `http://mock.<設定したドメイン>/`：[Bootstrap Page Generator](https://github.com/Vegetam/BootstrapPageGenerator)用のURLです。

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

設定可能な項目に関しては[config.yml](https://github.com/wate/lde/blob/master/config.yml#L7-L77)内にコメントで記載しています。

### extra_vars.yml

このファイルが存在する場合セットアップ時に読み込まれます。  
ファイル内に記載された内容はセットアップ用変数として、セットアップ処理に渡すことができます。

また、既に定義されているセットアップ用変数と同じ変数を定義すれば、  
セットアップ用変数を上書きできます。

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

# --------------
# PHPの設定を変更する
# --------------
php_cfg:
  display_errors: yes
  sendmail_path: /usr/local/bin/mhsendmail

# ----------
# 各PHPフレームワーク毎の設定例
# ----------
# ※「php_project_skeleton」は「post_task.yml」側で利用している変数

## CakePHP
doc_root_suffix: /webroot
php_project_skeleton: cakephp/app

## Laravel
# doc_root_suffix: /public
# php_project_skeleton: laravel/laravel

## Symfony
# doc_root_suffix: /public
# php_project_skeleton: symfony/website-skeleton

# FuelPHP
# doc_root_suffix: /public
# php_project_skeleton: fuel/fuel

## Slim
# doc_root_suffix: /public
# php_project_skeleton: slim/slim-skeleton
```


### post_task.yml

このファイルが存在する場合、セットアップ時に自動で呼び出されます。  
記載方法は[Ansible](https://www.ansible.com/)のplaybook形式で記載します。

#### サンプル

```yaml
- name: post tasks
  hosts: all
  become: yes
  tasks:
    - name: install xdebug
      yum:
        name: php-pecl-xdebug
    - name: check composer.json
      stat:
        path: /var/www/html/composer.json
      register: result
      tags: always
    - name: create PHP project
      block:
        - name: install oil command
          get_url:
            url: https://get.fuelphp.com/installer.sh
            dest: /usr/local/bin/oil
            mode: +x
          when:
            - php_project_skeleton is defined
            - php_project_skeleton == 'fuel/fuel'
        - block:
            - name: remove .gitkeep
              file:
                path: /var/www/html/.gitkeep
                state: absent
            - name: create project
              composer:
                command: create-project
                arguments: "--prefer-dist {{ php_project_skeleton }} ."
                no_dev: no
                prefer_dist: yes
                working_dir: /var/www/html
            - name: recreate .gitkeep
              file:
                path: /var/www/html/.gitkeep
                state: touch
          become: no
      when:
        - not result.stat.exists
        - php_project_skeleton is defined
      tags:
        - create_project_skeleton
```

### post_task.sh

このファイルが存在する場合、セットアップ時に自動で呼び出されます。  
処理内容はシェルスクリプトで記載します。

#### サンプル

```sh
#!/bin/bash
yum install -y --enablerepo=epel jq
```


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

※`app_type`に以下のいずれかが設定されている場合、  
**app_dev** の接続設定が利用されています。

* `wordpress_theme`
* `wordpress_theme`
* `wordpress_plugin`

### Webサーバー

ドキュメントルートに`/var/www/html`を設定しています。

### 共有ディレクトリの割当先について

ローカル開発環境全体を仮想マシンの`/vagrant`に割り当てています。

また、`app_type`の設定に応じて`source`ディレクトリを  
仮想マシンのディレクトリとして割り当てています。

#### `default`が設定されている場合

仮想マシンの`/var/www/html`として割り当てています。

#### `wordpress_theme`が設定されている場合

仮想マシンの`/var/www/html/wp-content/themes/source`として割り当てています。

#### `wordpress_plugin`が設定されている場合

仮想マシンの`/var/www/html/wp-content/plugins/source`として割り当てています。


WordPress用開発環境について
------------

### プラグインやテーマのインストール/アップデート方法

プラグインのインストールやプラグインの更新を行う場合、  
ダイアログに以下の情報を入力するとインストールまたはアップデートできます。

* ホスト名：localhost
* FTP/SSH ユーザー名：vagrant
* FTP/SSH パスワード：vagrant
* 接続形式：ssh2

※「SSH Authentication Keys」の設定は不要です。

その他
------------

仮想マシンを破棄するときに、ローカル開発環境が起動している場合は、  
データベースの内容を`db_dump.sql`というファイルに自動出力します。

ライセンス
-------

MIT
