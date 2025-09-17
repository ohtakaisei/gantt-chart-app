# 軽量なNginxイメージを使用
FROM nginx:alpine

# アプリケーションファイルをコピー
COPY index.html /usr/share/nginx/html/
COPY package.json /usr/share/nginx/html/

# Nginx設定ファイルをコピー
COPY nginx.conf /etc/nginx/nginx.conf

# ポート80でリッスン
EXPOSE 80

# Nginxを起動
CMD ["nginx", "-g", "daemon off;"]
