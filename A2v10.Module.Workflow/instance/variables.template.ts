// workflow/instance/variables.template

const template: Template = {
	options: {
	},
	properties: {
		'TInstance.$Vars'() {
			return {
				Variables: this.State.Variables,
				LastResult: this.State.LastResult,
				CurrentUser: this.State.CurrentUser
			};
		}
	}
}

export default template;


