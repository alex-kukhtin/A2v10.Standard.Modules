define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        options: {
            persistSelect: ["Agents"]
        },
        properties: {
            'TRoot.$ExportArg': exportArgument,
        }
    };
    exports.default = template;
    function exportArgument() {
        let fi = this.Agents.$ModelInfo.Filter;
        return { Period: fi.Period, Fragment: fi.Fragment };
    }
});
