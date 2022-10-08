# README
## 開発言語
ruby 3.0.4  
Rails 6.1.7

## アプリケーションに取り入れる技術(就業Termで学んだもの)
1. AWS EC2
2. devise
3. Ajax

## アプリケーションに取り入れる技術(カリキュラム外)
1. Vue.js
2. vuedraggable
3. omniauth-twitter


## アプリケーションの実行手順
```:terminal
git clone git@github.com:motoya0118/kj_method.git
cd kj_method
bundle install
rails db:create db:migrate
rails webpacker:install
rails s
```

## 設計資料
### チェックシート・カタログ設計・テーブル定義書
https://docs.google.com/spreadsheets/d/19gBtQsl7c9of99eKK8OHd9e151jE3XiGQxx48oJtnzw/edit#gid=1775028168

### ワイヤーフレーム
https://www.figma.com/proto/m8tBgLYaRxZ22maLygL4gL/Untitled?node-id=0%3A3&starting-point-node-id=0%3A3

### ER図
![デジタルKJ法_ER図](https://user-images.githubusercontent.com/90805736/194566957-da5ea5a8-967b-43a5-8fd8-a6d2829a3500.png)

### 画面遷移図
![デジタルKJ法_画面遷移図](https://user-images.githubusercontent.com/90805736/190155865-792bf749-a13e-4bae-851e-2402fc61adcd.png)

