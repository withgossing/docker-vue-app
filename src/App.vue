<template>
  <div class="min-h-screen bg-base-200">
    <Sidebar :isOpen="sidebarOpen" @toggle="toggleSidebar" />
    <div :class="`transition-all duration-300 ${sidebarOpen ? 'pl-64' : 'pl-20'}`">
      <Header @toggle-sidebar="toggleSidebar" :username="user.name" :avatarUrl="user.avatar" />
      <main class="px-6 py-8">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { RouterView } from 'vue-router';
import Header from '@/components/Header.vue';
import Sidebar from '@/components/Sidebar.vue';

// 사용자 상태 정의
interface User {
  name: string;
  avatar: string;
}

const sidebarOpen = ref(true);
const user = ref<User>({
  name: '홍길동',
  avatar: '/api/placeholder/40/40'
});

const toggleSidebar = (): void => {
  sidebarOpen.value = !sidebarOpen.value;
};
</script>