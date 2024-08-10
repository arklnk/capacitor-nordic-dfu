import { registerPlugin } from '@capacitor/core';
const NordicDFU = registerPlugin('NordicDFU', {
    web: () => import('./web').then(m => new m.NordicDFUWeb()),
});
export * from './definitions';
export { NordicDFU };
//# sourceMappingURL=index.js.map