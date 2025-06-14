// workflow/instance/index.template

const template: Template = {
	options: {
		noDirty: true,
		persistSelect: ["Instances"]
	},
	properties: {
		'TInstance.$Mark'() { return this.Lock ? 'red' : undefined; }
	},
	events: {
	},
	commands: {
		resume,
		resumeBookmark,
		unlock: {
			exec: unlock,
			canExec: (inst) => !!inst.Lock
		},
		start
	}
}

export default template;


async function resume(inbox) {
	const ctrl: IController = this.$ctrl;
	let res = await ctrl.$invoke('resume', {
		InstanceId: inbox.Instance,
		Bookmark: inbox.Bookmark,
		Reply: {
			Answer: this.Answer.Answer
		}
	}, '/$workflow/instance');

	let resMsg = `InstanceId: ${res.InstanceId}, Result: ${JSON.stringify(res.Result)}`;
	ctrl.$msg(resMsg, "Result", CommonStyle.info);

	ctrl.$reload();
}

async function resumeBookmark(bookmark) {
	const ctrl: IController = this.$ctrl;
	let res = await ctrl.$invoke('resume', {
		InstanceId: bookmark.Instance,
		Bookmark: bookmark.Bookmark
	}, '/$workflow/instance');

	let resMsg = `InstanceId: ${res.InstanceId}, Result: ${JSON.stringify(res.Result)}`;
	ctrl.$msg(resMsg, "Result", CommonStyle.info);

	ctrl.$reload();
}

async function unlock(inst) {
	const ctrl: IController = this.$ctrl;
	await ctrl.$invoke('unlock', { Id: inst.Id }, '/$workflow/instance');
	inst.Lock = '';	
	inst.LockDate = null;
}

async function start() {
	const ctrl: IController = this.$ctrl;
	var wf = await ctrl.$showDialog('/$workflow/catalog/browse');
	if (!wf) return;
	let res = await ctrl.$showDialog('/$workflow/catalog/run', wf);
	ctrl.$reload();
}
