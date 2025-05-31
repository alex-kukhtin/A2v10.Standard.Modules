define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        properties: {
            'TRoot.$$Tab': String,
            'TEnumItem.$LabelPlaceholder'() { return this.Name ? `@${this.Name}` : ''; }
        },
        commands: {},
        validators: {
            'Table.Items[].Name': "@[Error.Required]"
        },
        events: {
            'Model.saved': modelSaved
        }
    };
    exports.default = template;
    function modelSaved() {
        const ctrl = this.$ctrl;
        ctrl.$emitCaller('ch.table.saved', this.Table);
    }
});
