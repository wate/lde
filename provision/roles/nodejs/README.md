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
