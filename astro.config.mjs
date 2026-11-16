// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  // Custom domain — matches public/CNAME. Used for canonical/OG absolute URLs.
  site: 'https://ambotics.com',
  // The page stood here for sign-off before it replaced /. The links handed
  // round then still land on it.
  redirects: { '/v2-preview': '/' },
  vite: {
    plugins: [tailwindcss()],
  },
});
