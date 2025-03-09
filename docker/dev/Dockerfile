FROM node:20

WORKDIR /app

# 기본 도구 설치
RUN apt-get update && \
    apt-get install -y git curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 앱 의존성 파일 복사
COPY package*.json ./

# 의존성 설치
RUN npm install

# 개발 서버 포트 노출
EXPOSE 5173

# 개발 서버 실행
CMD ["npm", "run", "dev"]