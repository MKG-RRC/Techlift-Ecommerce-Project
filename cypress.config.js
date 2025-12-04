const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    baseUrl: "http://localhost:3000",
    video: false,
    retries: {
      runMode: 1,
      openMode: 0
    },
    defaultCommandTimeout: 8000
  }
});
