
const template: Template = {
	options: {
		noDirty: true,
		persistSelect: ["Workflows"]
	},
	properties: {
		'TWorkflow.$Mark'() { return this.NeedPublish ? 'warning' : ''; },
		'TWorkflow.$PopupStyle'() { return `zoom: ${this.Zoom};`; },
	},
	events: {
		'g.workflow.saved': handleSaved
	},
	commands: {
		publish: {
			exec: publish,
			canExec: a => a.NeedPublish
		},
		start: {
			exec: start,
			canExec: a => !a.NeedPublish
		},
		startWorkflow,
		download,
		upload,
		delete: {
			exec: deleteWorkflow,
			canExec: wf => !wf.Version,
			confirm: '@[Confirm.Delete.Element]'
		}
	}
}

export default template;


function handleSaved(wf) {
	let f = this.Workflows.$find(w => w.Id === wf.Id);
	if (f)
		f.$merge(wf);
	else
		this.Workflows.$prepend(wf);
}

async function publish(wf) {
	const ctrl: IController = this.$ctrl;
	let res = await ctrl.$invoke('publish', { WorkflowId: wf.Id }, '/$workflow/catalog');
	ctrl.$toast(`@[Published]. @[Version]: ${res.Version}`, CommonStyle.success);
	ctrl.$reload();
}

async function start(wf) {
	const ctrl: IController = this.$ctrl;
	if (wf.Arguments.length) {
		ctrl.$inlineOpen('args');
		return;
	}
	startWorkflow.call(this, wf);
}

async function startWorkflow(wf) {
	const ctrl: IController = this.$ctrl;
	let args = wf.Arguments.reduce((acc, arg) => {
		acc[arg.Name] = arg.Value;
		return acc;
	}, {});
	let res = await ctrl.$invoke('start', { WorkflowId: wf.Id, Args: args }, '/$workflow/catalog');
	ctrl.$inlineClose('args');
	let resMsg = `InstanceId: ${res.InstanceId}, Result: ${JSON.stringify(res.Result)}`;
	ctrl.$msg(resMsg, "Result", CommonStyle.info);
}

async function download(wf) {
	const ctrl: IController = this.$ctrl;
	await ctrl.$file('/$workflow/catalog/download',
		{ Id: wf.Id }, { action: FileActions.download }, { export: true });
}

async function upload() {
	const ctrl: IController = this.$ctrl;
	let nw = await ctrl.$upload('/$workflow/catalog/upload');
	await ctrl.$reload();
	let found = this.Workflows.$find(w => w.Id === nw.Id);
	if (found) {
		found.$select();
		ctrl.$navigate('/$workflow/catalog/edit', { Id: found.Id });
	}
}

async function deleteWorkflow(wf) {
	const ctrl: IController = this.$ctrl;
	await ctrl.$invoke('delete', { Id: wf.Id }, '/$workflow/catalog');
	wf.$remove();
}