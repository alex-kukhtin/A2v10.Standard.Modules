define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        validators: {
            'Workflow.Key': { valid: checkDuplicate, async: true, msg: '@[WfAfm.Error.DuplicateKey]' }
        }
    };
    exports.default = template;
    async function checkDuplicate(wf, text) {
        if (!text)
            return true;
        const ctrl = wf.$ctrl;
        return ctrl.$asyncValid('checkDuplicateKey', { Id: wf.Id, Text: text });
    }
});
