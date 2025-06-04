// workflow/autostart/add.template

const template: Template = {
	properties: {
		'TAutoStart.TimezoneOffset'() { return (new Date()).getTimezoneOffset(); }
	},
	validators: {
		'AutoStart.Workflow': "@[Error.Required]"
	},
	commands: {
	}
}

export default template;


