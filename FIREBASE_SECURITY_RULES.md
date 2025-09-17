# Firebase セキュリティルール設定手順

## 概要
このドキュメントでは、Firebase Firestoreのセキュリティルールを使用して、特定のユーザーのみがアクセスできるようにする設定方法を説明します。

## 設定手順

### 1. Firebase Console での設定

#### 1.1 Firestore セキュリティルールの設定
1. [Firebase Console](https://console.firebase.google.com/) にアクセス
2. プロジェクト「gantt-chart-app-b113a」を選択
3. 左メニューから「Firestore Database」をクリック
4. 「ルール」タブをクリック

#### 1.2 セキュリティルールの実装
以下のルールをコピーして貼り付け：

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 許可されたユーザーのメールアドレスリスト
    function isAuthorizedUser() {
      return request.auth != null && 
        request.auth.token.email in [
          'kaisei@cg5ch.com',
          'gyo@cg5ch.com',
          'fuko@cg5ch.com'
        ];
    }
    
    // すべてのコレクションに対して認証されたユーザーのみアクセス可能
    match /{document=**} {
      allow read, write: if isAuthorizedUser();
    }
  }
}
```

#### 1.3 ルールの公開
1. ルールを入力後、「公開」ボタンをクリック
2. 確認ダイアログで「公開」をクリック

### 2. ユーザー管理

#### 2.1 新しいユーザーの追加
1. Firebase Console → Firestore Database → ルール
2. `isAuthorizedUser()` 関数内のメールアドレス配列に新しいメールアドレスを追加
3. 「公開」ボタンをクリック

#### 2.2 ユーザーの削除
1. Firebase Console → Firestore Database → ルール
2. `isAuthorizedUser()` 関数内のメールアドレス配列から削除したいメールアドレスを削除
3. 「公開」ボタンをクリック

### 3. 高度な設定（オプション）

#### 3.1 管理者権限の設定
管理者のみがユーザー管理できるようにする場合：

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 管理者のメールアドレス
    function isAdmin() {
      return request.auth != null && 
        request.auth.token.email == 'kaisei@cg5ch.com';
    }
    
    // 許可されたユーザーのメールアドレスリスト
    function isAuthorizedUser() {
      return request.auth != null && 
        request.auth.token.email in [
          'kaisei@cg5ch.com',
          'gyo@cg5ch.com',
          'fuko@cg5ch.com'
        ];
    }
    
    // ユーザーコレクション（管理者のみ書き込み可能）
    match /users/{userId} {
      allow read: if isAuthorizedUser();
      allow write: if isAdmin();
    }
    
    // プロジェクトコレクション（認証されたユーザーが読み書き可能）
    match /projects/{projectId} {
      allow read, write: if isAuthorizedUser();
    }
  }
}
```

#### 3.2 時間制限の設定
特定の時間帯のみアクセス可能にする場合：

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 許可されたユーザーのメールアドレスリスト
    function isAuthorizedUser() {
      return request.auth != null && 
        request.auth.token.email in [
          'kaisei@cg5ch.com',
          'gyo@cg5ch.com',
          'fuko@cg5ch.com'
        ];
    }
    
    // アクセス可能時間（9:00-18:00 JST）
    function isAccessTime() {
      return request.time.toMillis() >= 
        timestamp.date(2024, 1, 1, 0, 0, 0).toMillis() &&
        request.time.hour >= 9 && 
        request.time.hour <= 18;
    }
    
    match /{document=**} {
      allow read, write: if isAuthorizedUser() && isAccessTime();
    }
  }
}
```

## セキュリティの利点

### 実装前（コード内制限）の問題点
- ❌ メールアドレスがコードにハードコードされる
- ❌ ユーザー追加・削除時にコードの変更が必要
- ❌ セキュリティルールがクライアントサイドで実行される
- ❌ コードが公開されるため、制限をバイパス可能

### 実装後（Firebaseセキュリティルール）の利点
- ✅ メールアドレスがサーバーサイドで管理される
- ✅ Firebase Consoleから簡単にユーザー管理可能
- ✅ セキュリティルールがサーバーサイドで実行される
- ✅ クライアントサイドから制限をバイパス不可能
- ✅ リアルタイムでルール変更が反映される

## トラブルシューティング

### よくある問題

#### 1. アクセスが拒否される
- メールアドレスがセキュリティルールの配列に含まれているか確認
- Firebase Consoleでルールが正しく公開されているか確認

#### 2. ルールが反映されない
- ルール公開後、数分待ってから再試行
- ブラウザのキャッシュをクリア

#### 3. 認証エラーが発生する
- Firebase Console → Authentication → Settings でドメイン認証を確認
- `ohtakaisei.github.io` が認証済みドメインに追加されているか確認

## 注意事項

- セキュリティルールの変更は慎重に行う
- 本番環境では、ルールのテストを十分に行う
- 定期的にアクセス権限の見直しを行う
- 不要になったユーザーは速やかに削除する

## バージョン情報

- **v1.4**: Firebaseセキュリティルール実装
  - コード内メールアドレス制限を削除
  - Firestoreセキュリティルールでユーザー制限
  - サーバーサイドでのセキュリティ管理
