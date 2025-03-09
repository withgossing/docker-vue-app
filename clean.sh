#!/bin/bash

# 모든 환경 종료 및 Docker 자원 초기화 스크립트

echo "모든 환경을 종료하고 Docker 자원을 초기화합니다..."

# 모든 컨테이너 종료
echo "모든 컨테이너를 종료합니다..."
./stop-all.sh

# 모든 볼륨 삭제
echo "모든 볼륨을 삭제합니다..."
docker volume rm -f dev_modules test_build test_modules prod_modules 2>/dev/null || true

# 프로젝트 관련 Docker 이미지 삭제
echo "프로젝트 관련 Docker 이미지를 삭제합니다..."
docker images | grep "vue-app\|test\|prod" | awk '{print $3}' | xargs docker rmi -f 2>/dev/null || true

# dist 디렉토리 초기화
if [ -d "./dist" ]; then
    echo "빌드 결과물 디렉토리를 초기화합니다..."
    rm -rf ./dist
fi

# docker-compose로 생성된 네트워크 삭제
echo "Docker 네트워크를 정리합니다..."
docker network prune -f

echo "정리가 완료되었습니다. 모든 환경 및 관련 Docker 자원이 삭제되었습니다."