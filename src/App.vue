<template>
  <header class="navbar bg-base-100 shadow-md">
    <div class="navbar-start">
      <div class="dropdown">
        <label tabindex="0" class="btn btn-ghost lg:hidden">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h8m-8 6h16" />
          </svg>
        </label>
        <ul tabindex="0" class="menu menu-sm dropdown-content mt-3 p-2 shadow bg-base-100 rounded-box w-52">
          <li><RouterLink to="/">Home</RouterLink></li>
          <li><RouterLink to="/about">About</RouterLink></li>
          <li><RouterLink to="/daisy-example">Components</RouterLink></li>
        </ul>
      </div>
      <RouterLink to="/" class="btn btn-ghost normal-case text-xl">Vue App</RouterLink>
    </div>
    <div class="navbar-center hidden lg:flex">
      <ul class="menu menu-horizontal px-1">
        <li><RouterLink to="/">Home</RouterLink></li>
        <li><RouterLink to="/about">About</RouterLink></li>
        <li><RouterLink to="/daisy-example">Components</RouterLink></li>
      </ul>
    </div>
    <div class="navbar-end">
      <a class="btn btn-primary">Get Started</a>
    </div>
  </header>

  <main class="container mx-auto py-8">
    <RouterView />
  </main>

  <footer class="footer p-10 bg-base-200 text-base-content">
    <div>
      <span class="footer-title">Services</span> 
      <a class="link link-hover">Branding</a> 
      <a class="link link-hover">Design</a> 
      <a class="link link-hover">Marketing</a> 
      <a class="link link-hover">Advertisement</a>
    </div> 
    <div>
      <span class="footer-title">Company</span> 
      <a class="link link-hover">About us</a> 
      <a class="link link-hover">Contact</a> 
      <a class="link link-hover">Jobs</a> 
      <a class="link link-hover">Press kit</a>
    </div> 
    <div>
      <span class="footer-title">Legal</span> 
      <a class="link link-hover">Terms of use</a> 
      <a class="link link-hover">Privacy policy</a> 
      <a class="link link-hover">Cookie policy</a>
    </div> 
    <div>
      <span class="footer-title">Newsletter</span> 
      <div class="form-control w-80">
        <label class="label">
          <span class="label-text">Enter your email address</span>
        </label> 
        <div class="relative">
          <input type="text" placeholder="username@site.com" class="input input-bordered w-full pr-16" /> 
          <button class="btn btn-primary absolute top-0 right-0 rounded-l-none">Subscribe</button>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
</script>