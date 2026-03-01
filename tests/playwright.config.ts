import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './',
  
  // Maximum time one test can run
  timeout: 60 * 1000,
  
  // Test configuration
  fullyParallel: false, // Run tests serially to avoid race conditions
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: 1, // Only 1 worker to ensure sequential execution
  
  // Reporter
  reporter: [
    ['list'],
    ['html', { open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }]
  ],
  
  use: {
    // Collect trace on failure
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    
    // Browser options
    headless: true,
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});