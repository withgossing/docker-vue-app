#!/bin/bash

# 테스트 환경 시작 스크립트
cd "$(dirname "$0")/../.."

echo "테스트 환경을 시작합니다..."
echo "테스트 환경이 시작되면 http://localhost:8080 에서 접속할 수 있습니다."

# 테스트 환경 실행 (이미 실행 중이면 재실행하지 않음)
if [ "$(docker ps -q -f name=vue-test)" ]; then
    echo "테스트 컨테이너가 이미 실행 중입니다."
else
    docker-compose -f docker/test/docker-compose.yml up
fi