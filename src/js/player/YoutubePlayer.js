import VideoPlayer from './VideoPlayer.js';
import Time from '../models/Time.js';

export default class YouTubePlayer extends VideoPlayer {

    #player;

    #video;

    onStateChangeCallback = null;

    handleTimestamp;

    setElapsed;

    setIsPlaying;

    setIsPolling;



    constructor() {
        super();
    }


    isInitialized() {
        return false;
    }

    loadPlayer(containerRef, setPlayerInitialized, onReady, userWatchProgress, onStateChange, handleTimestamp, setElapsed, setIsPlaying, setIsPolling) {
        this.onStateChangeCallback = onStateChange;
        this.handleTimestamp = handleTimestamp;
        this.setElapsed = setElapsed;
        this.setIsPlaying = setIsPlaying;
        this.setIsPolling = setIsPolling;

        const onYouTubeIframeAPIReady = () => {

            const config = this.configYoutubeDisplay();

            config.events.onStateChange = (event) => {
                if (this.onStateChangeCallback) {
                    this.onStateChangeCallback(event);
                }
            };

            this.#player = new YT.Player(containerRef, config);
            setPlayerInitialized(true);
            console.log("Player initialized is true.");
        };

        window.onYouTubeIframeAPIReady = onYouTubeIframeAPIReady;

        YouTubePlayer.injectScriptElement();
    }




    queueVideo(video) {
        this.#video = video;
    }

    playVideo() {
        const p = this.#player.playVideo();
        this.handleTimestamp();
        this.setIsPlaying(true);
        this.setIsPolling(true);
        return p;
    }

    pauseVideo() {
        this.handleTimestamp();
        this.setIsPlaying(false);
        this.setIsPolling(false);
        this.#player.pauseVideo();

        //let resourceID = this.userWatchProgress.resourceId;
        let mediaEvent = this.getMediaPlayerEvent('foodbar', 1000);

        let myElement = document.querySelector('#player');

        myElement.dispatchEvent(mediaEvent);
        console.log('foobar');
    }

    restartVideo(time) {
        this.#player.seekTo(time, true);
        this.setElapsed(0);
        this.playVideo();
    }

    stopVideo() {
        const p = this.#player.stopVideo();
        this.handleTimestamp();
        this.setIsPlaying(false);
        this.setIsPolling(false);
        this.setElapsed(0);
        return p;
    }

    seekTo(time) {
        const p = this.#player.seekTo(time, true);
        return p;
    }

    getDuration() {
        //const p = this.player.getDuration();
        return 100;
    }

    getCurrentTime() {
        const p = this.#player.getCurrentTime();
        return p;
    }

    getPlayerState() {
        const p = this.#player.getPlayerState();
        return p;
    }



    configYoutubeDisplay() {
        return {
            height: '720',
            width: '1280',
            videoId: this.#video.getResourceId(),
            playerVars: {
                start: 0,
                autoplay: 0,
                modestbranding: 0,
                controls: 0,
                rel: 0,
            },
            events: {}
        };
    }



    static injectScriptElement() {
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


    /**
     * 
     * @param {string} url 
     * @returns 
     */
    static parseUrl(url) {
        var regExp = /.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=)([^#\&\?]*).*/;
        var match = url.match(regExp);

        return (match && match[1].length >= 11) ? match[1] : false;
    }
}
