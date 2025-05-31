
const template: Template = {
	properties: {
		'TRoot.$$Tab': String,
		'TRoot.$Forms': formsArray,
		'TApply.$DetailsArg'() { return { Details: this.Details.Id }; }
	},
	validators: {
		'Table.ParentTable': "@[Error.Required]",
		'Table.Apply[].Journal': "@[Error.Required]"
	},
	events: {
		'Model.saved': modelSaved,
		'Table.Apply[].add': (arr, e) => { e.InOut = 1; },
		'Table.Apply[].Details.change': (a) => { a.Kind.$empty(); }
	},
	commands: {
		preview,
		openForm,
		showMapping
	}
};

export default template;

function modelSaved() {
	const ctrl: IController = this.$ctrl;
	ctrl.$emitCaller('ch.table.saved', this.Table);
}

function formsArray() {
	return [
		{ Name: 'Index', Value: 'index' },
		{ Name: 'Edit Element', Value: 'edit' }
	];
}

function openForm(arg) {
	const ctrl: IController = this.$ctrl;
	ctrl.$navigate(`/$meta/config/form`, { Id: this.Table.Id, Form: arg });
}

function preview() {
	const ctrl: IController = this.$ctrl;
	// TODO: disable if not deployed;
	ctrl.$navigate(`/${this.Table.Endpoint}/index`, { Id: 0 });
}

async function showMapping(apply) {
	const ctrl: IController = this.$ctrl;
	let url = '/$meta/config/mapping';

	if (!apply.Journal.Id) {
		ctrl.$alert('@[Error.SelectJournalFirst]');
		return;
	}

	if (!apply.Id) {
		let index = this.Table.Apply.indexOf(apply);
		if (index < 0)
			return;
		await ctrl.$save();
		apply = this.Table.Apply[index];
	}
	await ctrl.$save();
	ctrl.$showDialog(url, { Id: apply.Id });
}