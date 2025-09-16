# Firestore Database 設定手順

## 📋 概要
このガイドでは、ガントチャートアプリをFirestore Databaseと連携させるための手順を説明します。

## 🚀 手順

### 1. Firebase プロジェクトの作成

1. **Firebase Console にアクセス**
   - https://console.firebase.google.com/ にアクセス
   - Googleアカウントでログイン

2. **新しいプロジェクトを作成**
   - 「プロジェクトを作成」をクリック
   - プロジェクト名を入力（例：`gantt-chart-app`）
   - Google Analytics は任意で有効化
   - 「プロジェクトを作成」をクリック

### 2. Firestore Database の設定

1. **Firestore Database を有効化**
   - 左メニューから「Firestore Database」を選択
   - 「データベースを作成」をクリック

2. **セキュリティルールの設定**
   - 「テストモードで開始」を選択（後で本番用に変更可能）
   - 場所を選択（asia-northeast1 推奨）
   - 「有効にする」をクリック

### 3. Web アプリの登録

1. **Web アプリを追加**
   - プロジェクト概要で「</>」アイコンをクリック
   - アプリのニックネームを入力（例：`gantt-web-app`）
   - 「Firebase Hosting も設定する」はチェックしない
   - 「アプリを登録」をクリック

2. **設定情報をコピー**
   - 表示されるFirebase設定をコピー
   - 以下のような形式です：
   ```javascript
   const firebaseConfig = {
     apiKey: "AIza...",
     authDomain: "your-project.firebaseapp.com",
     projectId: "your-project-id",
     storageBucket: "your-project.appspot.com",
     messagingSenderId: "123456789",
     appId: "1:123456789:web:abcdef..."
   };
   ```

   // Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCGS_Da-rjzrBOt5TNPO_A6b879lCuNUU0",
  authDomain: "gantt-chart-app-b113a.firebaseapp.com",
  projectId: "gantt-chart-app-b113a",
  storageBucket: "gantt-chart-app-b113a.firebasestorage.app",
  messagingSenderId: "300778880243",
  appId: "1:300778880243:web:9844d5c2948e39ad120b86"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

### 4. HTMLファイルの設定

1. **index.html を開く**
   - テキストエディタで `index.html` を開く

2. **Firebase設定を追加**
   - 24行目付近の `const firebaseConfig = {` の部分を探す
   - コピーした設定で置き換える：
   ```javascript
   const firebaseConfig = {
     apiKey: "あなたのAPIキー",
     authDomain: "あなたのプロジェクト.firebaseapp.com",
     projectId: "あなたのプロジェクトID",
     storageBucket: "あなたのプロジェクト.appspot.com",
     messagingSenderId: "あなたのSenderID",
     appId: "あなたのAppID"
   };
   ```

3. **設定を保存**
   - ファイルを保存

### 5. セキュリティルールの設定（本番用）

1. **Firestore Database のルールタブを開く**
   - Firebase Console で Firestore Database > ルール

2. **本番用ルールに変更**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // すべての読み書きを許可（開発用）
       match /{document=**} {
         allow read, write: if true;
       }
     }
   }
   ```

3. **「公開」をクリック**

### 6. 動作確認

1. **ローカルサーバーで起動**
   ```bash
   python3 -m http.server 8000
   ```

2. **ブラウザでアクセス**
   - http://localhost:8000 にアクセス

3. **機能テスト**
   - ユーザー追加
   - プロジェクト作成
   - データの永続化確認

## 🔒 セキュリティの考慮事項

### 本番環境での推奨設定

1. **認証の追加**
   - Firebase Authentication を有効化
   - ユーザー認証を必須にする

2. **セキュリティルールの強化**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null;
       }
       match /projects/{projectId} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

## 📊 データ構造

### Users コレクション
```javascript
{
  name: "ユーザー名",
  created_at: "2024-01-01T00:00:00.000Z"
}
```

### Projects コレクション
```javascript
{
  name: "プロジェクト名",
  startDate: "2024-01-15",
  endDate: "2024-03-15",
  participants: [1, 2],
  owner: 1,
  details: "プロジェクト詳細",
  color: "bg-blue-500",
  created_at: "2024-01-01T00:00:00.000Z",
  updated_at: "2024-01-01T00:00:00.000Z"
}
```

## 🆘 トラブルシューティング

### よくある問題

1. **CORS エラー**
   - ローカルサーバーを使用していることを確認
   - `python3 -m http.server 8000` で起動

2. **Firebase 設定エラー**
   - 設定が正しくコピーされているか確認
   - プロジェクトIDが正しいか確認

3. **データが保存されない**
   - ブラウザのコンソールでエラーを確認
   - Firestore のルールが正しく設定されているか確認

## 📞 サポート

問題が発生した場合は、以下を確認してください：
- ブラウザのコンソールエラー
- Firebase Console のログ
- ネットワーク接続

---

**注意**: この設定は開発用です。本番環境では適切なセキュリティ設定を行ってください。
