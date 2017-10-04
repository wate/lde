lde
=========

Ansibleを使ってローカル開発環境(LAMP)を構築します。

必要なもの
------------

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)
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
このファイルを設定内容を変更することにより、ローカル開発環境のセットアップ内容を調整できます。

主な変更点は以下の通りです

1. 変数`domain`の内容を自身の独自ドメインに変更します。

### config.yml

Vagrantが作成する可能マシンの設定ファイルです。

このファイルの設定を書き換えることによりVagrantfileを変更することなく、  
Vagrantによって作成した仮想マシンの設定を変更できます。

Vagrantの設定を変更したい場合のみ、必要に応じてへ変更を行ってださい。

License
-------

MIT
