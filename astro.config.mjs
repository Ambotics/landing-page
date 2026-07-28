// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  // Custom domain — matches public/CNAME. Used for canonical/OG absolute URLs.
  site: 'https://ambotics.com',
  vite: {
    plugins: [tailwindcss()],
  },
});
