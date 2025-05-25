<script setup lang="ts">
import { ref, onMounted } from 'vue'

interface Movie {
  title: string
  releaseYear: number
}

const movies = ref<Movie[]>([])

onMounted(async () => {
  try {
    const res = await fetch('https://movie-app-5gda.onrender.com/api/movies')
    movies.value = await res.json()
  } catch (error) {
    console.error('Failed to fetch movies:', error)
  }
})
</script>

<template>
  <main>
    <h1>🎬 Movie List</h1>
    <ul>
      <li v-for="movie in movies" :key="movie.title">
        {{ movie.title }} ({{ movie.releaseYear }})
      </li>
    </ul>
  </main>
</template>

<style scoped>
main {
  padding: 2rem;
  font-family: Arial, sans-serif;
}
</style>
