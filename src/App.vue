<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <header>
    <nav>
      <RouterLink to="/">Home</RouterLink>
      <RouterLink to="/movies">Movies</RouterLink>
      <RouterLink to="/about">About</RouterLink>
    </nav>
  </header>

  <RouterView />
</template>

<style scoped>
header {
  line-height: 1.5;
  max-height: 100vh;
  padding: 20px;
  background: var(--color-background-soft);
}

nav {
  width: 100%;
  text-align: center;
  margin-top: 2rem;
}

nav a {
  display: inline-block;
  padding: 0 1rem;
  border-left: 1px solid var(--color-border);
  font-size: 1rem;
  text-decoration: none;
  color: var(--color-text);
}

nav a:first-of-type {
  border: 0;
}

nav a.router-link-active {
  color: var(--color-heading);
  font-weight: bold;
}
</style>