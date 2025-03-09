# vue-app

This template should help get you started developing with Vue 3 in Vite.

## Recommended IDE Setup

[VSCode](https://code.visualstudio.com/) + [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur).

## Type Support for `.vue` Imports in TS

TypeScript cannot handle type information for `.vue` imports by default, so we replace the `tsc` CLI with `vue-tsc` for type checking. In editors, we need [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) to make the TypeScript language service aware of `.vue` types.

## Customize configuration

See [Vite Configuration Reference](https://vite.dev/config/).

## Project Setup

```sh
npm install
```

### Compile and Hot-Reload for Development

```sh
npm run dev
```

### Type-Check, Compile and Minify for Production

```sh
npm run build
```

### Lint with [ESLint](https://eslint.org/)

```sh
npm run lint
```



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
   - 실행 시 모든 환경 초기화 후 시작
   - 접속: http://localhost:5173

2. **테스트 환경 (test)**:
   - 개발 환경에서 작성된 소스 코드를 빌드
   - Nginx를 통해 빌드된 앱 제공
   - 기본적으로 Ctrl+C로 종료 가능한 포그라운드 모드로 실행
   - 프로덕션 배포 시에는 백그라운드 모드로 전환
   - 접속: http://localhost:8080

3. **프로덕션 환경 (prod)**:
   - 테스트 환경에서 생성된 빌드 결과물을 기반으로 실행
   - Nginx를 통해 앱 제공
   - 프로덕션 환경 설정 적용
   - 실행 시 프로덕션 환경만 초기화 후 시작
   - 접속: http://localhost

## 시작하기

### VS Code에서 개발 컨테이너 열기 (개발 환경)

1. VS Code 열기
2. Dev Containers 확장 설치
3. 명령 팔레트(F1)에서 `Dev Containers: Open Folder in Container` 선택
4. 프로젝트 폴더 선택

### 각 환경 실행 방법

**개발 환경 실행** (모든 환경 초기화 후 시작):
```bash
npm run docker:dev
# 또는
./scripts/run-dev.sh

# 백그라운드에서 실행
npm run docker:dev:detach
```

**테스트 환경 실행** (테스트 환경만 초기화 후 시작):
```bash
# 포그라운드에서 실행 (Ctrl+C로 종료 가능)
npm run docker:test
# 또는
./scripts/run-test.sh

# 프로덕션 배포를 위해 백그라운드에서 실행 (Ctrl+C로 종료되지 않음)
npm run docker:test:bg
# 또는
./scripts/start-test-background.sh
```

**프로덕션 환경 실행** (프로덕션 환경만 초기화 후 시작):
```bash
# 테스트 환경 빌드를 가져와 프로덕션 배포
npm run docker:deploy-prod
# 또는
./scripts/run-prod.sh

# 일반 프로덕션 실행
npm run docker:prod
```

### 워크플로우

일반적인 개발/테스트 워크플로우:
1. `npm run docker:dev` - 개발 환경에서 코드 작성 및 개발
2. `npm run docker:test` - 테스트 환경에서 빌드 및 테스트 (Ctrl+C로 종료 가능)

프로덕션 배포 워크플로우:
1. `npm run docker:test:bg` - 테스트 환경을 백그라운드에서 실행
2. `npm run docker:deploy-prod` - 테스트 환경 빌드를 프로덕션에 배포

### 볼륨 관리

각 환경은 명명된 볼륨을 사용하여 데이터를 유지합니다:

```bash
# 볼륨 목록 확인
docker volume ls | grep dev_ test_ prod_

# 특정 볼륨 삭제
docker volume rm dev_modules
docker volume rm test_build
docker volume rm test_modules
docker volume rm prod_modules
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