define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        options: {
            noDirty: true,
            persistSelect: ["Instances"]
        },
        events: {},
        commands: {
            resume,
            resumeBookmark,
            unlock: {
                exec: unlock,
                canExec: (inst) => !!inst.Lock
            }
        }
    };
    exports.default = template;
    async function resume(inbox) {
        const ctrl = this.$ctrl;
        let res = await ctrl.$invoke('resume', {
            InstanceId: inbox.Instance,
            Bookmark: inbox.Bookmark,
            Reply: {
                Answer: this.Answer.Answer
            }
        }, '/$workflow/instance');
        let resMsg = `InstanceId: ${res.InstanceId}, Result: ${JSON.stringify(res.Result)}`;
        ctrl.$msg(resMsg, "Result", "info");
        ctrl.$reload();
    }
    async function resumeBookmark(bookmark) {
        const ctrl = this.$ctrl;
        let res = await ctrl.$invoke('resume', {
            InstanceId: bookmark.Instance,
            Bookmark: bookmark.Bookmark
        }, '/$workflow/instance');
        let resMsg = `InstanceId: ${res.InstanceId}, Result: ${JSON.stringify(res.Result)}`;
        ctrl.$msg(resMsg, "Result", "info");
        ctrl.$reload();
    }
    async function unlock() {
        const ctrl = this.$ctrl;
        alert("Unlocking instance...");
    }
});
