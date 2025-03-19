#!/bin/bash

# =====================================================================
# 개발 환경 재시작 스크립트
# =====================================================================
# 사용법: ./docker/dev/restart.sh [--clean|-c]
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
            echo "사용법: ./docker/dev/restart.sh [--clean|-c]" 
            exit 1 
            ;;
    esac
    shift  # 다음 파라미터로 이동
done

echo "개발 환경을 재시작합니다..."

# 실행 중인 개발 컨테이너 확인 및 중지
if [ "$(docker ps -q -f name=vue-dev)" ]; then
    # docker ps -q: 컨테이너 ID만 반환
    # -f name=vue-dev: vue-dev 이름으로 필터링
    echo "개발 컨테이너를 중지합니다."
    docker-compose -p dev down  # 컨테이너 중지 및 제거
fi

# =================================================================
# 클린 모드: 이미지와 볼륨 모두 삭제
# =================================================================
if [ "$CLEAN_ALL" = true ]; then
    echo "개발 환경의 이미지와 볼륨을 모두 삭제합니다..."
    
    # 이미지 존재 여부 확인 후 삭제
    if [ "$(docker images -q dev-app)" ]; then
        echo "개발 이미지를 삭제합니다."
        docker rmi dev-app  # dev-app 이미지 삭제
    fi
    
    # 볼륨 존재 여부 확인 후 삭제
    if [ "$(docker volume ls -q -f name=dev_modules)" ]; then
        echo "개발 볼륨을 삭제합니다."
        docker volume rm dev_modules  # dev_modules 볼륨 삭제
    fi
    
    echo "이미지와 볼륨이 삭제되었습니다. 개발 환경을 새로 빌드합니다."
    
    # 개발 환경 새로 빌드 (이미지 새로 생성)
    docker-compose -p dev build
fi

echo "개발 환경을 시작합니다..."
echo "개발 서버가 시작되면 http://localhost:5173 에서 접속할 수 있습니다."

# 개발 환경 재실행 (백그라운드에서)
# -p dev: 프로젝트 이름을 'dev'로 지정
# up -d: 백그라운드(detached)에서 컨테이너 실행
docker-compose -p dev up -d
echo "개발 환경이 백그라운드에서 시작되었습니다."
echo "로그를 확인하려면: docker logs -f vue-dev"

# 서버 시작 확인 (최대 30초 대기)
echo "개발 서버 시작을 기다리는 중..."
max_wait=30  # 최대 대기 시간(초)
counter=0
while [ $counter -lt $max_wait ]; do
    # 개발 서버가 시작되었는지 확인
    # "Local:" 문자열이 Vite 서버가 시작될 때 로그에 나타남
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