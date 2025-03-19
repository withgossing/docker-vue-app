#!/bin/sh

# =====================================================================
# build-and-serve.sh - Vue 애플리케이션 빌드 및 Nginx 서버 실행 스크립트
# =====================================================================
# 테스트 환경에서 소스 코드를 빌드하고 빌드된 결과물을 Nginx 서버로 배포

# 볼륨 마운트 확인
# 개발 환경의 node_modules가 올바르게 마운트되었는지 확인
echo "볼륨 마운트 확인 중..."
if [ ! -d "/app/node_modules" ] || [ -z "$(ls -A /app/node_modules)" ]; then
    # node_modules 디렉토리가 없거나 비어있는 경우 오류 표시
    echo "오류: node_modules가 올바르게 마운트되지 않았습니다."
    echo "개발 환경이 실행 중인지 확인하세요."
    # 디버깅을 위해 /app 디렉토리 내용 출력
    echo "node_modules 디렉토리 내용:"
    ls -la /app
    exit 1
else
    # node_modules 디렉토리가 올바르게 마운트된 경우
    echo "개발 환경 node_modules 볼륨이 올바르게 마운트되었습니다."
    # 주요 패키지가 있는지 확인(Vue, Vite)
    echo "node_modules 내 주요 패키지:"
    ls -la /app/node_modules/vue /app/node_modules/vite 2>/dev/null || echo "Vue/Vite 패키지를 찾을 수 없습니다."
fi

# 테스트 환경 정보를 저장할 디렉토리 생성
# test_modules 디렉토리는 docker-compose.yml에서 볼륨으로 마운트됨
mkdir -p /app/test_modules
echo "test_modules 디렉토리 준비 완료"

# 테스트 환경 정보 저장
# 버전 정보, 환경 변수, 시간 등 기록
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

# 빌드가 필요한지 확인
# dist 디렉토리가 없거나 비어있는 경우 빌드 실행
if [ ! -d "/app/dist" ] || [ -z "$(ls -A /app/dist)" ]; then
    echo "빌드 시작..."
    
    # 테스트 환경용 환경 변수 파일 복사
    cp -f /app/docker/test/.env /app/.env
    
    # 빌드 시작 시간 로깅
    echo "빌드 시작: $(date)" > /app/test_modules/build.log
    
    # Vue 애플리케이션 빌드 실행
    cd /app && npm run build
    
    # 빌드 실패 시 오류 처리
    if [ $? -ne 0 ]; then
        # 빌드 실패 시간 로깅
        echo "빌드 실패: $(date)" >> /app/test_modules/build.log
        echo "오류: 빌드에 실패했습니다."
        exit 1
    fi
    
    # 빌드 완료 시간 로깅
    echo "빌드 완료: $(date)" >> /app/test_modules/build.log
    echo "빌드가 성공적으로 완료되었습니다."
else
    # dist 디렉토리가 이미 존재하는 경우 빌드 과정 건너뜀
    echo "이미 빌드된 dist 디렉토리가 존재합니다. 빌드를 건너뜁니다."
fi

# 빌드된 결과물을 Nginx의 웹 루트 디렉토리로 복사
echo "빌드 결과물을 Nginx 서버로 복사..."
cp -r /app/dist/* /usr/share/nginx/html/

# Nginx 서버 정보 로깅
{
    echo "===== Nginx 서버 정보 ====="
    echo "시작 시간: $(date)"
    # Nginx 버전 정보를 stderr에서 가져옴
    echo "Nginx 버전: $(nginx -v 2>&1)"
    echo "==========================="
} > /app/test_modules/nginx.log

# Nginx 서버 실행
# daemon off 옵션으로 포그라운드에서 실행하여 컨테이너가 종료되지 않도록 함
echo "Nginx 서버 시작..."
nginx -g "daemon off;"