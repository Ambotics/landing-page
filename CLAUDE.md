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

- **The blue only ever marks something real** — the CTA button, the footer, focus rings,
  text selection. Things that respond to the visitor. It is never decoration.
- **Default to grayscale.** New components start in `page` / `ink` / `nav` / `muted`.
  Reach for `accent` only when the element genuinely does something.
- **Don't add a second blue surface.** No blue-tinted photos, borders, dividers, or
  section backgrounds — a second blue halves the meaning of the first.
- **Don't swap the accent for a "nicer" blue.** The specific hue is the point. If a
  request implies changing it, confirm the intent rather than assuming.

Contrast floors, already verified: white on `#185de4` is 5.64:1; secondary copy on it must
not go below `text-white/85` (4.53:1); the accent on `#f4f4f4` is 5.13:1. All AA.

Full palette table and rationale: see **Design system** in `README.md`.

## Gotchas

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
