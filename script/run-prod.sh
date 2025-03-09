#!/bin/bash

# 프로덕션 환경 실행 스크립트
cd "$(dirname "$0")/.."

# 프로덕션 환경만 초기화
echo "프로덕션 환경을 초기화합니다..."

# 실행 중인 프로덕션 컨테이너 확인 및 중지
if [ "$(docker ps -q -f name=vue-prod)" ]; then
    echo "프로덕션 컨테이너를 중지합니다."
    docker-compose -f docker/prod/docker-compose.yml down
fi

# 프로덕션 볼륨 초기화 (선택적)
echo "프로덕션 환경 볼륨을 초기화합니다..."
docker volume rm -f prod_modules 2>/dev/null || true

# 테스트 환경이 실행 중인지 확인
CONTAINER_ID=$(docker ps -qf "name=vue-test")
  
if [ -z "$CONTAINER_ID" ]; then
    echo "테스트 컨테이너가 실행 중이지 않습니다. 테스트 환경을 백그라운드에서 시작합니다."
    
    # 테스트 환경을 분리 모드로 시작
    docker-compose -f docker/test/docker-compose.yml up --build -d
    
    echo "테스트 환경이 백그라운드에서 시작되었습니다. 빌드가 완료될 때까지 잠시 기다립니다..."
    sleep 20  # 빌드 완료를 위한 대기 시간
    
    # 테스트 컨테이너 ID 다시 확인
    CONTAINER_ID=$(docker ps -qf "name=vue-test")
    
    if [ -z "$CONTAINER_ID" ]; then
        echo "테스트 컨테이너가 시작되지 않았습니다. 프로덕션 배포를 중단합니다."
        exit 1
    fi
fi

# 먼저 테스트 환경에서 빌드가 있는지 확인
if [ ! -d "./dist" ] || [ ! "$(ls -A ./dist)" ]; then
    echo "테스트 환경의 빌드 결과물이 없습니다. 테스트 환경에서 빌드 결과물을 가져옵니다."
    
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
    
    echo "테스트 환경의 빌드 결과물을 프로덕션 환경에서 사용합니다."
fi

echo "프로덕션 배포 중..."
echo "배포가 완료되면 http://localhost 에서 프로덕션 환경에 접속할 수 있습니다."
echo "테스트 환경은 백그라운드에서 계속 실행 중입니다."

# 프로덕션 환경 빌드 및 실행
docker-compose -f docker/prod/docker-compose.yml up --build