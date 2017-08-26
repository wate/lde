lde
=========

Ansibleを使ってローカル開発環境(LAMP)を構築します。

必要なもの
------------

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)
* 独自ドメイン
* [Cloudflare](https://www.cloudflare.com/)の登録メールアドレスとAPIトークン
    * 上記の独自ドメインがCloudflareに登録されている必要があります。
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
    * Vagrantのプラグインです
    * インストールしていなくても動作しますが、  
      その場合はhostsファイルの書き換えを手動で行う必要があります


セットアップされるローカル開発環境の内容
------------

* www.<独自ドメイン>
    * sourceディレクトリをドキュメントルートとしてアクセスできるようにしています。
* mail.<独自ドメイン>
    * MailCatcherを利用できます。
* db.<独自ドメイン>
    * phpMyAdminを利用できます。
* er.<独自ドメイン>
    * WWW SQL Designerを利用できます。
* log.<独自ドメイン>
    * rtailのWebインターフェースを利用できます。


設定方法
------------

### provision/host_vars/default.yml

Ansibleの各ロールで設定されている変数の初期値を上書きするための変数定義ファイルです。  
このファイルを設定内湯を変更することにより、  
ローカル開発環境のセットアップ内容を調整できます。

以下が、主な変更内容です

1. 変数`domain`の内容を自身の独自ドメインに変更します。
2. 変数`cloudflare_email`の内容を自身のCloudflareの登録メールアドレスに変更します。
3. 変数`cloudflare_token`の内容を自身のCloudflareのAPIトークンに変更します。

2と3の手順は、`CLOUDFLARE_EMAIL`と`CLOUDFLARE_TOKEN`の環境変数を設定することで省略できます。

#### 環境変数の設定方法

~/.bashrcに以下の内容を追記し、CloudflareのAPI情報を環境変数に設定します。

```
export CLOUDFLARE_EMAIL=your@email-address.com
export CLOUDFLARE_TOKEN=abcdefghijklmnopqrstuvwxyz0123456789
```

### config.yml

Vagrantが作成する可能マシンの設定ファイルです。

このファイルの設定を書き換えることによりVagrantfileを変更することなく、  
Vagrantによって作成した仮想マシンの設定を変更できます。

Vagrantの設定を変更したい場合のみ、必要に応じてへ変更を行ってださい。

License
-------

MIT
