#!/bin/bash

# 개발 환경 재시작 스크립트
cd "$(dirname "$0")/../.."

echo "개발 환경을 재시작합니다..."

# 실행 중인 컨테이너 확인 및 중지
if [ "$(docker ps -q -f name=vue-dev)" ]; then
    echo "개발 컨테이너를 중지합니다."
    docker-compose down
fi

echo "개발 환경을 시작합니다..."
echo "개발 서버가 시작되면 http://localhost:5173 에서 접속할 수 있습니다."

# 개발 환경 재실행
docker-compose up