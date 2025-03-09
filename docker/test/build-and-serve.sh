#!/bin/sh

# 빌드 및 Nginx 서버 실행 스크립트

# 볼륨 마운트 확인
echo "볼륨 마운트 확인 중..."
if [ ! -d "/app/node_modules" ] || [ -z "$(ls -A /app/node_modules)" ]; then
    echo "오류: node_modules가 올바르게 마운트되지 않았습니다."
    echo "개발 환경이 실행 중인지 확인하세요."
    echo "node_modules 디렉토리 내용:"
    ls -la /app
    exit 1
else
    echo "개발 환경 node_modules 볼륨이 올바르게 마운트되었습니다."
    echo "node_modules 내 주요 패키지:"
    ls -la /app/node_modules/vue /app/node_modules/vite 2>/dev/null || echo "Vue/Vite 패키지를 찾을 수 없습니다."
fi

# test_modules 디렉토리 준비
mkdir -p /app/test_modules
echo "test_modules 디렉토리 준비 완료"

# 테스트 환경 정보 저장
echo "테스트 환경 정보를 test_modules에 저장..."
{
    echo "===== 테스트 환경 정보 ====="
    echo "Node.js 버전: $(node --version)"
    echo "npm 버전: $(npm --version)"
    echo "환경: $NODE_ENV"
    echo "시작 시간: $(date)"
    echo "호스트명: $(hostname)"
    echo "==========================="
} > /app/test_modules/environment.log

# 빌드가 필요한지 확인 (dist 디렉토리가 비어있는지 체크)
if [ ! -d "/app/dist" ] || [ -z "$(ls -A /app/dist)" ]; then
    echo "빌드 시작..."
    
    # 환경 변수 파일 복사
    cp -f /app/docker/test/.env /app/.env
    
    # 빌드 시작 정보 로깅
    echo "빌드 시작: $(date)" > /app/test_modules/build.log
    
    # 빌드 실행
    cd /app && npm run build
    
    if [ $? -ne 0 ]; then
        echo "빌드 실패: $(date)" >> /app/test_modules/build.log
        echo "오류: 빌드에 실패했습니다."
        exit 1
    fi
    
    echo "빌드 완료: $(date)" >> /app/test_modules/build.log
    echo "빌드가 성공적으로 완료되었습니다."
else
    echo "이미 빌드된 dist 디렉토리가 존재합니다. 빌드를 건너뜁니다."
fi

# dist 폴더를 nginx 서버 경로로 복사
echo "빌드 결과물을 Nginx 서버로 복사..."
cp -r /app/dist/* /usr/share/nginx/html/

# Nginx 서버 정보 로깅
{
    echo "===== Nginx 서버 정보 ====="
    echo "시작 시간: $(date)"
    echo "Nginx 버전: $(nginx -v 2>&1)"
    echo "==========================="
} > /app/test_modules/nginx.log

# Nginx 서버 실행
echo "Nginx 서버 시작..."
nginx -g "daemon off;"