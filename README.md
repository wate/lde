php
=========

PHPのインストールとセットアップを行います

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

* [repo-epel](https://github.com/wate/ansible-role-repo-remi)

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: php }

License
-------

MIT
