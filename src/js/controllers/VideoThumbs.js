const VideoThumbnails = (function () {


    var parts = "snippet,contentDetails,statistics";
    var videoId = ["4mxFb5VH12Y"];
    var apiKey = process.env.API_KEY;
    //var apiKey = "";
    var endpoint = "https://www.googleapis.com/youtube/v3/videos";

    async function getThumbs(ids) {
        ids = ids.join(",");
        let url = endpoint + "?part=" + parts + "&id=" + ids + "&key=" + apiKey;

        return fetch(url)
            .then((response) => {
                if(response.status == 400) {
                    return response.json().then((json) => {
                        if(json.error && json.error.errors && json.error.errors.length > 0) {
                            const errorReason = json.error.errors[0].reason || "";

                            console.log("400 error in fetch", errorReason);

                            if(errorReason == "missingRequiredParameter") {
                                throw new Error("Missing Required Parameter");
                            }
                        }
                        else {
                            throw new Error("Youtube API fetch error occured (400): " + response.status);
                        }
                    });
                }
                if(response.status == 403) {
                    return response.json().then((json) => {
                        if(json.error && json.error.errors && json.error.errors.length > 0) {
                            const errorReason = json.error.errors[0].reason || "";

                            console.log("403 error in fetch", errorReason);

                            if(errorReason == "quotaExceeded") {
                                throw new Error("Youtube API quota exceeded");
                            }
                            if(errorReason == "forbidden") {
                                throw new Error("Authorization failed, access is forbidden");
                            }
                        }
                        else {
                            throw new Error("Youtube API fetch error occured (403): " + response.status);
                        }
                    });
                }
                if (!response.ok) {
                    throw new Error(`Error: ${response.status} ${response.statusText}`);
                }

                  return response.json();
            }).then((json) => {
                    return json.items.map(function (item) {
                        var obj = {};
                        obj["id"] = item.id;
                        // Store all 5 resolutions for the thumbnail.
                        obj["thumbs"] = {
                          default: item.snippet.thumbnails.default,
                          high: item.snippet.thumbnails.high,
                          maxres: item.snippet.thumbnails.maxres,
                          medium: item.snippet.thumbnails.medium,
                          standard: item.snippet.thumbnails.standard,
                        };
                        //console.log("Thumbnail object:", obj);
                        return obj;
                      });
                    }).catch((error) => {
                        console.error("Error fetching thumbnails:", error);
                        throw error;
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

    let cache = new ThumbnailCache();
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
        //push to Salesforce
    };

    hasKey(key) {
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
export { VideoThumbnails };
export const getThumbs = VideoThumbnails.getThumbs;
