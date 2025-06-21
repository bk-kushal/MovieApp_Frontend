<script setup lang="ts">
import { computed } from 'vue'

interface Movie {
  id: string
  title: string
  year: number
  genre: string
  watched: boolean
  rating?: number
  review?: string
}

interface Props {
  movie: Movie
}

interface Emits {
  (e: 'toggle-watched', id: string): void
  (e: 'delete', id: string): void
  (e: 'edit', movie: Movie): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const ratingStars = computed(() => {
  if (!props.movie.rating) return ''
  return '⭐'.repeat(props.movie.rating)
})

const handleToggleWatched = () => {
  emit('toggle-watched', props.movie.id)
}

const handleDelete = () => {
  if (confirm(`Are you sure you want to delete "${props.movie.title}"?`)) {
    emit('delete', props.movie.id)
  }
}

const handleEdit = () => {
  emit('edit', props.movie)
}
</script>

<template>
  <div class="movie-card">
    <div class="movie-header">
      <h3 class="movie-title">{{ movie.title }}</h3>
      <div class="movie-year">{{ movie.year }}</div>
    </div>
    
    <div class="movie-content">
      <div class="movie-genre">
        <span class="genre-tag">{{ movie.genre }}</span>
      </div>
      
      <div class="movie-status">
        <span :class="['status-badge', movie.watched ? 'watched' : 'unwatched']">
          {{ movie.watched ? '✓ Watched' : '○ Not Watched' }}
        </span>
      </div>
      
      <div v-if="movie.rating" class="movie-rating">
        <span class="rating-stars">{{ ratingStars }}</span>
        <span class="rating-text">{{ movie.rating }}/5</span>
      </div>
      
      <div v-if="movie.review" class="movie-review">
        <p class="review-text">{{ movie.review }}</p>
      </div>
    </div>
    
    <div class="movie-actions">
      <button 
        @click="handleToggleWatched" 
        :class="['btn', 'btn-sm', movie.watched ? 'btn-secondary' : 'btn-primary']"
      >
        {{ movie.watched ? 'Mark Unwatched' : 'Mark Watched' }}
      </button>
      <button @click="handleEdit" class="btn btn-sm btn-secondary">
        Edit
      </button>
      <button @click="handleDelete" class="btn btn-sm btn-danger">
        Delete
      </button>
    </div>
  </div>
</template>

<style scoped>
.movie-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  box-shadow: var(--shadow-sm);
  transition: all var(--transition-base);
  height: 100%;
  display: flex;
  flex-direction: column;
}

.movie-card:hover {
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

.movie-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: var(--space-4);
  gap: var(--space-3);
}

.movie-title {
  margin: 0;
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-heading);
  line-height: 1.3;
  flex: 1;
}

.movie-year {
  background: var(--color-background-soft);
  color: var(--color-text-soft);
  padding: var(--space-1) var(--space-3);
  border-radius: var(--radius);
  font-size: var(--font-size-sm);
  font-weight: 500;
  white-space: nowrap;
}

.movie-content {
  flex: 1;
  margin-bottom: var(--space-4);
}

.movie-genre {
  margin-bottom: var(--space-3);
}

.genre-tag {
  display: inline-block;
  background: var(--color-primary);
  color: var(--color-white);
  padding: var(--space-1) var(--space-3);
  border-radius: var(--radius);
  font-size: var(--font-size-xs);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.movie-status {
  margin-bottom: var(--space-3);
}

.status-badge {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  padding: var(--space-2) var(--space-3);
  border-radius: var(--radius);
  font-size: var(--font-size-sm);
  font-weight: 500;
}

.status-badge.watched {
  background: rgba(16, 185, 129, 0.1);
  color: var(--color-success);
  border: 1px solid rgba(16, 185, 129, 0.2);
}

.status-badge.unwatched {
  background: rgba(156, 163, 175, 0.1);
  color: var(--color-text-soft);
  border: 1px solid rgba(156, 163, 175, 0.2);
}

.movie-rating {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  margin-bottom: var(--space-3);
}

.rating-stars {
  font-size: var(--font-size-lg);
}

.rating-text {
  font-size: var(--font-size-sm);
  color: var(--color-text-soft);
  font-weight: 500;
}

.movie-review {
  margin-bottom: var(--space-3);
}

.review-text {
  font-size: var(--font-size-sm);
  color: var(--color-text-soft);
  line-height: 1.5;
  font-style: italic;
  margin: 0;
}

.movie-actions {
  display: flex;
  gap: var(--space-2);
  flex-wrap: wrap;
  margin-top: auto;
}

@media (max-width: 640px) {
  .movie-actions {
    flex-direction: column;
  }
  
  .movie-actions .btn {
    width: 100%;
  }
}
</style>