import { fileURLToPath, URL } from 'node:url'
import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import VueDevTools from 'vite-plugin-vue-devtools'

/**
 * Vite 설정 파일
 * 
 * 이 파일은 Vite 빌드 도구의 설정을 정의합니다.
 * Vue.js 프로젝트의 빌드, 개발 서버, 플러그인 등의 설정을 관리합니다.
 * 
 * @see https://vitejs.dev/config/
 */
export default defineConfig(({ mode }) => {
  // 현재 실행 모드(development, production, test)에 따라 환경 변수 로드
  const env = loadEnv(mode, process.cwd())

  return {
    plugins: [
      vue(), // Vue 3 지원을 위한 플러그인
      VueDevTools(), // Vue 개발 도구 플러그인 - 개발 중 디버깅 및 분석 기능 제공
    ],
    resolve: {
      alias: {
        // '@' 심볼을 'src' 디렉토리로 설정하여 임포트 경로 단축
        '@': fileURLToPath(new URL('./src', import.meta.url))
      }
    },
    server: {
      host: '0.0.0.0', // 모든 네트워크 인터페이스에서 접근 가능하도록 설정 (Docker 컨테이너 내부에서 실행 시 필요)
      port: 5173, // 개발 서버 포트
      watch: {
        usePolling: true, // 파일 변경 감지를 위한 폴링 사용 (Docker 볼륨 마운트 시 필요)
      }
    }
  }
})