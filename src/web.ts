import { WebPlugin } from '@capacitor/core';

import type { NordicDFUPlugin } from './definitions';

export class NordicDFUWeb extends WebPlugin implements NordicDFUPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
