define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        options: {
            persistSelect: ["Users"]
        },
        properties: {
            'TUser.$Mark'() { return this.IsBlocked ? 'red' : ''; }
        },
        events: {
            'g.user.saved': handleUserSaved
        },
        commands: {
            inviteUser,
            deleteUser
        }
    };
    exports.default = template;
    function handleUserSaved(root) {
        let user = root.User;
        let found = this.Users.$find(e => e.Id == user.Id);
        found.Memo = user.Memo;
        found.PersonName = user.PersonName;
        found.PhoneNumber = user.PhoneNumber;
    }
    async function inviteUser() {
        let ctrl = this.$ctrl;
        let user = await ctrl.$showDialog('/$admin/userrole/user/invite');
        this.Users.$append(user);
    }
    async function deleteUser(user) {
        const ctrl = this.$ctrl;
        await ctrl.$invoke("deleteUser", { Id: user.Id }, '$admin/userrole/user');
        user.$remove();
    }
});
