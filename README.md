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
something real.** It appears on the footer that closes the page, and on focus rings and
text selection — places where it signals *this responds to you*. It is never decoration.
The one thing a visitor can act on, the "Notify me" button, is `signal` yellow; the blue
still owns the plane behind it and the focus state around it.

Everything else stays in a plain grayscale — `#f4f4f4` page, `#2b2b2b` copy, gray nav —
so the blue never has to compete for attention. When you add a component, the default is
grayscale; reach for the accent only if the element genuinely does something.

Two practical consequences:

- Don't tint photos, borders, dividers, or section backgrounds with it. A second blue
  surface halves the meaning of the first.
- Keep white on `#185de4` for text (5.64:1, AA) and don't drop below `text-white/85` for
  secondary copy on it (4.53:1, AA). The accent on `#f4f4f4` is 5.13:1, so it is also
  safe for small text on the page background if a future element needs it.

### The yellow is the "act on this" color

`#ffe01f` is safety yellow — machine controls, hazard marking, lockout tags. It is the
color that actually appears alongside workwear blue on a shop floor, which is why it
extends the argument the blue makes instead of diluting it. It does two jobs: it carries
the one thing a visitor can act on (the "Notify me" button), and it marks edges within
blue surfaces (the footer keyline). Like the blue, it is never decoration.

**The split is fill vs. text, not blue vs. sand:**

| Use | Token | Why |
| --- | --- | --- |
| A fill, on any surface | `signal` + an `ink` label | The label carries the contrast at 10.74:1 |
| Text or a mark on the blue | `signal`, ≥24px / ≥18.66px bold | 4.28:1 — large text and graphics only |
| Text or a mark on sand / field | `signal-deep` | 5.89:1 and 5.53:1 — unrestricted |

Three limits worth knowing:

- **A `signal` fill must carry an `ink` label.** `ink` on `signal` is 10.74:1, and that is
  what identifies the control under WCAG 1.4.11 — the fill itself is only 1.13:1 against
  the `field` pill, so the shape's edge is explicitly *not* doing that work. Never pair a
  yellow fill with a white label, and never rely on the pill outline alone.
- **`signal` never carries body copy on the blue.** At 4.28:1 it is legal for ≥24px
  regular, ≥18.66px bold, icons, and rules — not for anything smaller. Small copy on blue
  stays white / `text-white/85`.
- **`signal` is never text on the sand.** At ~1.2:1 it is illegible there. That is what
  `signal-deep` exists for.

`signal-deep` is the same hue at half the lightness — `hsl(50 100% 22%)` against the
bright's `hsl(52 100% 56%)` — so the two read as one family. It carries no restrictions:
5.89:1 on the page, 5.53:1 on the field, 6.48:1 on white.

Worth knowing why the obvious choices lost, so they don't get re-proposed: safety orange
is 2.01:1 on this blue and signal red is 1.32:1, both failing even the 3:1 UI floor.
Orange-on-blue is a *hue* contrast and WCAG scores *luminance*. For the same reason a
dark accent is impossible here — the ceiling for anything darker than `#185de4` is 3.72:1,
and that is pure black. A contrast color on this blue has to be a bright one.

### Palette

Edit these in the `@theme` block of `src/styles/global.css`; every utility follows.

| Token                  | Value     | Used for                                              |
| ---------------------- | --------- | ----------------------------------------------------- |
| `--color-page`         | `#f4f4f4` | Page background                                       |
| `--color-ink`          | `#2b2b2b` | Headings, body copy, active/hover nav                 |
| `--color-accent`       | `#185de4` | Footer background, focus rings, selection             |
| `--color-accent-hover` | `#1450c4` | Reserved — no blue-filled control on the page today   |
| `--color-signal`       | `#ffe01f` | CTA fill (with an `ink` label), footer keyline, marks on blue |
| `--color-signal-hover` | `#efce00` | CTA hover                                             |
| `--color-signal-deep`  | `#6f5d00` | The same yellow, for text and marks on sand or field  |
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
