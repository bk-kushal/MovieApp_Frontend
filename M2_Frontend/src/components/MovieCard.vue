<template>
  <div class="movie-card">
    <h3>{{ movie.title }} <span class="stars">⭐️ {{ movie.rating }}/5</span></h3>
    <p><em>Review:</em> {{ movie.review }}</p>

    <div class="buttons">
      <!-- Watch List Button -->
      <button @click="toggleWatchList" :class="{ 'added': isInWatchList }">
        {{ isInWatchList ? 'Remove from Watch List' : 'Add to Watch List' }}
      </button>
      <!-- Favorites Button -->
      <button @click="toggleFavorites" :class="{ 'added': isInFavorites }">
        {{ isInFavorites ? 'Remove from Favorites' : 'Add to Favorites' }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { defineProps } from 'vue';

// Define the props to receive from the parent component
defineProps({
  movie: Object,
  onAddToWatchList: Function,
  onAddToFavorites: Function,
  isInWatchList: Boolean,
  isInFavorites: Boolean
});

// Function to toggle the Watch List
const toggleWatchList = () => {
  onAddToWatchList(movie, !isInWatchList); // Toggle the state
};

// Function to toggle the Favorites
const toggleFavorites = () => {
  onAddToFavorites(movie, !isInFavorites); // Toggle the state
};
</script>

<style scoped>
.movie-card {
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 6px;
  padding: 1rem;
  margin-bottom: 1rem;
  transition: transform 0.2s ease;
}

.movie-card:hover {
  transform: scale(1.01);
}

.movie-card h3 {
  margin: 0 0 0.5rem;
  color: #222;
}

.stars {
  font-size: 0.9rem;
  color: #ff9900;
}

.buttons {
  margin-top: 10px;
}

button {
  padding: 0.5rem;
  margin: 5px;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

button.added {
  background-color: #ff6347;
  color: white;
}

button:hover {
  background-color: #ddd;
}
</style>
