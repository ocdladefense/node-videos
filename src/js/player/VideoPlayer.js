export default class VideoPlayer {
    player;
    videoLength;
    url;
    elapsedTime;
    isPolling;
    isPlaying;
    state;
    mediaEvent;

    constructor(containerRef, userWatchProgress, onReady, onStateChange) {
        this.player = null;
    }

    init(containerRef, userWatchProgress, onReady, onStateChange) {
        this.player = 'ready';
        this.state = 'unstarted';
        this.elapsedTime = 0;
        this.isPolling = false;
        this.isPlaying = false;
    }

    loadVideo(url, attrs) {
        this.videoLength = attrs.length;
    }

    playVideo() {
        isPlaying = true;
        isPolling = true;
        state = 'playing';
    }

    restartVideo() { }

    pauseVideo() { }

    stopVideo() { }

    seekTo() { }

    setVolume() { }

    getDuration() { }

    getCurrentTime() { }

    getMediaPlayerEvent(resourceId, timestamp) {
        return this.mediaEvent = new CustomEvent('mediastatechange', {
            detail: {timestamp: timestamp, resourceId: resourceId},
            bubbles: true
        });
    }
}
