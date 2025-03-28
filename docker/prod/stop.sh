#!/bin/bash

# =====================================================================
# 프로덕션 환경 종료 스크립트
# =====================================================================
# 사용법: ./docker/prod/stop.sh
# 기능: 프로덕션 환경 Docker 컨테이너를 안전하게 종료
# =====================================================================

# 스크립트의 위치와 상관없이 항상 프로젝트 루트 디렉토리로 이동
# 이렇게 하면 docker-compose.yml 파일을 정확히 찾을 수 있음
cd "$(dirname "$0")/../.."

echo "프로덕션 환경을 종료합니다..."

# 실행 중인 프로덕션 컨테이너 확인 및 중지
# "$(docker ps -q -f name=vue-prod)": vue-prod 이름의 실행 중인 컨테이너 ID 반환
if [ "$(docker ps -q -f name=vue-prod)" ]; then
    # 컨테이너가 실행 중인 경우 중지
    echo "프로덕션 컨테이너를 중지합니다."
    
    # docker-compose down: 컨테이너 중지 및 네트워크 제거
    # -f: 사용할 docker-compose 파일 지정
    # 컨테이너를 완전히 종료하고 리소스를 정리
    docker-compose -f docker/prod/docker-compose.yml down
    echo "프로덕션 환경이 종료되었습니다."
else
    # 실행 중인 컨테이너가 없는 경우 안내 메시지 출력
    echo "실행 중인 프로덕션 컨테이너가 없습니다."
fi