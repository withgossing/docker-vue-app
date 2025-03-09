#!/bin/bash

# 모든 환경 초기화 및 재시작 스크립트

echo "모든 환경을 종료합니다..."

# 모든 컨테이너 종료
./stop-all.sh

# 모든 볼륨 초기화
echo "모든 볼륨을 초기화합니다..."
docker volume rm -f dev_modules test_build test_modules prod_modules 2>/dev/null || true

# dist 디렉토리 초기화
if [ -d "./dist" ]; then
    echo "빌드 결과물 디렉토리를 초기화합니다..."
    rm -rf ./dist
fi

# 모든 환경 시작
echo "모든 환경을 재시작합니다..."
./start-all.sh