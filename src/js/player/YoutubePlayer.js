import VideoPlayer from './VideoPlayer';

export default class YouTubePlayer extends VideoPlayer {
    constructor() {
        super();
        this.player = null;
        this.onStateChangeCallback = null;

        this.handleTimestamp;
        this.setElapsed;
        this.setIsPlaying;
        this.setIsPolling;
        this.playVideo;
    }

    loadPlayer(containerRef, userWatchProgress, onReady, onStateChange, handleTimestamp, setElapsed, setIsPlaying, setIsPolling) {
        this.onStateChangeCallback = onStateChange;

        this.handleTimestamp = handleTimestamp;
        this.setElapsed = setElapsed;
        this.setIsPlaying = setIsPlaying;
        this.setIsPolling = setIsPolling;

        window.ydc.injectScriptElement();

        const onYouTubeIframeAPIReady = () => {
            const config = window.ydc.configYoutubeDisplay(
                userWatchProgress,
                (event) => {
                    this.player = event.target;
                    onReady(this);
                }
            );

            config.events.onStateChange = (event) => {
                if (this.onStateChangeCallback) {
                    this.onStateChangeCallback(event);
                }
            };

            new window.YT.Player(containerRef, config);
        };

        if (window.YT && window.YT.Player) {
            onYouTubeIframeAPIReady();
        } else {
            window.onYouTubeIframeAPIReady = onYouTubeIframeAPIReady;
        }
    }

    playVideo() {
        const p = this.player.playVideo();
        this.handleTimestamp();
        this.setIsPlaying(true);
        this.setIsPolling(true);
        return p;
    }

    pauseVideo = () => {
        this.handleTimestamp();
        this.setIsPlaying(false);
        this.setIsPolling(false);
        this.player.pauseVideo();
    }

    restartVideo(time) {
        this.player.seekTo(time, true);
        this.setElapsed(0);
        this.playVideo();
    }

    stopVideo() {
        const p = this.player.stopVideo();
        this.handleTimestamp();
        this.setIsPlaying(false);
        this.setIsPolling(false);
        this.setElapsed(0);
        return p;
    }

    seekTo(time) {
        const p = this.player.seekTo(time, true);
        return p;
    }

    getDuration() {
        const p = this.player.getDuration();
        return p;
    }

    getCurrentTime() {
        const p = this.player.getCurrentTime();
        return p;
    }

    getPlayerState() {
        const p = this.player.getPlayerState();
        return p;
    }
}
