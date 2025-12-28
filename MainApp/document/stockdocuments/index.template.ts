
import { TRoot, TDocument, TDocumentArray, TOperation, TAgent, TStore } from './index';

const template: Template = {
    options: {
        persistSelect: ['Documents']
    },
    events: {
        'g.document.saved': handleSaved,
		'g.document.applied': handleApply
    }
};

export default template;

function handleApply(elem: TRoot) {
    let doc = elem.Document;
    let found = this.Documents.find(d => d.Id == doc.Id);
    if (!found) return;
    found.Done = doc.Done;
}
function handleSaved(elem : TItemRoot) {
    let doc = elem.Document;
    let found = this.Documents.$find(d => d.Id === doc.Id);
    if (found)
        found.$merge(doc).$select();
}