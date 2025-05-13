define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        options: {
            noDirty: true,
            persistSelect: ["Workflows"]
        },
        properties: {
            'TWorkflow.$Mark'() { return this.NeedPublish ? 'warning' : ''; },
        },
        events: {
            'g.workflow.saved': handleSaved
        },
        commands: {
            publish,
            start,
            startWorkflow
        }
    };
    exports.default = template;
    function handleSaved(wf) {
        let f = this.Workflows.$find(w => w.Id === wf.Id);
        if (f)
            f.$merge(wf);
        else
            this.Workflows.$prepend(wf);
    }
    async function publish(wf) {
        const ctrl = this.$ctrl;
        let res = await ctrl.$invoke('publish', { WorkflowId: wf.Id }, '/$workflow/catalog');
        ctrl.$toast(`@[Published]. @[Version]: ${res.Version}`, "success");
        ctrl.$reload();
    }
    async function start(wf) {
        const ctrl = this.$ctrl;
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
    }
});
