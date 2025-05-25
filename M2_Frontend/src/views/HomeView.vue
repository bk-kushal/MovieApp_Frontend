<script setup lang="ts">
import { ref, onMounted } from 'vue'

interface Movie {
  title: string
  releaseYear: number
}

const items = ref<Movie[]>([])

const endpoint = 'https://movie-app-5gda.onrender.com/api/movies'
const requestOptions = {
  method: 'GET',
  redirect: 'follow' as RequestRedirect
}

onMounted(async () => {
  fetch(endpoint, requestOptions)
    .then(response => response.json())
    .then(result => result.forEach((movie: Movie) => {
      items.value.push(movie)
    }))
    .catch(error => console.error('Fetch error:', error))
})
</script>

<template>
  <main>
    <h1>🎬 Movie List</h1>
    <ul>
      <li v-for="movie in items" :key="movie.title">
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
