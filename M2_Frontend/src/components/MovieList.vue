<template>
  <div class="movie-list">
    <h2>🎬 My Favorite Movies</h2>

    <h3>📅 Watch List</h3>
    <ul>
      <li v-for="movie in watchList" :key="movie.id">
        <MovieCard
          :movie="movie"
          :onAddToWatchList="addToWatchList"
          :onAddToFavorites="addToFavorites"
          :isInWatchList="true"
          :isInFavorites="isInFavorites(movie)"
        />
      </li>
    </ul>

    <h3>🌟 Favorites</h3>
    <ul>
      <li v-for="movie in favorites" :key="movie.id">
        <MovieCard
          :movie="movie"
          :onAddToWatchList="addToWatchList"
          :onAddToFavorites="addToFavorites"
          :isInWatchList="isInWatchList(movie)"
          :isInFavorites="true"
        />
      </li>
    </ul>

    <h3>All Movies</h3>
    <ul>
      <li v-for="movie in movies" :key="movie.id">
        <MovieCard
          :movie="movie"
          :onAddToWatchList="addToWatchList"
          :onAddToFavorites="addToFavorites"
          :isInWatchList="isInWatchList(movie)"
          :isInFavorites="isInFavorites(movie)"
        />
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import MovieCard from './MovieCard.vue';

// Sample movie data
const movies = ref([
  { id: 1, title: 'Inception', rating: 5, review: 'Mind-blowing sci-fi with dreams inside dreams.' },
  { id: 2, title: 'The Matrix', rating: 4, review: 'Revolutionary effects and deep concepts.' },
  { id: 3, title: 'The Social Network', rating: 3, review: 'Interesting portrayal of Facebook’s origin.' }
]);

const watchList = ref([]);
const favorites = ref([]);

// Function to add/remove from Watch List
const addToWatchList = (movie, isInWatchList) => {
  if (isInWatchList) {
    watchList.value.push(movie);
  } else {
    watchList.value = watchList.value.filter(item => item.id !== movie.id);
  }
};

// Function to add/remove from Favorites
const addToFavorites = (movie, isInFavorites) => {
  if (isInFavorites) {
    favorites.value.push(movie);
  } else {
    favorites.value = favorites.value.filter(item => item.id !== movie.id);
  }
};

// Helper functions to check if movie is in Watch List or Favorites
const isInWatchList = (movie) => {
  return watchList.value.some(item => item.id === movie.id);
};

const isInFavorites = (movie) => {
  return favorites.value.some(item => item.id === movie.id);
};
</script>

<style scoped>
.movie-list {
  max-width: 600px;
  margin: 2rem auto;
  padding: 1rem;
  background-color: #f9fafb;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.movie-list h2 {
  text-align: center;
  color: #333;
  margin-bottom: 1.5rem;
}

h3 {
  margin-top: 2rem;
  font-size: 1.2rem;
  color: #444;
}
</style>
