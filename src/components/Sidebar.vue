<template>
    <aside
      class="fixed top-0 left-0 z-10 h-screen bg-base-100 shadow-lg transition-all duration-300"
      :class="isOpen ? 'w-64' : 'w-20'"
    >
      <div class="flex h-16 items-center justify-center border-b border-base-300">
        <div v-if="isOpen" class="text-2xl font-bold text-primary">대시보드</div>
        <div v-else class="text-2xl font-bold text-primary">D</div>
      </div>
  
      <nav class="mt-6 px-4">
        <ul class="space-y-2">
          <li v-for="(item, index) in menuItems" :key="index">
            <RouterLink
              :to="item.path"
              class="flex items-center rounded-lg p-3 hover:bg-base-200"
              :class="{ 'bg-primary text-primary-content hover:bg-primary-focus': item.active }"
              custom
              v-slot="{ isActive, href, navigate }"
            >
              <a
                :href="href"
                @click="navigate"
                class="flex items-center rounded-lg p-3 hover:bg-base-200"
                :class="{ 'bg-primary text-primary-content hover:bg-primary-focus': isActive }"
              >
                <span class="flex items-center justify-center">
                  <component :is="item.icon" class="h-6 w-6" />
                </span>
                <span v-if="isOpen" class="ml-4">{{ item.title }}</span>
              </a>
            </RouterLink>
          </li>
        </ul>
      </nav>
  
      <div class="absolute bottom-0 left-0 w-full border-t border-base-300 p-4">
        <a
          href="#"
          class="flex items-center rounded-lg p-3 hover:bg-base-200"
        >
          <span class="flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
          </span>
          <span v-if="isOpen" class="ml-4">로그아웃</span>
        </a>
      </div>
    </aside>
  </template>
  
  <script setup lang="ts">
  import { markRaw, h } from 'vue';
  import { RouterLink } from 'vue-router';
  
  interface MenuItem {
    title: string;
    path: string;
    active: boolean;
    icon: any;
  }
  
  const props = defineProps<{
    isOpen: boolean;
  }>();
  
  defineEmits<{
    (e: 'toggle'): void;
  }>();
  
  // 메뉴 아이템 정의
  const menuItems: MenuItem[] = [
    {
      title: '대시보드',
      path: '/',
      active: true,
      icon: markRaw({
        render: () => h('svg', {
          xmlns: 'http://www.w3.org/2000/svg',
          class: 'h-6 w-6',
          fill: 'none',
          viewBox: '0 0 24 24',
          stroke: 'currentColor'
        }, [
          h('path', {
            'stroke-linecap': 'round',
            'stroke-linejoin': 'round',
            'stroke-width': '2',
            d: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'
          })
        ])
      })
    },
    {
      title: '분석',
      path: '/analytics',
      active: false,
      icon: markRaw({
        render: () => h('svg', {
          xmlns: 'http://www.w3.org/2000/svg',
          class: 'h-6 w-6',
          fill: 'none',
          viewBox: '0 0 24 24',
          stroke: 'currentColor'
        }, [
          h('path', {
            'stroke-linecap': 'round',
            'stroke-linejoin': 'round',
            'stroke-width': '2',
            d: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z'
          })
        ])
      })
    },
    {
      title: '사용자',
      path: '/users',
      active: false,
      icon: markRaw({
        render: () => h('svg', {
          xmlns: 'http://www.w3.org/2000/svg',
          class: 'h-6 w-6',
          fill: 'none',
          viewBox: '0 0 24 24',
          stroke: 'currentColor'
        }, [
          h('path', {
            'stroke-linecap': 'round',
            'stroke-linejoin': 'round',
            'stroke-width': '2',
            d: 'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z'
          })
        ])
      })
    },
    {
      title: '설정',
      path: '/settings',
      active: false,
      icon: markRaw({
        render: () => h('svg', {
          xmlns: 'http://www.w3.org/2000/svg',
          class: 'h-6 w-6',
          fill: 'none',
          viewBox: '0 0 24 24',
          stroke: 'currentColor'
        }, [
          h('path', {
            'stroke-linecap': 'round',
            'stroke-linejoin': 'round',
            'stroke-width': '2',
            d: 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z'
          }),
          h('path', {
            'stroke-linecap': 'round',
            'stroke-linejoin': 'round',
            'stroke-width': '2',
            d: 'M15 12a3 3 0 11-6 0 3 3 0 016 0z'
          })
        ])
      })
    }
  ];
  </script>