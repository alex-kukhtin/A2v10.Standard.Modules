define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        properties: {
            'TAutoStart.TimezoneOffset'() { return (new Date()).getTimezoneOffset(); }
        },
        validators: {
            'AutoStart.Workflow': "@[Error.Required]"
        },
        commands: {}
    };
    exports.default = template;
});
