import users from '../data/users.json';

export default class UserController {
    constructor(userData) {
        this.userData = userData;
    }

<<<<<<< HEAD
    getUser(id) {
        const filter = this.userData.filter(i => i.userId === id );
        return filter.length > 1 ? filter[0] : filter;
    }


=======
    getUsers() {
        
    }

>>>>>>> development
}
