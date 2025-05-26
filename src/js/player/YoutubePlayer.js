import VideoPlayer from './VideoPlayer.js';
import { injectScriptElement } from '../utils.js';



const UNSTARTED = -1;

const ENDED = 0;

const PLAYING = 1;

const PAUSED = 2;

const BUFFERING = 3;

const VIDEO_CUED = 5;

// Width of the player, but can be overriden.
const DEFAULT_PLAYER_WIDTH = 1200;

// Height of the player, but can be overriden.
const DEFAULT_PLAYER_HEIGHT = 720;



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
    #_state = -1;


    // The id of an window-bound broadcaster.
    // The broadcaster executes an onStateChange method at intervals.
    #broadcastId;


    // Functions to call when the player's state changes.
    // Other processes can use the addListener() method to subscribe to state changes.
    #subscribers = [];


    #config = {};



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

    setSize(width, height) {
        this.#config.width = width;
        this.#config.height = height;
        if (this.#player && this.#player.setSize && typeof this.#player.setSize === "function") {
            this.#player.setSize(width, height);
        }
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
        this.#_state = -1;
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
    }

    restart(time) {
        this.#player.seekTo(time, true);
        this.play();
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




    isPlaying() {
        return this.#_state === PLAYING;
    }



    getVolume() {
        if (!this.#player || !this.#player.getVolume || typeof this.#player.getVolume != "function") {
            return 0;
        }

        return this.#player.getVolume();
    }

    setVolume(volume) {
        this.#player.setVolume(volume);
    }


    makeConfig(onReady) {


        return {
            width: this.#config.width || DEFAULT_PLAYER_WIDTH,
            height: this.#config.height || DEFAULT_PLAYER_HEIGHT,
            videoId: this.#video.getResourceId(),
            playerVars: {
                start: 0,
                autoplay: 1,
                modestbranding: 0,
                controls: 0,
                rel: 0,
                enablejsapi: 1
            },
            events: {
                onReady: onReady,
                onError: function(e) { console.error(e); },
                onStateChange: (event) => {
                    // console.log("YT Event:", event);
                    this.#_state = event.data;
                    console.log(event);
                    let e = this.getMediaPlayerEvent(this.#video.getResourceId(), this.getElapsedTime());
                    this.#player.getIframe().dispatchEvent(e);
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


    getPlayerState() {
        return {
            playerState: this.#_state,
            videoId: this.#video ? this.#video.getResourceId() : null,
            timestamp: this.getElapsedTime(), // Kept here temporarily for backwards-compatibility for other listeners.
            elapsedTime: this.getElapsedTime()
        };
    }


    serialize() {
        return JSON.stringify(this.getPlayerState());
    }

    startPublishing() {
        this.#broadcastId = setInterval(() => {
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
