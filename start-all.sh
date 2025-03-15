#!/bin/bash

# 모든 환경 시작 스크립트

echo "모든 환경을 시작합니다..."

# 개발 환경 시작 (백그라운드에서)
echo "개발 환경 시작 중..."
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

# 프로덕션 환경 시작 (백그라운드에서)
echo "프로덕션 환경 시작 중..."
chmod +x ./docker/prod/start.sh
./docker/prod/start.sh

echo -e "\n모든 환경이 시작되었습니다."
echo "- 개발 환경: http://localhost:5173"
echo "- 테스트 환경: http://localhost:8080"
echo "- 프로덕션 환경: http://localhost"
echo "각 환경의 상태를 확인하려면 다음 명령어를 사용하세요:"
echo "- 개발 환경 로그: docker logs -f vue-dev"
echo "- 테스트 환경 로그: docker logs -f vue-test"
echo "- 프로덕션 환경 로그: docker logs -f vue-prod"