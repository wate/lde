common
=========

ユーザーの追加や基本パッケージのインストールなど、サーバーの共通セットアップ処理を行います。

Role Variables
--------------

### common_groups

サーバーに登録/削除するグループを指定します。

```yml
common_groups:
  - name: group1
  - name: group2
    remove: yes
  - name: system_group
    system: yes
  - name: system_group_with_id
    id: 1000
    system: yes
```

### common_users

サーバーに登録/削除するユーザーを指定します。

```yaml
common_users:
  - name: sample_user
    # Optional
    password: "{{ 'password'|password_hash('sha512') }}"
    groups:
      - group1
      - group2
    authorized_keys:
      - "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
      - https://github.com/hoge.keys
    shell: /bin/nologin
    id: 100000
    system: yes
    admin: no
    remove: yes
```

### common_packages

インストールする基本パッケージを指定します。

```yaml
common_packages:
  - unzip
  - zip
  - perl
  - cpp
  - make
  - autoconf
  - automake
  - diffstat
  - m4
  - libtool
  - gcc
  - gcc-c++
  - patch
  - git
  - yum-utils
  - vim-enhanced
  - bash-completion
  - tig
```

### fail2ban_jail_cfg

fail2banの設定を定義します。

```yaml
fail2ban_jail_cfg:
  sshd:
    enabled: yes
```

### sudo_require_password

sudoで実行を行う場合にパスワードを求めるか否かを指定します。

```yaml
sudo_require_password: no
```

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
    - role: common
```

License
-------

MIT
