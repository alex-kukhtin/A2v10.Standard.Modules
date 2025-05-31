
const BASE_URL = '/$meta/config/deploy';

const template: Template = {
	properties: {
		'TRoot.$$Tab': String
	},
	commands: {
		deploy

	},
	events: {
		'Signal.meta.deploy': signalMessage,
		'Signal.meta.deploy.complete': completeMessage
	}
};

export default template;

function deploy() {
	const ctrl: IController = this.$ctrl;
	this.Deploy.forEach(d => {
		d.Index = 0;
		d.Table = '';
	});
	ctrl.$invoke('deploy', null, BASE_URL);
}

function signalMessage(msg) {
	var elem = this.Deploy.$find(d => d.Kind === msg.Kind);
	if (!elem) {
		console.error(`Deploy ${msg.Schema} not found`);
		return;
	}
	elem.Table = msg.Table;
	elem.Index = msg.Index + 1;
}

async function completeMessage() {
	const ctrl: IController = this.$ctrl;
	await ctrl.$msg('Розгортання завершено. Застосунок буде перезавантажено');
	window.location.reload();
}