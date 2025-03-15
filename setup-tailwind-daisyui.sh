#!/bin/bash

# Tailwind CSS 및 daisyUI 설치 스크립트
echo "Tailwind CSS 및 daisyUI 설치 중..."

# 필요한 패키지 설치
npm install -D tailwindcss postcss autoprefixer daisyui@latest

# Tailwind CSS 초기화
npx tailwindcss init -p

echo "Tailwind CSS 및 daisyUI 설치 완료!"