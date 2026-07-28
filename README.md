# Ambotics™ — landing page

A recreation of [ambotics.framer.website](https://ambotics.framer.website),
built with [Astro](https://astro.build) + Tailwind CSS v4 and deployed to GitHub Pages.

## Develop

```bash
npm install
npm run dev        # http://localhost:4321
```

| Command           | What it does                             |
| ----------------- | ---------------------------------------- |
| `npm run dev`     | Dev server with HMR                      |
| `npm run build`   | Static build into `dist/`                |
| `npm run preview` | Serve `dist/` locally                    |
| `npx astro check` | Type-check `.astro`/`.ts` files          |

## Structure

```
astro.config.mjs          # site URL + Tailwind Vite plugin
public/
  CNAME                   # custom domain for GitHub Pages
  og-image.png            # favicon + social card (needs an absolute URL, so it stays here)
src/
  assets/                 # carousel photos — optimised at build time by astro:assets
  components/
    Carousel.astro        # scroll-snap carousel + arrow buttons
    ContactForm.astro     # email capture (currently inert — see below)
    Footer.astro          # accent-blue footer with grain overlay
    Sidebar.astro         # logo, section nav, scroll-spy
    Wordmark.astro        # "Ambotics™" lockup, shared by header and footer
  data/applications.ts    # carousel entries (label + image)
  layouts/Layout.astro    # <head>, meta/OG tags, font loading
  pages/index.astro       # the page
  styles/global.css       # Tailwind import, @theme tokens, grain overlay
.github/workflows/deploy.yml
```

## Design system

### The blue is a working-class blue

`#185de4` is the blue of workwear and painted machinery — the color of a shop floor, not
of a robotics lab. It carries the same argument the copy makes: most of this industry
leads with the breakthrough and speaks to other engineers, and we lead with your business
and your problem. An Ambotics robot is meant for **actual work**, and the palette should
say so before anyone reads a word.

That gives the accent a job, and the job comes with a rule: **the blue only ever marks
something real.** It appears on the one thing a visitor can act on (the "Notify me"
button), on the footer that closes the page, and on focus rings and text selection —
places where it signals *this responds to you*. It is never decoration.

Everything else stays in a plain grayscale — `#f4f4f4` page, `#2b2b2b` copy, gray nav —
so the blue never has to compete for attention. When you add a component, the default is
grayscale; reach for the accent only if the element genuinely does something.

Two practical consequences:

- Don't tint photos, borders, dividers, or section backgrounds with it. A second blue
  surface halves the meaning of the first.
- Keep white on `#185de4` for text (5.64:1, AA) and don't drop below `text-white/85` for
  secondary copy on it (4.53:1, AA). The accent on `#f4f4f4` is 5.13:1, so it is also
  safe for small text on the page background if a future element needs it.

### Palette

Edit these in the `@theme` block of `src/styles/global.css`; every utility follows.

| Token                  | Value     | Used for                                              |
| ---------------------- | --------- | ----------------------------------------------------- |
| `--color-page`         | `#f4f4f4` | Page background                                       |
| `--color-ink`          | `#2b2b2b` | Headings, body copy, active/hover nav                 |
| `--color-accent`       | `#185de4` | CTA button, footer background, focus rings, selection |
| `--color-accent-hover` | `#1450c4` | CTA hover                                             |
| `--color-muted`        | `#a8a8a8` | Wordmark                                              |
| `--color-nav`          | `#808080` | Idle nav links                                        |
| `--color-field`        | `#ededed` | Form field background                                 |

Note the scroll-spy in `Sidebar.astro` toggles the literal class `text-ink` from
JavaScript — Tailwind picks it up by scanning the file, so renaming the token means
updating that string too.

## How it's built

- **Tailwind v4** via `@tailwindcss/vite`. The old inline `tailwind.config` object now lives
  as CSS custom properties in the `@theme` block of `src/styles/global.css`
  (`--color-ink`, `--font-display`, `--container-content`, …), which is what generates
  `text-ink`, `font-display`, `max-w-content`, and friends.
- **Fonts** from Google Fonts — `Gabarito` (display/logo), `Inter` (body),
  `Instrument Sans` (UI labels) — plus `Satoshi` from Fontshare for the form.
- **Images** go through `astro:assets`, which emits responsive WebP at 583w/1166w.
  This takes the carousel from ~3.4 MB of JPEG down to ~180 KB.
- **Layout** — a left sidebar (logo + section nav) beside a content column on desktop;
  a single column on mobile with the nav hidden.
- **Scripts** — the carousel arrows and the nav scroll-spy are plain `<script>` tags in
  their components; Astro bundles and inlines them. No client-side framework.

## Deploying

Pushing to `main` triggers `.github/workflows/deploy.yml`, which builds with
`withastro/action` and publishes via `actions/deploy-pages`.

One-time setup in the repo: **Settings → Pages → Build and deployment → Source: GitHub Actions**.

### Custom domain

The site is configured for `ambotics.com`, in two places that must agree:

- `public/CNAME` — copied verbatim into `dist/`, this is what GitHub Pages reads
- `site` in `astro.config.mjs` — used to build the absolute canonical and OG image URLs

DNS for an apex domain needs `A` records pointing at GitHub's Pages IPs
(`185.199.108.153`, `.109.153`, `.110.153`, `.111.153`); a `www` subdomain instead needs a
`CNAME` to `<user>.github.io`.

To serve from `ambotics.github.io/landing-page` instead, delete `public/CNAME` and set
`base: '/landing-page'` alongside `site` in `astro.config.mjs`.

## Notes

- The email form has no backend — submitting is prevented, matching the original page.
  Point the `<form>` at a handler (Formspree, Buttondown, a Worker) to make it live.
