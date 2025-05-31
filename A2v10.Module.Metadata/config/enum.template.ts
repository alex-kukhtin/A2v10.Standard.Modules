
const template: Template = {
	properties: {
		'TRoot.$$Tab': String,
		'TEnumItem.$LabelPlaceholder'() { return this.Name ? `@${this.Name}` : ''; }
	},
	commands: {
	},
	validators: {
		'Table.Items[].Name': "@[Error.Required]"
	},
	events: {
		'Model.saved': modelSaved
	}
};

export default template;

function modelSaved() {
	const ctrl: IController = this.$ctrl;
	ctrl.$emitCaller('ch.table.saved', this.Table);
}

