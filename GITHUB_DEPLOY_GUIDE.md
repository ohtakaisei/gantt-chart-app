# GitHub Pages + GitHub Actions デプロイ手順書

完全無料で社内ツールを運用する方法です。

## 無料枠

- **GitHub Pages**: 完全無料
- **GitHub Actions**: 月2,000分まで無料
- **プライベートリポジトリ**: 無料
- **クレジットカード不要**

## 手順

### 1. GitHub リポジトリの作成

1. [GitHub](https://github.com) にアクセス
2. 右上の「+」→「New repository」をクリック
3. 以下の設定でリポジトリを作成：
   - **Repository name**: `gantt-chart-app`
   - **Description**: `社内用ガントチャートアプリ`
   - **Visibility**: `Private` (社内限定)
   - **Initialize this repository with**: チェックを外す（空のリポジトリ）

### 2. ローカルリポジトリの初期化

```bash
# Gitリポジトリを初期化
git init

# リモートリポジトリを追加（YOUR_USERNAMEを実際のユーザー名に変更）
git remote add origin https://github.com/YOUR_USERNAME/gantt-chart-app.git

# ファイルを追加
git add .

# 初回コミット
git commit -m "Initial commit: ガントチャートアプリ"

# メインブランチにプッシュ
git branch -M main
git push -u origin main
```

### 3. GitHub Pages の設定

1. リポジトリの「Settings」タブをクリック
2. 左側のメニューから「Pages」をクリック
3. 「Source」で「GitHub Actions」を選択
4. 設定が完了すると、自動的にデプロイが開始されます

### 4. アクセス制御の設定

現在の実装では、以下の認証情報でアクセスできます：

- **管理者**: `admin` / `admin123`
- **ユーザー1**: `user1` / `user123`
- **ユーザー2**: `user2` / `user123`

### 5. カスタムドメインの設定（オプション）

1. リポジトリの「Settings」→「Pages」
2. 「Custom domain」にドメインを入力
3. DNS設定でCNAMEレコードを追加

## セキュリティの強化

### より安全な認証方法

現在の実装は簡易的なものですが、より安全にするには：

1. **環境変数を使用**
2. **JWT トークンを使用**
3. **外部認証サービスと連携**

### アクセス制御の改善

```javascript
// より安全な認証例
const allowedUsers = [
    { username: 'admin', password: 'admin123', role: 'admin' },
    { username: 'user1', password: 'user123', role: 'user' }
];

// ロールベースのアクセス制御
function checkPermission(requiredRole) {
    const user = JSON.parse(sessionStorage.getItem('user'));
    return user && user.role === requiredRole;
}
```

## メリット

- **完全無料**
- **クレジットカード不要**
- **簡単な設定**
- **自動デプロイ**
- **バージョン管理**
- **プライベートリポジトリ**

## デメリット

- **認証機能の実装が必要**
- **セキュリティ設定が手動**
- **GitHubの制限に依存**

## トラブルシューティング

### よくある問題

1. **GitHub Actionsが実行されない**
   - リポジトリの「Actions」タブでワークフローを有効化
   - プライベートリポジトリの場合は、SettingsでActionsを有効化

2. **ページが表示されない**
   - GitHub Pagesの設定を確認
   - デプロイログを確認

3. **認証が動作しない**
   - ブラウザの開発者ツールでコンソールエラーを確認
   - sessionStorageの設定を確認

## メンテナンス

### 定期的な作業

1. **セキュリティアップデート**
2. **ユーザー管理**
3. **バックアップの確認**
4. **ログの監視**

### バックアップ

- GitHubが自動的にバックアップを提供
- 重要な設定は別途バックアップを推奨