import { defineConfig } from 'vite'
import elm from 'vite-plugin-elm'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [elm()]
})
