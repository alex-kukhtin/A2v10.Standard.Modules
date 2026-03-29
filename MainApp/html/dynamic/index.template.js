"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const template = {
    options: {
        noDirty: true
    },
    properties: {
        'TRoot.$Text': String
    },
    commands: {
        setHtml,
    },
    delegates: {
        testClick
    }
};
exports.default = template;
function setHtml() {
    this.$Text = `Текст з <a href="" data-info='{"action": "report", "id": 77}'>прикладом посилання</a>`;
}
function testClick(elem, name) {
    console.log('delegate', this.$ctrl, elem, name);
    console.log(JSON.parse(elem.dataset.info));
}
