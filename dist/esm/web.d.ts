import { WebPlugin } from '@capacitor/core';
import type { NordicDFUPlugin } from './definitions';
export declare class NordicDFUWeb extends WebPlugin implements NordicDFUPlugin {
    startDFU(): Promise<void>;
    abortDFU(): Promise<void>;
}
