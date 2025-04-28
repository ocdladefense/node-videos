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
        const filter = allUsers.filter(i => i.userId === id );
        return filter.length > 0 ? filter[0] : filter;
    }

    addVideoToPurchased(user, video) {
        if (user.purchasedVideos.includes(video)) {
           console.log("User already owns video.")
        } else
        {
            user.purchasedVideos.push(video);
            
        }
    }


    getAllUsers() {
        let allUsers = this.parseUsers();
        return allUsers;
    }

}
