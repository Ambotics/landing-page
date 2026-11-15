# Ambotics — landing page

A recreation of [ambotics.framer.website](https://ambotics.framer.website),
built with [Astro](https://astro.build) + Tailwind CSS v4 and deployed to GitHub Pages.

The next page is live for sign-off at [`/v2-preview`](https://ambotics.com/v2-preview/):
it opens on the mark and zooms out onto the robot. See **/v2-preview** below. Everything
else in this file describes `/`.

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
scripts/hero.sh           # /v2-preview: encodes the hero's pictures from the robot's renders
src/
  assets/                 # carousel photos — optimised at build time by astro:assets
    hero/                 # /v2-preview: the hero's pictures of the robot, and where each lies (zoom.json)
    mark.svg              # the mark's drawing — read by Mark.astro and by the robot's render
  components/
    Carousel.astro        # scroll-snap carousel + arrow buttons (inside Applications)
    ContactForm.astro     # name / email / company / message, posted to Web3Forms
    Footer.astro          # accent-blue footer with grain overlay
    Hero.astro            # /v2-preview: the mark, the zoom out to the robot, the H1
    Mark.astro            # the "A" knocked out of a currentColor tile — sits in the wordmark lockup
    Section.astro         # /v2-preview: a section, heading in the first column, copy in the other two
    SectionHeading.astro  # the one heading treatment — display face, 20px
    Sidebar.astro         # logo, section nav, scroll-spy
    Wordmark.astro        # mark + "Ambotics" lockup, shared by header and footer
  data/applications.ts    # carousel entries (label + image)
  layouts/Layout.astro    # <head>, meta/OG tags, font loading
  pages/index.astro       # the page
  pages/v2-preview.astro  # the next page, live for sign-off
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
section, so the outline can stay honest while the page keeps one heading treatment. Nothing
uses it today — the page is one H1 and three h2s.

Nav labels in `Sidebar.astro` are the section headings verbatim — a link that lands on a
heading with different wording reads as the wrong destination. The section `id`s are a
separate contract with the scroll-spy and deliberately do not track the copy: `#starting`
still points at the section now headed "Robots are changing".

### `nav` is not for words

`#808080` on the page background is 3.59:1 — under AA. It is fine for the idle sidebar
links, which darken to `ink` on hover and focus. It is not fine for anything a visitor has
to read, and that includes small qualifiers: the contact form's "(optional)" is separated
from its label by weight, not by dropping to `nav`.

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

## /v2-preview

The next landing page, live at `/v2-preview` for sign-off before it replaces `/`. No page
links to it and it carries `noindex`. It has the copy, the carousel, the contact form and
the footer of `/`. Its hero and its layout are its own: no sidebar, and three sections on
one three-column grid, heading in the first column and copy in the other two. The carousel
runs on to the right edge of the screen.

| Level                | Size                                 | Face                 |
| -------------------- | ------------------------------------ | -------------------- |
| H1                   | 48px, 60px from `sm`, 72px from `lg` | Gabarito `ss01`, 500 |
| Section heading (h2) | 30px, 36px from `sm`                 | Gabarito `ss01`, 500 |
| Body                 | 18px on a 32px line                  | Inter, 460           |

### The hero

The page opens on the mark. Scrolling zooms out, and the mark turns out to be the tile on
the robot's chest. The head comes into view looking down at the robot's hands, then lifts
to look straight at the visitor. The headline comes in over the robot, and the page scrolls
on down the robot to its base.

- **One camera, five pictures.** `src/assets/hero/` holds the whole robot and four squares
  about the mark (`torso`, `chest`, `mark`, `tile`), each 2400px on its longer side, all
  through one camera with a zoom lens. `zoom.json` gives each picture's place in mm on the
  mark's plane, from the mark's centre. Laid over each other they are one picture that is
  sharp at every zoom, from 1.5px per mm for the whole robot to 48 for the tile.
- **The head is pictures of its own**, through the same camera: `head.webp` has it at
  home, looking 62 degrees down, and `head/00.webp` to `head/31.webp` lift it, 2 degrees a
  picture, to where the five pictures have it: level, looking at the visitor. The page
  draws one of them over the five. The camera's lenses are domes of dark glass, so they
  catch the lights as the head lifts.
- **924 kB in all.** The five pictures are 431 kB and the head's are 493 kB. The head's
  32 are fetched once the first screen is up.
- **At rest it is plain CSS.** `Hero.astro` lays out the headline and the whole robot with
  no script. The script draws the zoom on a canvas while the visitor scrolls through the
  260svh of `[data-travel]`, and hands over to the picture in the page once the robot is at
  rest. Without scripts, or with "reduce motion" on, there is no travel, the page is the
  resting state and only the whole robot's picture is fetched (the `zooming` variant in
  `global.css`).
- **The first screen is CSS too.** A cover draws the mark on the chest cover's grey at the
  size the zoom starts from, so the page opens on the mark before a picture has loaded. Its
  grey, `#d6d7d5`, is the render's, read off `mark.webp`; it is not in the palette.
- **The mark's tile is the accent**, the footer's blue, on the first screen and on the
  robot. The render cannot give that blue: its tone curve pales it, and `--mark-blue` is the
  nearest it has, `#3466db`. `scripts/hero.sh` moves the tile's blue the rest of the way, to
  `--color-accent`.
- **The robot is the one in `Ambotics/open_arm-mods`** (private): `full_robot/`, the robot
  to build. Its tile is drawn from `src/assets/mark.svg` here, so the mark on the chest is
  the page's own.

To render the pictures again, in a checkout of `open_arm-mods` with
`full_robot/robot_325_posed.glb` built as its `full_robot/README.md` says:

```sh
tools/outside.sh ../hero.log ~/Applications/Blender.app/Contents/MacOS/Blender -b --factory-startup \
    --python full_robot/shade.py -- full_robot/robot_325_posed.glb <out>/hero zoom \
    --samples 512 --zoom-px 2400 --zoom-head 62 32 --mark-blue \
    --mark-svg <this repo>/src/assets/mark.svg    # about 20 min
```

62 is the neck's home tilt: that far up, the head is level, and that is where the five
pictures have it. Then here,
`scripts/hero.sh <out>/hero` moves the tile to the accent, fades each picture's edges,
encodes it into `src/assets/hero/` and copies `zoom.json`: 2 min when it runs outside the agent's
background band (`tools/outside.sh` again, with `/opt/homebrew/bin` on its `PATH`).

### When it replaces /

`index.astro` takes `v2-preview.astro`'s content and `v2-preview.astro` goes, with its
`noindex`. `Sidebar.astro` and `SectionHeading.astro` go, and with them the `muted` and
`nav` tokens and the default of `Carousel.astro`'s `track`. This file and `CLAUDE.md` then
describe one page: commit `f409c79`, the first of the pull request that added
`/v2-preview`, has both as they read for that page alone.

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
- **Scripts** — the carousel arrows, the nav scroll-spy, the contact form and
  `/v2-preview`'s hero are plain `<script>` tags in their components; Astro bundles and
  inlines them. No client-side framework.

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
