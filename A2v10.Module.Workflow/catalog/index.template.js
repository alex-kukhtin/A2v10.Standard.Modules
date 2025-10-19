define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        options: {
            noDirty: true,
            persistSelect: ["Workflows"]
        },
        properties: {
            'TWorkflow.$Mark'() { return this.Archive ? 'red' : this.NeedPublish ? 'warning' : ''; },
            'TWorkflow.$PopupStyle'() { return `zoom: ${this.Zoom};`; },
        },
        events: {
            'g.workflow.saved': handleSaved,
            'g.workflow.props': handleProps
        },
        commands: {
            publish: {
                exec: publish,
                canExec: a => a.NeedPublish
            },
            start: {
                exec: start,
                canExec: a => !a.NeedPublish
            },
            download,
            upload,
            delete: {
                exec: deleteWorkflow,
                canExec: wf => !wf.Version,
                confirm: '@[Confirm.Delete.Element]'
            },
            backup,
            restore,
            copy
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
    function handleProps(root) {
        let wf = root.Workflow;
        let f = this.Workflows.$find(w => w.Id === wf.Id);
        if (!f)
            return;
        f.Name = wf.Name;
        f.Memo = wf.Memo;
        f.Key = wf.Key;
        f.Archive = wf.Archive;
    }
    async function publish(wf) {
        const ctrl = this.$ctrl;
        let res = await ctrl.$invoke('publish', { WorkflowId: wf.Id }, '/$workflow/catalog');
        ctrl.$toast(`@[WfAdm.Published]. @[Version]: ${res.Version}`, "success");
        ctrl.$reload();
    }
    async function start(wf) {
        const ctrl = this.$ctrl;
        if (wf.NeedPublish)
            return;
        ctrl.$showDialog('/$workflow/catalog/run', wf);
    }
    async function download(wf) {
        const ctrl = this.$ctrl;
        await ctrl.$file('/$workflow/catalog/download', { Id: wf.Id }, { action: "download" }, { export: true });
    }
    async function upload() {
        const ctrl = this.$ctrl;
        let nw = await ctrl.$upload('/$workflow/catalog/upload');
        await ctrl.$reload();
        let found = this.Workflows.$find(w => w.Id === nw.Id);
        if (found) {
            found.$select();
            ctrl.$navigate('/$workflow/catalog/edit', { Id: found.Id });
        }
    }
    async function deleteWorkflow(wf) {
        const ctrl = this.$ctrl;
        await ctrl.$invoke('delete', { Id: wf.Id }, '/$workflow/catalog');
        wf.$remove();
    }
    async function backup() {
        const ctrl = this.$ctrl;
        var worflows = await ctrl.$showDialog('/$workflow/catalog/choose', null);
        if (!worflows || !worflows.length)
            return;
        let ids = worflows.map(w => w.Id).join('\v');
        await ctrl.$file('/$workflow/catalog/backup', { Id: 0 }, { action: "download" }, { Ids: ids });
    }
    async function restore() {
        const ctrl = this.$ctrl;
        await ctrl.$upload('/$workflow/catalog/restore', 'application/zip');
        ctrl.$reload();
    }
    async function copy(wf) {
        const ctrl = this.$ctrl;
        let np = await ctrl.$invoke('copy', { Id: wf.Id }, '/$workflow/catalog');
        this.Workflows.$append(np.Workflow);
    }
});
