# アプリケーション概要
[ReserveSpace](https://www.reserve-space.net/)
レンタルスペースの予約管理、決済代行サービスです。

# 機能

共通
- スペース検索
- スペース地図確認

掲載者（オーナー）
- deviseによるログイン・ログアウト・登録・編集・削除
- スペース登録・削除・編集
- スペース設定編集
- 予約一覧確認
- 予約検索
- 予約CSV出力
- スペースのPV確認

利用者（ユーザー）
- deviseによるログイン・ログアウト・登録・編集・削除
- 予約作成・キャンセル
- 予約履歴確認
- 決済
- お気に入り登録・削除
- レビュー投稿・削除


# 使用技術

■言語  
Ruby 2.5.8

■フレームワーク  
Ruby on Rails 5.2.4.2

■テスティングフレームワーク  
RSpec

■CSSフレームワーク  
Bootstrap4

■CI  
circleCI

■テンプレートエンジン  
slim

■リンター  
Rubocop  
Slim-lint

■セキュリティチェック  
Brakeman

■API  
Pay.jp  
Google Map

■インフラ  
AWS EC2  
Docker

■データベース  
AWS RDS  
Postgresql 12.3

■ドメイン  
AWS Route53

■SSL証明書  
AWS ACM

■画像保存  
AWS S3

■メール  
Gmail

■アプリケーションサーバー  
puma

■webサーバー  
nginx
