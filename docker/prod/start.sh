#!/bin/bash

# 프로덕션 환경 시작 스크립트
cd "$(dirname "$0")/../.."

echo "프로덕션 환경을 시작합니다..."

# 먼저 테스트 환경에서 빌드가 있는지 확인
if [ ! -d "./dist" ] || [ ! "$(ls -A ./dist)" ]; then
    echo "테스트 환경의 빌드 결과물이 없습니다. 테스트 환경에서 빌드 결과물을 가져옵니다."
    
    # 테스트 컨테이너 실행 확인
    CONTAINER_ID=$(docker ps -qf "name=vue-test")
    
    if [ -z "$CONTAINER_ID" ]; then
        echo "테스트 컨테이너가 실행 중이지 않습니다. 먼저 테스트 환경을 실행해 주세요."
        echo "명령어: ./docker/test/start.sh"
        exit 1
    fi
    
    # 임시 디렉토리 생성 또는 비우기
    rm -rf ./dist 2>/dev/null || true
    mkdir -p ./dist
    
    # 컨테이너에서 빌드 결과물 추출
    docker cp $CONTAINER_ID:/usr/share/nginx/html/. ./dist/
    
    echo "테스트 환경에서 빌드 결과물을 복사했습니다."
    
    # 빌드 결과 확인
    if [ ! "$(ls -A ./dist)" ]; then
        echo "빌드 결과물이 없습니다: dist 디렉토리가 비어 있습니다."
        exit 1
    fi
fi

echo "프로덕션 환경이 시작되면 http://localhost 에서 접속할 수 있습니다."

# 프로덕션 환경 실행 (이미 실행 중이면 재실행하지 않음)
if [ "$(docker ps -q -f name=vue-prod)" ]; then
    echo "프로덕션 컨테이너가 이미 실행 중입니다."
else
    docker-compose -f docker/prod/docker-compose.yml up
fi