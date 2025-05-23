export default class User {
    userId;
    userName;
    purchasedVideos;
    previouslyWatched;

    constructor(name) {
        this.userName = name;
    }

    static fromUserData(data) {
        let user = new User(data.userName)
        user.userId = data.userId;
        user.userName = data.userName;
        user.purchasedVideos = data.purchasedVideos;
        user.previouslyWatched = data.previouslyWatched;
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

    getPurchasedVideo(videoId) {
        for(let i = 0; i < this.purchasedVideos.length; i++) {
            if (this.purchasedVideos[i].resourceId === videoId) {
                return this.purchasedVideos[i];
            }
        }
        return null;
    }

    getPreviouslyWatchedVideos() {
        return this.previouslyWatched;
    }

    getWatchedVideo(videoId) {
        for(let i = 0; i < this.previouslyWatched.length; i++) {
            if (this.previouslyWatched[i].resourceId === videoId) {
                return this.previouslyWatched[i];
            }
        }
        return null;
    }

    addToWatchedVideos(id, timestamp = 0) {
        this.previouslyWatched.push(
            {
                "resourceId": id,
                "timeStamp": timestamp
            }
        )
    }

    updateTimestamp(id, time) {
        for(let i = 0; i < this.previouslyWatched.length; i++)
        {
            if (this.previouslyWatched[i].resourceId === id)
            {
                this.previouslyWatched[i].timeStamp = time;
            }
        }
    }

    addToPurchasedVideos(video) {
        this.purchasedVideos.push(video);
    }

}
