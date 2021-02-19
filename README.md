wwwsqldesigner
=========

[![Build Status](https://travis-ci.org/wate/ansible-role-wwwsqldesigner.svg?branch=master)](https://travis-ci.org/wate/ansible-role-wwwsqldesigner)

[WWW SQL Designer](https://github.com/ondras/wwwsqldesigner)をインストールします

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

* [php](https://github.com/wate/ansible-role-php)

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - role: wwwsqldesigner
```

License
-------

MIT
