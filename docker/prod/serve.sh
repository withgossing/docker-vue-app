#!/bin/sh

# Nginx 서버 실행 스크립트

# prod_modules 디렉토리 준비
if [ ! -d "/app/prod_modules" ]; then
    mkdir -p /app/prod_modules
    echo "prod_modules 디렉토리 생성됨"
else
    echo "prod_modules 디렉토리가 이미 존재함"
fi

# 프로덕션 환경 정보 저장
echo "프로덕션 환경 정보를 prod_modules에 저장..."
echo "Nginx 버전: $(nginx -v 2>&1)" > /app/prod_modules/info.txt
echo "환경: $NODE_ENV" >> /app/prod_modules/info.txt
echo "시작 시간: $(date)" >> /app/prod_modules/info.txt
echo "호스트명: $(hostname)" >> /app/prod_modules/info.txt

# 웹 서버 상태 페이지 생성 (관리자용)
cat > /usr/share/nginx/html/server-info.html << EOL
<!DOCTYPE html>
<html>
<head>
    <title>Server Information</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { color: #333; }
        .info { background: #f5f5f5; padding: 15px; border-radius: 5px; }
        .note { color: #666; font-style: italic; }
    </style>
</head>
<body>
    <h1>Production Server Information</h1>
    <div class="info">
        <p><strong>Start Time:</strong> $(date)</p>
        <p><strong>Nginx Version:</strong> $(nginx -v 2>&1)</p>
        <p><strong>Environment:</strong> $NODE_ENV</p>
        <p><strong>Hostname:</strong> $(hostname)</p>
    </div>
    <p class="note">Note: This page is only accessible from the local network.</p>
</body>
</html>
EOL

# Nginx 서버 실행
echo "Nginx 서버 시작..."
nginx -g "daemon off;"