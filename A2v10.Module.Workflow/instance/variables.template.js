define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        options: {},
        properties: {
            'TInstance.$Vars'() { return { Variables: this.State.Variables, LastResult: this.State.LastResult }; }
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
    async function unlock(inst) {
        const ctrl = this.$ctrl;
        await ctrl.$invoke('unlock', { Id: inst.Id }, '/$workflow/instance');
        inst.Lock = '';
        inst.LockDate = null;
    }
    async function start() {
        const ctrl = this.$ctrl;
        var wf = await ctrl.$showDialog('/$workflow/catalog/browse');
        if (!wf)
            return;
        this.StartWorkflow = wf;
        if (wf.Arguments.length) {
            ctrl.$inlineOpen('args');
            return;
        }
        startWorkflow.call(this, wf);
    }
    async function startWorkflow(wf) {
        const ctrl = this.$ctrl;
        let args = wf.Arguments.reduce((acc, arg) => {
            acc[arg.Name] = arg.Value;
            return acc;
        }, {});
        let res = await ctrl.$invoke('start', { WorkflowId: wf.Id, Args: args }, '/$workflow/catalog');
        ctrl.$inlineClose('args');
        let resMsg = `InstanceId: ${res.InstanceId}, Result: ${JSON.stringify(res.Result)}`;
        ctrl.$msg(resMsg, "Result", "info");
        await ctrl.$reload();
        var f = this.Instances.$find(i => i.Id === res.InstanceId);
        if (f)
            f.$select();
    }
});
