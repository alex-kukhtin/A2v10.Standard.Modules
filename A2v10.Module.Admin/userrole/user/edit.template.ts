
// /admin/userrole/user/edit.template

const template: Template = {
	properties: {
	},
	validators: {
		'User.PersonName': "@[Error.Required]"
	}
}

export default template;

