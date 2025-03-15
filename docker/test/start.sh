#!/bin/bash

# 테스트 환경 시작 스크립트
cd "$(dirname "$0")/../.."

echo "테스트 환경을 시작합니다..."

# dev 환경의 node_modules 볼륨이 있는지 확인
if ! docker volume ls | grep -q "dev_modules"; then
    echo "개발 환경의 node_modules 볼륨이 없습니다. 먼저 개발 환경을 실행해 주세요."
    echo "명령어: ./docker/dev/start.sh"
    exit 1
fi

echo "테스트 환경이 시작되면 http://localhost:8080 에서 접속할 수 있습니다."
echo "빌드 중입니다. 잠시 기다려 주세요..."

# 테스트 환경 실행 (이미 실행 중이면 재실행하지 않음)
if [ "$(docker ps -q -f name=vue-test)" ]; then
    echo "테스트 컨테이너가 이미 실행 중입니다."
else
    # -d 옵션으로 백그라운드 실행 (프로젝트 이름을 'test'로 지정)
    docker-compose -p test -f docker/test/docker-compose.yml up -d
    echo "테스트 환경이 백그라운드에서 시작되었습니다."
    echo "로그를 확인하려면: docker logs -f vue-test"
    
    # 빌드 완료 확인 (최대 60초 대기)
    echo "빌드 완료를 기다리는 중..."
    max_wait=60
    counter=0
    while [ $counter -lt $max_wait ]; do
        # 빌드가 완료되었는지 확인 (Nginx가 작동 중인지 확인)
        if docker logs vue-test 2>&1 | grep -q "start worker process"; then
            echo "빌드가 완료되었습니다. http://localhost:8080 에서 접속 가능합니다."
            break
        fi
        sleep 2
        counter=$((counter+2))
        echo -n "."
    done
    
    if [ $counter -ge $max_wait ]; then
        echo ""
        echo "빌드 상태를 확인할 수 없습니다. 로그를 확인해보세요: docker logs vue-test"
    fi
fi