


export default class WatchedVideoService {

    handleMediaStateChange = (event) => {
        const { playerState, videoId, timestamp } = event.detail;
        //console.log("recieved mediastatechange event", videoId, timestamp, playerState);
        this.updateUserTimestamp(videoId, timestamp);
    }

    updateUserTimestamp(videoId, timestamp) {
        console.log("updating user timestamp data", videoId, timestamp);
    }

    listen() {
        document.addEventListener('mediastatechange', this.handleMediaStateChange);
    }

}


