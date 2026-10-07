Dev Containerビルド失敗時のトラブルシューティング
=================================================

`additional privileges requested` でビルドが即時失敗する事象の原因と対処を示します。
この事象は上流ツールの修正で解消するため、解消後はこのファイルを削除します。

対象となる症状
-------------------------

### 発生する状況

Dev Containerの起動またはリビルドで、`docker compose build` が数秒以内に終了コード1で失敗します。
`Dockerfile` の記述内容まで到達しないため、ビルドログにパッケージ取得やコンパイルのエラーが出ません。

### ログに出るメッセージ

ホストのDev Containersログ(`remoteContainers-*.log`)に次の行が残ります(パスは省略しています)。

```text
additional privileges requested: pass "--allow=fs.read=…/Dockerfile-with-features" to grant requested privileges
```

原因
-------------------------

原因は `.devcontainer` の設定ではなく、ホスト側のDockerツールチェーンの組み合わせにあります。

- buildx v0.37.2以降では、セキュリティ修正(GHSA-gwr2-q96m-6682)により `bake --progress rawjson` 時のファイル読み取り権限検査が強制されます。
- Composeは `build.context` と `build.additional_contexts` にしか読み取り権限を付与しません。
- Dev Containers CLIはFeatures導入用の `Dockerfile-with-features` を一時ディレクトリへ生成し、`dockerfile:` でそれを指定します。
- 一時ディレクトリはビルドコンテキストの外にあるため権限が付与されず、検査で失敗します。

対処
-------------------------

buildxが提供する検査無効化スイッチ `BUILDX_BAKE_ENTITLEMENTS_FS=0` をホスト側に設定します。
この変数はDev Containers拡張が起動する `docker compose build` へ届く必要があるため、VS Codeのプロセスに渡します。

### macOS

ホストのターミナルで次を実行します。

```bash
launchctl setenv BUILDX_BAKE_ENTITLEMENTS_FS 0
```

設定後、VS Codeを終了して(`Cmd + Q`)再起動します。
ターミナルから `export BUILDX_BAKE_ENTITLEMENTS_FS=0 && code .` で起動する方法でも代用できます。

### Windows

ホストのターミナルで次を実行します。

```powershell
setx BUILDX_BAKE_ENTITLEMENTS_FS 0
```

設定後、VS Codeを終了して再起動します。

### Linux

シェル設定ファイル(`~/.profile` など)へ `export BUILDX_BAKE_ENTITLEMENTS_FS=0` を追記し、再ログインします。
ターミナルから `code .` で起動する方法でも代用できます。

検証
-------------------------

**重要**: VS Codeの再起動を省略すると、設定は反映されません。

1. VS Codeを再起動します。
2. コマンドパレットから「Dev Containers: Rebuild and Reopen in Container」を実行します。
3. ビルドが成功し、コンテナへ接続できることを確認します。
4. ホストのターミナルで `curl -s -o /dev/null -w '%{http_code}' http://localhost:8080` を実行し、`200` が返ることを確認します。

補足
-------------------------

### 設定を元に戻す

macOSでは次を実行します。

```bash
launchctl unsetenv BUILDX_BAKE_ENTITLEMENTS_FS
```

Windowsでは `setx BUILDX_BAKE_ENTITLEMENTS_FS ""` を実行します。
Linuxでは追記した行を削除して再ログインします。

### 副作用

この設定はbuildxのファイル読み取り権限検査をすべて無効化します。
信頼できるプロジェクトでの一時回避として使用し、恒久設定としては扱いません。

### 対象外

`.devcontainer` 配下の設定変更では解決しません。
恒久策はbuildxまたはCompose側の修正であり、修正リリース後はこのファイルと回避設定を撤去します。

### 参考情報

- [docker/compose#14285](https://github.com/docker/compose/issues/14285)
- [microsoft/vscode-remote-release#11887](https://github.com/microsoft/vscode-remote-release/issues/11887)
