mailhog
=========

[![Build Status](https://travis-ci.org/wate/ansible-role-mailhog.svg?branch=master)](https://travis-ci.org/wate/ansible-role-mailhog)

HamilHogのインストールとセットアップを行います

Role Variables
--------------

### mailhog_version: v1.0.0

インストールするMailHogのバージョンを指定します

```yaml
mailhog_version: v1.0.0
```

### mailhog_mhsendmail_version

インストールするmhsendmailのバージョンを指定します

```yaml
mailhog_version: v0.2.0
```

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
     - role: mailhog
```

License
-------

MIT
