// workflow/catalog/edit.template

declare var window;

let modeler;
let commandStack;

const template: Template = {
	properties: {
		'TRoot.$CanUndo': Boolean,
		'TRoot.$CanRedo': Boolean
	},
	options: {
	},
	events: {
		'Model.load': modelLoad
	},
	commands: {
		save() { },
		undo: {
			exec() { commandStack ? commandStack.undo() : null },
			canExec(this: any) { return this.$CanUndo; }
		},
		redo: {
			exec() { commandStack ? commandStack.redo() : null },
			canExec(this: any) { return this.$CanRedo; }
		},
		togglePanel() { },
		checkSyntax
	}
};

export default template;

async function modelLoad() {

	let ctrl: IController = this.$ctrl;

	let allCanvas = this.$vm.$el.getElementsByClassName('bpmn-canvas');
	if (allCanvas.length < 1) return;

	let allPropPanels = this.$vm.$el.getElementsByClassName('bpmn-props-panel');
	if (allPropPanels.length < 1) return;

	let canvas = allCanvas[0];
	let propPanel = allPropPanels[0];

	let assets = new window.BpmnAssets();
	modeler = assets.createModeler(canvas, propPanel);

	assets.registerDropZone(canvas.parentElement, async ({ xml, name }) => {
		this.Workflow.Body = xml;
		this.Workflow.Name = (name || 'Untitiled').replace('.bpmn', '');
		await modeler.importXML(this.Workflow.Body);
	})

	commandStack = modeler.get("commandStack");

	if (this.Workflow.$isNew)
		ctrl.$nodirty(async () => {
			this.Workflow.Name = "Untitled";
			this.Workflow.Body = assets.defaultXml;
		});

	if (!this.Workflow.Body)
		await modeler.importXML(assets.defaultXml);
	else
		await modeler.importXML(this.Workflow.Body);

	modeler.on('commandStack.changed', (ev) => {
		this.$CanUndo = commandStack.canUndo();
		this.$CanRedo = commandStack.canRedo();
		this.$setDirty(true);
	});


	// save commands
	template.commands.togglePanel = () => { propPanel.classList.toggle('open') };

	template.commands.save = {
		canExec() { return this.$dirty },
		async exec(this: any) {
			let ctrl: IController = this.$ctrl;

			let { xml, svg, zoom } = await assets.saveXmlAndSvg(modeler);

			this.Workflow.Body = xml;
			this.Workflow.Svg = svg;
			this.Workflow.Zoom = Math.ceil(zoom * 100) / 100;

			await ctrl.$save();
			ctrl.$nodirty(async () => {
				this.Workflow.Svg = svg; // for preview in index
			})
			ctrl.$emitGlobal('g.workflow.saved', this.Workflow);

		}
	}
}

async function checkSyntax() {
	const ctrl: IController = this.$ctrl;
	let res = await ctrl.$invoke('checkSyntax', { WorkflowId: this.Workflow.Id }, '/$workflow/catalog');
	if (!res.Errors.length)
		ctrl.$msg('Помилок не знайдено', 'Перевірка синтаксису', CommonStyle.info);
	else
		ctrl.$alert({ msg: 'Знайдено помилки', list: res.Errors.map(e => `${e.Activity}: ${e.Message}`) });
}


