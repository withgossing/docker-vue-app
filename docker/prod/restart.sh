#!/bin/bash

# 테스트 환경 초기화 및 재시작 스크립트
cd "$(dirname "$0")/../.."

echo "테스트 환경을 초기화하고 재시작합니다..."

# 실행 중인 테스트 컨테이너 확인 및 중지
if [ "$(docker ps -q -f name=vue-test)" ]; then
    echo "테스트 컨테이너를 중지합니다."
    docker-compose -f docker/test/docker-compose.yml down
fi

# 테스트 볼륨 초기화
echo "테스트 환경 볼륨을 초기화합니다..."
docker volume rm -f test_build test_modules 2>/dev/null || true

echo "테스트 환경을 시작합니다..."
echo "테스트 서버가 시작되면 http://localhost:8080 에서 접속할 수 있습니다."

# 테스트 환경 빌드 및 실행
docker-compose -f docker/test/docker-compose.yml up --build