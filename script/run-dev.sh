#!/bin/bash

# 개발 환경 실행 스크립트
cd "$(dirname "$0")/.."

# 개발 환경 시작 전 모든 환경 초기화
echo "모든 환경을 초기화합니다..."

# 실행 중인 컨테이너 확인 및 중지
if [ "$(docker ps -q -f name=vue-dev)" ]; then
    echo "개발 컨테이너를 중지합니다."
    docker-compose down -v
fi

if [ "$(docker ps -q -f name=vue-test)" ]; then
    echo "테스트 컨테이너를 중지합니다."
    docker-compose -f docker/test/docker-compose.yml down -v
fi

if [ "$(docker ps -q -f name=vue-prod)" ]; then
    echo "프로덕션 컨테이너를 중지합니다."
    docker-compose -f docker/prod/docker-compose.yml down -v
fi

# 볼륨 초기화 (선택적)
echo "볼륨을 초기화합니다..."
docker volume rm -f dev_modules test_build test_modules prod_modules 2>/dev/null || true

echo "개발 환경을 시작합니다..."
echo "개발 서버가 시작되면 http://localhost:5173 에서 접속할 수 있습니다."

# 개발 환경 빌드 및 실행
docker-compose up --build