
import { TRoot, TAgent, TStore } from './edit';

const template : Template = {
    validators: {
        'Agent.Name': `@[Error.Required]`
    }
};

export default template;

