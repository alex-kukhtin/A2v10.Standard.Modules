
let designer;

const template: Template = {
	properties: {
		'TRoot.$Host': host,
		'TRoot.$$CanDeleteItem': Boolean
	},
	commands: {
		deleteItem: {
			exec: deleteItem,
			canExec: canDeleteItem,	
		},
		resetForm
	},
	events: {
		'Model.load': modelLoad
	}
};

export default template;

function modelLoad() {
}

function deleteItem() {
	if (!designer) return;
	designer.deleteItem();
}

function canDeleteItem() {
	return this.$$CanDeleteItem;
}	

function host() {
	const that = this;
	return {
		init(elem) {
			designer = elem;
		},
		canDeleteItemChanged(val) {
			that.$$CanDeleteItem = val;
		}
	};
}

async function resetForm() {
	const ctrl: IController = this.$ctrl;
	await ctrl.$invoke('resetForm', { Id: this.Table.Id, Key: this.Form.Key }, '/$meta/config');
	ctrl.$requery();
}