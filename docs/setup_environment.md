開発環境の構築
============================

以下のいずれかの方法で開発環境を構築することができます。

* [Docker][] + [VSCode][] + [Dev Containers][]
* [Vagrant][] + [VirtualBox][]

[Docker]: https://www.docker.com/
[VSCode]: https://code.visualstudio.com/
[Dev Containers]: https://code.visualstudio.com/docs/remote/containers
[Vagrant]: https://www.vagrantup.com/
[VirtualBox]: https://www.virtualbox.org/

[Docker][] + [VSCode][] + [Dev Containers][]
--------------------------------------------

### 前提条件

* [Docker Desktop][]がインストールされていること
* [VSCode][]がインストールされていること
    * [Dev Containers][]拡張機能がインストールされていること
        * Windowsの場合は、WSL2を有効にしておくこと

[Docker Desktop]: https://www.docker.com/ja-jp/products/docker-desktop/

### 手順

1. 本リポジトリをクローンする
2. VSCodeで本リポジトリを開く
3. コマンドパレットを開き`開発コンテナー:コンテナーで再度開く`をクリックする
   * コマンドパレットを開くには、`Ctrl+Shift+P`を押します
4. コンテナが起動するのを待つ
   * 初回起動時は構築処理が発生するため時間がかかります
5. 開発を開始する

[Vagrant][] + [VirtualBox][]
--------------------------------------------

### 前提条件

* [Vagrant][]がインストールされていること
* [VirtualBox][]がインストールされていること

### 手順

1. 本リポジトリをクローンする
2. ターミナルで本リポジトリのディレクトリに移動する
3. `vagrant up`を実行する
4. 開発環境が起動するのを待つ
   * 初回起動時はマシンイメージのダウンロードおよび構築処理が発生するため時間がかかります
5. 開発を開始する
