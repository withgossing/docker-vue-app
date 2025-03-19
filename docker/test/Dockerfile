# =====================================================================
# 테스트 환경용 Dockerfile
# =====================================================================
# 안정적인 Alpine 기반 Nginx 이미지를 베이스로 사용
# Alpine 이미지는 크기가 작고 보안성이 높은 경량 이미지
FROM nginx:stable-alpine

# 필요한 개발 도구 설치
# Node.js와 npm을 Alpine 패키지 매니저(apk)로 설치
# --no-cache 옵션은 패키지 캐시를 저장하지 않아 이미지 크기를 줄임
RUN apk add --no-cache nodejs npm

# Nginx 설정 파일을 컨테이너 내부의 Nginx 설정 디렉토리로 복사
# 이 설정으로 SPA(Single Page Application) 라우팅 및 캐싱 설정
COPY docker/test/nginx.conf /etc/nginx/conf.d/default.conf

# 빌드 및 서버 실행을 위한 쉘 스크립트 복사
# 이 스크립트는 Vue 애플리케이션을 빌드하고 Nginx로 서빙함
COPY docker/test/build-and-serve.sh /usr/local/bin/
# 스크립트에 실행 권한 부여
RUN chmod +x /usr/local/bin/build-and-serve.sh

# 작업 디렉토리 설정 - 애플리케이션 소스 코드가 이 경로에 마운트됨
WORKDIR /app

# Nginx 웹 서버 기본 포트 노출
# 이 포트는 docker-compose.yml에서 호스트의 8080 포트로 매핑됨
EXPOSE 80

# 컨테이너 시작 시 실행할 명령어
# 빌드 후 Nginx 서버를 실행하는 스크립트 호출
CMD ["/usr/local/bin/build-and-serve.sh"]