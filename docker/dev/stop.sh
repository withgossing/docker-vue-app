#!/bin/bash

# 개발 환경 종료 스크립트
cd "$(dirname "$0")/../.."

echo "개발 환경을 종료합니다..."

# 실행 중인 개발 컨테이너 확인 및 중지
if [ "$(docker ps -q -f name=vue-dev)" ]; then
    echo "개발 컨테이너를 중지합니다."
    docker-compose down
    echo "개발 환경이 종료되었습니다."
else
    echo "실행 중인 개발 컨테이너가 없습니다."
fi