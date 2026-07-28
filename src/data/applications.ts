import type { ImageMetadata } from 'astro';

import manufacturing from '../assets/manufacturing.jpg';
import hospitality from '../assets/hospitality.jpg';
import logistics from '../assets/logistics.jpg';
import retail from '../assets/retail.jpg';
import foodBeverage from '../assets/food-beverage.jpg';

export interface Application {
  label: string;
  image: ImageMetadata;
}

export const applications: Application[] = [
  { label: 'Manufacturing', image: manufacturing },
  { label: 'Hospitality', image: hospitality },
  { label: 'Logistics', image: logistics },
  { label: 'Retail', image: retail },
  { label: 'Food & Beverage', image: foodBeverage },
];
