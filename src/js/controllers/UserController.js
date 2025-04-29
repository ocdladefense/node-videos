import User from '../models/User.js';

export default class UserController {
    constructor(userData) {
        this.userData = userData;
    }



     parseUsers() {
        let users = [];
        for (let u in this.userData) {
                   
            let ud = this.userData[u];    
            users.push(new User(ud));
        }
        return users;
    }

    getUser(id) {
        const filter = this.userData.filter(i => i.userId === id );
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

    getUserPurchased(user) {
        return user.purchasedVideos;
    }

    getAllUsers() {
        return this.userData;
    }

}
