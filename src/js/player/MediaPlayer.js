




class MediaPlayer {



    constructor() {

    }

    getMediaPlayerEvent(resourceId, elapsedTime) {
        return this.mediaEvent = new CustomEvent('mediastatechange', {
            detail: { resourceId: resourceId, timestamp: elapsedTime, elapsedTime: elapsedTime },
            bubbles: true
        });
    }
}
