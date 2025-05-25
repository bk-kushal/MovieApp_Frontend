<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

interface Movie {
  id: string
  title: string
  year: number
  genre: string
  watched: boolean
  rating?: number
  review?: string
}

const movies = ref<Movie[]>([])
const loading = ref(true)
const error = ref<string | null>(null)

const fetchMovies = async () => {
  try {
    const { data, error: err } = await supabase
      .from('movies')
      .select('*')
      .order('created_at', { ascending: false })

    if (err) throw err

    movies.value = data
  } catch (err) {
    error.value = 'Error fetching movies'
    console.error('Error:', err)
  } finally {
    loading.value = false
  }
}

const addMovie = async (movie: Omit<Movie, 'id'>) => {
  try {
    const { error: err } = await supabase
      .from('movies')
      .insert([movie])

    if (err) throw err

    await fetchMovies()
  } catch (err) {
    error.value = 'Error adding movie'
    console.error('Error:', err)
  }
}

const updateMovie = async (id: string, updates: Partial<Movie>) => {
  try {
    const { error: err } = await supabase
      .from('movies')
      .update(updates)
      .eq('id', id)

    if (err) throw err

    await fetchMovies()
  } catch (err) {
    error.value = 'Error updating movie'
    console.error('Error:', err)
  }
}

const deleteMovie = async (id: string) => {
  try {
    const { error: err } = await supabase
      .from('movies')
      .delete()
      .eq('id', id)

    if (err) throw err

    movies.value = movies.value.filter(movie => movie.id !== id)
  } catch (err) {
    error.value = 'Error deleting movie'
    console.error('Error:', err)
  }
}

onMounted(() => {
  fetchMovies()
})
</script>

<template>
  <div class="movies">
    <h1>My Movie Collection</h1>
    
    <div v-if="error" class="error">
      {{ error }}
    </div>

    <div v-if="loading" class="loading">
      Loading movies...
    </div>

    <div v-else class="movie-grid">
      <div v-for="movie in movies" :key="movie.id" class="movie-card">
        <h3>{{ movie.title }}</h3>
        <p>Year: {{ movie.year }}</p>
        <p>Genre: {{ movie.genre }}</p>
        <p>Status: {{ movie.watched ? 'Watched' : 'Not Watched' }}</p>
        <div class="movie-actions">
          <button @click="updateMovie(movie.id, { watched: !movie.watched })">
            {{ movie.watched ? 'Mark Unwatched' : 'Mark Watched' }}
          </button>
          <button @click="deleteMovie(movie.id)" class="delete">Delete</button>
        </div>
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

.movie-actions {
  margin-top: 15px;
  display: flex;
  gap: 10px;
}

button {
  padding: 8px 12px;
  border-radius: 4px;
  border: none;
  background: var(--color-heading);
  color: var(--color-background);
  cursor: pointer;
  transition: opacity 0.2s;
}

button:hover {
  opacity: 0.9;
}

button.delete {
  background: #dc3545;
}

.error {
  color: #dc3545;
  padding: 10px;
  margin: 10px 0;
  border-radius: 4px;
  background: rgba(220, 53, 69, 0.1);
}

.loading {
  text-align: center;
  padding: 20px;
  color: var(--color-text);
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