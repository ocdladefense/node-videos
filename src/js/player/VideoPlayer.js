export default class VideoPlayer {




    constructor() {

    }

    init() {

    }

    load() {

    }

    play() {

    }

    restart() { }

    pause() { }

    stop() { }

    seekTo() { }

    setVolume() { }

    getDuration() { }

    getCurrentTime() { }

    getMediaPlayerEvent(resourceId, timestamp) {
        return this.mediaEvent = new CustomEvent('mediastatechange', {
            detail: { timestamp: timestamp, resourceId: resourceId },
            bubbles: true
        });
    }
}
