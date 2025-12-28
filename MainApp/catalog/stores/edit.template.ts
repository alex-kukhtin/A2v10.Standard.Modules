
import { TRoot, TStore } from './edit';

const template : Template = {
    properties: {
        'TStore.$$Tab': {type: String, value: 'Addresses'}
    },    validators: {
        'Store.Name': `@[Error.Required]`
    }
};

export default template;

