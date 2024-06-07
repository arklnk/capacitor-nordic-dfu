var capacitorNordicDFU = (function (exports, core) {
    'use strict';

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

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
