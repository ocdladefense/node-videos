const iframeURL = "https://www.youtube.com/iframe_api";

export default class YoutubeDisplayController {
    
    configYoutubeDisplay(videoData, index ,onPlayerReady) {
        return {
            height: '390',
            width: '640',
            videoId: videoData[index].getVideoResourceId(),
            playerVars: {
                autoplay: 0,
                rel: 0,
                controls: 0
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
