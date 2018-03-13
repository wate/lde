repo-epel
=========

epelリポジトリのインストールとセットアップを行います


Role Variables
--------------

### repo_epel_enabled

インストール後にリポジトリを有効化するか否かを指定します。

```
repo_epel_enabled: yes
```

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
     - { role: repo-epel }
```

License
-------

MIT
