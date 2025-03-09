#!/bin/bash

# 모든 환경 재시작 스크립트

echo "모든 환경을 종료합니다..."

# 모든 컨테이너 종료
./stop-all.sh

echo "모든 환경을 재시작합니다..."

# 개발 환경 시작 (백그라운드에서)
echo "개발 환경 시작 중..."
docker-compose up -d
echo "개발 환경이 백그라운드에서 시작되었습니다."

# 잠시 대기 (개발 환경 시작 대기)
echo "개발 환경 시작을 기다리는 중..."
sleep 10

# 테스트 환경 시작 (백그라운드에서)
echo "테스트 환경 시작 중..."
docker-compose -f docker/test/docker-compose.yml up -d
echo "테스트 환경이 백그라운드에서 시작되었습니다."

# 잠시 대기 (테스트 환경 빌드 완료 기다림)
echo "테스트 환경 빌드가 완료될 때까지 20초 대기 중..."
sleep 20

# 프로덕션 환경 시작 (백그라운드에서)
echo "프로덕션 환경 시작 중..."
chmod +x ./docker/prod/start.sh
./docker/prod/start.sh

echo -e "\n모든 환경이 재시작되었습니다."
echo "- 개발 환경: http://localhost:5173"
echo "- 테스트 환경: http://localhost:8080"
echo "- 프로덕션 환경: http://localhost"
echo "각 환경의 상태를 확인하려면 다음 명령어를 사용하세요:"
echo "- 개발 환경 로그: docker logs -f vue-dev"
echo "- 테스트 환경 로그: docker logs -f vue-test"
echo "- 프로덕션 환경 로그: docker logs -f vue-prod"