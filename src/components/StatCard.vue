<template>
    <div class="card bg-base-100 shadow-xl">
      <div class="card-body p-6">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-base-content/70 text-sm font-medium">{{ title }}</h2>
            <p class="mt-2 text-2xl font-bold">{{ value }}</p>
            <div class="mt-2 flex items-center text-sm">
              <span 
                :class="isPositive ? 'text-success' : 'text-error'"
              >
                {{ change }}
              </span>
              <span class="ml-1 text-base-content/70">지난달 대비</span>
            </div>
          </div>
          <div :class="`bg-${color}/10 p-3 rounded-lg`">
            <component :is="getIcon" class="h-6 w-6" :class="`text-${color}`" />
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { computed, markRaw, h } from 'vue';
  
  interface IconComponent {
    render: () => any;
  }
  
  interface Icons {
    [key: string]: IconComponent;
  }
  
  const props = defineProps<{
    title: string;
    value: string;
    change: string;
    isPositive: boolean;
    color: string;
    icon: string;
  }>();
  
  const getIcon = computed(() => {
    const icons: Icons = {
      'users': markRaw({
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
      }),
      'cash': markRaw({
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
            d: 'M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z'
          })
        ])
      }),
      'shopping-cart': markRaw({
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
            d: 'M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z'
          })
        ])
      }),
      'chart-bar': markRaw({
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
    };
  
    return icons[props.icon];
  });
  </script>