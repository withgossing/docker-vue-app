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

# 모든 환경 종료 및 Docker 자원 정리
./clean.sh
# 또는
npm run docker:clean
```

## 깨끗한 재시작 옵션

각 환경의 재시작 스크립트에는 `--clean` 또는 `-c` 플래그를 사용하여 이미지와 볼륨을 모두 삭제하고 처음부터 다시 시작하는 옵션이 추가되었습니다.

### 개발 환경 깨끗한 재시작

```bash
# 스크립트 직접 실행
./docker/dev/restart.sh --clean
# 또는
./docker/dev/restart.sh -c

# npm 스크립트 사용
npm run docker:dev:restart:clean
```

이 명령어는:
1. 실행 중인 개발 컨테이너를 중지합니다.
2. 개발 환경 이미지(dev-app)를 삭제합니다.
3. 개발 환경 볼륨(dev_modules)을 삭제합니다.
4. 개발 환경을 처음부터 다시 빌드하고 시작합니다.

### 테스트 환경 깨끗한 재시작

```bash
# 스크립트 직접 실행
./docker/test/restart.sh --clean
# 또는
./docker/test/restart.sh -c

# npm 스크립트 사용
npm run docker:test:restart:clean
```

### 프로덕션 환경 깨끗한 재시작

```bash
# 스크립트 직접 실행
./docker/prod/restart.sh --clean
# 또는
./docker/prod/restart.sh -c

# npm 스크립트 사용
npm run docker:prod:restart:clean
```

### 모든 환경 깨끗한 재시작

```bash
# 스크립트 직접 실행
./restart-all.sh --clean
# 또는
./restart-all.sh -c

# npm 스크립트 사용
npm run docker:restart:all:clean
```

이 명령어는 모든 환경(개발, 테스트, 프로덕션)의 컨테이너, 이미지, 볼륨을 모두 삭제하고 처음부터 다시 빌드하고 시작합니다.

### 사용 시나리오

- **의존성 충돌 해결**: 패키지 의존성 관련 문제가 발생할 때 볼륨을 정리하여 새로 설치
- **이미지 재빌드**: Dockerfile 변경 후 이미지를 완전히 새로 빌드해야 할 때
- **문제 해결**: 컨테이너나 볼륨에 문제가 발생했을 때 깨끗한 상태에서 다시 시작

## 컨테이너 접속 방법

```bash
# 개발 컨테이너 쉘 접속
npm run docker:dev:sh

# 테스트 컨테이너 쉘 접속
npm run docker:test:sh

# 프로덕션 컨테이너 쉘 접속
npm run docker:prod:sh
```

## 워크플로우

이 프로젝트의 개발, 테스트, 배포 워크플로우는 다음과 같습니다:

1. **개발 (Development)**:
   - 개발 환경(dev)에서 코드를 작성하고 개발 서버로 실시간 변경 사항 확인
   - 로컬 개발이 완료되면 테스트 환경으로 이동

2. **테스트 (Test)**:
   - 테스트 환경(test)에서 애플리케이션을 빌드
   - 빌드된 결과물을 Nginx를 통해 제공하여 테스트 환경에서 검증
   - 테스트가 완료되면 프로덕션 환경으로 이동

3. **프로덕션 (Production)**:
   - 테스트 환경에서 검증된 빌드 결과물을 그대로 사용
   - 프로덕션용 Nginx 설정으로 배포 환경에서 제공
   - 프로덕션 환경에서 최종 검증

이 워크플로우는 테스트 환경에서 검증된 동일한 빌드를 프로덕션으로 그대로 가져가므로 환경 간 일관성을 유지하고 배포 위험을 최소화합니다.

## 폴더 구조

```
.
├── .devcontainer/         # VS Code 개발 컨테이너 설정
├── docker/                # Docker 설정 파일들
│   ├── dev/               # 개발 환경 설정
│   │   ├── Dockerfile     # 개발 환경 도커 설정
│   │   ├── docker-compose.yml  # 개발 환경 도커 컴포즈 설정
│   │   ├── start.sh       # 개발 환경 시작 스크립트
│   │   ├── restart.sh     # 개발 환경 재시작 스크립트
│   │   ├── stop.sh        # 개발 환경 종료 스크립트
│   │   └── .env           # 개발 환경 변수
│   ├── test/              # 테스트 환경 설정
│   │   ├── Dockerfile     # 테스트 환경 도커 설정
│   │   ├── docker-compose.yml  # 테스트 환경 도커 컴포즈 설정
│   │   ├── start.sh       # 테스트 환경 시작 스크립트
│   │   ├── restart.sh     # 테스트 환경 재시작 스크립트
│   │   ├── stop.sh        # 테스트 환경 종료 스크립트
│   │   ├── nginx.conf     # 테스트 환경 Nginx 설정
│   │   └── .env           # 테스트 환경 변수
│   └── prod/              # 프로덕션 환경 설정
│       ├── Dockerfile     # 프로덕션 환경 도커 설정
│       ├── docker-compose.yml  # 프로덕션 환경 도커 컴포즈 설정
│       ├── start.sh       # 프로덕션 환경 시작 스크립트
│       ├── restart.sh     # 프로덕션 환경 재시작 스크립트
│       ├── stop.sh        # 프로덕션 환경 종료 스크립트
│       ├── nginx.conf     # 프로덕션 환경 Nginx 설정
│       └── .env           # 프로덕션 환경 변수
├── start-all.sh           # 모든 환경 시작 스크립트
├── restart-all.sh         # 모든 환경 재시작 스크립트
├── stop-all.sh            # 모든 환경 종료 스크립트
├── clean.sh               # 모든 환경 종료 및 Docker 자원 정리 스크립트
├── dist/                  # 빌드 결과물 (테스트 환경에서 생성, 프로덕션 환경에서 사용)
├── public/                # 정적 파일
├── src/                   # 소스 코드
└── vite.config.ts         # Vite 프로젝트 설정
```

## Tailwind CSS & daisyUI 사용 방법

이 프로젝트는 Tailwind CSS와 daisyUI를 사용하여 UI 개발을 더 빠르고 일관되게 할 수 있도록 설정되어 있습니다.

### 설치 및 설정

Tailwind CSS와 daisyUI는 이미 프로젝트에 설치되어 있지만, 새로 설치하려면 다음 명령어를 실행하세요:

```bash
# 스크립트 실행 권한 부여
chmod +x setup-tailwind-daisyui.sh

# 설치 스크립트 실행
./setup-tailwind-daisyui.sh

# 또는 npm 스크립트 사용
npm run setup:tailwind
```

### 주요 파일

- `tailwind.config.js`: Tailwind CSS 및 daisyUI 설정
- `postcss.config.js`: PostCSS 설정
- `src/assets/main.css`: Tailwind CSS 지시어 및 기본 스타일
- `src/components/DaisyExample.vue`: daisyUI 컴포넌트 예제

### daisyUI 테마

이 프로젝트는 다음 테마를 사용하도록 설정되어 있습니다:

- light: 기본 밝은 테마
- dark: 어두운 테마
- cupcake: 부드러운 파스텔 테마
- corporate: 전문적인 비즈니스 테마

테마를 변경하려면 다음 방법 중 하나를 사용하세요:

1. HTML의 data-theme 속성 변경:
   ```html
   <html data-theme="dark">
   ```

2. JavaScript로 동적 변경:
   ```js
   document.documentElement.setAttribute('data-theme', 'dark');
   ```

3. 예제 컴포넌트의 테마 선택기 사용 (`/daisy-example` 경로 방문)

### Tailwind CSS 유틸리티 클래스 사용법

기본적인 Tailwind CSS 클래스 사용법:

```html
<!-- 텍스트 스타일링 -->
<p class="text-lg font-bold text-blue-500">안녕하세요!</p>

<!-- 레이아웃 -->
<div class="flex justify-between items-center p-4 gap-2">
  <!-- 내용 -->
</div>

<!-- 반응형 디자인 -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <!-- 내용 -->
</div>
```

### daisyUI 컴포넌트 사용법

daisyUI는 Tailwind CSS 위에 구축된 컴포넌트 라이브러리입니다:

```html
<!-- 버튼 -->
<button class="btn btn-primary">버튼</button>

<!-- 카드 -->
<div class="card bg-base-100 shadow-xl">
  <div class="card-body">
    <h2 class="card-title">카드 제목</h2>
    <p>카드 내용</p>
    <div class="card-actions justify-end">
      <button class="btn btn-primary">확인</button>
    </div>
  </div>
</div>

<!-- 폼 요소 -->
<input type="text" placeholder="입력" class="input input-bordered w-full" />
```

### 예제 페이지

`/daisy-example` 경로에서 다양한 daisyUI 컴포넌트 예제를 확인할 수 있습니다.

### 더 알아보기

- [Tailwind CSS 공식 문서](https://tailwindcss.com/docs)
- [daisyUI 공식 문서](https://daisyui.com/components/)

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
- Tailwind CSS
- daisyUI