
// /$admin/userrole/user/create.template

const template: Template = {
	properties: {
		'TUser.Confirm': String
	},
	validators: {
		'User.Password': validPassword,
		'User.Confirm': validConfirm,
		'User.PersonName': "@[Error.Required]",
		'User.UserName': ["@[Error.Required]", { valid: StdValidator.email, msg: '@[Adm.Error.Email]' }],
	},
	commands: {
		create
	}
}

export default template;

function validPassword(usr, pwd): string {
	if (!pwd)
		return "@[Error.Required]";
	return pwd.length >= 6 ? null : '@[PasswordLength]';
}

function validConfirm(usr, cnf): string {
	if (!usr.Password)
		return '';
	return usr.Password === cnf ? '' : "@[MatchError]";
}


async function create() {
	const ctrl: IController = this.$ctrl;

	let usr = this.User;
	let dat = {
		UserName: usr.UserName,
		Email: usr.UserName,
		PersonName: usr.PersonName,
		PhoneNumber: usr.PhoneNumber,
		Memo: usr.Memo,
		Password: usr.Password,
	};

	try {
		let result = await ctrl.$invoke('createUser', { User: dat }, '/$admin/userrole/user', { catchError: true });
		ctrl.$modalClose(result.User);
	} catch (err) {
		ctrl.$alert(err);
	}
}

