# CLAUDE.md

The Ambotics™ landing page. Astro 7 + Tailwind v4, static output, deployed to GitHub Pages
by `.github/workflows/deploy.yml` on every push to `main`.

```bash
npm run dev        # http://localhost:4321
npm run build      # static build into dist/
npx astro check    # type-check .astro/.ts
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
- **Default to grayscale.** New components start in `page` / `ink` / `nav` / `muted`.
  Reach for `accent` only when the element genuinely does something.
- **Don't add a second blue surface.** No blue-tinted photos, borders, dividers, or
  section backgrounds — a second blue halves the meaning of the first.
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

**Every heading goes through `SectionHeading.astro`.** The display face (Gabarito + `ss01`)
carries the H1 *and* every heading below it — 20px against the H1's 28–32px and the 14px
body. Don't hand-roll a size or reach for `font-body` on a heading; add the class to the
component so the scale stays in one file. Use `as="h3"` for a heading nested inside another
section — Applications carries two, "With experience from" and "Where to start". The
level changes, the treatment does not.

`font-ui` at 12px is now the *form label* style, not a heading style. It labels controls,
which is a different job from titling a section.

Nav labels in `Sidebar.astro` are the section headings verbatim — a link that lands on a
heading worded differently reads as the wrong destination. Change one, change the other.
The `id`s are a separate contract with the scroll-spy and do not follow the copy (`starting`
still points at the "What changed" section).

**Anything that is real text must clear AA on the page, including qualifiers.** `nav`
(`#808080`) is 3.59:1 on `page` and so is only ever for the idle nav links and the logo
marks — WCAG exempts logotypes, not words. The form's "(optional)" is set apart by weight
rather than by dropping to `nav`, for exactly this reason.

**The logo wall is a single colour.** Partner marks in `src/assets/logos/` have had their
brand fills rewritten to `currentColor` — the geometry is untouched, the colour is not.
`LogoWall.astro` then tints the whole row `nav`, warming to `ink` on hover. Do not "restore"
the brand colours and reach for `filter: grayscale(1)` instead: that was built first and
fails, because `grayscale()` keeps each mark's own luminance and these four span 35–150
out of 255, so the row reads as four different weights. Details in `README.md`.

**The logo wall's heading is a claim, so the wording is load-bearing.** "With experience
from" — never "our customers" or "trusted by". These are the team's prior engagements, not
Ambotics accounts, and a bare logo strip reads as a client list unless the words rule it
out. The same care applies to the Applications copy that names the companies.

## Gotchas

- **The IKEA logo's oval is `var(--color-page)`, not white.** It is the only multi-colour
  mark on the wall; its box and letters are `currentColor`, and the oval has to be an
  actual fill or the letters vanish into the box. It tracks the page background by hand —
  change `--color-page` and you must change `src/assets/logos/ikea.svg` with it.
- **Logo sizing is optical, not uniform.** The per-logo `height` in `src/data/partners.ts`
  is tuned by eye: a filled box (IKEA) and a square symbol (Universal Robots) read far
  heavier than a wordmark at the same height. Don't normalise them to one number.
- **Scroll-spy uses a literal class string.** `src/components/Sidebar.astro` calls
  `classList.toggle('text-ink', …)` from its `<script>`. Tailwind v4 generates that
  utility only because it scans the file and finds the bare string — rename the token or
  the string and the active nav state silently stops working. Verify in the built CSS
  (`grep text-ink dist/_astro/*.css`), not just by reading the source.
- **`public/CNAME` and `site` in `astro.config.mjs` must agree.** `CNAME` is what GitHub
  Pages reads; `site` builds the absolute canonical and OG URLs. To serve from
  `ambotics.github.io/landing-page` instead, delete `CNAME` and set `base: '/landing-page'`.
- **Order matters against Tailwind's preflight.** Custom element styles belong *after*
  `@import 'tailwindcss'` in `global.css`. The pre-Astro page had an `input::placeholder`
  rule that never applied, because the Play CDN injected preflight after the inline
  `<style>` and silently won.
- **`og-image.png` lives in `public/`, not `src/assets/`.** Social crawlers need a stable
  absolute URL, so it must not go through `astro:assets` hashing.

## Verifying visual changes

There are no tests. For anything that changes rendering, build and screenshot before
claiming it works — `astro check` and a green build do not catch a color that didn't apply
or a utility Tailwind never generated. Reading computed styles out of a real browser
(`getComputedStyle`) is the reliable check; diffing full-page screenshots against the
previous build catches unintended layout shifts.
