define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        properties: {
            'TStore.$$Tab': { type: String, value: 'Addresses' }
        }, validators: {
            'Store.Name': `@[Error.Required]`
        }
    };
    exports.default = template;
});
