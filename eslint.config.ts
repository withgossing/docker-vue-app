import pluginVue from 'eslint-plugin-vue'
import { defineConfigWithVueTs, vueTsConfigs } from '@vue/eslint-config-typescript'
import skipFormatting from '@vue/eslint-config-prettier/skip-formatting'

/**
 * ESLint 설정 파일
 * 
 * 이 파일은 코드 품질과 일관성을 유지하기 위한 ESLint 규칙을 정의합니다.
 * Vue, TypeScript, Prettier와의 통합을 설정합니다.
 * 
 * 주요 기능:
 * - Vue 코드 린팅 규칙 적용
 * - TypeScript 코드 검증 
 * - Prettier와의 충돌 방지
 */

// To allow more languages other than `ts` in `.vue` files, uncomment the following lines:
// import { configureVueProject } from '@vue/eslint-config-typescript'
// configureVueProject({ scriptLangs: ['ts', 'tsx'] })
// More info at https://github.com/vuejs/eslint-config-typescript/#advanced-setup

export default defineConfigWithVueTs(
  {
    name: 'app/files-to-lint',
    files: ['**/*.{ts,mts,tsx,vue}'], // 린트 검사할 파일 패턴
  },

  {
    name: 'app/files-to-ignore',
    ignores: ['**/dist/**', '**/dist-ssr/**', '**/coverage/**'], // 린트 검사에서 제외할 파일 패턴
  },

  pluginVue.configs['flat/essential'], // Vue.js 필수 린팅 규칙
  vueTsConfigs.recommended, // TypeScript 권장 린팅 규칙
  skipFormatting, // Prettier와 충돌 방지 설정
)