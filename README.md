# メモアプリ（sinatra-practice）
メモアプリです。メモのタイトルと内容を登録・閲覧・編集・削除することができます。

## インストール・起動方法
### DB設定
事前にDBを設定してください。PostgreSQL 9.3以上が必要です。
以下を実行してデータベースを作成、接続してください
```
$ createdb memos
$ psql memos
```

データベースに接続したら、以下を実行してテーブルを作成してください。
```
CREATE TABLE memos (
    memo_id     varchar(36),
    title    text,
    content    text,
    PRIMARY KEY(memo_id)
);
```
### 必要ライブラリのインストール
git cloneしたディレクトリで以下を実行してライブラリをインストールしてください。
```
$ bundle install
```
### サーバーの起動
ライブラリがインストールできたら以下を実行してサーバーを起動してください。
```
$ bundle exec ruby ./myapp.rb
```
## アプリの使用方法
ブラウザで`http://localhost:4567/memos` にアクセスするとアプリを使用することができます。
