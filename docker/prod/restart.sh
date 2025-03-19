#!/bin/bash

# =====================================================================
# 프로덕션 환경 재시작 스크립트
# =====================================================================
# 사용법: ./docker/prod/restart.sh [--clean|-c]
# 옵션:
#   --clean, -c: 이미지와 볼륨을 모두 삭제하고 새로 빌드
# =====================================================================

# 스크립트의 위치와 상관없이 항상 프로젝트 루트 디렉토리로 이동
# dirname $0: 현재 스크립트 경로
# cd: 상위 디렉토리의 상위 디렉토리(프로젝트 루트)로 이동
cd "$(dirname "$0")/../.."

# 파라미터 초기화
CLEAN_ALL=false

# 명령줄 파라미터 처리
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --clean|-c) 
            # 클린 모드 활성화 (이미지와 볼륨 모두 삭제 후 재빌드)
            CLEAN_ALL=true 
            ;;
        *) 
            # 알 수 없는 파라미터 오류 처리
            echo "알 수 없는 파라미터: $1" 
            echo "사용법: ./docker/prod/restart.sh [--clean|-c]"
            exit 1 
            ;;
    esac
    shift  # 다음 파라미터로 이동
done

echo "프로덕션 환경을 재시작합니다..."

# 실행 중인 프로덕션 컨테이너 확인 및 중지
if [ "$(docker ps -q -f name=vue-prod)" ]; then
    # docker ps -q: 컨테이너 ID만 반환
    # -f name=vue-prod: vue-prod 이름으로 필터링
    echo "프로덕션 컨테이너를 중지합니다."
    # 프로덕션 환경 전용 docker-compose 설정 파일 사용
    docker-compose -p prod -f docker/prod/docker-compose.yml down
fi

# =================================================================
# 클린 모드: 이미지와 볼륨 모두 삭제
# =================================================================
if [ "$CLEAN_ALL" = true ]; then
    echo "프로덕션 환경의 이미지와 볼륨을 모두 삭제합니다..."
    
    # 이미지 존재 여부 확인 후 삭제
    if [ "$(docker images -q prod-app)" ]; then
        echo "프로덕션 이미지를 삭제합니다."
        docker rmi prod-app  # prod-app 이미지 삭제
    fi
    
    # 볼륨 존재 여부 확인 후 삭제
    if [ "$(docker volume ls -q -f name=prod_modules)" ]; then
        echo "프로덕션 볼륨을 삭제합니다."
        docker volume rm prod_modules  # prod_modules 볼륨 삭제
    fi
    
    # dist 디렉토리 삭제 (빌드 결과물 정리)
    if [ -d "./dist" ]; then
        echo "빌드 결과물을 삭제합니다."
        rm -rf ./dist
    fi
    
    echo "이미지와 볼륨이 삭제되었습니다. 프로덕션 환경을 새로 빌드합니다."
fi

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

echo "프로덕션 환경을 시작합니다..."
echo "프로덕션 서버가 시작되면 http://localhost 에서 접속할 수 있습니다."

# 프로덕션 환경 재실행 (백그라운드에서)
# -p prod: 프로젝트 이름을 'prod'로 지정
# -f: 사용할 docker-compose 파일 지정
# up -d: 백그라운드(detached)에서 컨테이너 실행
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