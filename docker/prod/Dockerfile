# =====================================================================
# 프로덕션 환경용 Dockerfile
# =====================================================================
# 안정적인 Alpine 기반 Nginx 이미지를 베이스로 사용
# Alpine 이미지는 크기가 작고 보안성이 높은 경량 이미지로 프로덕션에 적합
FROM nginx:stable-alpine

# Nginx 설정 파일을 컨테이너 내부의 Nginx 설정 디렉토리로 복사
# 이 설정으로 SPA(Single Page Application) 라우팅 및 캐싱 설정
COPY docker/prod/nginx.conf /etc/nginx/conf.d/default.conf

# 서버 실행을 위한 쉘 스크립트 복사
# 이 스크립트는 프로덕션 환경 정보를 기록하고 Nginx를 시작함
COPY docker/prod/serve.sh /usr/local/bin/
# 스크립트에 실행 권한 부여
RUN chmod +x /usr/local/bin/serve.sh

# 작업 디렉토리 설정
# 애플리케이션 관련 파일과 로그가 이 경로에 저장됨
WORKDIR /app

# 테스트 환경에서 이미 빌드된 결과물을 Nginx의 웹 루트 디렉토리로 복사
# 프로덕션 환경은 별도의 빌드 과정 없이 이미 빌드된 정적 파일만 제공
COPY dist/ /usr/share/nginx/html/

# Nginx 웹 서버 기본 포트 노출
# 이 포트는 docker-compose.yml에서 호스트의 80 포트로 매핑됨
EXPOSE 80

# 컨테이너 시작 시 실행할 명령어
# 서버 정보를 기록하고 Nginx를 시작하는 스크립트 실행
CMD ["/usr/local/bin/serve.sh"]