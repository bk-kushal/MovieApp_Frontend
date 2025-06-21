<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { supabase } from '@/lib/supabase'
import MovieCard from '@/components/MovieCard.vue'
import MovieForm from '@/components/MovieForm.vue'

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
const showForm = ref(false)
const editingMovie = ref<Movie | null>(null)
const searchQuery = ref('')
const filterGenre = ref('')
const filterWatched = ref<'all' | 'watched' | 'unwatched'>('all')

const genres = computed(() => {
  const uniqueGenres = [...new Set(movies.value.map(movie => movie.genre))]
  return uniqueGenres.sort()
})

const filteredMovies = computed(() => {
  let filtered = movies.value

  // Search filter
  if (searchQuery.value.trim()) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(movie =>
      movie.title.toLowerCase().includes(query) ||
      movie.genre.toLowerCase().includes(query)
    )
  }

  // Genre filter
  if (filterGenre.value) {
    filtered = filtered.filter(movie => movie.genre === filterGenre.value)
  }

  // Watched status filter
  if (filterWatched.value !== 'all') {
    filtered = filtered.filter(movie =>
      filterWatched.value === 'watched' ? movie.watched : !movie.watched
    )
  }

  return filtered.sort((a, b) => a.title.localeCompare(b.title))
})

const watchedCount = computed(() => movies.value.filter(m => m.watched).length)
const unwatchedCount = computed(() => movies.value.filter(m => !m.watched).length)

const fetchMovies = async () => {
  try {
    loading.value = true
    const { data, error: err } = await supabase
      .from('movies')
      .select('*')
      .order('created_at', { ascending: false })

    if (err) throw err

    movies.value = data || []
  } catch (err) {
    error.value = 'Error fetching movies'
    console.error('Error:', err)
  } finally {
    loading.value = false
  }
}

const addMovie = async (movieData: Omit<Movie, 'id'>) => {
  try {
    const { error: err } = await supabase
      .from('movies')
      .insert([{ ...movieData, user_id: (await supabase.auth.getUser()).data.user?.id }])

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

const handleToggleWatched = async (id: string) => {
  const movie = movies.value.find(m => m.id === id)
  if (movie) {
    await updateMovie(id, { watched: !movie.watched })
  }
}

const handleEdit = (movie: Movie) => {
  editingMovie.value = movie
  showForm.value = true
}

const handleCloseForm = () => {
  showForm.value = false
  editingMovie.value = null
}

const handleSaveMovie = async (movieData: Omit<Movie, 'id'>) => {
  await addMovie(movieData)
}

const handleUpdateMovie = async (id: string, updates: Partial<Movie>) => {
  await updateMovie(id, updates)
}

const clearFilters = () => {
  searchQuery.value = ''
  filterGenre.value = ''
  filterWatched.value = 'all'
}

onMounted(() => {
  fetchMovies()
})
</script>

<template>
  <div class="movies-view">
    <div class="container">
      <!-- Header -->
      <div class="page-header">
        <div class="header-content">
          <h1 class="page-title">🎬 My Movie Collection</h1>
          <p class="page-subtitle">
            {{ movies.length }} movies • {{ watchedCount }} watched • {{ unwatchedCount }} to watch
          </p>
        </div>
        <button @click="showForm = true" class="btn btn-primary btn-lg">
          Add Movie
        </button>
      </div>

      <!-- Error Message -->
      <div v-if="error" class="error mb-6">
        {{ error }}
        <button @click="error = null" class="error-close">×</button>
      </div>

      <!-- Filters -->
      <div class="filters-section">
        <div class="filters-grid">
          <div class="filter-group">
            <label for="search" class="form-label">Search</label>
            <input
              id="search"
              v-model="searchQuery"
              type="text"
              class="form-input"
              placeholder="Search movies..."
            />
          </div>
          
          <div class="filter-group">
            <label for="genre-filter" class="form-label">Genre</label>
            <select
              id="genre-filter"
              v-model="filterGenre"
              class="form-input form-select"
            >
              <option value="">All Genres</option>
              <option v-for="genre in genres" :key="genre" :value="genre">
                {{ genre }}
              </option>
            </select>
          </div>
          
          <div class="filter-group">
            <label for="status-filter" class="form-label">Status</label>
            <select
              id="status-filter"
              v-model="filterWatched"
              class="form-input form-select"
            >
              <option value="all">All Movies</option>
              <option value="watched">Watched</option>
              <option value="unwatched">To Watch</option>
            </select>
          </div>
        </div>
        
        <button
          v-if="searchQuery || filterGenre || filterWatched !== 'all'"
          @click="clearFilters"
          class="btn btn-secondary btn-sm"
        >
          Clear Filters
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="loading-state">
        <div class="loading"></div>
        <p>Loading your movies...</p>
      </div>

      <!-- Empty State -->
      <div v-else-if="movies.length === 0" class="empty-state">
        <div class="empty-icon">🎬</div>
        <h3>No movies yet</h3>
        <p>Start building your movie collection by adding your first movie!</p>
        <button @click="showForm = true" class="btn btn-primary">
          Add Your First Movie
        </button>
      </div>

      <!-- No Results -->
      <div v-else-if="filteredMovies.length === 0" class="empty-state">
        <div class="empty-icon">🔍</div>
        <h3>No movies found</h3>
        <p>Try adjusting your search or filters to find what you're looking for.</p>
        <button @click="clearFilters" class="btn btn-secondary">
          Clear Filters
        </button>
      </div>

      <!-- Movies Grid -->
      <div v-else class="movies-grid">
        <MovieCard
          v-for="movie in filteredMovies"
          :key="movie.id"
          :movie="movie"
          @toggle-watched="handleToggleWatched"
          @delete="deleteMovie"
          @edit="handleEdit"
        />
      </div>

      <!-- Movie Form Modal -->
      <MovieForm
        :is-open="showForm"
        :movie="editingMovie"
        @close="handleCloseForm"
        @save="handleSaveMovie"
        @update="handleUpdateMovie"
      />
    </div>
  </div>
</template>

<style scoped>
.movies-view {
  min-height: 100vh;
  background: var(--color-background);
  padding: var(--space-8) 0;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: var(--space-8);
  gap: var(--space-6);
}

.header-content {
  flex: 1;
}

.page-title {
  margin: 0 0 var(--space-2);
  font-size: var(--font-size-4xl);
  font-weight: 700;
  color: var(--color-heading);
}

.page-subtitle {
  margin: 0;
  color: var(--color-text-soft);
  font-size: var(--font-size-lg);
}

.filters-section {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  margin-bottom: var(--space-8);
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: var(--space-4);
}

.filters-grid {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr;
  gap: var(--space-4);
  flex: 1;
}

.filter-group {
  display: flex;
  flex-direction: column;
}

.movies-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: var(--space-6);
}

.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--space-20);
  text-align: center;
  color: var(--color-text-soft);
}

.loading-state .loading {
  margin-bottom: var(--space-4);
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--space-20);
  text-align: center;
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: var(--space-4);
  opacity: 0.5;
}

.empty-state h3 {
  margin: 0 0 var(--space-2);
  font-size: var(--font-size-xl);
  color: var(--color-heading);
}

.empty-state p {
  margin: 0 0 var(--space-6);
  color: var(--color-text-soft);
  max-width: 400px;
}

.error {
  position: relative;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.error-close {
  background: none;
  border: none;
  font-size: 20px;
  cursor: pointer;
  color: inherit;
  padding: var(--space-1);
  border-radius: var(--radius);
  transition: background-color var(--transition-fast);
}

.error-close:hover {
  background: rgba(255, 255, 255, 0.2);
}

@media (max-width: 1024px) {
  .page-header {
    flex-direction: column;
    align-items: stretch;
    text-align: center;
  }
  
  .filters-section {
    flex-direction: column;
    align-items: stretch;
  }
  
  .filters-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .movies-view {
    padding: var(--space-4) 0;
  }
  
  .movies-grid {
    grid-template-columns: 1fr;
  }
  
  .page-title {
    font-size: var(--font-size-3xl);
  }
}
</style>