php
=========

[![Build Status](https://travis-ci.org/wate/ansible-role-php.svg?branch=master)](https://travis-ci.org/wate/ansible-role-php)

PHPのインストールとセットアップを行います

Role Variables
--------------

### php_version

インストールするPHPのバージョンを指定します

```yaml
php_version: 7.4
```

### php_packages

インストールするパッケージを指定します

```yaml
php_packages:
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
```

### php_cfg

php.iniの内容を定義します

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
    - role: php
```

License
-------

MIT
