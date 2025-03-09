#!/bin/bash

# 테스트 환경 실행 스크립트
cd "$(dirname "$0")/.."

# 테스트 환경만 초기화
echo "테스트 환경을 초기화합니다..."

# 실행 중인 테스트 컨테이너 확인 및 중지
if [ "$(docker ps -q -f name=vue-test)" ]; then
    echo "테스트 컨테이너를 중지합니다."
    docker-compose -f docker/test/docker-compose.yml down
fi

# 테스트 볼륨 초기화
echo "테스트 환경 볼륨을 초기화합니다..."
docker volume rm -f test_build test_modules 2>/dev/null || true

echo "빌드 및 테스트 환경 실행 중..."
echo "빌드가 완료되면 http://localhost:8080 에서 테스트 환경에 접속할 수 있습니다."
echo "Ctrl+C로 종료하면 테스트 컨테이너도 함께 종료됩니다."

# 테스트 환경을 포그라운드에서 실행 (Ctrl+C로 종료할 수 있음)
docker-compose -f docker/test/docker-compose.yml up --build