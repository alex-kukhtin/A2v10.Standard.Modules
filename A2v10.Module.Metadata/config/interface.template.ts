
const template: Template = {
	properties: {
		'TRoot.$$Tab': String,
	},
	validators: {
		'Interface.Name': `@[Error.Required]`,
		'Interface.Sections[].Name': `@[Error.Required]`,
		'Interface.Sections[].MenuItems[].Name': `@[Error.Required]`,
		'Interface.Sections[].MenuItems[].Url': `@[Error.Required]`
	},
	events: {
		'Model.saved': modelSaved,
	},
	commands: {
		browseUrl
	}
};

export default template;

function modelSaved() {
	const ctrl: IController = this.$ctrl;
	ctrl.$emitCaller('ch.table.saved', this.Interface);
}

async function browseUrl(elem) {
	const ctrl: IController = this.$ctrl;
	let ep = await ctrl.$showDialog('/$meta/config/endpoint/browse');
	elem.Url = ep.Endpoint;
	elem.Name = ep.Name;
}