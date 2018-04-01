pagegenerator
=========

[Bootstrap Page Generator](https://github.com/wate/BootstrapPageGenerator)をインストールします

Role Variables
--------------

### pagegenerator_varsion

チェックアウトするBootstrap Page Generatorのバージョン(ブランチ)を指定します。

```yaml
pagegenerator_varsion: master
```

Example Playbook
----------------


```yaml
- hosts: servers
  roles:
     - { role: pagegenerator }
```

License
-------

MIT
