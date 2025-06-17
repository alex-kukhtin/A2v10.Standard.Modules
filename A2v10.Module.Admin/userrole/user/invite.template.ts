
// User.Invite

const template: Template = {
	validators: {
		'User.UserName': ["@[Error.Required]", { valid: StdValidator.email, msg: '@[Adm.Error.Email]'}],
	},
	commands: {
		inviteUser
	}
}

export default template;

async function inviteUser(user) {
	const ctrl: IController = this.$ctrl;
	let res = await ctrl.$invoke("inviteUser", { User: { UserName: user.UserName } });
	ctrl.$modalClose(res.User);
}