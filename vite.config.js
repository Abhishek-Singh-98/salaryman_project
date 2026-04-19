import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react({ fastRefresh: true })],
  server: {
    port: 5173,
    strictPort: true,
    origin: 'http://localhost:5173',
    hmr: {
      host: 'localhost',
    },
  },
  build: {
    outDir: 'public/vite',
    manifest: true,
    rollupOptions: {
      input: 'app/frontend/entrypoints/app.jsx'
    }
  }
})

