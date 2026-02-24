
import { TRoot, TAgent, TAgentArray, TStore } from './index';

const eb: EventBus = require('std:eventBus');

const template: Template = {
    options: {
        persistSelect: ['Agents']
    },
    commands: {
        shareUrl
    }
};

export default template;


function shareUrl() {
    let x = { url: '' };
    let ctrl: any = this.$ctrl;
    eb.$emit('activeTabUrl', x);
    console.dir(x);

    let shareUrl = ctrl.$shareUrl();
    navigator.clipboard.writeText(shareUrl);
    ctrl.$toast('share url : ' + shareUrl);
}