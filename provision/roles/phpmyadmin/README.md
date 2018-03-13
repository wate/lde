phpmyadmin
=========

phpMyAdminをインストールします

Dependencies
------------

* [repo-epel](https://github.com/wate/ansible-role-repo-epel)
* [php](https://github.com/wate/ansible-role-php)

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
     - { role: phpmyadmin }
```

License
-------

MIT
