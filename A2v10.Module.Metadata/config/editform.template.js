define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        properties: {
            'TRoot.$Host': host
        },
        commands: {},
        events: {
            'Model.load': modelLoad
        }
    };
    exports.default = template;
    function modelLoad() {
    }
    async function execCommand(cmd) {
        switch (cmd) {
            case 'reload':
                this.$requery();
                break;
            case 'save':
                await this.$save();
                break;
            default: alert(cmd);
        }
    }
    function host() {
        const ctrl = this.$ctrl;
        const root = this;
        return {
            exec(cmd) {
                execCommand.call(ctrl, cmd);
            },
            setDirty() {
                root.$setDirty(true);
            },
            isDirty() {
                if (!ctrl)
                    return false;
                return ctrl.$isDirty;
            }
        };
    }
});
