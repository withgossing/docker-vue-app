#!/bin/bash

# ===================================================================
# start-all.sh - 모든 환경 시작 스크립트
# ===================================================================
# 사용법: ./start-all.sh
# 기능: 개발, 테스트, 프로덕션 환경의 Docker 컨테이너를 모두 시작합니다.
# ===================================================================

echo "모든 환경을 시작합니다..."

# =================================================================
# 개발 환경 시작
# =================================================================
echo "개발 환경 시작 중..."
# docker-compose를 사용하여 개발 환경 컨테이너 시작 (백그라운드 모드)
docker-compose -p dev up -d
echo "개발 환경이 백그라운드에서 시작되었습니다."

# 개발 서버 시작 확인 (최대 30초 대기)
echo "개발 서버 시작을 기다리는 중..."
max_wait=30
counter=0
while [ $counter -lt $max_wait ]; do
    # "Local:" 문자열이 로그에 나타나면 Vite 개발 서버가 준비된 것으로 판단
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
# docker-compose를 사용하여 테스트 환경 컨테이너 시작 (백그라운드 모드)
docker-compose -p test -f docker/test/docker-compose.yml up -d
echo "테스트 환경이 백그라운드에서 시작되었습니다."

# 테스트 환경 빌드 완료 확인 (최대 120초 대기)
echo "테스트 환경 빌드 완료를 기다리는 중..."
max_wait=120
counter=0
while [ $counter -lt $max_wait ]; do
    # Nginx worker 프로세스 시작 메시지가 로그에 나타나면 빌드가 완료된 것으로 판단
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
# 프로덕션 환경 시작
# =================================================================
echo "프로덕션 환경 시작 중..."
# 프로덕션 시작 스크립트에 실행 권한 부여 후 실행
chmod +x ./docker/prod/start.sh
./docker/prod/start.sh

# =================================================================
# 모든 환경 시작 완료 요약
# =================================================================
echo -e "\n모든 환경이 시작되었습니다."
echo "- 개발 환경: http://localhost:5173"
echo "- 테스트 환경: http://localhost:8080"
echo "- 프로덕션 환경: http://localhost"
echo "각 환경의 상태를 확인하려면 다음 명령어를 사용하세요:"
echo "- 개발 환경 로그: docker logs -f vue-dev"
echo "- 테스트 환경 로그: docker logs -f vue-test"
echo "- 프로덕션 환경 로그: docker logs -f vue-prod"