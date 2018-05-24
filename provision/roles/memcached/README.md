memcached
=========

memcachedのインストールとセットアップを行います。

Role Variables
--------------

### memcached_cfg

memcachedのオプションを指定します。

```yml
memcached_cfg:
  port: 11211
  user: memcached
  maxconn: 1024
  cachesize: 64
  options: ""
```

Example Playbook
----------------

```yml
- hosts: servers
  roles:
     - { role: memcached }
```

License
-------

MIT
