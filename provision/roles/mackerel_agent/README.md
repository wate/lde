mackerel-agent
=========

[![Build Status](https://travis-ci.org/wate/ansible-role-mackerel-agent.svg?branch=master)](https://travis-ci.org/wate/ansible-role-mackerel-agent)

mackerel-agentのインストールとセットアップを行います。

Role Variables
--------------

### mackerel_agent_packages

インストールするパッケージを指定します

```yml
mackerel_agent_packages:
  - mackerel-agent
  - mackerel-agent-plugins
  - mackerel-check-plugins
  - mkr

```

### mackerel_agent_api_key

mackerel-agentのAPIキーを指定します。

```yml
mackerel_agent_api_key: "abcdefg"
```

### mackerel_agent_active_and_enabled_on_system_startup

mackerel-agentを起動させるかどうかを指定します。

この変数に`true`が設定されている場合、
mackerel-agentを有効に設定し起動させます。

この変数に`false`が設定されている場合、
mackerel-agentを無効に設定し停止させます。

```yml
mackerel_agent_active_and_enabled_on_system_startup: true
```

### mackerel_agent_extra_setting

mackerel-agentのチェックプラグインなどの設定を指定します

```yml
mackerel_agent_extra_setting: |
  [plugin.metrics.linux]
  command = "mackerel-plugin-linux"
  [plugin.checks.la]
  command = "check-load -w 3,2,1 -c 3,2,1"
  action = { command = "bash -c '[ \"$MACKEREL_STATUS\" != \"OK\" ]' && date >> /var/log/ps-auxf.txt && ps auxf >> /var/log/ps-auxf.txt", user = "root" }
  memo = "LAをチェックし、高騰したときにはそのときの ps auxf の結果を出力します"
```

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - role: mackerel-agent
```

License
-------

Apache License 2.0
