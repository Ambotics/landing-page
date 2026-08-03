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
    logos/                # partner marks, recoloured to currentColor (see below)
  components/
    Carousel.astro        # scroll-snap carousel + arrow buttons (inside Applications)
    ContactForm.astro     # name / email / company / message (currently inert — see below)
    Footer.astro          # accent-blue footer with grain overlay
    LogoWall.astro        # "With experience from" — inlined, single-colour logos
    SectionHeading.astro  # the one heading treatment — display face, 20px
    Sidebar.astro         # logo, section nav, scroll-spy
    Wordmark.astro        # "Ambotics™" lockup, shared by header and footer
  data/applications.ts    # carousel entries (label + image)
  data/partners.ts        # logo wall entries (name + raw SVG + optical height)
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

The contact form's "Send" button is filled with `ink` rather than the accent. That is the
grayscale-default rule applied to the most important control on the page: it earns
attention through weight, not hue, and the blue stays on the plane behind it and the focus
ring around it.

Everything else stays in a plain grayscale — `#f4f4f4` page, `#2b2b2b` copy, gray nav —
so the blue never has to compete for attention. When you add a component, the default is
grayscale; reach for the accent only if the element genuinely does something.

Two practical consequences:

- Don't tint photos, borders, dividers, or section backgrounds with it. A second blue
  surface halves the meaning of the first.
- Keep white on `#185de4` for text (5.64:1, AA) and don't drop below `text-white/85` for
  secondary copy on it (4.53:1, AA). The accent on `#f4f4f4` is 5.13:1, so it is also
  safe for small text on the page background if a future element needs it.

### The CTA is ink

The "Send" button is `bg-ink text-white hover:bg-ink-hover`. White on ink is 14.16:1,
and the fill is 12.09:1 against the `#ededed` field background, so both the label and the
control's own edge are far clear of AA. A neutral button is the grayscale-default rule
applied to the most important control on the page — it earns attention through weight
rather than hue, which leaves the blue free to mean *this responds to you*.

Because of that, `--color-accent-hover` has no use site today. It stays in the palette
rather than being deleted.

### One heading treatment

Every heading renders through `SectionHeading.astro` in the display face — Gabarito with
`ss01`, the H1's own treatment — so the page reads as one typographic voice and size alone
establishes the hierarchy:

| Level                       | Size                    | Face                    |
| --------------------------- | ----------------------- | ----------------------- |
| H1                          | `clamp(28px,5vw,32px)`  | Gabarito `ss01`, 500    |
| Heading (`h2`, `h3`)        | 20px                    | Gabarito `ss01`, 500    |
| Body                        | 14px                    | Inter, 460              |
| Form label                  | 12px                    | Instrument Sans, 500    |

20px was picked by measuring, not by ratio arithmetic. At 18px the heading reads as a
bolded first line of the paragraph beneath it rather than as a heading; 20px separates
cleanly and lands the h2/h1 ratio at 0.63, alongside the 0.65 of the reference page this
layout follows.

`as="h3"` drops the level without changing the look, for a heading nested inside another
section — the logo wall's "With experience from" inside Applications. The outline stays
honest while the page keeps one heading treatment.

Nav labels in `Sidebar.astro` are the section headings verbatim — a link that lands on a
heading with different wording reads as the wrong destination. The section `id`s are a
separate contract with the scroll-spy and deliberately do not track the copy: `#starting`
still points at the section now headed "What changed".

### `nav` is not for words

`#808080` on the page background is 3.59:1 — under AA. It is fine for the idle sidebar
links (which darken to `ink` on hover and focus) and for the logo marks, since WCAG exempts
logotypes from contrast minimums and each mark carries an `sr-only` name. It is not fine
for anything a visitor has to read, and that includes small qualifiers: the contact form's
"(optional)" is separated from its label by weight, not by dropping to `nav`.

### The logo wall is one colour, not four desaturated ones

`LogoWall.astro` closes the Applications section: the carousel shows the kinds of work,
and the marks underneath say where the people doing it have done it before. Every mark is bound
to `currentColor` in its SVG file, so the row idles at `nav` and warms to `ink` on
hover — the same idle/active pair the sidebar nav uses.

The obvious alternative, keeping the brand palettes and applying `filter: grayscale(1)`,
was built first and does not work. CSS `grayscale()` preserves each mark's own
luminance, and these four are nowhere near each other: AstraZeneca's plum computes to
roughly 35/255, ABB's red to 55, while Universal Robots' light blue lands at 150. On one
row that reads as four different weights, with the UR mark almost gone. Flattening
everything to a single ink is the only treatment that makes the row look deliberate.

Two consequences worth knowing:

- **IKEA is the one multi-colour mark**, and it can't be flattened wholesale — box,
  oval and letters would collapse into a solid rectangle. Its box and letters take
  `currentColor` and its oval is filled with `var(--color-page)`, which preserves the
  knockout. Change the page background and that oval must follow.
- **The heading is `ink`, not `nav`,** and its wording is load-bearing: "With experience
  from", never "our customers" or "trusted by". These are prior engagements, not Ambotics
  accounts, and a bare logo strip reads as a client list unless the words rule it out.
  The logos themselves may sit at `nav` — WCAG exempts logotypes from contrast minimums,
  and each carries an `sr-only` name — but no word on the page may.

The logos are sized individually rather than to a common height: a filled box and a
square symbol read much heavier than a wordmark at the same height. The per-logo
`height` in `src/data/partners.ts` is optical, so re-tune it by eye, not by arithmetic.

### Why the palette stays at three colors

A fourth color — safety yellow, for the button and a footer keyline — was built and then
removed. The measurements are kept here so the ground isn't re-covered:

- **Nothing dark can sit on the blue.** The ceiling for anything darker than `#185de4` is
  3.72:1, and that is pure black. Ink on the blue is 2.51:1.
- **Orange and red fail too** — 2.01:1 and 1.32:1 on the blue, under even the 3:1 UI floor.
  Orange-on-blue is a *hue* contrast and WCAG scores *luminance*. That is why the attempt
  had to go bright, and why it landed on yellow.
- **A bright fill on the sand has a near-invisible edge.** Safety yellow measured 1.13:1
  against the field pill. Arguably conformant under WCAG 1.4.11, since a 10.74:1 label
  identifies the control — but ink at 12.09:1 sidesteps the question.
- **The real bar for a fourth color** is clearing 4.5:1 against *both* `#185de4` and
  `#f4f4f4`. Almost nothing does, which is the honest reason the palette is three colors
  and not four.

### Palette

Edit these in the `@theme` block of `src/styles/global.css`; every utility follows.

| Token                  | Value     | Used for                                              |
| ---------------------- | --------- | ----------------------------------------------------- |
| `--color-page`         | `#f4f4f4` | Page background                                       |
| `--color-ink`          | `#2b2b2b` | Headings, body copy, active/hover nav, CTA fill       |
| `--color-ink-hover`    | `#3d3d3d` | CTA hover                                             |
| `--color-accent`       | `#185de4` | Footer background, focus rings, selection             |
| `--color-accent-hover` | `#1450c4` | Reserved — no blue-filled control on the page today   |
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

- The contact form (name, email, company, and an optional message) has no backend —
  submitting is prevented, matching the original page.
  Point the `<form>` at a handler (Formspree, Buttondown, a Worker) to make it live.
