<template>
    <div class="p-6 max-w-4xl mx-auto">
      <h1 class="text-3xl font-bold mb-6">Tailwind CSS & daisyUI Examples</h1>
      
      <!-- 버튼 예제 -->
      <div class="mb-8">
        <h2 class="text-xl font-semibold mb-4">Buttons</h2>
        <div class="flex flex-wrap gap-2">
          <button class="btn">Button</button>
          <button class="btn btn-primary">Primary</button>
          <button class="btn btn-secondary">Secondary</button>
          <button class="btn btn-accent">Accent</button>
          <button class="btn btn-ghost">Ghost</button>
          <button class="btn btn-link">Link</button>
        </div>
      </div>
  
      <!-- 카드 예제 -->
      <div class="mb-8">
        <h2 class="text-xl font-semibold mb-4">Cards</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="card bg-base-100 shadow-xl">
            <figure><img src="https://via.placeholder.com/400x200" alt="Card Image" /></figure>
            <div class="card-body">
              <h2 class="card-title">Card Title</h2>
              <p>This is a simple card example using daisyUI components.</p>
              <div class="card-actions justify-end">
                <button class="btn btn-primary">Action</button>
              </div>
            </div>
          </div>
          
          <div class="card bg-primary text-primary-content">
            <div class="card-body">
              <h2 class="card-title">Primary Card</h2>
              <p>This card has a primary background color.</p>
              <div class="card-actions justify-end">
                <button class="btn">Close</button>
              </div>
            </div>
          </div>
        </div>
      </div>
  
      <!-- 폼 요소 예제 -->
      <div class="mb-8">
        <h2 class="text-xl font-semibold mb-4">Form Elements</h2>
        <div class="flex flex-col gap-4 max-w-md">
          <div class="form-control">
            <label class="label">
              <span class="label-text">Email</span>
            </label>
            <input type="email" placeholder="email@example.com" class="input input-bordered" />
          </div>
          
          <div class="form-control">
            <label class="label">
              <span class="label-text">Password</span>
            </label>
            <input type="password" placeholder="password" class="input input-bordered" />
          </div>
          
          <div class="form-control">
            <label class="label cursor-pointer">
              <span class="label-text">Remember me</span>
              <input type="checkbox" class="checkbox checkbox-primary" />
            </label>
          </div>
          
          <div class="form-control">
            <label class="label">
              <span class="label-text">Select Option</span>
            </label>
            <select class="select select-bordered w-full">
              <option disabled selected>Pick one</option>
              <option>Option 1</option>
              <option>Option 2</option>
              <option>Option 3</option>
            </select>
          </div>
        </div>
      </div>
  
      <!-- 테마 전환 예제 -->
      <div class="mb-8">
        <h2 class="text-xl font-semibold mb-4">Theme Switcher</h2>
        <select class="select select-bordered" v-model="theme" @change="changeTheme">
          <option value="light">Light</option>
          <option value="dark">Dark</option>
          <option value="cupcake">Cupcake</option>
          <option value="corporate">Corporate</option>
        </select>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, onMounted } from 'vue';
  
  const theme = ref('light');
  
  function changeTheme() {
    document.documentElement.setAttribute('data-theme', theme.value);
    localStorage.setItem('theme', theme.value);
  }
  
  onMounted(() => {
    const savedTheme = localStorage.getItem('theme') || 'light';
    theme.value = savedTheme;
    document.documentElement.setAttribute('data-theme', savedTheme);
  });
  </script>