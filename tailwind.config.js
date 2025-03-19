/** 
 * Tailwind CSS 설정 파일
 * 
 * 이 파일은 Tailwind CSS 프레임워크의 설정을 정의합니다.
 * 콘텐츠 경로, 테마 확장, 플러그인 등을 구성할 수 있습니다.
 * 
 * @type {import('tailwindcss').Config} 
 */
export default {
  content: [
    "./index.html", // 프로젝트의 HTML 파일
    "./src/**/*.{vue,js,ts,jsx,tsx}", // Vue 컴포넌트와 JavaScript/TypeScript 파일
  ],
  theme: {
    extend: {}, // 기본 Tailwind 테마 확장 (필요에 따라 색상, 폰트 등 추가 가능)
  },
  plugins: [
    require("daisyui") // daisyUI 플러그인 사용 - 추가 컴포넌트 및 테마 제공
  ],
  daisyui: {
    themes: ["light", "dark", "cupcake", "corporate"], // 사용할 daisyUI 테마 목록
  },
}