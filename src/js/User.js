export default class User {
    constructor(userData) {
        this.userData = userData;
    }

    getUserId() {
        return this.userData.userId;
    }

    getUserName() {
        return this.userData.userName;
    }

    getUserPurchasedVideos() {
        // return an array
        return this.userData.purchasedVideos;
    }

}
