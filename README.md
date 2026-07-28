# Ambotics™ — landing page

A faithful recreation of [ambotics.framer.website](https://ambotics.framer.website),
rebuilt with plain HTML + Tailwind CSS (no Framer, no build step).

## Run

Just open the file — there is no build:

```bash
open index.html            # macOS
# or serve it
python3 -m http.server 8000   # then visit http://localhost:8000
```

## Structure

```
index.html        # the whole page
assets/           # images (renamed from the originals)
  manufacturing.jpg  hospitality.jpg  logistics.jpg
  retail.jpg         food-beverage.jpg  og-image.png
```

## How it's built

- **Tailwind** via the Play CDN, configured inline in `index.html` (colors, fonts, spacing).
- **Fonts** from Google Fonts — `Gabarito` (display/logo), `Inter` (body), `Instrument Sans` (UI labels), matching the source.
- **Layout** — a left sidebar (logo + section nav) beside a content column on desktop;
  a single column on mobile with the nav hidden, mirroring the original responsive behaviour.
- **Carousel** — native horizontal scroll with CSS scroll-snap and two hover-revealed
  chevron arrows driven by ~15 lines of vanilla JS.

### Going to production

The Tailwind Play CDN prints a console warning and ships the full engine. To remove it,
compile a static stylesheet instead:

```bash
npx tailwindcss -i input.css -o style.css --minify
```

…then drop the `<script src="https://cdn.tailwindcss.com">` tag and link `style.css`.
