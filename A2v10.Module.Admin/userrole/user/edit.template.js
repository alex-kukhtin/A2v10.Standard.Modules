define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        properties: {},
        validators: {
            'User.PersonName': "@[Error.Required]"
        }
    };
    exports.default = template;
});
