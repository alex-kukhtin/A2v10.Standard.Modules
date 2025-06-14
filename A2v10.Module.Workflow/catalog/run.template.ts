// workflow/catalog/run.template


const template: Template = {
	commands: {
		runProcess
	}
};

export default template;

async function runProcess() {
	const ctrl: IController = this.$ctrl;
	const wf = this.Workflow;
	let args = wf.Arguments.reduce((acc, arg) => {
		acc[arg.Name] = arg.Value;
		return acc;
	}, {});

	try {
		let res = await ctrl.$invoke('start', { WorkflowId: wf.Id, CorrelationId: wf.CorrelationId, Args: args }, '/$workflow/catalog', { catchError: true });
		let resMsg = `InstanceId: ${res.InstanceId}, Result: ${JSON.stringify(res.Result)}`;
		await ctrl.$msg(resMsg, "Result", CommonStyle.info);
		ctrl.$modalClose(res);
	}
	catch (err) {
		await ctrl.$alert(err);
		ctrl.$modalClose();
	}
}

