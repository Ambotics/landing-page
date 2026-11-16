# CLAUDE.md

The Ambotics landing page. Astro 7 + Tailwind v4, static output, deployed to GitHub Pages
by `.github/workflows/deploy.yml` on every push to `main`.

```bash
npm run dev        # http://localhost:4321
npm run build      # static build into dist/
npx astro check    # type-check .astro/.ts
scripts/hero.sh <prefix>   # the hero's pictures, from the robot's renders (README, "The hero")
```

## Design system

**The accent blue is a "working-class blue."** `#185de4` is the blue of workwear and
painted machinery — a shop floor, not a robotics lab. It exists to signal that an Ambotics
robot is meant for **actual work**, which is the same argument the page copy makes: the
industry leads with the breakthrough and talks to engineers; we lead with the customer's
business and their problem.

This is the load-bearing rule when touching color:

- **The blue only ever marks something real** — the footer, focus rings, text selection.
  Things that respond to the visitor. It is never decoration. The CTA is filled with `ink`,
  not the accent: the blue owns the plane and the response states, and the control itself
  stays grayscale like everything else.
- **Default to grayscale.** New components start in `page` / `ink` / `field`.
  Reach for `accent` only when the element genuinely does something.
- **Don't add a second blue surface.** No blue-tinted photos, borders, dividers, or
  section backgrounds — a second blue halves the meaning of the first. The one exception
  is Daniel's: the mark's tile in the hero (see "The hero").
- **Don't swap the accent for a "nicer" blue.** The specific hue is the point. If a
  request implies changing it, confirm the intent rather than assuming.

Contrast floors, already verified: white on `#185de4` is 5.64:1; secondary copy on it must
not go below `text-white/85` (4.53:1); the accent on `#f4f4f4` is 5.13:1. All AA.

**The CTA is `ink`, not the accent.** `bg-ink text-white hover:bg-ink-hover` — white on ink
is 14.16:1 and the fill is 12.09:1 against the `field` background, so both the label and
the control's own edge clear AA with room to spare. This follows the grayscale-default rule
rather than breaking it: the button is the one thing a visitor can act on, and it earns
attention through weight, not hue. `--color-accent-hover` is consequently unused today;
leave it in place rather than deleting a documented token.

The accent still owns the response states on the contact form: every field takes
`focus:ring-accent/35`, which is the blue doing its one job — marking the control that is
answering you.

**Settled: there is no fourth color, and adding one is harder than it looks.** A yellow
accent was tried on this palette and removed. Keep the measurements so nobody re-derives
them:

- **No dark accent can sit on the blue.** The ceiling for anything darker than `#185de4` is
  3.72:1 — and that is pure black. `ink` on the blue is only 2.51:1.
- **Orange and red don't work either.** 2.01:1 and 1.32:1 on the blue, failing even the
  3:1 UI floor. Orange-on-blue is a *hue* contrast; WCAG scores *luminance*. A contrast
  color on this blue has to be a bright one, which is why the attempt went yellow.
- **A bright fill on the sand has a near-invisible edge.** Safety yellow was 1.13:1 against
  the `field` pill. It is defensible under WCAG 1.4.11 if the label carries the
  identification, but `ink` at 12.09:1 avoids the argument entirely.
- If a fourth color comes up again, the constraint to lead with is that it must clear
  4.5:1 on *both* `#185de4` and `#f4f4f4` to be usable everywhere — and essentially
  nothing does, which is why the palette stays at three.

Full palette table and rationale: see **Design system** in `README.md`.

**The mark is the A knocked out of the designer's rounded tile, and the tile takes
`currentColor`.** The source file (replaced 2026-11-01) is a white 391px square with 20px
corners and the A cut through it. The tile came back on 2026-11-01 as an app-icon-style
badge; NOW-255 had dropped it. Earlier frames put the mark on a navy square, dropped
because navy would be a second blue. The A is re-centred in the tile: the designer's frame
sat it 17px right of centre. `src/assets/mark.svg` and `favicon.svg` carry the same
shifted path. `Mark.astro` draws the first, and so does the robot's render, for the tile on
the robot's chest in the hero.
On the page the tile is white on the footer, beside the wordmark, and the accent in the
hero; the A shows whatever is behind it. Off the page — favicon, apple-touch-icon,
`og-image.png` — the badge is the footer's: a white tile with the A in `#185de4`. The
favicon paints the A rather than cutting it, so it stays blue on any tab. On a white tab
the tile itself disappears and only the A shows. `apple-touch-icon.png` is full-bleed
white with square corners, because iOS cuts its own corners and turns transparency black.
The tile is 0.9em and centred on Gabarito's 0.681em cap height (see `Wordmark.astro`);
resize it and the offset must be recomputed.

**The wordmark is Gabarito 500, set in `Wordmark.astro`, not by its callers.** It was 600
until 2026-09-30. 500 is also every heading's weight. `og-image.png`
bakes in the footer lockup: white on `#185de4`, Gabarito at 92px, centred in 1200×630. Change
the weight or the mark and re-render the card.

**The name carries no ™ anywhere** — not the lockup, the `<title>`, the meta tags, the
social card or the docs.

**Every section goes through `Section.astro`.** It holds the page's three columns and the
one heading treatment: the display face (Gabarito + `ss01`), the H1's own, at 30–36px
against the H1's 48–72px and the 18px body. Don't hand-roll a size or reach for `font-body`
on a heading; change the component so the scale stays in one file. The page is one H1, in
`Hero.astro`, and three h2s. The section is a grid of its own with a gutter either side, so
its `wide` slot, the carousel's, runs through the right gutter to the edge of the screen.

`font-ui` at 12px is now the *form label* style, not a heading style. It labels controls,
which is a different job from titling a section.

The section `id`s are anchors and do not follow the copy (`starting` is the "Robots are
changing" section).

**Anything that is real text must clear AA on the page, including qualifiers.** A grey
light enough to read as secondary does not: `#808080` is 3.59:1 on `page`. So all text is
`ink`, and the form's "(optional)" is set apart by weight.

**One filled button on the page: "Send".** The hero's "Get in touch" is a text link for
that reason.

**Naming IKEA, ABB, AstraZeneca or Universal Robots is a claim, so the wording is
load-bearing.** The Applications copy says the team *has worked with* them — never "our customers",
"trusted by", or anything that reads as a client list. These are the people's
previous engagements, not Ambotics accounts, and the distinction has to survive every
rewrite of that paragraph.

A logo wall carrying the same four marks was built and then removed (PR #2). If one comes
back, the reasoning that took the longest to recover is in git: the marks were bound to
`currentColor` and tinted as one row, because `filter: grayscale(1)` preserves each mark's
own luminance — these four span 35–150 out of 255 — so a desaturated row reads as four
different weights.

## The hero

Daniel's brief (NOW-318, 2026-11-15): an Apple-like page that starts on the logo; scrolling
zooms out and the logo reveals itself on the chest of the actual robot from the mod repo;
simple; after Apple and moving.parts. Then: the carousel on to the right edge of the
screen; the head turns as the visitor scrolls and ends looking straight ahead (the first
pass turned it down from there, and he asked for the other way); the camera's lenses
reflective; the logo the same blue as the last panel, as a try; the head following the
pointer, his pick from a list of ideas after moving.parts. How it works is in README.md,
"The hero".

- **The zoom is drawn on a canvas, after three ways in the DOM failed** in Playwright's
  browsers. One transform around all five pictures: Chromium rounds each picture's box to
  whole pixels before the scale, and at a scale of 14 the tile's edge sat about 6px apart
  in a picture and the closer one over it. Sizing the pictures each frame: sharp in
  Chromium, coarse and jagged in WebKit. Each picture a layer of its own with a transform:
  sharp in Chromium, coarse in WebKit once the zoom had run.
- **The head's picture replaces the head in the five pictures.** The script clears a box
  inside the faded edge of the head's picture, then draws it. The box has to hold the head
  at every angle, so `shade.py` sizes the picture from the head's whole sweep.
- **The first screen's size is the chest cover's.** The cover's tile is
  `max(24.2vw, 22.7svh)` wide: the tile is 30mm, and the 124 × 132mm of plain chest cover
  around the mark has to fill the screen, else the shoulders show on the first screen. A
  new chest cover or a moved mark needs both numbers measured again, off `chest.webp`.
- **The mark's tile is the accent**: on the first screen and on the robot's chest. That
  is a second blue surface, against the rule above. Daniel asked for it as a try
  (2026-11-15) and took the page to `/` with it (2026-11-16).
- **The cover's grey is read off the render**, beside the tile in `mark.webp`. Read it
  again after a new render. The cover's tile is `accent`, and `scripts/hero.sh` moves the
  rendered tile to the same value.
- **The `zooming` condition is written twice**, in `global.css` and in `Hero.astro`'s
  script. The script cannot read it off the page: WebKit runs a module script before the
  stylesheet is in. For the same reason the script measures in a `ResizeObserver`, never
  once at the start.
- **The pictures keep their transparency.** Laid on the page's colour and saved without
  it, a closer picture showed as a faint rectangle: lossy WebP turns `#f4f4f4` into
  `#f5f5f5`. Tried again for the head's looks, where it halves the bytes: Chromium drew
  their ground `#f6f6f6`. `webp:alpha-quality=60` is what cuts a look's bytes instead.
- **At rest the turned head is a canvas of its own over the robot's picture.** The robot's
  own head is in that picture, so the canvas paints the page's colour, read off `body`,
  inside the look's faded edge, then draws the look. In the zoom's canvas the same box is
  cleared instead.
- **Two looks are never blended.** A blend is two heads: a look 5 degrees on has the head
  5 to 7mm further along. Daniel saw it at rest, then as a blur while the head turned
  (2026-11-15). Between looks the script draws the nearer one in strips: the head down to
  its chin moved by the way its eyes have gone, the neck under it sheared a row of px at a
  time, the still part as it is. `zoom.json` has every look's eyes and chin and the neck's
  still top.
- **The head stops on a look.** Short of rest it does too. Over the last 5% of the travel it turns part
  of the way to the pointer, and its aim is the look nearest that. The part was once a
  factor on the look drawn, and the head sat blurred wherever the scroll stopped there
  (Daniel, 2026-11-15).
- **The looks wait for a pointer**: a `pointermove` that is no touch, or a `wheel`, which
  says where the pointer is before it has moved.
- **The outline is one width on the robot, not in the picture.** Every picture once had it
  4px wide. Where the zoom passes from a picture to the next wider one, that one is drawn
  up to 1.4 times its size and its line is 2.4 times as wide on the robot: Daniel saw the
  outer outline suddenly wider and fuzzy (2026-11-16). Now it is 0.35mm on the robot in all
  of them (`ZOOM_LINE` in `shade.py`), at 50% on the robot and 30% along its edge.
- **A large screen shows the robot at rest larger than its picture.** The robot is
  `min(125vw, 78svh)` wide: in Daniel's window, some 1470px high at 2x, 1.8 times the
  2400px picture, and the head's looks with it. He saw the head fuzzy. Where the screen
  has a fifth more px than the picture (`large()`), the script puts `robot_2x.webp` in the
  picture's place, in the page and as the zoom's first picture, and fetches the looks from
  `look_2x/`. It asks only once the stylesheet is in: before that the robot is as large as
  its picture, and WebKit runs the script that early. The sharper looks are fetched but
  not decoded ahead: ten of them decoded are 280 MB.
- **The canvas is never over 16 million pixels.** iOS draws nothing on a larger one.
- **A headless browser says nothing about the zoom's speed.** Playwright's Chromium and
  WebKit have no GPU here and take 100ms or more a frame.

## State as of 2026-11-16

- The page is `/` on ambotics.com since 2026-11-16, on Daniel's word (NOW-318: "Perfect
  now. Merge it. Move it to the main domain as well"). It stood at `/v2-preview` for
  sign-off from 2026-11-15, beside the first landing page: a sidebar with the wordmark and
  a nav, 14px copy in one column. That page went, with `Sidebar.astro`,
  `SectionHeading.astro` and the `muted` and `nav` tokens; `95f8578` is the last commit
  with it. `/v2-preview` redirects to `/`.
- The render script's side is in `open_arm-mods` main (its PRs #24 and #25).
- Checked in Playwright's Chromium and WebKit at 1440 × 900, 2560 × 1440 at 2x and
  390 × 844. Not run in a real Safari, on a phone, or on a slow machine.
- Off the page the mark is still the footer's badge, a white tile with the A in the
  accent: favicon, apple-touch-icon, `og-image.png`. The hero's mark is the reverse, an
  accent tile. Daniel has not said whether they follow.
- The sharper looks' first use was not timed: each is decoded when the head first needs it.
- Daniel watched the head follow the pointer on the live page ("Nice!"). How far it turns
  for a pointer (`reach`) and how fast (80ms in `follow`) are as first set; he has asked for
  no change.
- The head's turn without a blend was checked frame by frame, not watched: Playwright's
  clock held (`page.clock.install`, `pauseAt`, `runFor(16)`) and a screenshot a frame, a
  turn sideways and one up and down in Chromium, a diagonal one in WebKit. The lenses keep
  their size and darkness in every frame, and their way from frame to frame falls off
  evenly. At a change of look the head's shape changes at once: a px or two at its ends.

## Gotchas

- **Tailwind reads comments and these docs too.** A bare word that is a utility's name
  lands in the stylesheet as a class that nothing uses. It happened with the flex utility
  spelled like the verb for getting larger, first in a comment in `Hero.astro`, then in
  this very note. After a change to a comment or a doc, build `main` and the branch and
  compare the stylesheets' class names.
- **`public/CNAME` and `site` in `astro.config.mjs` must agree.** `CNAME` is what GitHub
  Pages reads; `site` builds the absolute canonical and OG URLs. To serve from
  `ambotics.github.io/landing-page` instead, delete `CNAME` and set `base: '/landing-page'`.
- **Order matters against Tailwind's preflight.** Custom element styles belong *after*
  `@import 'tailwindcss'` in `global.css`. The pre-Astro page had an `input::placeholder`
  rule that never applied, because the Play CDN injected preflight after the inline
  `<style>` and silently won.
- **The contact address is not in this repo, and should stay that way.** The form posts to
  Web3Forms, which relays to whatever address that account is set to; changing the
  destination is a dashboard change, not a code change. An earlier `mailto:` version had to
  keep the address in the page under a character-shift obfuscation to hide it from
  harvesters — the relay removes the problem rather than obscuring it. `grep -rlE
  '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' dist/` should keep returning nothing.
  The `access_key` in `ContactForm.astro` is public by design and is not a secret; it is
  the form's identifier. Spam is held off by the `botcheck` honeypot plus the domain
  restriction set in the Web3Forms dashboard — if submissions start arriving from
  elsewhere, that setting is the thing to check first.
- **`og-image.png` lives in `public/`, not `src/assets/`.** Social crawlers need a stable
  absolute URL, so it must not go through `astro:assets` hashing.

## Verifying visual changes

There are no tests. For anything that changes rendering, build and screenshot before
claiming it works — `astro check` and a green build do not catch a color that didn't apply
or a utility Tailwind never generated. Screenshot the hero in WebKit too, not
only in Chromium: the two differ there (see "The hero"). Reading computed styles out of a real browser
(`getComputedStyle`) is the reliable check; diffing full-page screenshots against the
previous build catches unintended layout shifts.
