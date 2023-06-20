import { WebPlugin } from '@capacitor/core';

import type { NordicDFUPlugin } from './definitions';

export class NordicDFUWeb extends WebPlugin implements NordicDFUPlugin {
  async startDFU(): Promise<void> {
    console.warn('Can not startDFU in Web.');
  }
}
