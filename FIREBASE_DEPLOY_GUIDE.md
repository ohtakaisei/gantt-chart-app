# Firebase Hosting + Authentication デプロイ手順書

クレジットカードなしで完全無料で社内ツールを運用する方法です。

## 無料枠

- **Firebase Hosting**: 月10GB転送量まで無料
- **Firebase Authentication**: 無料
- **Firestore**: 月50,000回の読み取りまで無料
- **クレジットカード不要**

## 手順

### 1. Firebase プロジェクトの作成

1. [Firebase Console](https://console.firebase.google.com/) にアクセス
2. 「プロジェクトを作成」をクリック
3. プロジェクト名: `gantt-chart-app`
4. Google Analyticsは無効でOK
5. 「プロジェクトを作成」をクリック

### 2. Firebase Hosting の設定

```bash
# Firebase CLIをインストール
npm install -g firebase-tools

# Firebaseにログイン
firebase login

# プロジェクトを初期化
firebase init hosting

# デプロイ
firebase deploy
```

### 3. Firebase Authentication の設定

1. Firebase Console で「Authentication」をクリック
2. 「始める」をクリック
3. 「Sign-in method」タブをクリック
4. 「Google」を有効化
5. プロジェクトサポートメールを設定
6. 「保存」をクリック

### 4. アクセス制御の設定

Firebase Hostingの設定で、認証が必要なページを保護できます。

## メリット

- クレジットカード不要
- 完全無料
- 簡単な設定
- 自動SSL証明書
- 高速CDN

## デメリット

- IAPほどの細かいアクセス制御はできない
- Googleアカウントでの認証のみ
