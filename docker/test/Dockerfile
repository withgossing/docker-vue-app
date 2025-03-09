FROM nginx:stable-alpine

# 필요한 도구 설치
RUN apk add --no-cache nodejs npm

# Nginx 설정
COPY docker/test/nginx.conf /etc/nginx/conf.d/default.conf

# 빌드 스크립트 복사
COPY docker/test/build-and-serve.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/build-and-serve.sh

# 소스 코드 폴더 생성
WORKDIR /app

# nginx 포트 노출
EXPOSE 80

# 빌드 후 nginx 실행
CMD ["/usr/local/bin/build-and-serve.sh"]