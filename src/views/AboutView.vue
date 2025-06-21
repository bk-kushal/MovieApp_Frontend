<script setup lang="ts">
// About page component
</script>

<template>
  <div class="about-view">
    <div class="container">
      <div class="about-content">
        <h1 class="about-title">About Movie Organizer</h1>
        
        <div class="about-section">
          <h2>What is Movie Organizer?</h2>
          <p>
            Movie Organizer is a personal movie collection management app that helps you keep track 
            of all the movies you've watched and want to watch. Whether you're a casual movie watcher 
            or a serious cinephile, this app provides an easy way to organize your movie experiences.
          </p>
        </div>

        <div class="about-section">
          <h2>Features</h2>
          <div class="features-list">
            <div class="feature-item">
              <div class="feature-icon">📝</div>
              <div class="feature-content">
                <h3>Track Your Movies</h3>
                <p>Add movies to your collection with details like title, year, and genre.</p>
              </div>
            </div>
            
            <div class="feature-item">
              <div class="feature-icon">⭐</div>
              <div class="feature-content">
                <h3>Rate and Review</h3>
                <p>Give ratings from 1-5 stars and write personal reviews for movies you've watched.</p>
              </div>
            </div>
            
            <div class="feature-item">
              <div class="feature-icon">✅</div>
              <div class="feature-content">
                <h3>Watch Status</h3>
                <p>Mark movies as watched or keep them in your "to watch" list.</p>
              </div>
            </div>
            
            <div class="feature-item">
              <div class="feature-icon">🔍</div>
              <div class="feature-content">
                <h3>Search and Filter</h3>
                <p>Easily find movies by title, genre, or watch status.</p>
              </div>
            </div>
            
            <div class="feature-item">
              <div class="feature-icon">📊</div>
              <div class="feature-content">
                <h3>Collection Stats</h3>
                <p>View statistics about your movie collection including total count and average ratings.</p>
              </div>
            </div>
            
            <div class="feature-item">
              <div class="feature-icon">🔒</div>
              <div class="feature-content">
                <h3>Personal and Secure</h3>
                <p>Your movie data is private and secure, accessible only to you.</p>
              </div>
            </div>
          </div>
        </div>

        <div class="about-section">
          <h2>How to Use</h2>
          <div class="steps-list">
            <div class="step-item">
              <div class="step-number">1</div>
              <div class="step-content">
                <h3>Add Movies</h3>
                <p>Click "Add Movie" to start building your collection. Enter the movie title, year, and genre.</p>
              </div>
            </div>
            
            <div class="step-item">
              <div class="step-number">2</div>
              <div class="step-content">
                <h3>Mark as Watched</h3>
                <p>When you watch a movie, mark it as watched and optionally add a rating and review.</p>
              </div>
            </div>
            
            <div class="step-item">
              <div class="step-number">3</div>
              <div class="step-content">
                <h3>Organize and Search</h3>
                <p>Use the search and filter features to find specific movies or browse by genre and status.</p>
              </div>
            </div>
          </div>
        </div>

        <div class="about-section">
          <h2>Built With</h2>
          <div class="tech-stack">
            <div class="tech-item">
              <strong>Vue 3</strong> - Modern JavaScript framework
            </div>
            <div class="tech-item">
              <strong>TypeScript</strong> - Type-safe JavaScript
            </div>
            <div class="tech-item">
              <strong>Supabase</strong> - Backend as a Service
            </div>
            <div class="tech-item">
              <strong>Vite</strong> - Fast build tool
            </div>
          </div>
        </div>

        <div class="cta-section">
          <h2>Ready to Start?</h2>
          <p>Begin organizing your movie collection today!</p>
          <router-link to="/movies" class="btn btn-primary btn-lg">
            Go to My Movies
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.about-view {
  min-height: 100vh;
  background: var(--color-background);
  padding: var(--space-8) 0;
}

.about-content {
  max-width: 800px;
  margin: 0 auto;
}

.about-title {
  font-size: var(--font-size-4xl);
  font-weight: 700;
  color: var(--color-heading);
  text-align: center;
  margin: 0 0 var(--space-12);
}

.about-section {
  margin-bottom: var(--space-12);
}

.about-section h2 {
  font-size: var(--font-size-2xl);
  font-weight: 600;
  color: var(--color-heading);
  margin: 0 0 var(--space-6);
}

.about-section p {
  font-size: var(--font-size-lg);
  line-height: 1.6;
  color: var(--color-text);
  margin: 0 0 var(--space-4);
}

.features-list {
  display: grid;
  gap: var(--space-6);
}

.feature-item {
  display: flex;
  gap: var(--space-4);
  align-items: flex-start;
}

.feature-icon {
  font-size: 2rem;
  flex-shrink: 0;
}

.feature-content h3 {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-heading);
  margin: 0 0 var(--space-2);
}

.feature-content p {
  font-size: var(--font-size-base);
  color: var(--color-text-soft);
  margin: 0;
}

.steps-list {
  display: grid;
  gap: var(--space-6);
}

.step-item {
  display: flex;
  gap: var(--space-4);
  align-items: flex-start;
}

.step-number {
  width: 40px;
  height: 40px;
  background: var(--color-primary);
  color: var(--color-white);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  flex-shrink: 0;
}

.step-content h3 {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-heading);
  margin: 0 0 var(--space-2);
}

.step-content p {
  font-size: var(--font-size-base);
  color: var(--color-text-soft);
  margin: 0;
}

.tech-stack {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: var(--space-4);
}

.tech-item {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  padding: var(--space-4);
  text-align: center;
  font-size: var(--font-size-sm);
  color: var(--color-text);
}

.tech-item strong {
  color: var(--color-heading);
  display: block;
  margin-bottom: var(--space-1);
}

.cta-section {
  text-align: center;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-12);
  margin-top: var(--space-16);
}

.cta-section h2 {
  font-size: var(--font-size-2xl);
  font-weight: 600;
  color: var(--color-heading);
  margin: 0 0 var(--space-4);
}

.cta-section p {
  font-size: var(--font-size-lg);
  color: var(--color-text-soft);
  margin: 0 0 var(--space-8);
}

@media (max-width: 768px) {
  .about-title {
    font-size: var(--font-size-3xl);
  }
  
  .about-section h2 {
    font-size: var(--font-size-xl);
  }
  
  .feature-item,
  .step-item {
    flex-direction: column;
    text-align: center;
  }
  
  .tech-stack {
    grid-template-columns: 1fr;
  }
}
</style>