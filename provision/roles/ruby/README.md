ruby
=========

[![Build Status](https://travis-ci.org/wate/ansible-role-ruby.svg?branch=master)](https://travis-ci.org/wate/ansible-role-ruby)

Rubyの基本パッケージをインストールします

Role Variables
--------------

### python_packages

インストールするパッケージを指定します

```yaml
ruby_packages:
  - ruby
  - ruby-devel
  - rubygems
```

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
     - role: ruby
```

License
-------

MIT
