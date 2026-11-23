フレームワークの雛形セットアップ
================================

`.devcontainer/provision/framework_setup.yml`は、CakePHPとLaravelの雛形を1つのコマンドで作るplaybookです。  
このDevContainerの設定を新しいプロジェクトへ移したときに使います。  
コンテナを作るとき(`post_create.sh`)からは読み込まないため、使うときにコマンドで実行します。

フレームワークの違いはこのplaybookが吸収するため、DevContainerの設定(イメージや`compose.yml`)は変えません。

使い方
-------------------------

### フレームワークの雛形を作る

プロジェクトのルートで次のコマンドを実行します。

```bash
ansible-playbook -i 127.0.0.1, -c local .devcontainer/provision/framework_setup.yml -e framework=cakephp
```

Laravelの雛形を作るときは、`framework=laravel`を指定します。

```bash
ansible-playbook -i 127.0.0.1, -c local .devcontainer/provision/framework_setup.yml -e framework=laravel
```

既定値では`/workspace`に雛形を作り、Webサーバーの公開先(`/var/www/html`)を雛形の公開フォルダーへ張り替えます。  
公開フォルダーは、CakePHPが`webroot`、Laravelが`public`です。

### 変数

`-e`で次の変数を指定できます。

- `framework`: 作る雛形の種類です(`cakephp`か`laravel`)。必ず指定します
- `project_dir`: 雛形を作るフォルダーの絶対パスです。既定値は`/workspace`です
- `allow_workspace`: `false`にすると、`/workspace`とその下へは作れません。テスト用の環境で使います
- `link_docroot`: `false`にすると、公開先を張り替えません。既定値は`true`です

### 実行が止まる場合

`project_dir`に`composer.json`がある場合は、雛形を作らずに止まります。  
既存のアプリを上書きしないための確認です。  
テンプレートのファイル(`.devcontainer/`など)が`project_dir`にあっても止まりません。

作られる雛形
-------------------------

CakePHPの雛形は、`.env`の読み込みの有効化、`josegonzalez/dotenv`と`phpstan/phpstan`の追加、`direnv`の設定まで行います。  
Laravelの雛形は、`.env`の接続先をDevContainerのMariaDB(`app_dev`)とMailpitへ向けます。  
どちらもデータベースは`app_dev`を使い、セッションとキャッシュはデータベースのテーブルを増やさないようファイルへ置きます。

Webサーバーが実行時に書き込むフォルダー(`tmp`、`logs`、`storage`など)は、公開先を張り替えて画面を表示できるよう書き込み権限を付けます。

トラブルシューティング
-------------------------

### 画面に500が出る場合

雛形のフォルダーの中に書かれるログ(`logs/`、`storage/logs/`)を確認します。  
データベースへ接続できない場合は、コンテナのMariaDBが起動しているかを確かめてください。

### 公開先を元に戻す場合

公開先を張り替えたくないときは`-e link_docroot=false`を付けます。  
張り替えた後で元に戻すときは、コンテナを作り直してください。
