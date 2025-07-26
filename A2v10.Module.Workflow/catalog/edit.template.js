define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    let modeler;
    let commandStack;
    const template = {
        properties: {
            'TRoot.$CanUndo': Boolean,
            'TRoot.$CanRedo': Boolean
        },
        options: {},
        events: {
            'Model.load': modelLoad
        },
        commands: {
            save() { },
            undo: {
                exec() { commandStack ? commandStack.undo() : null; },
                canExec() { return this.$CanUndo; }
            },
            redo: {
                exec() { commandStack ? commandStack.redo() : null; },
                canExec() { return this.$CanRedo; }
            },
            togglePanel() { },
            checkSyntax
        }
    };
    exports.default = template;
    async function modelLoad() {
        let ctrl = this.$ctrl;
        let allCanvas = this.$vm.$el.getElementsByClassName('bpmn-canvas');
        if (allCanvas.length < 1)
            return;
        let allPropPanels = this.$vm.$el.getElementsByClassName('bpmn-props-panel');
        if (allPropPanels.length < 1)
            return;
        let canvas = allCanvas[0];
        let propPanel = allPropPanels[0];
        let assets = new window.BpmnAssets();
        modeler = assets.createModeler(canvas, propPanel);
        assets.registerDropZone(canvas.parentElement, async ({ xml, name }) => {
            this.Workflow.Body = xml;
            this.Workflow.Name = (name || 'Untitiled').replace('.bpmn', '');
            await modeler.importXML(this.Workflow.Body);
        });
        commandStack = modeler.get("commandStack");
        let eventBus = modeler.get("eventBus");
        let editorActions = modeler.get("editorActions");
        eventBus.on('keyboard.keydown', (ctx) => {
            let ev = ctx.keyEvent;
            if (!ev.ctrlKey && !ev.metaKey)
                return;
            switch (ev.code) {
                case 'KeyC':
                    editorActions.trigger('copy');
                    ev.preventDefault();
                    return true;
                case 'KeyV':
                    editorActions.trigger('paste');
                    ev.preventDefault();
                    return true;
                case 'KeyZ':
                    editorActions.trigger('undo');
                    ev.preventDefault();
                    return true;
                case 'KeyY':
                    editorActions.trigger('redo');
                    ev.preventDefault();
                    return true;
            }
        });
        if (this.Workflow.$isNew)
            ctrl.$nodirty(async () => {
                this.Workflow.Name = "Untitled";
                this.Workflow.Body = assets.defaultXml;
            });
        if (!this.Workflow.Body)
            await modeler.importXML(assets.defaultXml);
        else
            await modeler.importXML(this.Workflow.Body);
        modeler.on('commandStack.changed', (ev) => {
            this.$CanUndo = commandStack.canUndo();
            this.$CanRedo = commandStack.canRedo();
            this.$setDirty(true);
        });
        template.commands.togglePanel = () => { propPanel.classList.toggle('open'); };
        template.commands.save = {
            canExec() { return this.$dirty; },
            async exec() {
                let ctrl = this.$ctrl;
                let { xml, svg, zoom } = await assets.saveXmlAndSvg(modeler);
                this.Workflow.Body = xml;
                this.Workflow.Svg = svg;
                this.Workflow.Zoom = Math.ceil(zoom * 100) / 100;
                await ctrl.$save();
                ctrl.$nodirty(async () => {
                    this.Workflow.Svg = svg;
                });
                ctrl.$emitGlobal('g.workflow.saved', this.Workflow);
            }
        };
    }
    async function checkSyntax() {
        const ctrl = this.$ctrl;
        let res = await ctrl.$invoke('checkSyntax', { WorkflowId: this.Workflow.Id }, '/$workflow/catalog');
        if (!res.Errors.length)
            ctrl.$msg('Помилок не знайдено', 'Перевірка синтаксису', "info");
        else
            ctrl.$alert({ msg: 'Знайдено помилки', list: res.Errors.map(e => `${e.Activity}: ${e.Message}`) });
    }
});
