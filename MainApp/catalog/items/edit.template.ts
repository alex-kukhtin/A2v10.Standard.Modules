
import { TRoot, TItem } from './edit';

const template : Template = {
    validators: {
        'Item.Name': `@[Error.Required]`
    }
};

export default template;

