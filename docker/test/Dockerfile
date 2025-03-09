FROM node:20 as build-stage

WORKDIR /app

# 앱 의존성 파일 복사
COPY package*.json ./

# 의존성 설치 (ci 대신 install 사용)
RUN npm install

# 소스 코드 복사
COPY . .

# 테스트 환경 변수 파일을 .env로 복사
COPY docker/test/.env .env

# 테스트용 빌드
RUN npm run build

# Nginx 스테이지
FROM nginx:stable-alpine as test-stage

# Nginx 설정
COPY docker/test/nginx.conf /etc/nginx/conf.d/default.conf

# 빌드된 앱 파일 복사
COPY --from=build-stage /app/dist /usr/share/nginx/html

# nginx 포트 노출
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]