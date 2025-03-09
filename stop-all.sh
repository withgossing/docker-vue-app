#!/bin/bash

# 모든 환경 종료 스크립트

echo "모든 환경을 종료합니다..."

# 프로덕션 환경 종료
echo "프로덕션 환경 종료 중..."
./docker/prod/stop.sh

# 테스트 환경 종료
echo "테스트 환경 종료 중..."
./docker/test/stop.sh

# 개발 환경 종료
echo "개발 환경 종료 중..."
./docker/dev/stop.sh

echo "모든 환경이 종료되었습니다."