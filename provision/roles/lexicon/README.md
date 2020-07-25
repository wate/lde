lexicon
=========

[![Build Status](https://travis-ci.org/wate/ansible-role-lexicon.svg?branch=master)](https://travis-ci.org/wate/ansible-role-lexicon)

[lexicon](https://github.com/AnalogJ/lexicon)をインストールします

Role Variables
--------------

### lexicon_additional_packages

追加インストールするパッケージを指定します

```yaml
lexicon_additional_packages:
  - python2-dns-lexicon+route53
```

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
     - role: lexicon
```

License
-------

MIT
