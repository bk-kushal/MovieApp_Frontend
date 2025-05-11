<script setup lang="ts">
import { ref } from 'vue'

interface Movie {
  id: number
  title: string
  year: number
  genre: string
  watched: boolean
}

const movies = ref<Movie[]>([
  { id: 1, title: 'Inception', year: 2010, genre: 'Sci-Fi', watched: true },
  { id: 2, title: 'The Dark Knight', year: 2008, genre: 'Action', watched: false }
])
</script>

<template>
  <div class="movies">
    <h1>My Movie Collection</h1>
    <div class="movie-grid">
      <div v-for="movie in movies" :key="movie.id" class="movie-card">
        <h3>{{ movie.title }}</h3>
        <p>Year: {{ movie.year }}</p>
        <p>Genre: {{ movie.genre }}</p>
        <p>Status: {{ movie.watched ? 'Watched' : 'Not Watched' }}</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.movies {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.movie-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.movie-card {
  background: var(--color-background-soft);
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h1 {
  color: var(--color-heading);
  font-size: 2em;
  margin-bottom: 20px;
}

h3 {
  color: var(--color-heading);
  margin-bottom: 10px;
}

p {
  margin: 5px 0;
  color: var(--color-text);
}
</style>