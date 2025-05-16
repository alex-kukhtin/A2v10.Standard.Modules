// workflow/instance/index.template

const template: Template = {
	options: {
		noDirty: true,
		persistSelect: ["Instances"]
	},
	events: {
	},
	commands: {
		resume,
		resumeBookmark,
		unlock: {
			exec: unlock,
			canExec: (inst) => !!inst.Lock
		}
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

async function unlock() {
	const ctrl: IController = this.$ctrl;
	alert("Unlocking instance...");
}