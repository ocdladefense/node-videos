export default class User {


    userId;


    username;


    purchased = new Map();


    watched = new Map();




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


    // Purchased video methods.

    getPurchasedVideos() {
        // return an array
        return this.purchased.values();
    }

    getPurchasedIds() {
        return [...this.purchased.keys()];
    }

    hasPurchasedVideo(videoId) {
        return this.purchased.get(videoId) || false;
    }

    hasPurchased(videoId) {
        return this.purchased.get(videoId) || false;
    }

    getPurchasedVideo(videoId) {
        let found = this.purchased.get(videoId);

        return found || {};
    }



    // Watched video methods.

    getWatchedVideos() {
        return this.watched.values();
    }

    getWatchedIds() {
        return [...this.watched.keys()];
    }

    hasWatchedVideo(videoId) {
        return this.watched.get(videoId) != null;
    }

    hasWatched(videoId) {
        return this.watched.get(videoId) != null;
    }

    getWatchedVideo(videoId) {
        let found = this.watched.get(videoId);

        return found || {};
    }



    // Add methods.
    addWatched(record) {
        console.log(record);
        this.watched.set(record.resourceId, record);
    }


    addPurchased(record) {
        this.purchased.set(record.resourceId, record);
    }


    async load(service, callback) {
        let data = await service.load();

        callback(this, data);
    }

}
