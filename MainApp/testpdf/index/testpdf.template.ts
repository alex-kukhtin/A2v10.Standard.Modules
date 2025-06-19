//testpdf.template

const template: Template = {
	properties: {
		'TRoot.$ReportUrl': reportUrl,
		'TRoot.$Number': Number
	}
};

export default template;

function reportUrl() {
	return '/report/show/55?base=/testpdf/index&rep=testpdf';
}

