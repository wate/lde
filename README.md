nodejs
=========

Node.jsをインストールします

Role Variables
--------------

### nodejs_major_version

インストールするNode.jsのメジャーバージョンを指定します

```yaml
nodejs_major_version: 8
```

Dependencies
------------

* [repo-epel](https://github.com/wate/ansible-role-repo-epel)

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
     - { role: nodejs }
```

License
-------

MIT
