const iframeURL = "https://www.youtube.com/iframe_api";

export default class YoutubeDisplayController {

    configYoutubeDisplay(userWatchProgress, onPlayerReady) {
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
                widget_referrer: "http://localhost"
            },
            events: {
                onReady: onPlayerReady
            }
        };
    }
    injectScriptElement() {
        let tag = document.createElement('script');
        tag.src = iframeURL

        let firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    }
}
