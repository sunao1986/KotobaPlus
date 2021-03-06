# アプリ名:KotobaPlus(コトバプラス)
## 概要
コトバにコトバをストックさせるメモ帳
## 開発をした理由
#### 「消したいけど消せない言葉の場所を作りたかったから」
&ensp;メモは思いついた時にすぐ記録しますが、だんだんと乱雑になってしまって、今はいらない言葉が増えてきます。でも、一度はビビッときた言葉だから消したくはない。そういう時に、言葉をストックして必要な時だけ表示できるメモ帳が良いと思いました。<br>&ensp;言葉を選んで表示する、という機能は、アイデアを整理したい時にも役に立ちます。
## 特徴・機能
- iPhoneの操作性を生かしたシンプルなUI
- 言葉をストックして自由に
- ファイルのソート機能
- Realmを利用したデータベース管理
- 単語から全データまで幅広く削除できる編集機能

## 開発環境情報
- Swift 5.0.1
- Xcode11.3
- RealmSwift
- Google-Mobile-Ads-SDK
- Illustrator CC 2015

## App Store
配信中（リリース済)
https://apps.apple.com/jp/app/kotobaplus/id1493346374?mt=8

## アイコンデザイン
https://gyazo.com/6368a99c2d4ad6d8abc7cc1cf8aadeba
[![Image from Gyazo](https://i.gyazo.com/6368a99c2d4ad6d8abc7cc1cf8aadeba.png)](https://gyazo.com/6368a99c2d4ad6d8abc7cc1cf8aadeba)
## 機能紹介

### 基本性能
- AutoRayoutによる全画面の横向き対応
- デバイスはiPadまで対応
- キーボード出現に合わせて選択したtextFieldの位置を取得してスクロール
- RealmでIDを作成して管理し、すべてのデータが任意に削除できます
#### コトバ選択画面
https://gyazo.com/cd9aa18ac69a061588bf8186a93a9f46
[![Image from Gyazo](https://i.gyazo.com/cd9aa18ac69a061588bf8186a93a9f46.png)](https://gyazo.com/cd9aa18ac69a061588bf8186a93a9f46)
#### コトバ編集画面
https://gyazo.com/86dd54fd82d3e0368e1147874284b855
[![Image from Gyazo](https://i.gyazo.com/86dd54fd82d3e0368e1147874284b855.png)](https://gyazo.com/86dd54fd82d3e0368e1147874284b855)

### 新規ファイル作成
- textFieldによるファイル作成
#### 参考動画
[![Image from Gyazo](https://i.gyazo.com/ca84d34ebf30fb3cfa58b9ec507360ec.gif)](https://gyazo.com/ca84d34ebf30fb3cfa58b9ec507360ec)
#### 動画リンク
https://gyazo.com/ca84d34ebf30fb3cfa58b9ec507360ec

### ラベルの作成
- ファイル別にラベル(見出しのようなもの)を作成できます
#### 参考動画
[![Image from Gyazo](https://i.gyazo.com/6f9537d1bc2021d59a2f4ca0c92dfe84.gif)](https://gyazo.com/6f9537d1bc2021d59a2f4ca0c92dfe84)
#### 動画リンク
https://gyazo.com/6f9537d1bc2021d59a2f4ca0c92dfe84

### コトバをストック
- ラベルにたいして多くの言葉をストックできます
- 言葉に言葉を持たせることで、様々なパターンの検証ができます
#### 参考動画
[![Image from Gyazo](https://i.gyazo.com/11eb5330b0641136e98b276f48d3d2f8.gif)](https://gyazo.com/11eb5330b0641136e98b276f48d3d2f8)
#### 動画リンク
https://gyazo.com/11eb5330b0641136e98b276f48d3d2f8

### 選択した言葉に合わせて編集したり、言葉を選んだりできます
- ラベルが言葉を持っているかいないかで、違う編集画面に飛びます
#### 参考動画
[![Image from Gyazo](https://i.gyazo.com/4c948765c822cf967e4c55b67d8edff5.gif)](https://gyazo.com/4c948765c822cf967e4c55b67d8edff5)
#### 動画リンク
https://gyazo.com/4c948765c822cf967e4c55b67d8edff5

### 様々なパターンで削除できます
- １単語ごとに削除
- 1ラベルごとに削除
#### 参考動画
[![Image from Gyazo](https://i.gyazo.com/fa17cfc919f636af8699e85a6b477d0b.gif)](https://gyazo.com/fa17cfc919f636af8699e85a6b477d0b)
#### 動画リンク
https://gyazo.com/fa17cfc919f636af8699e85a6b477d0b

### ソート機能/全データリセット
- 作成日時と名前でソートできます
- 全データを一気に削除することができます
#### 参考動画
[![Image from Gyazo](https://i.gyazo.com/18f7e45bfad77f08fbf8476dd6154064.gif)](https://gyazo.com/18f7e45bfad77f08fbf8476dd6154064)
#### 動画リンク
https://gyazo.com/18f7e45bfad77f08fbf8476dd6154064
