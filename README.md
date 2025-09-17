# ガンちゃ！ - ガントチャートアプリ

Firestore Databaseを使用したプロジェクト管理ガントチャートアプリケーションです。

## 機能

- 📊 ガントチャート表示
- 👥 ユーザー管理
- 📝 プロジェクト作成・編集・削除
- 🔥 Firestore Database連携
- 📱 レスポンシブデザイン

## 技術スタック

- **フロントエンド**: HTML5, CSS3, JavaScript (ES6+)
- **UI フレームワーク**: Tailwind CSS
- **データベース**: Firebase Firestore
- **日付処理**: Flatpickr

## セットアップ

### 1. リポジトリのクローン

```bash
git clone <リポジトリURL>
cd <リポジトリ名>
```

### 2. Firebase設定

1. [Firebase Console](https://console.firebase.google.com/)でプロジェクトを作成
2. Firestore Databaseを有効化
3. Webアプリを登録して設定を取得
4. `index.html`の`firebaseConfig`を更新

詳細は`FIRESTORE_SETUP.md`を参照してください。

### 3. ローカルサーバーの起動

```bash
python3 -m http.server 8000
```

### 4. アクセス

ブラウザで `http://localhost:8000` にアクセス

## 使用方法

1. **ユーザー追加**: 「ユーザー管理」ボタンからユーザーを追加
2. **プロジェクト作成**: 「プロジェクト追加」ボタンからプロジェクトを作成
3. **ガントチャート表示**: 作成したプロジェクトがガントチャートに表示されます
4. **プロジェクト編集**: ガントチャートのプロジェクトバーをクリックして編集・削除

## ファイル構成

```
├── index.html              # メインアプリケーション
├── FIRESTORE_SETUP.md      # Firestore設定手順
├── README.md               # このファイル
└── .gitignore              # Git除外設定
```

## 開発履歴

- **v1.0.0**: 初期リリース
  - Firestore Database連携
  - ガントチャート表示機能
  - ユーザー・プロジェクト管理機能

## ライセンス

MIT License

