
const template: Template = {
	properties: {
		'TMapping.$SourceTables'() { return this.$root.Tables.filter(t => !t.IsJournal); }
	},
	validators: {
		'Mapping[].Source': validSource,
		'Mapping[].Target': validTarget,
	},
	events: {
		'Mapping[].add': addRow
	},
	commands: {
	}
};

export default template;

function addRow(arr, elem) {
	elem.TargetTable = this.$root.Tables.filter(t => t.IsJournal)[0];
	elem.SourceTable = this.$root.Tables.filter(t => !t.IsJournal)[0];
}

function validDataType(d1, d2) {
	if (d1 == d2)
		return true;
	if (!d1 || !d2)
		return true; // yet not defined
	if (d1.startsWith('date') && d2.startsWith('date'))
		return true;
	if (d1 === 'id' && d2 === 'reference' || d2 === 'id' && d1 === 'reference')
		return true;
	return false;
}

function validSource(map, el): string {
	if (!el.Id)
		return "@[Error.Required]";
	if (!validDataType(el.DataType, map.Target.DataType))
		return "@[Error.TypeMismatch]";
	return '';
}

function validTarget(map, el): string {
	if (!el.Id)
		return "@[Error.Required]";
	if (!validDataType(el.DataType, map.Source.DataType))
		return "@[Error.TypeMismatch]";
	return '';
}

