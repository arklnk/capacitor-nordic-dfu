import { WebPlugin } from '@capacitor/core';
export class NordicDFUWeb extends WebPlugin {
    async startDFU() {
        console.warn('Can not startDFU in Web.');
    }
    async abortDFU() {
        console.warn('Can not abortDFU in Web.');
    }
}
//# sourceMappingURL=web.js.map