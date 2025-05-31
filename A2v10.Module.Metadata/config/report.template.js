define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        properties: {
            'TRoot.$$Tab': String,
            'TRepItem.$LabelPlaceholder'() { return `@${this.Column.Field}`; }
        },
        validators: {
            'Table.ParentTable': "@[Error.Required]",
            'Table.Type': "@[Error.Required]"
        },
        events: {
            'Model.saved': modelSaved
        },
        commands: {
            preview,
            addGrouping,
            addFilter,
            addData
        }
    };
    exports.default = template;
    function modelSaved() {
        const ctrl = this.$ctrl;
        ctrl.$emitCaller('ch.table.saved', this.Table);
    }
    function preview() {
        const ctrl = this.$ctrl;
        ctrl.$navigate(`/${this.Table.Endpoint}/report`, { Id: '{genrandom}' });
    }
    function addColumns(src, target, checked) {
        src.forEach(item => {
            if (!target.some(c => c.Column.Id === item.Id))
                target.$append({ Column: item, Checked: checked });
        });
    }
    async function addGrouping() {
        const ctrl = this.$ctrl;
        let res = await ctrl.$showDialog('/$meta/config/journal/browsefield', null, { Journal: this.Table.ParentTable.Id, Kind: 'G' });
        addColumns(res, this.Table.Grouping, true);
    }
    async function addFilter() {
        const ctrl = this.$ctrl;
        let res = await ctrl.$showDialog('/$meta/config/journal/browsefield', null, { Journal: this.Table.ParentTable.Id, Kind: 'F' });
        addColumns(res, this.Table.Filters, false);
    }
    async function addData() {
        const ctrl = this.$ctrl;
        let res = await ctrl.$showDialog('/$meta/config/journal/browsefield', null, { Journal: this.Table.ParentTable.Id, Kind: 'D' });
        addColumns(res, this.Table.Data, true);
    }
});
