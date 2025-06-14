define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        commands: {
            runProcess
        }
    };
    exports.default = template;
    async function runProcess() {
        const ctrl = this.$ctrl;
        const wf = this.Workflow;
        let args = wf.Arguments.reduce((acc, arg) => {
            acc[arg.Name] = arg.Value;
            return acc;
        }, {});
        try {
            let res = await ctrl.$invoke('start', { WorkflowId: wf.Id, CorrelationId: wf.CorrelationId, Args: args }, '/$workflow/catalog', { catchError: true });
            let resMsg = `InstanceId: ${res.InstanceId}, Result: ${JSON.stringify(res.Result)}`;
            await ctrl.$msg(resMsg, "Result", "info");
            ctrl.$modalClose(res);
        }
        catch (err) {
            await ctrl.$alert(err);
            ctrl.$modalClose();
        }
    }
});
