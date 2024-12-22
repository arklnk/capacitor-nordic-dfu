'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var core = require('@capacitor/core');

const NordicDFU = core.registerPlugin('NordicDFU', {
    web: () => Promise.resolve().then(function () { return web; }).then(m => new m.NordicDFUWeb()),
});

class NordicDFUWeb extends core.WebPlugin {
    async startDFU() {
        console.warn('Can not startDFU in Web.');
    }
    async abortDFU() {
        console.warn('Can not abortDFU in Web.');
    }
}

var web = /*#__PURE__*/Object.freeze({
    __proto__: null,
    NordicDFUWeb: NordicDFUWeb
});

exports.NordicDFU = NordicDFU;
//# sourceMappingURL=plugin.cjs.js.map
