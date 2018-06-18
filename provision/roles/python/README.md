python
=========

Pythonの基本パッケージをインストールします

Role Variables
--------------

### python_packages

インストールするパッケージを指定します

```yaml
python_packages:
  - python-setuptools
  - python2-pip
  - python-devel
```

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
     - { role: python }
```

License
-------

MIT
