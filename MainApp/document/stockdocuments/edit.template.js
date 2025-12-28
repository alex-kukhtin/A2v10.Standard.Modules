define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const du = require('std:utils').date;
    const template = {
        options: {
            globalSaveEvent: 'g.document.saved'
        },
        properties: {
            'TDocument.$$Tab': { type: String, value: 'Stock' },
            'TDocument.Name'() { return `${this.Operation.Name} № ${this.Number} від ${this.Date.toLocaleDateString()}`; },
            'TDocument.Sum'() { return this.Stock.Sum + this.Service.Sum; },
            'TRow.Sum'() { return this.Price * this.Qty; },
            'TRowArray.Sum'() { return this.$sum(c => c.Sum); },
            'TRowArray.XVat': {
                get() { return this.$sum(r => r.Sum); },
                set(val) { this.Count; }
            }
        },
        defaults: {
            'Document.Date'() { return du.today(); }
        },
        events: {
            'Document.Operation.changing': (newValue, oldValue) => false,
        },
        validators: {
            'Document.Rows[].VatRate': `@[Error.Required]`,
            'Document.Rows[].Qty': `@[Error.Required]`,
            'Document.Rows[].Price': `@[Error.Required]`,
            'Document': ["dddd", () => ""]
        },
        commands: {
            apply,
            unApply
        }
    };
    exports.default = template;
    async function apply() {
        const ctrl = this.$ctrl;
        await ctrl.$invoke('apply', { Id: this.Document.Id }, '/document/stockdocuments');
        this.Document.Done = true;
        ctrl.$emitGlobal('g.document.applied', this);
        ctrl.$requery();
    }
    async function unApply() {
        const ctrl = this.$ctrl;
        await ctrl.$invoke('unapply', { Id: this.Document.Id }, '/document/stockdocuments');
        this.Document.Done = false;
        ctrl.$emitGlobal('g.document.applied', this);
        ctrl.$requery();
    }
});
