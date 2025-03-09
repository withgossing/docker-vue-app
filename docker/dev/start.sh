#!/bin/bash

# 개발 환경 시작 스크립트
cd "$(dirname "$0")/../.."

echo "개발 환경을 시작합니다..."
echo "개발 서버가 시작되면 http://localhost:5173 에서 접속할 수 있습니다."

# 개발 환경 실행 (이미 실행 중이면 재실행하지 않음)
if [ "$(docker ps -q -f name=vue-dev)" ]; then
    echo "개발 컨테이너가 이미 실행 중입니다."
else
    docker-compose up --build
fi