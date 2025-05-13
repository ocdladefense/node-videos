import Time from '../models/Time.js';

let formattedTime;
let videoDuration;

export default class YoutubeDisplayController {

    configYoutubeDisplay(userWatchProgress, onPlayerReady, onStateChange) {
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
                onReady: onPlayerReady,
                onStateChange: onStateChange
            }
        };
    }
    injectScriptElement() {
        let tag = document.createElement('script');
        tag.src = "https://www.youtube.com/iframe_api";

        let firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    }
    getFormattedTime(duration) {
        return (formattedTime = Time.parseTime(duration));
    }
    getVideoDuration(player) {
        return videoDuration = player.getDuration();
    }
}
