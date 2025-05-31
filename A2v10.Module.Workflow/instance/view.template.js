define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        properties: {
            'TRoot.$ActiveName': String,
            'TRoot.$ActiveId': String,
            'TRoot.$ActiveLog': activeLog
        },
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
        let eventBus = viewer.get('eventBus');
        eventBus.on('element.click', (ev) => {
            let el = ev.element;
            if (!el)
                return;
            let bo = el.businessObject;
            if (bo) {
                this.$root.$ActiveId = bo.id;
                this.$root.$ActiveName = bo.name || bo.id;
            }
            else {
                this.$root.$ActiveName = '';
                this.$root.$ActiveId = '';
            }
        });
        let arr = this.Instance.Track.map((x, i, a) => { return { idle: x.IsIdle, activity: registry.get(x.Activity) }; });
        arr.forEach(act => {
            modl.setColor(act.activity, {
                fill: act.idle ? '#e0f6de' : '#defbff',
                stroke: act.idle ? '#4e995a' : '#1E90FF'
            });
        });
    }
    const activityMap = "Schedule,Execute,Bookmark,Resume,Event,HandleEvent,HandleMessage,Inbox".split(',');
    function activeLog() {
        if (!this.$ActiveId)
            return [];
        return this.Instance.FullTrack
            .filter(x => x.Id === this.$ActiveId)
            .map(x => {
            let actionName = x.Action === 999 ? 'Exception' : activityMap[x.Action] || 'Unknown';
            return {
                Action: actionName,
                Time: x.EventTime,
                Message: x.Message || '',
            };
        });
    }
});
