import SalesforceRestApi from "@ocdla/salesforce/SalesforceRestApi";

export default class User {


    userId;


    username;


    purchased = new Map();


    watched = new Map();


    api = null;



    constructor(userId, api) {
        this.userId = userId;
        this.api = api;
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

    setApi(api) {
        this.api = api;
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

    hasPurchased(mediaId) {
        return this.purchased.get(mediaId) || false;
    }

    async hasAccess(mediaId) {
        /*
         if (!this.api) {
            console.error("SalesforceRestApi instance not set on User.");
            return false;
        }

        try {
            const response = await this.api.access(mediaId);
            return response?.status === 200 || response?.access === true;
        } catch (err) {
            console.error("Error checking access:", err);
            return false;
        }



        let tokens;

        if (process.env.NODE_ENV != 'development') {
            tokens = await fetch("/connect").then(resp => resp.json());
        } else {
            tokens = { instance_url: process.env.SF_INSTANCE_URL, access_token: process.env.SF_ACCESS_TOKEN };
        }

        ({ instance_url, access_token } = tokens);

        let api = new SalesforceRestApi(instance_url, access_token);

        let accessResp = await api.access(mediaId);    

        
         */
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
        // console.log(record);
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
