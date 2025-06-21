<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
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

const stats = computed(() => {
  const total = movies.value.length
  const watched = movies.value.filter(m => m.watched).length
  const unwatched = total - watched
  const avgRating = movies.value
    .filter(m => m.rating)
    .reduce((sum, m) => sum + (m.rating || 0), 0) / movies.value.filter(m => m.rating).length || 0

  return { total, watched, unwatched, avgRating }
})

const recentMovies = computed(() => {
  return movies.value
    .filter(m => m.watched)
    .sort((a, b) => new Date(b.created_at || '').getTime() - new Date(a.created_at || '').getTime())
    .slice(0, 3)
})

const topRatedMovies = computed(() => {
  return movies.value
    .filter(m => m.rating && m.rating >= 4)
    .sort((a, b) => (b.rating || 0) - (a.rating || 0))
    .slice(0, 3)
})

const fetchMovies = async () => {
  try {
    const { data, error } = await supabase
      .from('movies')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error
    movies.value = data || []
  } catch (err) {
    console.error('Error fetching movies:', err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchMovies()
})
</script>

<template>
  <div class="home-view">
    <div class="container">
      <!-- Hero Section -->
      <div class="hero-section">
        <div class="hero-content">
          <h1 class="hero-title">Welcome to Your Movie Collection</h1>
          <p class="hero-subtitle">
            Track, rate, and organize all your favorite movies in one place
          </p>
          <div class="hero-actions">
            <router-link to="/movies" class="btn btn-primary btn-lg">
              View Collection
            </router-link>
            <router-link to="/movies" class="btn btn-secondary btn-lg">
              Add Movie
            </router-link>
          </div>
        </div>
        <div class="hero-image">
          <div class="movie-stack">
            <div class="movie-card-demo card-1">🎬</div>
            <div class="movie-card-demo card-2">🍿</div>
            <div class="movie-card-demo card-3">🎭</div>
          </div>
        </div>
      </div>

      <!-- Stats Section -->
      <div v-if="!loading && movies.length > 0" class="stats-section">
        <h2 class="section-title">Your Collection Stats</h2>
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-number">{{ stats.total }}</div>
            <div class="stat-label">Total Movies</div>
          </div>
          <div class="stat-card">
            <div class="stat-number">{{ stats.watched }}</div>
            <div class="stat-label">Watched</div>
          </div>
          <div class="stat-card">
            <div class="stat-number">{{ stats.unwatched }}</div>
            <div class="stat-label">To Watch</div>
          </div>
          <div class="stat-card">
            <div class="stat-number">{{ stats.avgRating.toFixed(1) }}</div>
            <div class="stat-label">Avg Rating</div>
          </div>
        </div>
      </div>

      <!-- Recent Movies -->
      <div v-if="!loading && recentMovies.length > 0" class="section">
        <div class="section-header">
          <h2 class="section-title">Recently Watched</h2>
          <router-link to="/movies" class="section-link">View All</router-link>
        </div>
        <div class="movies-preview">
          <div v-for="movie in recentMovies" :key="movie.id" class="movie-preview-card">
            <h3 class="movie-title">{{ movie.title }}</h3>
            <div class="movie-meta">
              <span class="movie-year">{{ movie.year }}</span>
              <span class="movie-genre">{{ movie.genre }}</span>
            </div>
            <div v-if="movie.rating" class="movie-rating">
              <span class="rating-stars">{{ '⭐'.repeat(movie.rating) }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Top Rated Movies -->
      <div v-if="!loading && topRatedMovies.length > 0" class="section">
        <div class="section-header">
          <h2 class="section-title">Top Rated Movies</h2>
          <router-link to="/movies" class="section-link">View All</router-link>
        </div>
        <div class="movies-preview">
          <div v-for="movie in topRatedMovies" :key="movie.id" class="movie-preview-card">
            <h3 class="movie-title">{{ movie.title }}</h3>
            <div class="movie-meta">
              <span class="movie-year">{{ movie.year }}</span>
              <span class="movie-genre">{{ movie.genre }}</span>
            </div>
            <div class="movie-rating">
              <span class="rating-stars">{{ '⭐'.repeat(movie.rating || 0) }}</span>
              <span class="rating-text">{{ movie.rating }}/5</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Getting Started -->
      <div v-if="!loading && movies.length === 0" class="getting-started">
        <div class="getting-started-content">
          <h2>Get Started</h2>
          <p>Start building your movie collection today!</p>
          <div class="features-grid">
            <div class="feature-card">
              <div class="feature-icon">📝</div>
              <h3>Track Movies</h3>
              <p>Keep a record of movies you've watched and want to watch</p>
            </div>
            <div class="feature-card">
              <div class="feature-icon">⭐</div>
              <h3>Rate & Review</h3>
              <p>Rate your movies and write reviews to remember what you thought</p>
            </div>
            <div class="feature-card">
              <div class="feature-icon">🔍</div>
              <h3>Search & Filter</h3>
              <p>Easily find movies by title, genre, or watch status</p>
            </div>
          </div>
          <router-link to="/movies" class="btn btn-primary btn-lg">
            Add Your First Movie
          </router-link>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="loading-state">
        <div class="loading"></div>
        <p>Loading your collection...</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.home-view {
  min-height: 100vh;
  background: linear-gradient(135deg, var(--color-background) 0%, var(--color-background-soft) 100%);
}

.hero-section {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-12);
  align-items: center;
  padding: var(--space-20) 0;
  min-height: 60vh;
}

.hero-content {
  max-width: 500px;
}

.hero-title {
  font-size: var(--font-size-4xl);
  font-weight: 700;
  color: var(--color-heading);
  margin: 0 0 var(--space-4);
  line-height: 1.1;
}

.hero-subtitle {
  font-size: var(--font-size-xl);
  color: var(--color-text-soft);
  margin: 0 0 var(--space-8);
  line-height: 1.5;
}

.hero-actions {
  display: flex;
  gap: var(--space-4);
}

.hero-image {
  display: flex;
  justify-content: center;
  align-items: center;
}

.movie-stack {
  position: relative;
  width: 200px;
  height: 200px;
}

.movie-card-demo {
  position: absolute;
  width: 120px;
  height: 160px;
  background: var(--color-surface);
  border: 2px solid var(--color-border);
  border-radius: var(--radius-lg);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 3rem;
  box-shadow: var(--shadow-lg);
  transition: transform var(--transition-base);
}

.card-1 {
  top: 0;
  left: 0;
  z-index: 3;
  transform: rotate(-10deg);
}

.card-2 {
  top: 20px;
  left: 40px;
  z-index: 2;
  transform: rotate(5deg);
}

.card-3 {
  top: 40px;
  left: 80px;
  z-index: 1;
  transform: rotate(15deg);
}

.movie-stack:hover .card-1 {
  transform: rotate(-15deg) translateY(-10px);
}

.movie-stack:hover .card-2 {
  transform: rotate(0deg) translateY(-5px);
}

.movie-stack:hover .card-3 {
  transform: rotate(20deg) translateY(-2px);
}

.stats-section {
  margin-bottom: var(--space-16);
}

.section-title {
  font-size: var(--font-size-2xl);
  font-weight: 600;
  color: var(--color-heading);
  margin: 0 0 var(--space-6);
  text-align: center;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: var(--space-6);
}

.stat-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-8);
  text-align: center;
  box-shadow: var(--shadow-sm);
  transition: transform var(--transition-fast);
}

.stat-card:hover {
  transform: translateY(-2px);
}

.stat-number {
  font-size: var(--font-size-4xl);
  font-weight: 700;
  color: var(--color-primary);
  margin-bottom: var(--space-2);
}

.stat-label {
  font-size: var(--font-size-sm);
  color: var(--color-text-soft);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.section {
  margin-bottom: var(--space-16);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--space-6);
}

.section-link {
  color: var(--color-primary);
  font-weight: 500;
  text-decoration: none;
  transition: color var(--transition-fast);
}

.section-link:hover {
  color: var(--color-primary-hover);
}

.movies-preview {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: var(--space-4);
}

.movie-preview-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-4);
  box-shadow: var(--shadow-sm);
  transition: all var(--transition-fast);
}

.movie-preview-card:hover {
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

.movie-title {
  margin: 0 0 var(--space-2);
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-heading);
}

.movie-meta {
  display: flex;
  gap: var(--space-3);
  margin-bottom: var(--space-2);
}

.movie-year,
.movie-genre {
  font-size: var(--font-size-sm);
  color: var(--color-text-soft);
}

.movie-rating {
  display: flex;
  align-items: center;
  gap: var(--space-2);
}

.rating-stars {
  font-size: var(--font-size-sm);
}

.rating-text {
  font-size: var(--font-size-sm);
  color: var(--color-text-soft);
}

.getting-started {
  text-align: center;
  padding: var(--space-16) 0;
}

.getting-started-content h2 {
  font-size: var(--font-size-3xl);
  font-weight: 600;
  color: var(--color-heading);
  margin: 0 0 var(--space-4);
}

.getting-started-content p {
  font-size: var(--font-size-xl);
  color: var(--color-text-soft);
  margin: 0 0 var(--space-12);
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: var(--space-8);
  margin-bottom: var(--space-12);
}

.feature-card {
  text-align: center;
}

.feature-icon {
  font-size: 3rem;
  margin-bottom: var(--space-4);
}

.feature-card h3 {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-heading);
  margin: 0 0 var(--space-2);
}

.feature-card p {
  font-size: var(--font-size-sm);
  color: var(--color-text-soft);
  margin: 0;
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

@media (max-width: 1024px) {
  .hero-section {
    grid-template-columns: 1fr;
    text-align: center;
    gap: var(--space-8);
  }
  
  .hero-actions {
    justify-content: center;
  }
}

@media (max-width: 768px) {
  .hero-title {
    font-size: var(--font-size-3xl);
  }
  
  .hero-subtitle {
    font-size: var(--font-size-lg);
  }
  
  .hero-actions {
    flex-direction: column;
    align-items: center;
  }
  
  .hero-actions .btn {
    width: 100%;
    max-width: 300px;
  }
  
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .movies-preview {
    grid-template-columns: 1fr;
  }
  
  .features-grid {
    grid-template-columns: 1fr;
  }
}
</style>