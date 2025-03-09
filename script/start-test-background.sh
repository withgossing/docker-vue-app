#!/bin/bash

# 테스트 환경을 백그라운드에서 실행하는 스크립트 (프로덕션 배포용)
cd "$(dirname "$0")/.."

# 이미 실행 중인 테스트 컨테이너가 있는지 확인
if [ "$(docker ps -q -f name=vue-test)" ]; then
    echo "테스트 컨테이너가 이미 실행 중입니다."
    echo "테스트 환경 URL: http://localhost:8080"
else
    # 테스트 환경만 초기화
    echo "테스트 환경을 초기화합니다..."

    # 테스트 볼륨 초기화
    echo "테스트 환경 볼륨을 초기화합니다..."
    docker volume rm -f test_build test_modules 2>/dev/null || true

    echo "테스트 환경을 백그라운드에서 시작합니다..."
    echo "빌드가 완료되면 http://localhost:8080 에서 테스트 환경에 접속할 수 있습니다."

    # 테스트 환경을 백그라운드에서 실행
    docker-compose -f docker/test/docker-compose.yml up --build -d

    echo "테스트 환경이 백그라운드에서 실행 중입니다."
    echo "로그를 확인하려면: docker logs -f vue-test"
fi

# 테스트 환경을 위한 명령어 안내
echo -e "\n프로덕션 배포를 위한 테스트 환경이 실행 중입니다."
echo "프로덕션 배포 준비가 되면: ./scripts/run-prod.sh"