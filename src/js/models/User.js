export default class User {


    userId;


    username;


    purchased = [];


    watched = [];




    constructor(userId) {
        this.userId = userId;
    }

    static fromUserData(data) {
        let user = new User(data.userName)
        user.userId = data.userId;
        user.username = data.userName;
        user.purchased = data.purchasedVideos;
        user.watched = data.previouslyWatched;

        return user;
    }

    getUserId() {
        return this.userId;
    }

    getUsername() {
        return this.username;
    }

    getPurchasedVideos() {
        // return an array
        return this.purchased;
    }

    hasPurchasedVideo(videoId) {
        return this.purchased.some((video) => video.resourceId == videoId);
    }

    getWatchedVideos() {
        return this.watched;
    }

    hasWatchedVideo(videoId) {
        return this.watched.some((video) => video.resourceId == videoId);
    }

    getPurchasedVideo(videoId) {
        return this.hasPurchasedVideo(videoId) && {};
    }

    getWatchedVideo(videoId) {
        return this.hasWatchedVideo(videoId) && {};
    }


    addWatched(record) {
        this.watched.push(record);
    }


    addPurchased(record) {
        this.purchased.push(record);
    }


    async load(service, callback) {
        let data = await service.load();

        callback(this, data);
    }

}
