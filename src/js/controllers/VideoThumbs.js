const VideoThumbnails = (function () {


    var parts = "snippet,contentDetails,statistics";
    var videoId = ["4mxFb5VH12Y"];
    var apiKey = "AIzaSyB95m4ud1CBRSP-4evnK_ng8CkMBG6Hyu0";
    var endpoint = "https://www.googleapis.com/youtube/v3/videos";

    async function getThumbs(ids) {
        ids = ids.join(",");

        let url = endpoint + "?part=" + parts + "&id=" + ids + "&key=" + apiKey;

        //$thumbs = fetch(url);
        let thumbs = fetch(url);

        return thumbs.then(function (resp) {
            return resp.json();
        })
            .then(function (json) {
                //console.log(json);
                return json.items.map(function (item) {
                    //console.log("item from getThumbs", item);
                    var obj = {};
                    var id = item.id;
                    obj["id"] = id;
                    //obj["image"] = item.snippet.thumbnails.medium;

                    //update thumb collector to store all 5 resolutions
                    obj["thumbs"] = {
                        default: item.snippet.thumbnails.default,
                        high: item.snippet.thumbnails.high,
                        maxres: item.snippet.thumbnails.maxres,
                        medium: item.snippet.thumbnails.medium,
                        standard: item.snippet.thumbnails.standard,
                    }
                    //console.log(obj);
                    return obj;
                });
            });

    }

    function getThumbById(thumbs, id) {
        if (null == id) return {};
        for (var i = 0; i < thumbs.length; i++) {
            if (id == thumbs[i].id) return thumbs[i];
        }
        return {};
    }

    var prepareThumbnailData = function (chapters) {

        var published = chapters.filter(function (chapter) { return chapter.VideoURL != null && chapter.PublishVideo != false; });
        console.log("Chapters are: ", published);

        videoIds = published.map(function (chapter) {
            return chapter.VideoURL;
        });
        return getThumbs(videoIds).then(function (thumbs) {
            console.log("Thumbs are: ", thumbs);
            return chapters.map(function (chapter) {
                chapter.thumb = getThumbById(thumbs, chapter.VideoURL);
                return chapter;
            });
        });
    };

    return {
        getThumbs: getThumbs,
        prepareThumbnailData: prepareThumbnailData
    };

})();

async function initThumbs(videos) {

    let cache = new ThumbnailCache(false);
    let thumbnailMap = new Map();

    const videoIDs = videos.map(video => video.resourceId);

    //check for thumbs that havent been cached, and therefore need to be fetched
    const uncachedIDs = videoIDs.filter(id => !cache.hasKey(id));

    //divide thumbs to collect to fit within api call size limits
    const uncollectedThumbs = chunkArray(uncachedIDs, 50);

    for (const batch of uncollectedThumbs) {
        try {
            //fetch for thumb data
            const data = await VideoThumbnails.getThumbs(batch);

            //cache thumb data
            data.forEach(thumbData => {
                cache.set(thumbData.id, thumbData.thumbs);
                thumbnailMap.set(thumbData.id, thumbData.thumbs);
            });
        } catch (error) {
            console.error("Error fetching thumbs", batch, error);
        }
    }

    //console.log("cache:", cache.getCacheContents());
    //console.log("thumbnailMap:", thumbnailMap)
    return cache.isEnabled() ? cache : thumbnailMap;
}

//for slicing data to handle youTube api limits
function chunkArray(array, size) {
    const chunks = [];
    for (let i = 0; i < array.length; i += size) {
        chunks.push(array.slice(i, i + size));
    }
    return chunks;
}

export function clearThumbCache() {
    const cache = new ThumbnailCache();
    cache.clear();
    console.log("Thumbnail cache cleared.");
}

class ThumbnailCache {
    static PREFIX = "thumb.";
    #enabled;

    constructor(enabled = true) {
        this.#enabled = enabled;
    }

    set(key, value) {
        if (this.#enabled === true) {
            localStorage.setItem(ThumbnailCache.PREFIX + key, JSON.stringify(value));
        }
    };

    get(key) {
        return JSON.parse(localStorage.getItem(ThumbnailCache.PREFIX + key));
    };

    clear() {
        localStorage.clear();
    };

    remove(key) {
        localStorage.removeItem(ThumbnailCache.PREFIX + key);
    };

    persist() {
        //push to longterm data storage
    };

    hasKey(key) {
        //key = Array.isArray(key) ? key : [key];
        return null == localStorage.getItem(ThumbnailCache.PREFIX + key) ? false : true;
    };

    isEnabled() {
        return this.#enabled;
    };

    getCacheContents() {
        let cacheContents = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            if (key.startsWith(ThumbnailCache.PREFIX)) {
                cacheContents[key] = JSON.parse(localStorage.getItem(key));
            }
        }
        return cacheContents;
    };
}

export default initThumbs;
