define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        properties: {
            'TRoot.$ReportUrl': reportUrl,
            'TRoot.$Number': Number
        }
    };
    exports.default = template;
    function reportUrl() {
        return '/report/show/55?base=/testpdf/index&rep=testpdf';
    }
});
