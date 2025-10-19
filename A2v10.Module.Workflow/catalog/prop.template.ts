
const template: Template = {
	validators: {
		'Workflow.Key': { valid: checkDuplicate, async:true, msg: '@[WfAfm.Error.DuplicateKey]' }
	}
}

export default template;


async function checkDuplicate(wf, text): Promise<Boolean> {
	if (!text) return true;
	const ctrl: IController = wf.$ctrl;
	return ctrl.$asyncValid('checkDuplicateKey', { Id: wf.Id, Text: text });
}