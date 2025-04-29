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

        return thumbs.then(function(resp) {
            return resp.json();
        })
            .then(function(json) {
                //console.log(json);
                return json.items.map(function(item) {
                    console.log("item from getThumbs", item);
                    var obj = {};
                    var id = item.id;
                    obj["id"] = id;
                    //obj["image"] = item.snippet.thumbnails.medium;

                    //update thumb collector to store all 5 resolutions
                    obj["thumbs"] = {
                        default: item.snippet.thumbnails.default,
                        high: item.snippet.thumbnails.high,
                        detailsView: item.snippet.thumbnails.maxres,
                        listView: item.snippet.thumbnails.medium,
                        standard: item.snippet.thumbnails.standard,
                    }
                    console.log(obj);
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

    var prepareThumbnailData = function(chapters) {

        var published = chapters.filter(function(chapter) { return chapter.VideoURL != null && chapter.PublishVideo != false; });
        console.log("Chapters are: ", published);

        videoIds = published.map(function(chapter) {
            return chapter.VideoURL;
        });
        return getThumbs(videoIds).then(function(thumbs) {
            console.log("Thumbs are: ", thumbs);
            return chapters.map(function(chapter) {
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

//add thumbnail metadeta as function for appending data
async function initThumbs(videos) {
    const videoIDs = videos.map(video => video.resourceId);
    const cachedThumbs = getCachedThumbs(); //determine which thumbs have already been cached

    const uncachedIDs = videoIDs.filter(id => !cachedThumbs[id]); //check for thumbs that havent been cached, and therefore need to be fetched
    const uncollectedThumbs = chunkArray(uncachedIDs, 50);
    const thumbnailMap = { ...cachedThumbs };

    for (const batch of uncollectedThumbs) {
        try {
            const data = await VideoThumbnails.getThumbs(batch);
            data.forEach(thumbData => {
                thumbnailMap[thumbData.id] = thumbData.thumbs.listView.url;
                //thumbnailMap[thumbData.id] = thumbData.thumbs;
            });
        } catch (error) {
            console.error("Error fetching thumbs", chunk, error);
        }
    }

    //console.log("thumbnailMap", thumbnailMap);
    //console.log(`Total items in thumbnailMap: ${Object.keys(thumbnailMap).length}`);

    updateCachedThumbs(thumbnailMap);

    return thumbnailMap;
}

function chunkArray(array, size) {
    const chunks = [];
    for (let i = 0; i < array.length; i += size) {
        chunks.push(array.slice(i, i + size));
    }
    return chunks;
}

function getCachedThumbs() {
    const cached = localStorage.getItem("thumbnailMap");
    return cached ? JSON.parse(cached) : {};
}

function updateCachedThumbs(newThumbnails) {
    const existingCache = getCachedThumbs();
    const updatedCache = { ...existingCache, ...newThumbnails };
    localStorage.setItem("thumbnailMap", JSON.stringify(updatedCache));
    return updatedCache;
}

export function clearThumbCache() {
    localStorage.removeItem("thumbnailMap"); // Remove the thumbnail cache
    console.log("Thumbnail cache cleared.");
}

export default initThumbs;