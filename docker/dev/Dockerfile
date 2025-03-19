# =====================================================================
# 개발 환경용 Dockerfile
# =====================================================================
# Node.js 20 버전을 기반 이미지로 사용
FROM node:20

# 작업 디렉토리 설정 - 앱의 모든 파일과 명령어가 이 경로에서 실행됨
WORKDIR /app

# 기본 개발 도구 설치
# apt-get update: 패키지 목록 업데이트
# apt-get install: git과 curl 설치
# apt-get clean: 캐시 정리
# rm -rf: 불필요한 패키지 목록 제거하여 이미지 크기 축소
RUN apt-get update && \
    apt-get install -y git curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# package.json과 package-lock.json 파일을 컨테이너로 복사
# 의존성 설치 레이어를 캐싱하기 위해 소스 코드보다 먼저 복사
COPY package*.json ./

# NPM 의존성 패키지 설치
# 개발에 필요한 모든 라이브러리 설치(Tailwind CSS 및 DaisyUI 포함)
RUN npm install

# Vite 개발 서버가 사용하는 5173 포트 노출
# 호스트에서 이 포트로 개발 서버에 접근 가능
EXPOSE 5173

# 컨테이너 시작 시 실행되는 기본 명령어
# npm run dev: Vite 개발 서버 실행 명령어
CMD ["npm", "run", "dev"]