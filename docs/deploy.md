デプロイ方法
============================

Github Actionsにより各ブランチごとに専用の環境に自動でデプロイされますが、  
以下のコマンドを実行することで各環境に手動でデプロイを行うことができます。

前提条件
----------------------------

以下の2つが必要になります。

* [Ansible](https://www.ansible.com/)がインストールされている
    * インストール方法は[Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/index.html)を参照してください
* 各デプロイ環境にSSH接続ができる

手動デプロイ方法
----------------------------

### 開発環境への手動デプロイ

以下のコマンドを実行すると、  
`develop`ブランチの内容が開発環境にデプロイされます。

```sh
ansible-playbook deploy.yml --limit development
```

### ステージング環境への手動デプロイ

以下のコマンドを実行すると、  
`staging`ブランチの内容がステージング環境にデプロイされます。

```sh
ansible-playbook deploy.yml --limit staging
```

### 本番環境への手動デプロイ

以下のコマンドを実行すると、  
`master`ブランチの内容がステージング環境にデプロイされます。

```sh
ansible-playbook deploy.yml --limit production
```
