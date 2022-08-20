const { defineConfig } = require('cypress')

module.exports = defineConfig({
  screenshotsFolder: 'tmp/cypress_screenshots',
  videosFolder: 'tmp/cypress_videos',
  trashAssetsBeforeRuns: false,
  projectId: '2ojcg1',
  runMode: 2,
  e2e: {
    // We've imported your old cypress plugins here.
    // You may want to clean this up later by importing these.
    setupNodeEvents(on, config) {
      return require('./cypress/plugins/index.js')(on, config)
    },
    specPattern: 'cypress/e2e/**/*.{js,jsx,ts,tsx}',
  },
})
