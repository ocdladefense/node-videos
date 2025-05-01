export default class User {
<<<<<<< HEAD
    constructor(userData) {
        this.userData = userData;
    }

    getUserId() {
        return this.userData.userId;
    }

    getUserName() {
        return this.userData.userName;
=======
    userId;
    userName;
    purchasedVideos;

    constructor(name) {
        this.userName = name;
    }

    static fromUserData(data) {
        let user = new User(data.userName)
        user.userId = data.userId;
        user.userName = data.userName;
        user.purchasedVideos = data.purchasedVideos;
        return user;
    }

    getUserId() {
        return this.userId;
    }

    getUserName() {
        return this.userName;
>>>>>>> 95e9311 (refactored User and fixed parsing issues. Ran some console.log tests)
    }

    getUserPurchasedVideos() {
        // return an array
<<<<<<< HEAD
        return this.userData.purchasedVideos;
=======
        if (this.purchasedVideos.length > 1) {
            return this.purchasedVideos;
        } else {
            return this.purchasedVideos[0];
        }
>>>>>>> 95e9311 (refactored User and fixed parsing issues. Ran some console.log tests)
    }

}
