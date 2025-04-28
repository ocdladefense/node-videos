export default class User {
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
    }

    getUserPurchasedVideos() {
        // return an array
        if (this.purchasedVideos.length > 1) {
            return this.purchasedVideos;
        } else {
            return this.purchasedVideos[0];
        }
    }

}
