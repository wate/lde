mailcatcher
=========

[MailCatcher](https://mailcatcher.me/)のインストールとセットアップを行います

Role Variables
--------------

### mailcatcher_smtp_ip

```yaml
mailcatcher_smtp_ip: 127.0.0.1
```

### mailcatcher_smtp_port

```yaml
mailcatcher_smtp_port: 1025
```

### mailcatcher_web_ip

```yaml
mailcatcher_web_ip: 127.0.0.1
```


### mailcatcher_web_port

```yaml
mailcatcher_web_port: 1080
```

Dependencies
------------

* [ruby](https://github.com/wate/ansible-role-ruby)

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
     - { role: mailcatcher }
```

License
-------

MIT
