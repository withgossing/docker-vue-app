# Vue.js + Vite Docker 개발 환경

이 프로젝트는 Vue.js 3 + Vite + TypeScript 애플리케이션을 Docker 컨테이너에서 개발, 테스트 및 배포하기 위한 환경을 제공합니다.

## 요구사항

- Docker
- Docker Compose
- VS Code (+ Dev Containers 확장)

## 환경 구성

프로젝트는 세 가지 별도의 환경으로 구성되어 있습니다:

1. **개발 환경 (dev)**:
   - 핫 리로딩이 적용된 Vite 개발 서버 실행
   - 소스 코드 편집 및 개발 작업 수행
   - 접속: http://localhost:5173

2. **테스트 환경 (test)**:
   - 개발 환경에서 작성된 소스 코드를 빌드
   - Nginx를 통해 빌드된 앱 제공
   - 접속: http://localhost:8080

3. **프로덕션 환경 (prod)**:
   - 테스트 환경에서 생성된 빌드 결과물을 기반으로 실행
   - Nginx를 통해 앱 제공
   - 접속: http://localhost

## 스크립트 설명

각 환경별로 다음 스크립트가 제공됩니다:

### 개발 환경 스크립트

- `start.sh`: 개발 환경을 시작합니다.
- `restart.sh`: 개발 환경을 초기화하고 재시작합니다.
- `stop.sh`: 개발 환경을 종료합니다.

### 테스트 환경 스크립트

- `start.sh`: 테스트 환경을 시작합니다.
- `restart.sh`: 테스트 환경을 초기화하고 재시작합니다.
- `stop.sh`: 테스트 환경을 종료합니다.

### 프로덕션 환경 스크립트

- `start.sh`: 프로덕션 환경을 시작합니다.
- `restart.sh`: 프로덕션 환경을 초기화하고 재시작합니다.
- `stop.sh`: 프로덕션 환경을 종료합니다.

### 종합 스크립트

- `start-all.sh`: 모든 환경을 시작합니다.
- `restart-all.sh`: 모든 환경을 초기화하고 재시작합니다.
- `stop-all.sh`: 모든 환경을 종료합니다.

## 시작하기

### 스크립트 실행 권한 부여

```bash
# 모든 스크립트에 실행 권한 부여
chmod +x docker/dev/*.sh docker/test/*.sh docker/prod/*.sh *.sh
```

### 환경별 실행 방법

**개발 환경**:
```bash
# 시작
./docker/dev/start.sh
# 또는
npm run docker:dev:start

# 재시작
./docker/dev/restart.sh
# 또는
npm run docker:dev:restart

# 종료
./docker/dev/stop.sh
# 또는
npm run docker:dev:stop
```

**테스트 환경**:
```bash
# 시작
./docker/test/start.sh
# 또는
npm run docker:test:start

# 재시작
./docker/test/restart.sh
# 또는
npm run docker:test:restart

# 종료
./docker/test/stop.sh
# 또는
npm run docker:test:stop
```

**프로덕션 환경**:
```bash
# 시작
./docker/prod/start.sh
# 또는
npm run docker:prod:start

# 재시작
./docker/prod/restart.sh
# 또는
npm run docker:prod:restart

# 종료
./docker/prod/stop.sh
# 또는
npm run docker:prod:stop
```

**모든 환경 한 번에 관리**:
```bash
# 모든 환경 시작
./start-all.sh
# 또는
npm run docker:start:all

# 모든 환경 재시작
./restart-all.sh
# 또는
npm run docker:restart:all

# 모든 환경 종료
./stop-all.sh
# 또는
npm run docker:stop:all
```

### 컨테이너 접속 방법

```bash
# 개발 컨테이너 쉘 접속
npm run docker:dev:sh

# 테스트 컨테이너 쉘 접속
npm run docker:test:sh

# 프로덕션 컨테이너 쉘 접속
npm run docker:prod:sh
```

### 환경 정리

```bash
# 개발 환경 정리
npm run docker:clean:dev

# 테스트 환경 정리
npm run docker:clean:test

# 프로덕션 환경 정리
npm run docker:clean:prod

# 모든 환경 정리
npm run docker:clean:all
```

## 워크플로우

이 프로젝트의 개발, 테스트, 배포 워크플로우는 다음과 같습니다:

1. **개발 (Development)**:
   - `run-dev.sh` 스크립트 실행 시 모든 환경이 초기화됨
   - 개발 환경(dev)에서 코드를 작성하고 개발 서버로 실시간 변경 사항 확인
   - 개발이 완료되면 테스트 환경으로 이동

2. **테스트 (Test)**:
   - `run-test.sh` 스크립트 실행 시 테스트 환경만 초기화됨
   - 테스트 환경(test)에서 애플리케이션을 빌드
   - 빌드된 결과물을 Nginx를 통해 제공하여 테스트 환경에서 검증
   - 테스트 환경은 계속 실행되어 프로덕션 배포를 위한 소스로 사용
   - 필요에 따라 지속적으로 개발 및 테스트 진행

3. **프로덕션 (Production)**:
   - `run-prod.sh` 스크립트 실행 시 프로덕션 환경만 초기화됨
   - 테스트 환경에서 검증된 빌드 결과물을 프로덕션 환경으로 가져옴
   - 프로덕션용 Nginx 설정으로 배포 환경에서 제공
   - 테스트 환경은 영향 없이 계속 실행 가능

이 워크플로우는 각 환경이 독립적으로 운영되면서도 테스트 환경의 결과물을 프로덕션에 활용할 수 있습니다. 테스트 환경은 프로덕션 배포와 상관없이 계속 실행되어 개발 및 테스트를 지속할 수 있습니다.

## 폴더 구조

```
.
├── .devcontainer/         # VS Code 개발 컨테이너 설정
├── docker/                # Docker 설정 파일들
│   ├── dev/               # 개발 환경 설정
│   │   ├── Dockerfile     # 개발 환경 도커 설정
│   │   ├── docker-compose.yml  # 개발 환경 도커 컴포즈 설정
│   │   └── .env           # 개발 환경 변수
│   ├── test/              # 테스트 환경 설정
│   │   ├── Dockerfile     # 테스트 환경 도커 설정
│   │   ├── docker-compose.yml  # 테스트 환경 도커 컴포즈 설정
│   │   ├── nginx.conf     # 테스트 환경 Nginx 설정
│   │   └── .env           # 테스트 환경 변수
│   └── prod/              # 프로덕션 환경 설정
│       ├── Dockerfile     # 프로덕션 환경 도커 설정
│       ├── docker-compose.yml  # 프로덕션 환경 도커 컴포즈 설정
│       ├── nginx.conf     # 프로덕션 환경 Nginx 설정
│       └── .env           # 프로덕션 환경 변수
├── scripts/               # 실행 스크립트
│   ├── run-dev.sh         # 개발 환경 실행 스크립트 (모든 환경 초기화)
│   ├── run-test.sh        # 테스트 환경 실행 스크립트 (테스트 환경만 초기화)
│   └── run-prod.sh        # 프로덕션 환경 실행 스크립트 (프로덕션 환경만 초기화)
├── docker-compose.yml     # 기본 개발 환경 도커 컴포즈 설정 (VS Code Dev Container용)
├── dist/                  # 빌드 결과물 (테스트 환경에서 생성, 프로덕션 환경에서 사용)
├── public/                # 정적 파일
├── src/                   # 소스 코드
└── vite.config.ts         # Vite 프로젝트 설정
```

## 기술 스택

- Vue 3
- TypeScript
- Vite
- Vue Router
- Pinia
- ESLint
- Prettier
- Vitest
- Docker
- Nginx