//testpdf.template

const template: Template = {
	options: {
		persistSelect: ["Agents"]
	},
	properties: {
		'TRoot.$ExportArg': exportArgument,
	}
};

export default template;

function exportArgument() {
	let fi = this.Agents.$ModelInfo.Filter;
	return { Period: fi.Period, Fragment: fi.Fragment };
}

