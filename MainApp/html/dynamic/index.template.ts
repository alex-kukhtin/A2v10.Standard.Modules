//testpdf.template

const template: Template = {
	options: {
		noDirty: true
	},
	properties: {
		'TRoot.$Text': String
	},
	commands: {
		setHtml,
	},
	delegates: {
		testClick
	}
};

export default template;

function setHtml() {
	this.$Text = `Текст з <a href="" data-info='{"action": "report", "id": 77}'>прикладом посилання</a>`
}

function testClick(elem: HTMLElement, name) {
	console.log('delegate', this.$ctrl, elem, name);
	console.log(JSON.parse(elem.dataset.info));
}