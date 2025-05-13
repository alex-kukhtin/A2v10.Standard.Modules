// workflow/instance/index.template

const template: Template = {
	options: {
		noDirty: true,
		persistSelect: ["Instances"]
	},
	events: {
	},
	commands: {
		resume
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
	}, '/workflow');

	let resMsg = `InstanceId: ${res.InstanceId}, Result: ${JSON.stringify(res.Result)}`;
	ctrl.$msg(resMsg, "Result", CommonStyle.info);

	ctrl.$reload();
}