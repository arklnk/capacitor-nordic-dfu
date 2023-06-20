import { registerPlugin } from '@capacitor/core';

import type { NordicDFUPlugin } from './definitions';

const NordicDFU = registerPlugin<NordicDFUPlugin>('NordicDFU', {
  web: () => import('./web').then(m => new m.NordicDFUWeb()),
});

export * from './definitions';
export { NordicDFU };
