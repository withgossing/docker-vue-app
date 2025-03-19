#!/bin/bash

# ===================================================================
# clean.sh - 모든 환경 종료 및 Docker 자원 초기화 스크립트
# ===================================================================
# 사용법: ./clean.sh
# 기능: 모든 개발, 테스트, 프로덕션 환경을 종료하고 관련 Docker 리소스를 정리합니다.
# ===================================================================

echo "모든 환경을 종료하고 Docker 자원을 초기화합니다..."

# stop-all.sh 스크립트를 호출하여 실행 중인 모든 컨테이너를 종료
echo "모든 컨테이너를 종료합니다..."
./stop-all.sh

# 프로젝트와 관련된 Docker 볼륨 목록 표시
echo "현재 볼륨 목록:"
docker volume ls | grep -E 'dev_modules|test_modules|test_build|prod_modules'

# 사용자에게 볼륨 삭제 여부를 묻는 프롬프트 표시
read -p "모든 볼륨을 삭제하시겠습니까? (y/n): " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    # 사용자가 y 또는 yes로 응답한 경우 볼륨 삭제
    echo "모든 볼륨을 삭제합니다..."
    # 오류가 발생해도 스크립트 실행을 계속하기 위해 || true 사용
    docker volume rm -f dev_modules test_modules test_build prod_modules 2>/dev/null || true
else
    # 사용자가 n 또는 no로 응답한 경우 볼륨 유지
    echo "볼륨을 유지합니다."
fi

# 프로젝트와 관련된 Docker 이미지 찾아서 삭제
echo "프로젝트 관련 Docker 이미지를 삭제합니다..."
# grep으로 관련 이미지를 찾고, awk로 이미지 ID를 추출한 후, xargs로 docker rmi 명령에 전달
docker images | grep -E 'dev-app|test-app|prod-app' | awk '{print $3}' | xargs docker rmi -f 2>/dev/null || true

# 빌드 결과물이 있는 dist 디렉토리가 존재하면 삭제
if [ -d "./dist" ]; then
    echo "빌드 결과물 디렉토리를 초기화합니다..."
    rm -rf ./dist
fi

# 사용하지 않는 Docker 네트워크 삭제 (docker-compose로 생성된 네트워크 포함)
echo "Docker 네트워크를 정리합니다..."
docker network prune -f

echo "정리가 완료되었습니다."