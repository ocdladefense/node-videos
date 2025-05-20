import VideoPlayer from './VideoPlayer';
import Time from '../models/Time.js';

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

    configYoutubeDisplay(userWatchProgress, onReady) {
        return {
            height: '720',
            width: '1280',
            videoId: userWatchProgress.resourceId,
            playerVars: {
                start: userWatchProgress.timeStamp,
                autoplay: 0,
                modestbranding: 0,
                controls: 0,
                rel: 0,
            },
            events: {
                onReady: onReady,
            }
        };
    }
    injectScriptElement() {
        let tag = document.createElement('script');
        tag.src = "https://www.youtube.com/iframe_api";

        let firstScriptTag = document.getElementsByTagName('script')[0];
        if (firstScriptTag == null) {
            (document.body || document.head).appendChild(tag);
        }
        else {
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
        }
    }

    getFormattedTime(duration) {
        let formattedTime;
        return (formattedTime = Time.parseTime(duration));
    }

    isInitialized() {
        return false;
    }

    loadPlayer(containerRef, userWatchProgress, onReady=null, onInitialized, onStateChange, handleTimestamp, setElapsed, setIsPlaying, setIsPolling) {
        this.onStateChangeCallback = onStateChange;

        this.handleTimestamp = handleTimestamp;
        this.setElapsed = setElapsed;
        this.setIsPlaying = setIsPlaying;
        this.setIsPolling = setIsPolling;

        this.injectScriptElement();

        const onYouTubeIframeAPIReady = () => {
            onInitialized(true);
            const config = this.configYoutubeDisplay(
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

    loadVideo() {

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

        //let resourceID = this.userWatchProgress.resourceId;
        let mediaEvent = this.getMediaPlayerEvent('foodbar', 1000);

        let myElement = document.querySelector('#player');

        myElement.dispatchEvent(mediaEvent);
        console.log('foobar');
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
        //const p = this.player.getDuration();
        return 100;
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
