/**
 * 환경 선언 타입 파일
 * 
 * 이 파일은 TypeScript에 환경에 관련된 타입 정보를 제공합니다.
 * Vite 클라이언트 타입과 Vue 컴포넌트 타입 선언을 포함합니다.
 */
/// <reference types="vite/client" />

/**
 * Vue 단일 파일 컴포넌트(.vue 파일)에 대한 타입 선언
 * 이를 통해 TypeScript가 .vue 파일을 모듈로 인식하고 처리할 수 있습니다.
 */
declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}