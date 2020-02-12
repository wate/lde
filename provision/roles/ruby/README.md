ruby
=========

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
     - { role: ruby }
```

License
-------

MIT
