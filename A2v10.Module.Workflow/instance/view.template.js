define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        properties: {},
        events: {
            'Model.load': modelLoad
        }
    };
    exports.default = template;
    async function modelLoad() {
        let ctrl = this.$ctrl;
        let allCanvas = this.$vm.$el.getElementsByClassName('bpmn-canvas');
        if (allCanvas.length < 1)
            return;
        let canvas = allCanvas[0];
        let assets = new window.BpmnAssets();
        let viewer = assets.createViewer(canvas);
        await viewer.importXML(this.Instance.Xml);
        let modl = viewer.get('modeling');
        let registry = viewer.get('elementRegistry');
        let complete = this.Instance.ExecutionStatus != 'Idle';
        let arr = this.Instance.Track.map((x, i, a) => { return { last: !complete && i == a.length - 1, activity: registry.get(x.Activity) }; });
        arr.forEach(act => {
            modl.setColor(act.activity, {
                fill: act.last ? '#e0f6de' : '#defbff',
                stroke: act.last ? '#4e995a' : '#1E90FF'
            });
        });
    }
});
