
const template: Template = {
	options: {
		persistSelect: ["Users"]
	},
	properties: {
		'TUser.$Mark'() { return !this.EmailConfirmed ? 'warning' : ''; }
	},
	events: {
		'g.user.saved': handleUserSaved
	},
	commands: {
		inviteUser,
		createUser,
		deleteUser
	}
}

export default template;

function handleUserSaved(root) {
	let user = root.User;
	let found = this.Users.$find(e => e.Id == user.Id);
	found.Memo = user.Memo;
	found.PersonName = user.PersonName;
	found.PhoneNumber = user.PhoneNumber;
}

async function inviteUser() {
	let ctrl: IController = this.$ctrl;
	let user = await ctrl.$showDialog('/$admin/userrole/user/invite');
	this.Users.$append(user);
}

async function createUser() {
	let ctrl: IController = this.$ctrl;
	let user = await ctrl.$showDialog('/$admin/userrole/user/create');
	this.Users.$append(user);
}

async function deleteUser(user) {
	const ctrl: IController = this.$ctrl;
	await ctrl.$invoke("deleteUser", {Id: user.Id}, '$admin/userrole/user');
	user.$remove();
}
