#!/bin/bash

# 모든 환경 재시작 스크립트

# 파라미터 확인
CLEAN_ALL=false

# 파라미터 처리
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --clean|-c) CLEAN_ALL=true ;;
        *) echo "알 수 없는 파라미터: $1"; exit 1 ;;
    esac
    shift
done

echo "모든 환경을 종료합니다..."

# 모든 컨테이너 종료
./stop-all.sh

# 이미지 및 볼륨 삭제 옵션이 활성화된 경우
if [ "$CLEAN_ALL" = true ]; then
    echo "모든 환경의 이미지와 볼륨을 삭제합니다..."
    
    # 이미지 삭제
    echo "Docker 이미지 삭제 중..."
    images_to_remove=(dev-app test-app prod-app)
    for img in "${images_to_remove[@]}"; do
        if [ "$(docker images -q $img)" ]; then
            echo "이미지 $img 삭제"
            docker rmi $img
        fi
    done
    
    # 볼륨 삭제
    echo "Docker 볼륨 삭제 중..."
    volumes_to_remove=(dev_modules test_modules test_build prod_modules)
    for vol in "${volumes_to_remove[@]}"; do
        if [ "$(docker volume ls -q -f name=$vol)" ]; then
            echo "볼륨 $vol 삭제"
            docker volume rm $vol
        fi
    done
    
    # 빌드 결과물 삭제
    if [ -d "./dist" ]; then
        echo "빌드 결과물 삭제 중..."
        rm -rf ./dist
    fi
    
    echo "모든 이미지와 볼륨이 삭제되었습니다. 환경을 새로 빌드합니다."
fi

echo "모든 환경을 재시작합니다..."

# 개발 환경 시작 (백그라운드에서)
echo "개발 환경 시작 중..."
if [ "$CLEAN_ALL" = true ]; then
    docker-compose -p dev build
fi
docker-compose -p dev up -d
echo "개발 환경이 백그라운드에서 시작되었습니다."

# 개발 서버 시작 확인 (최대 30초 대기)
echo "개발 서버 시작을 기다리는 중..."
max_wait=30
counter=0
while [ $counter -lt $max_wait ]; do
    # 개발 서버가 시작되었는지 확인
    if docker logs vue-dev 2>&1 | grep -q "Local:"; then
        echo "개발 서버가 시작되었습니다. http://localhost:5173 에서 접속 가능합니다."
        break
    fi
    sleep 1
    counter=$((counter+1))
    echo -n "."
done

if [ $counter -ge $max_wait ]; then
    echo ""
    echo "개발 서버 상태를 확인할 수 없습니다. 로그를 확인해보세요: docker logs vue-dev"
fi

# 테스트 환경 시작 (백그라운드에서)
echo "테스트 환경 시작 중..."
if [ "$CLEAN_ALL" = true ]; then
    docker-compose -p test -f docker/test/docker-compose.yml build
fi
docker-compose -p test -f docker/test/docker-compose.yml up -d
echo "테스트 환경이 백그라운드에서 시작되었습니다."

# 빌드 완료 확인 (최대 120초 대기)
echo "테스트 환경 빌드 완료를 기다리는 중..."
max_wait=120
counter=0
while [ $counter -lt $max_wait ]; do
    # 빌드가 완료되었는지 확인 (Nginx가 작동 중인지 확인)
    if docker logs vue-test 2>&1 | grep -q "start worker process"; then
        echo "테스트 환경 빌드가 완료되었습니다. http://localhost:8080 에서 접속 가능합니다."
        break
    fi
    sleep 1
    counter=$((counter+1))
    echo -n "."
done

if [ $counter -ge $max_wait ]; then
    echo ""
    echo "테스트 환경 빌드 상태를 확인할 수 없습니다. 로그를 확인해보세요: docker logs vue-test"
    echo "프로덕션 환경 시작을 건너뜁니다."
    exit 1
fi

# 프로덕션 환경 시작을 위한 빌드 결과물 복사
echo "테스트 환경에서 빌드 결과물 복사 중..."
CONTAINER_ID=$(docker ps -qf "name=vue-test")
rm -rf ./dist 2>/dev/null || true
mkdir -p ./dist
docker cp $CONTAINER_ID:/usr/share/nginx/html/. ./dist/

# 프로덕션 환경 시작 (백그라운드에서)
echo "프로덕션 환경 시작 중..."
if [ "$CLEAN_ALL" = true ]; then
    docker-compose -p prod -f docker/prod/docker-compose.yml build
fi
docker-compose -p prod -f docker/prod/docker-compose.yml up -d
echo "프로덕션 환경이 백그라운드에서 시작되었습니다."

# Nginx 서버 시작 확인 (최대 30초 대기)
echo "프로덕션 서버 시작을 기다리는 중..."
max_wait=30
counter=0
while [ $counter -lt $max_wait ]; do
    # Nginx가 시작되었는지 확인
    if docker logs vue-prod 2>&1 | grep -q "start worker process"; then
        echo "프로덕션 서버가 시작되었습니다. http://localhost 에서 접속 가능합니다."
        break
    fi
    sleep 1
    counter=$((counter+1))
    echo -n "."
done

if [ $counter -ge $max_wait ]; then
    echo ""
    echo "프로덕션 서버 상태를 확인할 수 없습니다. 로그를 확인해보세요: docker logs vue-prod"
fi

echo -e "\n모든 환경이 재시작되었습니다."
echo "- 개발 환경: http://localhost:5173"
echo "- 테스트 환경: http://localhost:8080"
echo "- 프로덕션 환경: http://localhost"
echo "각 환경의 상태를 확인하려면 다음 명령어를 사용하세요:"
echo "- 개발 환경 로그: docker logs -f vue-dev"
echo "- 테스트 환경 로그: docker logs -f vue-test"
echo "- 프로덕션 환경 로그: docker logs -f vue-prod"