import User from '../models/User.js';

export default class UserController {
    users;

    constructor(userData) {
        this.userData = userData;
    }


    parseUsers() {
        this.users = [];
        for (let u in this.userData) {

            let ud = this.userData[u];
            this.users.push(User.fromUserData(ud));
        }
        return this.users;
    }

    getUser(id) {
        let allUsers = this.parseUsers();
        const filter = allUsers.filter(i => i.userId === id);
        return filter.length > 0 ? filter[0] : filter;
    }

    addVideoToPurchased(resourceId) {
        if (!user.purchasedVideos.includes(resourceId)) {
            user.purchasedVideos.push(resourceId);
        }
    }


    getAllUsers() {
        let allUsers = this.parseUsers();
        return allUsers;
    }

}
