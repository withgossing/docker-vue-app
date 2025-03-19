#!/bin/bash

# =====================================================================
# 개발 환경 시작 스크립트
# =====================================================================
# 사용법: ./docker/dev/start.sh
# 기능: 개발 환경 Docker 컨테이너를 시작하고 Vite 개발 서버 실행 확인
# =====================================================================

# 스크립트의 위치와 상관없이 항상 프로젝트 루트 디렉토리로 이동
# 이렇게 하면 docker-compose.yml 파일을 정확히 찾을 수 있음
cd "$(dirname "$0")/../.."

echo "개발 환경을 시작합니다..."
echo "개발 서버가 시작되면 http://localhost:5173 에서 접속할 수 있습니다."

# 개발 환경 실행 (이미 실행 중이면 재실행하지 않음)
# "$(docker ps -q -f name=vue-dev)": vue-dev 이름의 실행 중인 컨테이너 ID 반환
if [ "$(docker ps -q -f name=vue-dev)" ]; then
    # 이미 실행 중인 경우 메시지만 출력하고 종료
    echo "개발 컨테이너가 이미 실행 중입니다."
else
    # 백그라운드에서 실행 (프로젝트 이름을 'dev'로 지정)
    # -p dev: 프로젝트 이름 설정
    # up -d: 백그라운드(detached) 모드로 컨테이너 실행
    docker-compose -p dev up -d
    echo "개발 환경이 백그라운드에서 시작되었습니다."
    echo "로그를 확인하려면: docker logs -f vue-dev"
    
    # 서버 시작 확인 (최대 30초 대기)
    echo "개발 서버 시작을 기다리는 중..."
    max_wait=30  # 최대 대기 시간(초)
    counter=0
    while [ $counter -lt $max_wait ]; do
        # 개발 서버가 시작되었는지 확인
        # Vite 서버가 시작되면 로그에 "Local:" 문자열이 포함됨
        if docker logs vue-dev 2>&1 | grep -q "Local:"; then
            echo "개발 서버가 시작되었습니다. http://localhost:5173 에서 접속 가능합니다."
            break  # 서버가 시작되면 루프 종료
        fi
        sleep 2  # 2초 대기
        counter=$((counter+2))  # 카운터 증가
        echo -n "."  # 진행 중임을 표시
    done
    
    # 타임아웃 발생 시 안내 메시지 출력
    if [ $counter -ge $max_wait ]; then
        echo ""  # 줄바꿈
        echo "개발 서버 상태를 확인할 수 없습니다. 로그를 확인해보세요: docker logs vue-dev"
    fi
fi