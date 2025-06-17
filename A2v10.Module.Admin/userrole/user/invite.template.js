define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        validators: {
            'User.UserName': ["@[Error.Required]", { valid: "email", msg: '@[Adm.Error.Email]' }],
        },
        commands: {
            inviteUser
        }
    };
    exports.default = template;
    async function inviteUser(user) {
        const ctrl = this.$ctrl;
        let res = await ctrl.$invoke("inviteUser", { User: { UserName: user.UserName } });
        ctrl.$modalClose(res.User);
    }
});
