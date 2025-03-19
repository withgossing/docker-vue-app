#!/bin/bash

# ===================================================================
# restart-all.sh - 개발/테스트/프로덕션 환경을 모두 재시작하는 스크립트
# ===================================================================
# 사용법: ./restart-all.sh [--clean|-c]
# 옵션:
#   --clean, -c: 모든 Docker 이미지, 볼륨 및 빌드 결과물 삭제 후 재시작
# ===================================================================

# 파라미터 초기화
CLEAN_ALL=false

# 명령줄 파라미터 처리
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --clean|-c) 
            CLEAN_ALL=true  # 환경을 완전히 초기화하는 옵션 활성화
            ;;
        *) 
            echo "알 수 없는 파라미터: $1" 
            echo "사용법: ./restart-all.sh [--clean|-c]"
            exit 1 
            ;;
    esac
    shift
done

echo "모든 환경을 종료합니다..."

# 현재 실행 중인 모든 컨테이너 종료 (stop-all.sh 스크립트 호출)
./stop-all.sh

# =================================================================
# 클린 모드: 모든 이미지, 볼륨 및 빌드 결과물 삭제
# =================================================================
if [ "$CLEAN_ALL" = true ]; then
    echo "모든 환경의 이미지와 볼륨을 삭제합니다..."
    
    # Docker 이미지 삭제
    echo "Docker 이미지 삭제 중..."
    images_to_remove=(dev-app test-app prod-app)
    for img in "${images_to_remove[@]}"; do
        # 이미지가 존재하는지 확인 후 삭제
        if [ "$(docker images -q $img)" ]; then
            echo "이미지 $img 삭제"
            docker rmi $img
        fi
    done
    
    # Docker 볼륨 삭제
    echo "Docker 볼륨 삭제 중..."
    volumes_to_remove=(dev_modules test_modules test_build prod_modules)
    for vol in "${volumes_to_remove[@]}"; do
        # 볼륨이 존재하는지 확인 후 삭제
        if [ "$(docker volume ls -q -f name=$vol)" ]; then
            echo "볼륨 $vol 삭제"
            docker volume rm $vol
        fi
    done
    
    # 로컬 빌드 결과물 디렉토리 삭제
    if [ -d "./dist" ]; then
        echo "로컬 빌드 결과물 삭제 중..."
        rm -rf ./dist
    fi
    
    echo "모든 이미지와 볼륨이 삭제되었습니다. 환경을 새로 빌드합니다."
fi

echo "모든 환경을 재시작합니다..."

# =================================================================
# 개발 환경 시작
# =================================================================
echo "개발 환경 시작 중..."
# 클린 모드인 경우 이미지를 다시 빌드
if [ "$CLEAN_ALL" = true ]; then
    docker-compose -p dev build
fi
# 개발 환경 컨테이너 시작 (백그라운드 모드)
docker-compose -p dev up -d
echo "개발 환경이 백그라운드에서 시작되었습니다."

# 개발 서버 시작 확인 (최대 30초 대기)
echo "개발 서버 시작을 기다리는 중..."
max_wait=30
counter=0
while [ $counter -lt $max_wait ]; do
    # "Local:" 문자열이 로그에 나타나면 서버가 준비된 것으로 판단
    if docker logs vue-dev 2>&1 | grep -q "Local:"; then
        echo "개발 서버가 시작되었습니다. http://localhost:5173 에서 접속 가능합니다."
        break
    fi
    sleep 1
    counter=$((counter+1))
    echo -n "."  # 진행 중임을 표시
done

# 타임아웃 시 오류 메시지 표시
if [ $counter -ge $max_wait ]; then
    echo ""
    echo "개발 서버 상태를 확인할 수 없습니다. 로그를 확인해보세요: docker logs vue-dev"
fi

# =================================================================
# 테스트 환경 시작
# =================================================================
echo "테스트 환경 시작 중..."
# 클린 모드인 경우 이미지를 다시 빌드
if [ "$CLEAN_ALL" = true ]; then
    docker-compose -p test -f docker/test/docker-compose.yml build
fi
# 테스트 환경 컨테이너 시작 (백그라운드 모드)
docker-compose -p test -f docker/test/docker-compose.yml up -d
echo "테스트 환경이 백그라운드에서 시작되었습니다."

# 테스트 환경 빌드 완료 확인 (최대 120초 대기)
echo "테스트 환경 빌드 완료를 기다리는 중..."
max_wait=120
counter=0
while [ $counter -lt $max_wait ]; do
    # Nginx worker 프로세스 시작 메시지가 로그에 나타나면 준비된 것으로 판단
    if docker logs vue-test 2>&1 | grep -q "start worker process"; then
        echo "테스트 환경 빌드가 완료되었습니다. http://localhost:8080 에서 접속 가능합니다."
        break
    fi
    sleep 1
    counter=$((counter+1))
    echo -n "."  # 진행 중임을 표시
done

# 타임아웃 시 오류 메시지 표시 및 스크립트 종료
if [ $counter -ge $max_wait ]; then
    echo ""
    echo "테스트 환경 빌드 상태를 확인할 수 없습니다. 로그를 확인해보세요: docker logs vue-test"
    echo "프로덕션 환경 시작을 건너뜁니다."
    exit 1
fi

# =================================================================
# 테스트 환경에서 빌드 결과물 추출
# =================================================================
echo "테스트 환경에서 빌드 결과물 복사 중..."
# 테스트 컨테이너 ID 가져오기
CONTAINER_ID=$(docker ps -qf "name=vue-test")
# 기존 dist 디렉토리 제거 (있는 경우)
rm -rf ./dist 2>/dev/null || true
# 새 dist 디렉토리 생성
mkdir -p ./dist
# 테스트 컨테이너에서 빌드된 파일 복사
docker cp $CONTAINER_ID:/usr/share/nginx/html/. ./dist/

# =================================================================
# 프로덕션 환경 시작
# =================================================================
echo "프로덕션 환경 시작 중..."
# 클린 모드인 경우 이미지를 다시 빌드
if [ "$CLEAN_ALL" = true ]; then
    docker-compose -p prod -f docker/prod/docker-compose.yml build
fi
# 프로덕션 환경 컨테이너 시작 (백그라운드 모드)
docker-compose -p prod -f docker/prod/docker-compose.yml up -d
echo "프로덕션 환경이 백그라운드에서 시작되었습니다."

# 프로덕션 서버 시작 확인 (최대 30초 대기)
echo "프로덕션 서버 시작을 기다리는 중..."
max_wait=30
counter=0
while [ $counter -lt $max_wait ]; do
    # Nginx worker 프로세스 시작 메시지가 로그에 나타나면 준비된 것으로 판단
    if docker logs vue-prod 2>&1 | grep -q "start worker process"; then
        echo "프로덕션 서버가 시작되었습니다. http://localhost 에서 접속 가능합니다."
        break
    fi
    sleep 1
    counter=$((counter+1))
    echo -n "."  # 진행 중임을 표시
done

# 타임아웃 시 오류 메시지 표시
if [ $counter -ge $max_wait ]; then
    echo ""
    echo "프로덕션 서버 상태를 확인할 수 없습니다. 로그를 확인해보세요: docker logs vue-prod"
fi

# =================================================================
# 모든 환경 시작 완료 요약
# =================================================================
echo -e "\n모든 환경이 재시작되었습니다."
echo "- 개발 환경: http://localhost:5173"
echo "- 테스트 환경: http://localhost:8080"
echo "- 프로덕션 환경: http://localhost"
echo "각 환경의 상태를 확인하려면 다음 명령어를 사용하세요:"
echo "- 개발 환경 로그: docker logs -f vue-dev"
echo "- 테스트 환경 로그: docker logs -f vue-test"
echo "- 프로덕션 환경 로그: docker logs -f vue-prod"