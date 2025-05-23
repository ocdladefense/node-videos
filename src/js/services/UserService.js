export default class UserService {
    user;
    constructor(user) {
        this.user = user;
    }


  

    listen() {
        document.addEventListener('mediastatechange', (e) => this.addToWatched(e));
        document.addEventListener('mediapurchased', (e) => this.addToPurchased(e));
    }

    addToPurchased(event) {
        let videoId = event.detail.videoId;
        this.user.addToPurchasedVideos(videoId);
    }

    addToWatched(event) {
        let videoId = event.detail.videoId;
        let timestamp = event.detail.timestamp;
        this.user.addToWatchedVideos(videoId, timestamp);
        console.log('added to watched video')
    }


}


