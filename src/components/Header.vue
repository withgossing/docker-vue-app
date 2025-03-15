<template>
    <header class="bg-base-100 shadow-md py-4 px-6 flex justify-between items-center">
      <div class="flex items-center">
        <button @click="$emit('toggle-sidebar')" class="p-2 rounded-lg hover:bg-base-200 mr-4">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
        </button>
        <h1 class="text-xl font-semibold">모던 대시보드</h1>
      </div>
  
      <div class="flex items-center gap-4">
        <!-- 검색 -->
        <div class="relative">
          <input
            type="text"
            placeholder="검색..."
            class="input input-bordered input-sm w-64 pl-10"
          />
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
            />
          </svg>
        </div>
        
        <!-- 알림 -->
        <div class="dropdown dropdown-end">
          <label tabindex="0" class="btn btn-ghost btn-circle">
            <div class="indicator">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-6 w-6"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
                />
              </svg>
              <span class="badge badge-xs badge-primary indicator-item">3</span>
            </div>
          </label>
          <div tabindex="0" class="mt-3 z-[1] card card-compact dropdown-content w-52 bg-base-100 shadow">
            <div class="card-body">
              <span class="font-bold text-lg">3개의 알림</span>
              <span class="text-info">새로운 메시지가 도착했습니다</span>
              <div class="card-actions">
                <button class="btn btn-primary btn-block">모두 보기</button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 사용자 -->
        <div class="dropdown dropdown-end">
          <label tabindex="0" class="btn btn-ghost btn-circle avatar">
            <div class="w-10 rounded-full">
              <img :src="avatarUrl" alt="프로필" />
            </div>
          </label>
          <ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52">
            <li><a>프로필</a></li>
            <li><a>설정</a></li>
            <li><a>로그아웃</a></li>
          </ul>
        </div>
      </div>
    </header>
  </template>
  
  <script setup lang="ts">
  defineProps<{
    username: string;
    avatarUrl: string;
  }>();
  
  defineEmits<{
    (e: 'toggle-sidebar'): void;
  }>();
  </script>