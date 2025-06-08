

/**
 * https://developers.google.com/youtube/iframe_api_reference#Requirements
 * Embedded players must have a viewport that is at least 200px by 200px. If the player displays controls, it must be large enough to fully display the controls without shrinking the viewport below the minimum size. We recommend 16:9 players be at least 480 pixels wide and 270 pixels tall.
 */
export default class MediaPlayer {



    constructor() {

    }

    init() {

    }

    load() {

    }

    play() {

    }


    /**
     * 
     * @param {Video} video 
     In summary, "cue" is a signal or prompt, especially in performance contexts, while "queue" is a line or sequence of people or things waiting in an orderly manner.
     */
    cue(video) {

    }

    restart() { }

    pause() { }

    stop() { }

    seekTo() { }

    setVolume() { }

    getDuration() { }

    getCurrentTime() { }


    getMediaPlayerEvent(resourceId, elapsedTime) {
        return this.mediaEvent = new CustomEvent('mediastatechange', {
            detail: { resourceId: resourceId, timestamp: elapsedTime, elapsedTime: elapsedTime },
            bubbles: true
        });
    }
}




