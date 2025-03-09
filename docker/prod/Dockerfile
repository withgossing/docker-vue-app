FROM nginx:stable-alpine

# Nginx 설정
COPY docker/prod/nginx.conf /etc/nginx/conf.d/default.conf

# 스크립트 복사
COPY docker/prod/serve.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/serve.sh

# 작업 디렉토리 생성
WORKDIR /app

# 테스트 환경에서 복사한 빌드 결과물 사용
COPY dist/ /usr/share/nginx/html/

# nginx 포트 노출
EXPOSE 80

CMD ["/usr/local/bin/serve.sh"]