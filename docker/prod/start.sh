#!/bin/bash

# =====================================================================
# 프로덕션 환경 시작 스크립트
# =====================================================================
# 사용법: ./docker/prod/start.sh
# 기능: 프로덕션 환경 Docker 컨테이너를 시작하고 Nginx 서버 실행 확인
# =====================================================================

# 스크립트의 위치와 상관없이 항상 프로젝트 루트 디렉토리로 이동
# 이렇게 하면 docker-compose.yml 파일을 정확히 찾을 수 있음
cd "$(dirname "$0")/../.."

echo "프로덕션 환경을 시작합니다..."

# =================================================================
# 빌드 결과물 확인 및 테스트 환경에서 복사
# =================================================================
# dist 디렉토리가 없거나 비어있으면 테스트 환경에서 빌드 결과물 복사
if [ ! -d "./dist" ] || [ ! "$(ls -A ./dist)" ]; then
    echo "테스트 환경의 빌드 결과물이 없습니다. 테스트 환경에서 빌드 결과물을 가져옵니다."
    
    # 테스트 컨테이너 실행 여부 확인
    CONTAINER_ID=$(docker ps -qf "name=vue-test")
    
    # 테스트 컨테이너가 실행 중이 아니면 오류 메시지 출력 후 종료
    if [ -z "$CONTAINER_ID" ]; then
        echo "테스트 컨테이너가 실행 중이지 않습니다. 먼저 테스트 환경을 실행해 주세요."
        echo "명령어: ./docker/test/start.sh"
        exit 1
    fi
    
    # 기존 dist 디렉토리 제거 후 새로 생성
    rm -rf ./dist 2>/dev/null || true
    mkdir -p ./dist
    
    # 테스트 컨테이너에서 빌드 결과물 복사
    # docker cp 명령어로 컨테이너의 웹 루트 디렉토리에서 로컬의 dist 디렉토리로 파일 복사
    docker cp $CONTAINER_ID:/usr/share/nginx/html/. ./dist/
    
    echo "테스트 환경에서 빌드 결과물을 복사했습니다."
    
    # 복사 후 빌드 결과물 존재 여부 확인
    if [ ! "$(ls -A ./dist)" ]; then
        echo "빌드 결과물이 없습니다: dist 디렉토리가 비어 있습니다."
        exit 1
    fi
fi

echo "프로덕션 환경이 시작되면 http://localhost 에서 접속할 수 있습니다."

# 프로덕션 환경 실행 (이미 실행 중이면 재실행하지 않음)
# "$(docker ps -q -f name=vue-prod)": vue-prod 이름의 실행 중인 컨테이너 ID 반환
if [ "$(docker ps -q -f name=vue-prod)" ]; then
    # 이미 실행 중인 경우 메시지만 출력하고 종료
    echo "프로덕션 컨테이너가 이미 실행 중입니다."
else
    # 백그라운드에서 실행 (프로젝트 이름을 'prod'로 지정)
    # -p prod: 프로젝트 이름 설정
    # -f: 사용할 docker-compose 파일 지정
    # up -d: 백그라운드(detached) 모드로 컨테이너 실행
    docker-compose -p prod -f docker/prod/docker-compose.yml up -d
    echo "프로덕션 환경이 백그라운드에서 시작되었습니다."
    echo "로그를 확인하려면: docker logs -f vue-prod"
    
    # Nginx 서버 시작 확인 (최대 30초 대기)
    echo "프로덕션 서버 시작을 기다리는 중..."
    max_wait=30  # 최대 대기 시간(초)
    counter=0
    while [ $counter -lt $max_wait ]; do
        # Nginx 서버가 시작되었는지 확인
        # "start worker process" 메시지가 로그에 나타나면 서버가 시작된 것
        if docker logs vue-prod 2>&1 | grep -q "start worker process"; then
            echo "프로덕션 서버가 시작되었습니다. http://localhost 에서 접속 가능합니다."
            break  # 서버가 시작되면 루프 종료
        fi
        sleep 2  # 2초 대기
        counter=$((counter+2))  # 카운터 증가
        echo -n "."  # 진행 중임을 표시
    done
    
    # 타임아웃 발생 시 안내 메시지 출력
    if [ $counter -ge $max_wait ]; then
        echo ""  # 줄바꿈
        echo "프로덕션 서버 상태를 확인할 수 없습니다. 로그를 확인해보세요: docker logs vue-prod"
    fi
fi