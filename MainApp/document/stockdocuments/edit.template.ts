
import { TRoot, TDocument, TOperation, TAgent, TStore, TRow, TRowArray } from './edit';

const du: UtilsDate = require('std:utils').date;
const template: Template = {
    options: {
        globalSaveEvent: 'g.document.saved'
    },
    properties: {
        'TDocument.$$Tab': {type: String, value: 'Stock'},
		'TDocument.Name'(this: TDocument) { return `${this.Operation.Name} № ${this.Number} від ${this.Date.toLocaleDateString()}`;},
		'TDocument.Sum'(this: TDocument) { return this.Stock.Sum + this.Service.Sum;},
        'TRow.Sum'(this: TRow) { return this.Price * this.Qty; },
        'TRowArray.Sum'(this: TRowArray) { return this.$sum(c => c.Sum); }
    },
    defaults: {
        'Document.Date'() { return du.today(); }
    },
    validators: {
        'Document.Rows[].VatRate': `@[Error.Required]`,
		'Document.Rows[].Qty': `@[Error.Required]`,
		'Document.Rows[].Price': `@[Error.Required]`
    },
    commands: {
        apply,
        unApply
    }
};

export default template;

async function apply(this: TRoot) {
    const ctrl: IController = this.$ctrl;
    await ctrl.$invoke('apply', {Id: this.Document.Id}, '/document/stockdocuments');
	this.Document.Done = true;
    ctrl.$emitGlobal('g.document.applied', this);
    ctrl.$requery();
}

async function unApply(this: TRoot) {
    const ctrl: IController = this.$ctrl;
    await ctrl.$invoke('unapply', {Id: this.Document.Id}, '/document/stockdocuments');
	this.Document.Done = false;
    ctrl.$emitGlobal('g.document.applied', this);
    ctrl.$requery();
}