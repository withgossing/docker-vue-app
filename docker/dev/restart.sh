#!/bin/bash

# 개발 환경 재시작 스크립트
cd "$(dirname "$0")/../.."

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

echo "개발 환경을 재시작합니다..."

# 실행 중인 컨테이너 확인 및 중지
if [ "$(docker ps -q -f name=vue-dev)" ]; then
    echo "개발 컨테이너를 중지합니다."
    docker-compose -p dev down
fi

# 이미지 및 볼륨 삭제 옵션이 활성화된 경우
if [ "$CLEAN_ALL" = true ]; then
    echo "개발 환경의 이미지와 볼륨을 모두 삭제합니다..."
    
    # 이미지 삭제
    if [ "$(docker images -q dev-app)" ]; then
        echo "개발 이미지를 삭제합니다."
        docker rmi dev-app
    fi
    
    # 볼륨 삭제
    if [ "$(docker volume ls -q -f name=dev_modules)" ]; then
        echo "개발 볼륨을 삭제합니다."
        docker volume rm dev_modules
    fi
    
    echo "이미지와 볼륨이 삭제되었습니다. 개발 환경을 새로 빌드합니다."
    
    # 개발 환경 새로 빌드
    docker-compose -p dev build
fi

echo "개발 환경을 시작합니다..."
echo "개발 서버가 시작되면 http://localhost:5173 에서 접속할 수 있습니다."

# 개발 환경 재실행 (백그라운드에서)
docker-compose -p dev up -d
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