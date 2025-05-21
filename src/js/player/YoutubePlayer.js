import VideoPlayer from './VideoPlayer.js';
import Time from '../models/Time.js';

export default class YouTubePlayer extends VideoPlayer {

    // Internal reference to this wrapper class's video player.
    #player;

    // The video currently assigned to this player.
    // Note this doesn't necessarily have a video loaded into it.
    #video;

    // Whether the player and its dependencies have loaded and are ready for use.
    #initialized;

    // The id of an window-bound broadcaster.
    // The broadcaster executes an onStateChange method at intervals.
    #broadcastId;





    constructor() {
        super();
    }


    /**
     * When the player is initialized it has loaded all required scripts and is ready to be used.
     * @returns {boolean} Whether the player has been initialized.
     */
    isInitialized() {
        return this.#initialized;
    }


    /**
     * Initialize and load the YouTube iframe player to the specified element.
     * @param {string} elem 
     * @param {function} setPlayerInitialized 
     * @param {function} onStateChange 
     */
    loadPlayer(elem, setPlayerInitialized, onStateChange) {

        const onYouTubeIframeAPIReady = () => {

            const config = this.configYoutubeDisplay(() => {
                setPlayerInitialized(true);
                this.#initialized = true;
                console.log("YouTube Player is initialized.");
                this.broadcast(onStateChange);
            });

            config.events.onStateChange = (event) => {
                if (this.onStateChangeCallback) {
                    this.onStateChangeCallback(event);
                }
            };

            this.#player = new YT.Player(elem, config);
        };

        window.onYouTubeIframeAPIReady = onYouTubeIframeAPIReady;

        YouTubePlayer.injectScriptElement();
    }




    queueVideo(video) {
        this.#video = video;
    }

    playVideo() {
        this.#player.playVideo();
    }

    pauseVideo() {
        this.#player.pauseVideo();

        //let resourceID = this.userWatchProgress.resourceId;
        let mediaEvent = this.getMediaPlayerEvent('foodbar', 1000);

        let myElement = document.querySelector('#player');

        myElement.dispatchEvent(mediaEvent);
        console.log('foobar');
    }

    restartVideo(time) {
        this.#player.seekTo(time, true);
        this.playVideo();
    }

    stopVideo() {
        this.#player.stopVideo();
    }

    seekTo(time) {
        this.#player.seekTo(time, true);
    }

    getDuration() {
        return this.#player.getDuration();
    }

    getCurrentTime() {
        return this.#player.getCurrentTime();
    }

    getElapsedTime() {
        return this.#initialized ? this.#player.getCurrentTime() : 0;
    }

    getPlayerState() {
        return this.#player.getPlayerState();
    }



    configYoutubeDisplay(onReady) {
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
            events: {
                onReady: onReady
            }
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
     * @returns {string} The videoId of any currently queued or playing video.
     */
    getVideoId() {
        return YouTubePlayer.parseId(this.#player.getVideoUrl());
    }


    /**
     * Parse the YouTube resourceId from the given url.
     * @param {string} url 
     * @returns {string|boolean}
     */
    static parseId(url) {
        var regExp = /.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=)([^#\&\?]*).*/;
        var match = url.match(regExp);

        return (match && match[1].length >= 11) ? match[1] : false;
    }


    serialize() {
        return JSON.stringify({
            videoId: this.#video ? this.#video.getResourceId() : null,
            timestamp: this.getElapsedTime()
        });
    }

    broadcast(setPlayerState) {
        this.#broadcastId = setInterval(() => {
            console.log("Player state is: ", this.serialize());
            setPlayerState(this.serialize())
        }, 1000);
    }
}
