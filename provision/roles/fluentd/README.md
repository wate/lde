fluentd
=========

[Fluentd](https://www.fluentd.org/)のインストールとセットアップを行います。


Role Variables
--------------

### fluentd_plugins

インストールするプラグインを指定します。

```yml
fluentd_plugins:
  - fluent-plugin-elasticsearch
  - fluent-plugin-influxdb
  - fluent-plugin-rewrite
```

### fluentd_source_cfg

sourceディレクティブの設定を定義します。

```yml
fluentd_source_cfg:
  - type: forward
  - type: http
    content: |
      port 8888
  - type: tail
    content: |
      <parse>
        @type apache2
      </parse>
      path /var/log/httpd-access.log
      tag apache.access
  - type: tail
    content: |
      <parse>
        @type nginx
      </parse>
      path /var/log/nginx/access.log
      tag nginx.access
```


### fluentd_filter_cfg

filterディレクティブの設定を定義します。

```yml
fluentd_filter_cfg:
  - pattern: foo.bar
    type: grep
    id: filter_grep
    content: |
      <regexp>
        key message
        pattern cool
      </regexp>
      <regexp>
        key hostname
        pattern ^web\d+\.example\.com$
      </regexp>
      <exclude>
        key message
        pattern uncool
      </exclude>
  - pattern: hoge.fuga
    type: stdout
```


### fluentd_match_cfg

matchディレクトリの設定を定義します。

```yml
fluentd_match_cfg:
  - pattern: td.*.*
    type: tdlog
    content: |
      apikey YOUR_API_KEY
      path /var/log/td-agent/access
      <buffer>
        @type file
        path /var/log/td-agent/buffer/td
      </buffer>
      <secondary>
        @type file
        path /var/log/td-agent/failed_records
      </secondary>
  - pattern: local.**
    type: file
    content: |
      path /var/log/td-agent/access
```

Example Playbook
----------------

```yml
- hosts: servers
  roles:
     - { role: fluentd }
```

License
-------

MIT
