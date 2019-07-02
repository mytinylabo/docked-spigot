# Spigot on Docker

## 動かすまで

### リポジトリの取得
```
git clone https://github.com/mytinylabo/docked-spigot.git
cd docked-spigot
```

･･･と、必要なディレクトリの作成（TODO:リポジトリに含める）

```
mkdir data
```

### EULAの同意確認

MINECRAFT エンド ユーザー ライセンス条項 https://account.mojang.com/documents/minecraft_eula

spigot.env の内容を`EULA=true`に書き換えることで同意とみなす。

### MariaDBのパスワードを設定

```
echo MYSQL_ROOT_PASSWORD=hogehoge > secret.env
```

### イメージをビルド

（以下、`sudo`は環境によっては不要）

```
sudo docker-compose build
```

### Spigot起動

```
sudo docker-compose up -d
```

### Spigotのコンソールにアタッチ

```
sudo docker-compose exec spigot spigot-attach
```

メインプロセスは`docker-compose down`をフックするためにsleepループを回しているため、`sudo docker-compose attach spigot`ではアタッチできない。

### Spigot終了

```
sudo docker-compose down
```

### プラグインの導入

1回起動した後に data/plugins にプラグインのjarを配置する。

プラグインのデータ保存用にDBコンテナも立ち上がっているので、利用する場合はプラグインのconfigのそれらしい箇所に以下の値を設定する。

- 使用するDB: MariaDB (なければ MySQL)
- ホスト名: `db`
- ポート: `3306`
- データベース名: `spigot_plugins`
- ユーザー: `root`
- パスワード: secret.env で設定したパスワード

LuckPerms, CoreProtectでストレージをDBにできることを確認済み。
DynMapはMariaDBのドライバがないとかで詰まった･･･。
