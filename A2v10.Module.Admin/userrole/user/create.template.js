define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        properties: {
            'TUser.Confirm': String
        },
        validators: {
            'User.Password': validPassword,
            'User.Confirm': validConfirm,
            'User.PersonName': "@[Error.Required]",
            'User.UserName': ["@[Error.Required]", { valid: "email", msg: '@[Adm.Error.Email]' }],
        },
        commands: {
            create
        }
    };
    exports.default = template;
    function validPassword(usr, pwd) {
        if (!pwd)
            return "@[Error.Required]";
        return pwd.length >= 6 ? null : '@[PasswordLength]';
    }
    function validConfirm(usr, cnf) {
        if (!usr.Password)
            return '';
        return usr.Password === cnf ? '' : "@[MatchError]";
    }
    async function create() {
        const ctrl = this.$ctrl;
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
        }
        catch (err) {
            ctrl.$alert(err);
        }
    }
});
