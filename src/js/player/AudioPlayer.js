import MediaPlayer from './MediaPlayer.js';
// import { injectScriptElement } from '../utils.js';
// https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement



const UNINITIALIZED = -9;

const UNSTARTED = -1;

const ENDED = 0;

const PLAYING = 1;

const PAUSED = 2;

const BUFFERING = 3;

const VIDEO_CUED = 5;

const PLAYER_STATE_SEEKING = 101;

// Width of the player, but can be overriden.
const DEFAULT_PLAYER_WIDTH = 1200;

// Height of the player, but can be overriden.
const DEFAULT_PLAYER_HEIGHT = 720;

// Interval, in milliseconds, to use when publishing events.
const PUBLISH_INTERVAL = 1000;



export default class AudioPlayer extends MediaPlayer {

    // Internal reference to this wrapper class's video player.
    #player;


    static scriptsReady = false;

    // The video currently assigned to this player.
    // Note: a value here doesn't necessarily mean that the video is playing.
    #video;

    // Configuration variable.
    #startTime;

    // Whether the player and its dependencies have loaded and are ready for use.
    #initialized = false;

    // The state of the player.
    #_state = UNINITIALIZED;


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



    onElapsedTimeChange(subscriber) {
        this.#subscribers.push(subscriber);
    }


    /**
     * Initialize and load the YouTube iframe player to the element with the specified id.
     * @param {string} elemId 
     */
    async load(elemId) {



        return new Promise((resolve, reject) => {

            // Executes when the player instance is actually ready to interact with.
            // Technically this happens after initialization.
            const onReady = (event) => {
                // We will only start emitting player statuses if the user indicates they want to load and interact* with the player.
                // we should do the reverse when we want to tear down this instance.
                this.startPublishing();
                this.#player = event.target; // interesting this is the fully functioning player; perhaps unlike the `new YT.Player()` call, below.
                this.#_state = event.data;
                console.log(event);
            };

            const onYouTubeIframeAPIReady = () => {
                AudioPlayer.scriptsReady = true;
                this.#player = document.getElementById(elemId);

                if (null != this.#player) {
                    this.#initialized = true;
                    console.log("Audio Player is initialized.");
                    resolve(this);
                }

                else reject("DOM_ELEMENT_MISSING");
            };


            onYouTubeIframeAPIReady();


        });
    }


    /**
     * The destroy() method should remove event listeners and free up any other resources used by the player.
     * 
     * @returns {boolean}
     */
    destroy() {
        this.#_state = UNINITIALIZED;
        this.removeSubscribers();
        this.stopPublishing();
        // this.#player.destroy(); // for youtube only
        this.#player = null;
        this.#video = null;
        console.log("Audio Player is destroyed.");
        this.#initialized = false;
    }


    // "Cue" refers to a signal or prompt that indicates a specific action or change.
    cue(video, startTime) {
        this.#video = video;
        this.#startTime = startTime;
    }

    play() {

        this.#player.play();

    }

    pause() {
        this.#player.pause();
    }

    restart(time) {
        this.#player.currentTime = time;
        this.play();
    }

    stop() {
        this.#player.pause();
    }

    seekTo(time) {
        if (this.#player && typeof this.#player.currentTime !== "undefined") {
            const duration = this.#player.duration;

            // Clamp the seek time within the media duration
            if (!isNaN(duration)) {
                this.#player.currentTime = Math.min(Math.max(time, 0), duration);
            } else {
                console.warn("Unable to seek: media duration not available.");
            }

            this.publish(PLAYER_STATE_SEEKING);
        } else {
            console.warn("Player not ready or currentTime unsupported.");
        }
    }


    getDuration() {
        return this.#player.duration;
    }

    getCurrentTime() {
        return this.#player.currentTime;
    }

    getElapsedTime() {
        return Math.round(this.#player.currentTime);
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
                start: this.#startTime,
                autoplay: 1,
                modestbranding: 0,
                controls: 0,
                rel: 0,
                enablejsapi: 1
            },
            events: {
                onReady: onReady,
                onError: (event) => console.error(event),
                onStateChange: (event) => {
                    this.#_state = event.data;
                    let playerState = this.getPlayerState();
                    this.dispatchStateChange(playerState);
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
        let resourceId = this.#video ? this.#video.getResourceId() : "https://ocdla.app/content/uploads/modules/player/ac-2024/chapter-1.mp3";
        let elapsedTime = this.getElapsedTime();

        return {
            state: this.#_state,
            videoId: resourceId,
            resourceId,
            timestamp: elapsedTime, // Kept here temporarily for backwards-compatibility for other listeners.
            elapsedTime
        };
    }


    publish = (state) => {
        let playerState = this.getPlayerState();
        if (state) {
            playerState.state = state
        }
        console.log(playerState);
        this.dispatchStateChange(playerState);
        this.#subscribers.forEach((fn) => fn(JSON.stringify(playerState)));
    };

    startPublishing() {
        this.#broadcastId = setInterval(this.publish, PUBLISH_INTERVAL);
    }



    /**
     * dispatchStateChange
     * 
     */
    dispatchStateChange(playerState) {
        let e = new CustomEvent('mediastatechange', {
            detail: playerState,
            bubbles: true
        });
        this.#player.dispatchEvent(e);
    }


    stopPublishing() {
        clearInterval(this.#broadcastId);
        console.log("Stopped publishing.");
    }

    removeSubscribers() {
        this.#subscribers = [];
    }
}
