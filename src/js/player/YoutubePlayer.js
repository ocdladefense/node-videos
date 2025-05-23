import VideoPlayer from './VideoPlayer.js';
import { injectScriptElement } from '../utils.js';



const UNSTARTED = -1;

const ENDED = 0;

const PLAYING = 1;

const PAUSED = 2;

const BUFFERING = 3;

const VIDEO_CUED = 5;



export default class YouTubePlayer extends VideoPlayer {

    // Internal reference to this wrapper class's video player.
    #player;


    #scriptsReady = false;

    // The video currently assigned to this player.
    // Note: a value here doesn't necessarily mean that the video is playing.
    #video;

    // Whether the player and its dependencies have loaded and are ready for use.
    #initialized = false;

    // The state of the player.
    #state = -1;


    // The id of an window-bound broadcaster.
    // The broadcaster executes an onStateChange method at intervals.
    #broadcastId;


    // Functions to call when the player's state changes.
    // Other processes can use the addListener() method to subscribe to state changes.
    #subscribers = [];





    constructor() {
        super();
    }


    /**
     * When the player is initialized it has loaded all required scripts and is ready to be used.
     * @returns {boolean} Whether the player has been initialized.
     */
    isInitialized() {
        return this.#initialized === true;
    }




    addListener(listener) {
        this.#subscribers.push(listener);
    }


    /**
     * Initialize and load the YouTube iframe player to the element with the specified id.
     * @param {string} elemId 
     * @param {function} setPlayerInitialized 
     * @param {function} onStateChange 
     */
    load(elemId, setPlayerInitialized) {

        // We will only start emitting player statuses if the user indicates they want to load and interact* with the player.
        // we should do the reverse when we want to tear down this instance.
        this.startPublishing();

        // Executes when the player instance is actually ready to interact with.
        // Technically this happens after initialization.
        const onReady = () => {
            this.#initialized = true;
            setPlayerInitialized(true);
            console.log("YouTube Player is initialized.");
        };


        const onYouTubeIframeAPIReady = () => {
            this.#scriptsReady = true;
            const config = this.makeConfig(onReady);
            this.#player = new YT.Player(elemId, config);
        };


        window.onYouTubeIframeAPIReady = onYouTubeIframeAPIReady;

        if (!this.#scriptsReady) {
            injectScriptElement("https://www.youtube.com/iframe_api");
        } else {
            onYouTubeIframeAPIReady();
        }
    }


    /**
     * The destroy() method should remove event listeners and free up any other resources used by the player.
     * 
     * @returns {boolean}
     */
    destroy() {
        this.#state = -1;
        this.removeListeners();
        this.stopPublishing();
        this.#player.destroy();
        this.#player = null;
        this.#video = null;
        console.log("YouTube Player is destroyed.");
        this.#initialized = false;
    }


    // "Cue" refers to a signal or prompt that indicates a specific action or change.
    cue(video) {
        this.#video = video;
    }

    play() {
        this.#player.playVideo();
    }

    pause() {
        this.#player.pauseVideo();

        let mediaEvent = this.getMediaPlayerEvent(this.#video.getResourceId(), this.getElapsedTime());

        let playerElement = document.querySelector('#player');
        playerElement.dispatchEvent(mediaEvent);
    }

    restart(time) {
        this.#player.seekTo(time, true);
        this.playVideo();
    }

    stop() {
        this.#player.stopVideo();
        this.#player.seekTo(0);
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
        return this.#initialized ? Math.round(this.#player.getCurrentTime()) : 0;
    }

    getPlayerState() {
        return this.#state;
    }


    isPlaying() {
        return this.#state === PLAYING;
    }



    getVolume() {
        return this.#player ? this.#player.getVolume() : 0;
    }

    setVolume(volume) {
        this.#player.setVolume(volume);
    }

    makeConfig(onReady) {


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
                enablejsapi: 1
            },
            events: {
                onReady: onReady,
                onStateChange: (event) => {
                    // console.log("YT Event:", event);
                    this.#state = event.data;
                }
            }
        };
    }



    /**
     * 
     * @returns {string} The videoId of any currently cued or playing video.
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
            playerState: this.#state,
            videoId: this.#video ? this.#video.getResourceId() : null,
            timestamp: this.getElapsedTime()
        });
    }

    startPublishing() {
        this.#broadcastId = setInterval(() => {
            // console.log("Player state is: ", this.serialize());
            this.#subscribers.forEach((fn) => fn(this.serialize()));
        }, 1000);
    }


    stopPublishing() {
        clearInterval(this.#broadcastId);
        console.log("Stopped broadcasting.");
    }

    removeListeners() {
        this.#subscribers = [];
    }
}
