define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        options: {
            persistSelect: ['Documents']
        },
        events: {
            'g.document.saved': handleSaved,
            'g.document.applied': handleApply
        }
    };
    exports.default = template;
    function handleApply(elem) {
        let doc = elem.Document;
        let found = this.Documents.find(d => d.Id == doc.Id);
        if (!found)
            return;
        found.Done = doc.Done;
    }
    function handleSaved(elem) {
        let doc = elem.Document;
        let found = this.Documents.$find(d => d.Id === doc.Id);
        if (found)
            found.$merge(doc).$select();
    }
});
