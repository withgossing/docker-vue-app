#!/bin/bash

# 개발 환경 시작 스크립트
cd "$(dirname "$0")/../.."

echo "개발 환경을 시작합니다..."
echo "개발 서버가 시작되면 http://localhost:5173 에서 접속할 수 있습니다."

# 개발 환경 실행 (이미 실행 중이면 재실행하지 않음)
if [ "$(docker ps -q -f name=vue-dev)" ]; then
    echo "개발 컨테이너가 이미 실행 중입니다."
else
    # 백그라운드에서 실행
    docker-compose up -d
    echo "개발 환경이 백그라운드에서 시작되었습니다."
    echo "로그를 확인하려면: docker logs -f vue-dev"
    
    # 서버 시작 확인 (최대 30초 대기)
    echo "개발 서버 시작을 기다리는 중..."
    max_wait=30
    counter=0
    while [ $counter -lt $max_wait ]; do
        # 개발 서버가 시작되었는지 확인
        if docker logs vue-dev 2>&1 | grep -q "Local:"; then
            echo "개발 서버가 시작되었습니다. http://localhost:5173 에서 접속 가능합니다."
            break
        fi
        sleep 2
        counter=$((counter+2))
        echo -n "."
    done
    
    if [ $counter -ge $max_wait ]; then
        echo ""
        echo "개발 서버 상태를 확인할 수 없습니다. 로그를 확인해보세요: docker logs vue-dev"
    fi
fi