#!/bin/sh

# =====================================================================
# serve.sh - 프로덕션 환경에서 Nginx 서버 실행 스크립트
# =====================================================================
# 프로덕션 환경 정보를 기록하고 Nginx 서버를 시작하는 스크립트

# prod_modules 디렉토리 준비
# 이 디렉토리는 프로덕션 환경의 정보와 로그를 저장하는 영구 볼륨
if [ ! -d "/app/prod_modules" ]; then
    # 디렉토리가 없으면 생성
    mkdir -p /app/prod_modules
    echo "prod_modules 디렉토리 생성됨"
else
    # 이미 존재하는 경우
    echo "prod_modules 디렉토리가 이미 존재함"
fi

# 프로덕션 환경 정보 저장
# 서버 시작 시마다 새로운 정보로 갱신
echo "프로덕션 환경 정보를 prod_modules에 저장..."
# Nginx 버전
echo "Nginx 버전: $(nginx -v 2>&1)" > /app/prod_modules/info.txt
# 환경 변수 기록 (production 상태)
echo "환경: $NODE_ENV" >> /app/prod_modules/info.txt
# 서버 시작 시간
echo "시작 시간: $(date)" >> /app/prod_modules/info.txt
# 컨테이너 호스트명
echo "호스트명: $(hostname)" >> /app/prod_modules/info.txt

# 웹 서버 상태 페이지 생성 (관리자용)
# 프로덕션 서버의 기본 정보를 보여주는 HTML 페이지 생성
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
# daemon off 옵션으로 포그라운드에서 실행하여 컨테이너가 종료되지 않도록 함
echo "Nginx 서버 시작..."
nginx -g "daemon off;"