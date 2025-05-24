export default class UserService {


    // The user this service is configured for.
    #user;


    constructor(user) {
        this.#user = user;
    }




    listen() {
        document.addEventListener('mediastatechange', (e) => this.addToWatched(e));
        document.addEventListener('mediapurchased', (e) => this.addToPurchased(e));
    }

    addToPurchased(event) {
        let videoId = event.detail.videoId; // change to resourceId or event just id.
        this.#user.addToPurchasedVideos(videoId); // same here
        console.log('Added to purchased video!')
    }

    addToWatched(event) {
        let videoId = event.detail.videoId;
        let timestamp = event.detail.timestamp; // change to elapsedTime.  Timestamp should be associated with when the event occurred.
        this.#user.addToWatchedVideos(videoId, timestamp);
        console.log('Added to watched video!');
    }


}


