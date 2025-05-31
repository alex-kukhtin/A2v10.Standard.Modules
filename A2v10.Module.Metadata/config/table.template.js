define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    function singular(text) {
        if (!text)
            return '';
        if (text.endsWith('ies'))
            return text.substring(0, text.length - 3) + 'y';
        else if (text.endsWith('es'))
            return text.substring(0, text.length - 2);
        else if (text.endsWith('s'))
            return text.substring(0, text.length - 1);
        return text;
    }
    const ROLE_PK = 1;
    const ROLE_NAME = 2;
    const ROLE_CODE = 4;
    const ROLE_ROWNO = 8;
    const ROLE_VOID = 16;
    const ROLE_PARENT = 32;
    const ROLE_ISFOLDER = 64;
    const ROLE_ISYSTEM = 128;
    const ROLE_DONE = 256;
    const ROLE_KIND = 512;
    const ROLE_OWNER = 1024;
    const ROLE_NUMBER = 2048;
    function normalColumn(column) {
        const flag = ROLE_PK | ROLE_PARENT | ROLE_ISFOLDER | ROLE_ISYSTEM
            | ROLE_VOID | ROLE_DONE | ROLE_OWNER | ROLE_KIND | ROLE_ROWNO;
        return (column.Role & flag) === 0;
    }
    const template = {
        properties: {
            'TRoot.$$Tab': String,
            'TTable.$HasApply'() { return false; },
            'TTable.$HasForms'() { return (this.Schema === 'doc' || this.Schema === 'cat' || this.Schema === 'jrn') && this.Kind === 'table'; },
            'TTable.$HasKinds'() { return this.Schema === 'doc' && this.Kind === 'details'; },
            'TTable.$IsDetails'() { return this.Kind === 'details'; },
            'TTable.$HasUseFolders'() { return this.Schema === 'cat'; },
            'TTable.$HasPreview'() { return this.Kind === 'table'; },
            'TTable.$HasGenerate'() { return this.Kind === 'table'; },
            'TTable.$ItemPlaceholder'() { return singular(this.ItemsName ? this.ItemsName : this.Name); },
            'TTable.$TypePlaceholder'() { return this.ItemName ? `T${this.ItemName}` : `T${this.$ItemPlaceholder}`; },
            'TTable.$ItemsLabelPlaceholder'() { return this.ItemsName ? `@${this.ItemsName}` : `@${this.Name}`; },
            'TTable.$ItemLabelPlaceholder'() { return `@${this.ItemName || this.$ItemPlaceholder}`; },
            'TTable.$OtherColumns'() { return this.Columns.filter(normalColumn); },
            'TColumn.$LabelPlaceholder'() { return `@${this.Name}`; },
            'TColumn.$HasLength'() { return this.DataType === 'string'; },
            'TColumn.$IsReference'() { return this.DataType === 'reference' || this.DataType === 'enum'; },
            'TColumn.$ReferenceData'() { return { DataType: this.DataType }; },
            'TColumn.$DataTypeDisabled': dataTypeDisabled,
            'TKind.$LabelPlaceholder'() { return `@${this.Name}`; },
            'TRoot.$Forms': formsArray
        },
        events: {
            'Table.Columns[].add': columnAdd,
            'Table.Columns[].DataType.change': dataTypeChange,
            'Table.Columns[].Role.change': roleChange,
            'Table.UseFolders.change': useFoldersChange,
            'Model.saved': modelSaved
        },
        validators: {
            'Table.Kinds[].Name': 'The Name is required',
            'Table.Columns[].Name': 'The Name is required',
        },
        commands: {
            preview,
            generate,
            openForm,
            moveUp: {
                exec(itm) { itm.$move('up'); },
                canExec(itm) { return itm.$canMove('up'); }
            },
            moveDown: {
                exec(itm) { itm.$move('down'); },
                canExec(itm) { return itm.$canMove('down'); }
            }
        }
    };
    exports.default = template;
    function formsArray() {
        return [
            { Name: 'Index', Value: 'index' },
            { Name: 'Edit Element', Value: 'edit' },
            { Name: 'Edit Folder', Value: 'editfolder' },
            { Name: 'Browse Element', Value: 'browse' },
            { Name: 'Browse Folder', Value: 'browsefolder' }
        ];
    }
    function columnAdd(arr, elem) {
        if (!elem.Name)
            elem.Name = `Field${arr.length}`;
        if (!elem.DataType)
            elem.DataType = "int";
    }
    function dataTypeChange(el, dt) {
        if (dt === 'string' && !el.MaxLength)
            el.MaxLength = 50;
    }
    function dataTypeDisabled() {
        let role = this.Role;
        return role === ROLE_ISFOLDER || role === ROLE_ISYSTEM
            || role === ROLE_VOID || role === ROLE_PK
            || role === ROLE_PARENT || role === ROLE_DONE
            || role === ROLE_OWNER || role === ROLE_ROWNO;
    }
    function roleChange(el, role) {
        if (role === ROLE_ISFOLDER || role === ROLE_ISYSTEM
            || role === ROLE_VOID || role === ROLE_DONE)
            el.DataType = 'bit';
        else if (role === ROLE_PK)
            el.DataType = 'id';
        else if (role === ROLE_PARENT || role === ROLE_OWNER)
            el.DataType = 'reference';
        else if (role === ROLE_ROWNO)
            el.DataType = 'int';
    }
    function useFoldersChange(table, useFolders) {
        let cols = table.Columns;
        if (useFolders) {
            if (!cols.some(c => c.Role === ROLE_ISFOLDER))
                cols.$append({ Name: 'IsFolder', Role: ROLE_ISFOLDER, DataType: 'bit' });
            if (!cols.some(c => c.Role === ROLE_PARENT)) {
                let pe = cols.$append({ Name: 'Parent', Role: ROLE_PARENT, DataType: 'reference' });
                pe.Reference.Id = table.Id;
                pe.Reference.Name = `Catalog.${table.Name}`;
            }
        }
        else {
            let isFolder = cols.filter(c => c.Role === ROLE_ISFOLDER);
            if (isFolder && isFolder.length)
                isFolder[0].$remove();
            let parentField = cols.filter(c => c.Role === ROLE_PARENT);
            if (parentField && parentField.length)
                parentField[0].$remove();
        }
    }
    function modelSaved() {
        const ctrl = this.$ctrl;
        ctrl.$emitCaller('ch.table.saved', this.Table);
    }
    function preview() {
        const ctrl = this.$ctrl;
        ctrl.$navigate(`/${this.Table.Endpoint}/index`, { Id: 0 });
    }
    async function generate() {
        const ctrl = this.$ctrl;
        await ctrl.$invoke('generate', { Schema: this.Table.Schema, Name: this.Table.Name }, '/$meta/config');
    }
    function openForm(arg) {
        const ctrl = this.$ctrl;
        ctrl.$navigate(`/$meta/config/form`, { Id: this.Table.Id, Form: arg });
    }
});
