define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        options: {},
        properties: {
            'TInstance.$Vars'() {
                return {
                    Variables: this.State.Variables,
                    LastResult: this.State.LastResult,
                    CurrentUser: this.State.CurrentUser
                };
            }
        }
    };
    exports.default = template;
});
