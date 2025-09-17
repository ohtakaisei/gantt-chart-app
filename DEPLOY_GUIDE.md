# GCP + IAP デプロイ手順書

このガイドでは、ガントチャートアプリをGCPのCloud RunとIAP（Identity-Aware Proxy）を使用して、指定のGoogleアカウントのみがアクセスできるようにデプロイする手順を説明します。

## 前提条件

- Google Cloud Platformアカウント
- Google Cloud SDK（gcloud）がインストール済み
- Dockerがインストール済み（ローカルビルドの場合）

## 完全無料で利用可能なサービス

- **Cloud Run**: 月100万リクエストまで無料
- **Container Registry**: 月500MBまで無料
- **Cloud Build**: 月120分まで無料
- **IAP**: 無料（ただし、OAuth同意画面の設定が必要）

## 手順

### 1. GCPプロジェクトの作成と設定

```bash
# 新しいGCPプロジェクトを作成
gcloud projects create your-project-id --name="Gantt Chart App"

# プロジェクトを設定
gcloud config set project your-project-id

# 必要なAPIを有効化
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable iap.googleapis.com
gcloud services enable compute.googleapis.com
```

### 2. アプリケーションのデプロイ

#### 方法A: Cloud Buildを使用（推奨）

```bash
# Cloud Buildでビルド・デプロイ
gcloud builds submit --config cloudbuild.yaml .
```

#### 方法B: ローカルでビルド

```bash
# Dockerイメージをビルド
docker build -t gcr.io/your-project-id/gantt-chart-app .

# Container Registryにプッシュ
docker push gcr.io/your-project-id/gantt-chart-app

# Cloud Runにデプロイ
gcloud run deploy gantt-chart-app \
  --image gcr.io/your-project-id/gantt-chart-app \
  --platform managed \
  --region asia-northeast1 \
  --allow-unauthenticated \
  --port 80 \
  --memory 256Mi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 10
```

### 3. IAP（Identity-Aware Proxy）の設定

#### 3.1 OAuth同意画面の設定

1. [Google Cloud Console](https://console.cloud.google.com/)にアクセス
2. 「APIとサービス」→「OAuth同意画面」に移動
3. 「外部」を選択して「作成」
4. 以下の情報を入力：
   - アプリ名: `ガントチャートアプリ`
   - ユーザーサポートメール: あなたのメールアドレス
   - デベロッパー連絡先情報: あなたのメールアドレス
5. 「保存して次へ」をクリック
6. スコープはそのまま「保存して次へ」
7. テストユーザーにアクセスを許可したいGoogleアカウントを追加
8. 「保存して次へ」→「ダッシュボードに戻る」

#### 3.2 OAuth 2.0クライアントIDの作成

1. 「APIとサービス」→「認証情報」に移動
2. 「認証情報を作成」→「OAuth 2.0クライアントID」
3. アプリケーションの種類: 「ウェブアプリケーション」
4. 名前: `ガントチャートアプリ IAP`
5. 承認済みのリダイレクトURI: `https://your-app-url.run.app/_gcp_iap/process_oauth2_callback`
6. 「作成」をクリック
7. クライアントIDとクライアントシークレットをメモ

#### 3.3 IAPの有効化

```bash
# IAPを有効化
gcloud iap web enable --resource-type=app-engine

# または、Cloud Runの場合
gcloud iap web enable --resource-type=backend-services
```

#### 3.4 アクセス権限の設定

```bash
# 特定のGoogleアカウントにアクセス権限を付与
gcloud iap web add-iam-policy-binding \
  --resource-type=backend-services \
  --service=your-service-name \
  --member=user:user@example.com \
  --role=roles/iap.httpsResourceAccessor
```

### 4. ドメイン設定（オプション）

カスタムドメインを使用したい場合：

```bash
# カスタムドメインをマッピング
gcloud run domain-mappings create \
  --service gantt-chart-app \
  --domain your-domain.com \
  --region asia-northeast1
```

### 5. 環境変数の設定

Firebase設定を環境変数として設定：

```bash
gcloud run services update gantt-chart-app \
  --set-env-vars="FIREBASE_API_KEY=your-api-key" \
  --set-env-vars="FIREBASE_AUTH_DOMAIN=your-auth-domain" \
  --set-env-vars="FIREBASE_PROJECT_ID=your-project-id" \
  --region asia-northeast1
```

### 6. セキュリティ設定の確認

```bash
# 現在のIAP設定を確認
gcloud iap web get-iam-policy --resource-type=backend-services

# アクセス権限を確認
gcloud iap web get-iam-policy --resource-type=backend-services --service=your-service-name
```

## トラブルシューティング

### よくある問題

1. **IAPにアクセスできない**
   - OAuth同意画面でテストユーザーに追加されているか確認
   - クライアントIDが正しく設定されているか確認

2. **Firebase接続エラー**
   - Firebase設定が正しく設定されているか確認
   - 環境変数が正しく設定されているか確認

3. **デプロイエラー**
   - Cloud Buildのログを確認
   - 必要なAPIが有効化されているか確認

### ログの確認

```bash
# Cloud Runのログを確認
gcloud logging read "resource.type=cloud_run_revision" --limit 50

# Cloud Buildのログを確認
gcloud logging read "resource.type=build" --limit 50
```

## コスト最適化

### 無料枠の活用

- **Cloud Run**: 月100万リクエストまで無料
- **Container Registry**: 月500MBまで無料
- **Cloud Build**: 月120分まで無料

### コスト削減のポイント

1. **最小インスタンス数を0に設定**
2. **不要なリージョンでのデプロイを避ける**
3. **定期的にログを確認して不要なリソースを削除**

## セキュリティのベストプラクティス

1. **最小権限の原則**: 必要最小限のアクセス権限のみ付与
2. **定期的なアクセス権限の見直し**
3. **ログの監視**: 不審なアクセスがないか定期的に確認
4. **Firebaseセキュリティルールの設定**

## メンテナンス

### 定期的な作業

1. **セキュリティアップデートの確認**
2. **アクセス権限の見直し**
3. **ログの確認とクリーンアップ**
4. **コストの監視**

### バックアップ

- Firebase Firestoreのデータは自動バックアップされる
- 重要な設定はバージョン管理システムで管理

## サポート

問題が発生した場合は、以下を確認してください：

1. [Google Cloud ドキュメント](https://cloud.google.com/docs)
2. [Firebase ドキュメント](https://firebase.google.com/docs)
3. [Cloud Run トラブルシューティング](https://cloud.google.com/run/docs/troubleshooting)
