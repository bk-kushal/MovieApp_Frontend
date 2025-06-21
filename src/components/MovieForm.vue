<script setup lang="ts">
import { ref, watch } from 'vue'

interface Movie {
  id?: string
  title: string
  year: number
  genre: string
  watched: boolean
  rating?: number
  review?: string
}

interface Props {
  movie?: Movie | null
  isOpen: boolean
}

interface Emits {
  (e: 'close'): void
  (e: 'save', movie: Omit<Movie, 'id'>): void
  (e: 'update', id: string, movie: Partial<Movie>): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const form = ref<Movie>({
  title: '',
  year: new Date().getFullYear(),
  genre: '',
  watched: false,
  rating: undefined,
  review: ''
})

const genres = [
  'Action', 'Adventure', 'Animation', 'Biography', 'Comedy', 'Crime', 
  'Documentary', 'Drama', 'Family', 'Fantasy', 'History', 'Horror', 
  'Music', 'Mystery', 'Romance', 'Sci-Fi', 'Sport', 'Thriller', 'War', 'Western'
]

const isEditing = ref(false)

watch(() => props.movie, (newMovie) => {
  if (newMovie) {
    form.value = { ...newMovie }
    isEditing.value = true
  } else {
    resetForm()
    isEditing.value = false
  }
}, { immediate: true })

watch(() => props.isOpen, (isOpen) => {
  if (!isOpen) {
    resetForm()
  }
})

const resetForm = () => {
  form.value = {
    title: '',
    year: new Date().getFullYear(),
    genre: '',
    watched: false,
    rating: undefined,
    review: ''
  }
  isEditing.value = false
}

const handleSubmit = () => {
  if (!form.value.title.trim() || !form.value.genre) {
    return
  }

  const movieData = {
    title: form.value.title.trim(),
    year: form.value.year,
    genre: form.value.genre,
    watched: form.value.watched,
    rating: form.value.rating || undefined,
    review: form.value.review?.trim() || undefined
  }

  if (isEditing.value && props.movie?.id) {
    emit('update', props.movie.id, movieData)
  } else {
    emit('save', movieData)
  }

  handleClose()
}

const handleClose = () => {
  emit('close')
  resetForm()
}
</script>

<template>
  <div v-if="isOpen" class="modal-overlay" @click="handleClose">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h2 class="modal-title">
          {{ isEditing ? 'Edit Movie' : 'Add New Movie' }}
        </h2>
        <button @click="handleClose" class="modal-close">×</button>
      </div>

      <form @submit.prevent="handleSubmit" class="movie-form">
        <div class="form-group">
          <label for="title" class="form-label">Title *</label>
          <input
            id="title"
            v-model="form.title"
            type="text"
            class="form-input"
            placeholder="Enter movie title"
            required
          />
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="year" class="form-label">Year *</label>
            <input
              id="year"
              v-model.number="form.year"
              type="number"
              class="form-input"
              :min="1900"
              :max="new Date().getFullYear() + 5"
              required
            />
          </div>

          <div class="form-group">
            <label for="genre" class="form-label">Genre *</label>
            <select
              id="genre"
              v-model="form.genre"
              class="form-input form-select"
              required
            >
              <option value="">Select a genre</option>
              <option v-for="genre in genres" :key="genre" :value="genre">
                {{ genre }}
              </option>
            </select>
          </div>
        </div>

        <div class="form-group">
          <label class="checkbox-label">
            <input
              v-model="form.watched"
              type="checkbox"
              class="checkbox-input"
            />
            <span class="checkbox-text">I've watched this movie</span>
          </label>
        </div>

        <div v-if="form.watched" class="form-group">
          <label for="rating" class="form-label">Rating</label>
          <select
            id="rating"
            v-model.number="form.rating"
            class="form-input form-select"
          >
            <option :value="undefined">No rating</option>
            <option :value="1">⭐ 1 - Terrible</option>
            <option :value="2">⭐⭐ 2 - Bad</option>
            <option :value="3">⭐⭐⭐ 3 - Okay</option>
            <option :value="4">⭐⭐⭐⭐ 4 - Good</option>
            <option :value="5">⭐⭐⭐⭐⭐ 5 - Excellent</option>
          </select>
        </div>

        <div v-if="form.watched" class="form-group">
          <label for="review" class="form-label">Review</label>
          <textarea
            id="review"
            v-model="form.review"
            class="form-input form-textarea"
            placeholder="What did you think about this movie?"
            rows="4"
          ></textarea>
        </div>

        <div class="form-actions">
          <button type="button" @click="handleClose" class="btn btn-secondary">
            Cancel
          </button>
          <button type="submit" class="btn btn-primary">
            {{ isEditing ? 'Update Movie' : 'Add Movie' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: var(--space-4);
}

.modal-content {
  background: var(--color-surface);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-lg);
  width: 100%;
  max-width: 500px;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-6);
  border-bottom: 1px solid var(--color-border);
}

.modal-title {
  margin: 0;
  font-size: var(--font-size-xl);
  font-weight: 600;
  color: var(--color-heading);
}

.modal-close {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: var(--color-text-soft);
  padding: var(--space-2);
  border-radius: var(--radius);
  transition: all var(--transition-fast);
}

.modal-close:hover {
  background: var(--color-background-soft);
  color: var(--color-text);
}

.movie-form {
  padding: var(--space-6);
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  cursor: pointer;
  font-weight: 500;
}

.checkbox-input {
  width: 18px;
  height: 18px;
  accent-color: var(--color-primary);
}

.checkbox-text {
  color: var(--color-text);
}

.form-actions {
  display: flex;
  gap: var(--space-3);
  justify-content: flex-end;
  margin-top: var(--space-6);
  padding-top: var(--space-4);
  border-top: 1px solid var(--color-border);
}

@media (max-width: 640px) {
  .form-row {
    grid-template-columns: 1fr;
  }
  
  .form-actions {
    flex-direction: column-reverse;
  }
  
  .form-actions .btn {
    width: 100%;
  }
}
</style>