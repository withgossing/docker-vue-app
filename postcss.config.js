/**
 * PostCSS 설정 파일
 * 
 * 이 파일은 CSS 처리를 위한 PostCSS 도구의 플러그인 구성을 정의합니다.
 * Tailwind CSS와 Autoprefixer 플러그인을 사용하도록 설정되어 있습니다.
 */
export default {
  plugins: {
    tailwindcss: {}, // Tailwind CSS 처리를 위한 플러그인
    autoprefixer: {}, // 브라우저 호환성을 위한 CSS 접두사 자동 추가 플러그인
  },
}