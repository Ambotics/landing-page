# Ambotics — landing page

The page opens on the mark. Scrolling zooms out until the mark is the tile on the robot's
chest. Built with [Astro](https://astro.build) + Tailwind CSS v4 and deployed to GitHub
Pages.

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
  og-image.png            # social card: the lockup, white on the accent (needs an absolute URL)
  favicon.{svg,ico}, apple-touch-icon.png  # the mark: accent A on a white tile
scripts/hero.sh           # encodes the hero's pictures from the robot's renders
src/
  assets/                 # carousel photos — optimised at build time by astro:assets
    hero/                 # the hero's five pictures of the robot, and where each lies (zoom.json)
    mark.svg              # the mark's drawing — read by Mark.astro and by the robot's render
  components/
    Carousel.astro        # scroll-snap carousel + arrow buttons (inside Applications)
    ContactForm.astro     # name / email / company / message, posted to Web3Forms
    Footer.astro          # accent-blue footer with grain overlay
    Hero.astro            # the mark, the zoom out to the robot, the H1
    Mark.astro            # the "A" knocked out of a currentColor tile
    Section.astro         # a section: heading in the first column, copy in the other two
    Wordmark.astro        # mark + "Ambotics" lockup, in the footer
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

The contact form's "Send" button is filled with `ink` rather than the accent. That is the
grayscale-default rule applied to the most important control on the page: it earns
attention through weight, not hue, and the blue stays on the plane behind it and the focus
ring around it.

Everything else stays in a plain grayscale — `#f4f4f4` page, `#2b2b2b` copy — so the
blue never has to compete for attention. The robot in the hero is grayscale too. When you add a component, the default is
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

Every heading is set in the display face — Gabarito with `ss01` — so the page reads as
one typographic voice and size alone establishes the hierarchy. The H1 is in `Hero.astro`.
Every section heading renders through `Section.astro`, which also holds the page's three
columns, so headings and copy line up from one section to the next:

| Level                | Size                               | Face                 |
| -------------------- | ---------------------------------- | -------------------- |
| H1                   | 48px, 60px from `sm`, 72px from `lg` | Gabarito `ss01`, 500 |
| Section heading (h2) | 30px, 36px from `sm`               | Gabarito `ss01`, 500 |
| Body                 | 18px on a 32px line                | Inter, 460           |
| Form label           | 12px                               | Instrument Sans, 500 |

The page is one H1 and three h2s. The section `id`s are anchors and do not track the
copy: `#starting` is the section headed "Robots are changing".

### Real text is ink

Anything a visitor has to read is `ink`, small qualifiers included: the contact form's
"(optional)" is separated from its label by weight, not by a lighter grey. A grey light
enough to read as secondary does not clear AA on the page: `#808080` is 3.59:1.

### Naming companies is a claim

The Applications copy says the team **has worked with** IKEA, ABB, AstraZeneca and
Universal Robots — never "our customers", "trusted by", or anything else that reads as a
client list. These are the people's previous engagements, not Ambotics accounts,
and that distinction has to survive every rewrite of the paragraph.

A logo wall carrying the same four marks was built and then removed (PR #2). The finding
worth keeping, if one ever comes back: bind the marks to `currentColor` and tint the row as
one. Keeping the brand palettes and applying `filter: grayscale(1)` was built first and does
not work — `grayscale()` preserves each mark's own luminance, and these four are nowhere
near each other (AstraZeneca's plum ~35/255, ABB's red 55, Universal Robots' light blue
150), so the row reads as four different weights. The SVGs are in git history.

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
| `--color-ink`          | `#2b2b2b` | Headings, body copy, CTA fill                         |
| `--color-ink-hover`    | `#3d3d3d` | CTA hover                                             |
| `--color-accent`       | `#185de4` | Footer background, focus rings, selection             |
| `--color-accent-hover` | `#1450c4` | Reserved — no blue-filled control on the page today   |
| `--color-field`        | `#ededed` | Form field background                                 |

## The hero

The page opens on the mark. Scrolling zooms out, and the mark turns out to be the tile on
the robot's chest. The headline then comes in over the robot, and the page scrolls on down
the robot to its base.

- **One camera, five pictures.** `src/assets/hero/` holds the whole robot and four squares
  about the mark (`torso`, `chest`, `mark`, `tile`), each 2400px on its longer side, all
  through one camera with a zoom lens. `zoom.json` gives each picture's place in mm on the
  mark's plane, from the mark's centre. Laid over each other they are one picture that is
  sharp at every zoom, from 1.5px per mm for the whole robot to 48 for the tile. Together
  they are 412 kB.
- **At rest it is plain CSS.** `Hero.astro` lays out the headline and the whole robot with
  no script. The script draws the zoom on a canvas while the visitor scrolls through the
  260svh of `[data-travel]`, and hands over to the picture in the page once the robot is at
  rest. Without scripts, or with "reduce motion" on, there is no travel, the page is the
  resting state and only the whole robot's picture is fetched (the `zooming` variant in
  `global.css`).
- **The first screen is CSS too.** A cover draws the mark on the chest cover's grey at the
  size the zoom starts from, so the page opens on the mark before a picture has loaded. Its
  two colours, `#d6d7d5` and `#2c2e2f`, are the render's, read off `mark.webp`; they are
  not in the palette.
- **The robot is the one in `Ambotics/open_arm-mods`** (private): `full_robot/`, the robot
  to build. Its tile is drawn from `src/assets/mark.svg` here, so the mark on the chest is
  the page's own.

To render the pictures again, in a checkout of `open_arm-mods` with
`full_robot/robot_325_posed.glb` built as its `full_robot/README.md` says:

```sh
tools/outside.sh ../hero.log ~/Applications/Blender.app/Contents/MacOS/Blender -b --factory-startup \
    --python full_robot/shade.py -- full_robot/robot_325_posed.glb <out>/hero zoom \
    --samples 512 --zoom-px 2400 --mark-svg <this repo>/src/assets/mark.svg    # 6 min
```

Then here, `scripts/hero.sh <out>/hero` fades each picture's edges, encodes it into
`src/assets/hero/` and copies `zoom.json`: 5 min from an agent's shell.

## How it's built

- **Tailwind v4** via `@tailwindcss/vite`. The old inline `tailwind.config` object now lives
  as CSS custom properties in the `@theme` block of `src/styles/global.css`
  (`--color-ink`, `--font-display`, `--container-content`, …), which is what generates
  `text-ink`, `font-display`, `max-w-content`, and friends.
- **Fonts** from Google Fonts — `Gabarito` (display/logo), `Inter` (body),
  `Instrument Sans` (UI labels) — plus `Satoshi` from Fontshare for the form.
- **Images** — the carousel's go through `astro:assets`, which emits responsive WebP at
  583w/1166w. This takes the carousel from ~3.4 MB of JPEG down to ~180 KB. The hero's
  pictures are encoded by `scripts/hero.sh` and served as they are.
- **Layout** — the hero across the page, then three sections on one three-column grid:
  heading in the first column, copy in the other two; a single column below `lg`.
- **Scripts** — the hero's zoom, the carousel arrows and the contact form are plain
  `<script>` tags in their components; Astro bundles and inlines them. No client-side
  framework.

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

- The contact form (name, email, company, and an optional message) posts to
  [Web3Forms](https://web3forms.com), which relays submissions to the address on that
  account — the site itself stays static, and the destination address never appears in the
  page. The `<form>` carries a real `action`, so it still works without JavaScript;
  the script upgrades it to a fetch so the visitor stays on the page, and reports the
  outcome in the status line below the button.
