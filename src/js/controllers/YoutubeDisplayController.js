const iframeURL = "https://www.youtube.com/iframe_api";

export default class YoutubeDisplayController {

    configYoutubeDisplay(userWatchProgress, onPlayerReady) {
        return {
            height: '720',
            width: '1280',
            videoId: userWatchProgress.resourceId,
            playerVars: {
                controls: 0,
                start: userWatchProgress.timeStamp,
                showinfo: 0,
                modestbranding: 1,
                rel: 0,
                fs: 0,
                disablekb: 1,
                iv_load_policy: 3,
                playsinline: 1
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
