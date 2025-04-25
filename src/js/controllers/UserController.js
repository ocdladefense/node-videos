import users from '../../data/users.json';

export default class UserController {
    constructor(userData) {
        this.userData = userData;
    }

    getUser(id) {
        const filter = this.userData.filter(i => i.userId === id );
        return filter.length > 0 ? filter[0] : filter;
    }

    addVideoToUserPurchased(user, videoId) {
        
    }

}
