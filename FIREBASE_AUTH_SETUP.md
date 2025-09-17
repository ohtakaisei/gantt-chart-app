# Firebase Authentication 設定手順

## 概要
このアプリケーションはFirebase Authenticationを使用して、指定されたGoogleアカウントのみのアクセスを制限しています。

## 設定手順

### 1. Firebase Console での設定

#### 1.1 Authentication の有効化
1. [Firebase Console](https://console.firebase.google.com/) にアクセス
2. プロジェクトを選択
3. 左メニューから「Authentication」をクリック
4. 「始める」ボタンをクリック

#### 1.2 Google プロバイダーの有効化
1. 「Authentication」画面で「Sign-in method」タブをクリック
2. 「Google」をクリック
3. 「有効にする」をクリック
4. プロジェクトのサポートメールを設定
5. 「保存」をクリック

#### 1.3 認証済みドメインの設定（重要）
1. 「Authentication」画面で「Settings」タブをクリック
2. 「Authorized domains」セクションを探す
3. 「Add domain」ボタンをクリック
4. 以下のドメインを追加：
   - `localhost`（ローカル開発用）
   - `ohtakaisei.github.io`（本番環境用）
5. 各ドメインを入力後「Done」をクリック

### 2. ユーザー制限の設定（推奨方法）

**重要**: v1.4から、ユーザー制限はFirebaseセキュリティルールで管理されます。

#### 2.1 Firestoreセキュリティルールでの設定
詳細な設定手順は `FIREBASE_SECURITY_RULES.md` を参照してください。

#### 2.2 基本的なセキュリティルール
Firebase Console → Firestore Database → ルール で以下を設定：

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthorizedUser() {
      return request.auth != null && 
        request.auth.token.email in [
          'kaisei@cg5ch.com',
          'gyo@cg5ch.com',
          'fuko@cg5ch.com'
        ];
    }
    
    match /{document=**} {
      allow read, write: if isAuthorizedUser();
    }
  }
}
```

#### 2.3 ユーザーの追加・削除
- Firebase Console → Firestore Database → ルール
- `isAuthorizedUser()` 関数内のメールアドレス配列を編集
- 「公開」ボタンをクリック

### 3. セキュリティルールの設定（必須）

#### 3.1 基本的なセキュリティルール
上記の2.2で設定したルールが適用されます。

#### 3.2 高度な設定
管理者権限や時間制限などの詳細設定については、`FIREBASE_SECURITY_RULES.md` を参照してください。

## 使用方法

### ログイン手順
1. アプリケーションにアクセス
2. 「Googleでログイン」ボタンをクリック
3. Googleアカウントでログイン
4. 許可されたメールアドレスの場合、アプリケーションにアクセス可能

### ログアウト手順
1. アプリケーション内の「ログアウト」ボタンをクリック
2. 認証ページに戻る

## セキュリティの特徴

### 実装されているセキュリティ機能
- ✅ Firebase Authentication による安全な認証
- ✅ 指定されたメールアドレスのみアクセス可能
- ✅ Google のセキュアな認証システムを利用
- ✅ セッション管理の自動化
- ✅ ログアウト機能

### セキュリティの利点
- パスワードの管理が不要
- Google の二要素認証を利用可能
- 認証情報がクライアントサイドに保存されない
- Firebase のセキュリティ機能を活用

## トラブルシューティング

### よくある問題

#### 1. ログインできない
- メールアドレスが `allowedEmails` 配列に含まれているか確認
- Firebase Console で Google プロバイダーが有効になっているか確認

#### 2. 認証エラーが発生する
- **auth/unauthorized-domain エラー**: Firebase Console で認証済みドメインに `ohtakaisei.github.io` が追加されているか確認
- Firebase 設定が正しいか確認
- ブラウザのコンソールでエラーメッセージを確認

#### 3. アクセスが拒否される
- Firestore セキュリティルールを確認
- ユーザーのメールアドレスが正しいか確認

#### 4. ドメイン認証エラーの解決手順
1. Firebase Console → Authentication → Settings
2. 「Authorized domains」で `ohtakaisei.github.io` を追加
3. 数分待ってから再度ログインを試行

## 注意事項

- 本番環境では、`allowedEmails` 配列を環境変数や設定ファイルで管理することを推奨
- 定期的にアクセス権限の見直しを行う
- 不要になったユーザーは速やかに削除する
- セキュリティルールの変更は慎重に行う

## バージョン情報

- **v1.3**: Firebase Authentication 実装
  - Google 認証の追加
  - メールアドレス制限の実装
  - セキュアなログアウト機能
