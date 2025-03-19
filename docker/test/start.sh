#!/bin/bash

# =====================================================================
# 테스트 환경 시작 스크립트
# =====================================================================
# 사용법: ./docker/test/start.sh
# 기능: 테스트 환경 Docker 컨테이너를 시작하고 Vue 앱 빌드 및 Nginx 서버 실행 확인
# =====================================================================

# 스크립트의 위치와 상관없이 항상 프로젝트 루트 디렉토리로 이동
# 이렇게 하면 docker-compose.yml 파일을 정확히 찾을 수 있음
cd "$(dirname "$0")/../.."

echo "테스트 환경을 시작합니다..."

# 개발 환경의 node_modules 볼륨이 있는지 확인
# 테스트 환경은 개발 환경의 node_modules 볼륨을 재사용함
if ! docker volume ls | grep -q "dev_modules"; then
    # 개발 환경 볼륨이 없는 경우 오류 메시지 출력 후 스크립트 종료
    echo "개발 환경의 node_modules 볼륨이 없습니다. 먼저 개발 환경을 실행해 주세요."
    echo "명령어: ./docker/dev/start.sh"
    exit 1
fi

echo "테스트 환경이 시작되면 http://localhost:8080 에서 접속할 수 있습니다."
echo "빌드 중입니다. 잠시 기다려 주세요..."

# 테스트 환경 실행 (이미 실행 중이면 재실행하지 않음)
# "$(docker ps -q -f name=vue-test)": vue-test 이름의 실행 중인 컨테이너 ID 반환
if [ "$(docker ps -q -f name=vue-test)" ]; then
    # 이미 실행 중인 경우 메시지만 출력하고 종료
    echo "테스트 컨테이너가 이미 실행 중입니다."
else
    # -d 옵션으로 백그라운드 실행 (프로젝트 이름을 'test'로 지정)
    # -p test: 프로젝트 이름 설정
    # -f: 사용할 docker-compose 파일 지정
    # up -d: 백그라운드(detached) 모드로 컨테이너 실행
    docker-compose -p test -f docker/test/docker-compose.yml up -d
    echo "테스트 환경이 백그라운드에서 시작되었습니다."
    echo "로그를 확인하려면: docker logs -f vue-test"
    
    # 빌드 완료 확인 (최대 60초 대기)
    echo "빌드 완료를 기다리는 중..."
    max_wait=60  # 최대 대기 시간(초)
    counter=0
    while [ $counter -lt $max_wait ]; do
        # Nginx 서버가 시작되었는지 확인
        # "start worker process" 메시지가 로그에 나타나면 서버가 시작된 것
        if docker logs vue-test 2>&1 | grep -q "start worker process"; then
            echo "빌드가 완료되었습니다. http://localhost:8080 에서 접속 가능합니다."
            break  # 서버가 시작되면 루프 종료
        fi
        sleep 2  # 2초 대기
        counter=$((counter+2))  # 카운터 증가
        echo -n "."  # 진행 중임을 표시
    done
    
    # 타임아웃 발생 시 안내 메시지 출력
    if [ $counter -ge $max_wait ]; then
        echo ""  # 줄바꿈
        echo "빌드 상태를 확인할 수 없습니다. 로그를 확인해보세요: docker logs vue-test"
    fi
fi