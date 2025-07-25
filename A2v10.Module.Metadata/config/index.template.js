define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const BASE_URL = '/$meta/config';
    const template = {
        properties: {
            'TRoot.$PartUrl': partUrl,
            'TElem.$Icon': itemIcon
        },
        commands: {
            addItem,
            addDetails: {
                canExec: canAddDetails,
                exec: addDetails
            },
            deleteItem: {
                exec: deleteItem,
                canExec(arg) { return !arg.IsFolder && arg.Kind != 'app'; },
                confirm: 'Are you sure?'
            },
            copy: {
                exec: copy,
                canExec: canCopy
            },
            exportApp,
            importApp
        },
        events: {
            'ch.table.saved': tableSaved
        }
    };
    exports.default = template;
    function schema2url(schema) {
        switch (schema) {
            case 'app': return 'application';
            case 'doc': return 'document';
            case 'cat': return 'catalog';
            case 'jrn': return 'journal';
            case 'rep': return 'report';
            case 'op': return 'operation';
            case 'enm': return 'enum';
            case 'acc': return 'account';
            case 'regi': return 'reginfo';
            case 'ui': return 'interface';
        }
    }
    function itemIcon() {
        if (this.IsFolder)
            return 'folder-outline';
        switch (this.Schema) {
            case 'cat':
            case 'doc': return 'table';
            case 'rep': return 'report';
            case 'jrn': return 'log';
            case 'form': return 'storyboard';
            case 'app': return 'devices';
            case 'enm': return 'list';
            case 'op': return 'account';
            case 'acc': return 'account-folder';
            case 'regi': return 'table';
            case 'ui': return 'devices';
        }
        return 'undefined';
    }
    async function addItem(arg) {
        const ctrl = this.$ctrl;
        let sp = arg.split('.');
        let f = this.Elems.find(x => x.Schema === sp[0]);
        if (!f)
            return;
        f.$expand(true);
        let name = `${sp[1]}${f.Items.length + 1}`;
        let result = await ctrl.$invoke('createItem', { Parent: f.Id, Schema: sp[0], Name: name, Kind: sp[2] }, BASE_URL);
        console.dir(result);
        f.Items.$append(result.Elem);
    }
    function canAddDetails() {
        let f = this.Elems.$selected;
        if (!f)
            return false;
        return f.Kind === 'table' && (f.Schema === 'cat' || f.Schema === 'doc');
    }
    async function addDetails() {
        const ctrl = this.$ctrl;
        let f = this.Elems.$selected;
        if (!f)
            return;
        if (f.IsFolder)
            return;
        f.$expand();
        let name = `Details${f.Items.length + 1}`;
        let result = await ctrl.$invoke('createItem', { Parent: f.Id, Schema: f.Schema, Name: name, Kind: 'details' }, BASE_URL);
        console.dir(result);
        f.Items.$append(result.Elem);
    }
    function partUrl() {
        let sel = this.Elems.$selected;
        if (!sel)
            return undefined;
        if (sel.IsFolder && sel.Schema === 'op')
            return `/$meta/config/optable/${sel.Id}`;
        if (sel.IsFolder)
            return undefined;
        return `/$meta/config/${schema2url(sel.Schema)}/${sel.Id}`;
    }
    function tableSaved(table) {
        const ctrl = this.$ctrl;
        let xt = this.Elems.$find(x => x.Id === table.Id);
        if (!xt)
            return;
        xt.Name = table.Name;
        ctrl.$invoke('clearCache', { Schema: xt.Schema, Table: xt.Name }, BASE_URL);
        let pt = table.ParentElem;
        if (pt && pt.Schema)
            ctrl.$invoke('clearCache', { Schema: pt.Schema, Table: pt.Name }, BASE_URL);
    }
    async function deleteItem(item) {
        const ctrl = this.$ctrl;
        await ctrl.$invoke('deleteItem', { Id: item.Id }, BASE_URL);
        item.$remove();
    }
    async function exportApp() {
        const ctrl = this.$ctrl;
        await ctrl.$file('/$meta/config/export', null, { action: "download" });
        ctrl.$toast('Application exported successfully', "success");
    }
    async function importApp() {
        const ctrl = this.$ctrl;
        await ctrl.$upload('/$meta/config/import', 'application/zip');
        await ctrl.$msg('Application imported successfully', "success");
        ctrl.$requery();
    }
    function canCopy() {
        let sel = this.Elems.$selected;
        if (!sel)
            return false;
        if (sel.IsFolder || sel.Kind === 'app')
            return false;
        return true;
    }
    async function copy() {
        if (!canCopy.call(this))
            return;
        let sel = this.Elems.$selected;
        const ctrl = this.$ctrl;
        let res = await ctrl.$invoke('copyItem', { Id: sel.Id }, BASE_URL);
        if (!res)
            return;
        alert('Copy is not implemented yet');
    }
});
