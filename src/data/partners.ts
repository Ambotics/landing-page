// Companies the team has worked with on robotics, for the logo wall.
//
// The SVGs are imported as raw markup rather than through `astro:assets` so the
// component can inline them: `currentColor` only resolves in an inlined <svg>,
// never through an <img src>. Inlining also keeps the wall at zero extra requests.
//
// The geometry is each company's own mark, untouched; only the fills are rewritten
// to `currentColor` so LogoWall can tint the row as one. IKEA is the exception
// worth knowing about — it is the one multi-colour mark here, and its oval is
// filled with `var(--color-page)` to keep the letters knocked out of the box.
//
// `height` is optical, not literal. Matching every logo to one height makes the
// square marks read as far heavier than the wordmarks, so each is sized until it
// carries the same weight as its neighbours.
import abb from '../assets/logos/abb.svg?raw';
import astrazeneca from '../assets/logos/astrazeneca.svg?raw';
import ikea from '../assets/logos/ikea.svg?raw';
import universalRobots from '../assets/logos/universal-robots.svg?raw';

export interface Partner {
  /** Accessible name — the logo itself is presentational. */
  name: string;
  svg: string;
  /** Optically balanced render height, in px. */
  height: number;
}

export const partners: Partner[] = [
  // IKEA sits below the rest because it is the only filled mark — matched on
  // height it reads as a block, not a logo. The square UR symbol needs the
  // opposite nudge, and AstraZeneca is a pure wordmark, so cap-height is enough.
  { name: 'IKEA', svg: ikea, height: 30 },
  { name: 'ABB', svg: abb, height: 26 },
  { name: 'AstraZeneca', svg: astrazeneca, height: 17 },
  { name: 'Universal Robots', svg: universalRobots, height: 28 },
];
