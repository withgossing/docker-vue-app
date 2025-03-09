FROM node:20 as build-stage

WORKDIR /app

# 앱 의존성 파일 복사
COPY package*.json ./

# 의존성 설치
RUN npm install

# 소스 코드 복사
COPY . .

# Nginx 스테이지
FROM nginx:stable-alpine

# Nginx 설정
COPY docker/prod/nginx.conf /etc/nginx/conf.d/default.conf

# 테스트 환경에서 복사한 빌드 결과물 사용
COPY dist/ /usr/share/nginx/html/

# nginx 포트 노출
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]