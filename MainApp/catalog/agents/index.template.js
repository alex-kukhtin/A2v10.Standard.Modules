define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const eb = require('std:eventBus');
    const template = {
        options: {
            persistSelect: ['Agents']
        },
        commands: {
            shareUrl
        }
    };
    exports.default = template;
    function shareUrl() {
        let x = { url: '' };
        let ctrl = this.$ctrl;
        eb.$emit('activeTabUrl', x);
        console.dir(x);
        let shareUrl = ctrl.$shareUrl();
        navigator.clipboard.writeText(shareUrl);
        ctrl.$toast('share url : ' + shareUrl);
    }
});
