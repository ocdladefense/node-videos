import moment from 'moment';
import Cache from './Cache';
import chunkArray from '../utils';
import Video from '../models/Video';

const YouTubeData = (function() {


    var parts = "snippet,contentDetails";
    var apiKey = process.env.API_KEY;
    var endpoint = "https://www.googleapis.com/youtube/v3/videos";
    let thumbs;
    let durations;

    async function load(ids) {
        ids = ids.join(",");
        let url = endpoint + "?part=" + parts + "&id=" + ids + "&key=" + apiKey;
        let statusCode;
        let ok;


        let response = await fetch(url)
            .then((resp) => {
                statusCode = resp.status;
                ok = resp.ok;
                return resp.json();
            })
            .then((json) => {
                if (ok) {
                    return ifOkay(json);
                }
                const errorReason = statusCode + ok + json.error.errors[0].reason;
                throw new Error(errorReason);
            })
            .finally(() => {
                statusCode = null;
                ok = null;
            });

        thumbs = response.map(item => ({
            id: item.id,
            thumbs: item.thumbs
        }));;
        durations = response.map(item => ({
            id: item.id,
            durations: item.duration
        }));;

        //console.log("thumbs + dura:", thumbs, durations);
    }


    function convertISODurationToSeconds(ISODuration) {
        if (typeof ISODuration === 'number' && !isNaN(ISODuration)) {
            return NaN;
        }
        return moment.duration(ISODuration).asSeconds();
    }


    function ifOkay(json) {
        return json.items.map(function(item) {
            var obj = {};
            var duration;

            duration = convertISODurationToSeconds(item.contentDetails.duration); //convert ISO to seconds

            //return object with resourceId, 5 thumbnail resolution urls, and total video duration (in seconds)
            obj["id"] = item.id;
            obj["thumbs"] = {
                default: item.snippet.thumbnails.default,
                high: item.snippet.thumbnails.high,
                maxres: item.snippet.thumbnails.maxres,
                medium: item.snippet.thumbnails.medium,
                standard: item.snippet.thumbnails.standard,
            };
            obj["duration"] = duration;

            return obj;
        });
    }

    function formatErrorMessage(error) {
        console.log("Error: ", error);
        console.log("Error Message:", error.message);



        if (json.status == 400) {
            return (json) => {
                if (json.error && json.error.errors && json.error.errors.length > 0) {
                    const errorReason = json.error.errors[0].reason || "";

                    console.log("400 error in fetch", errorReason);

                    if (errorReason == "missingRequiredParameter") {
                        throw new Error("Missing Required Parameter");
                    }
                }
                else {
                    throw new Error("Youtube API fetch error occured (400): " + response.status);
                }
            };
        }

        if (response.status == 403) {
            return response.json().then((json) => {
                if (json.error && json.error.errors && json.error.errors.length > 0) {
                    const errorReason = json.error.errors[0].reason || "";

                    console.log("403 error in fetch", errorReason);

                    if (errorReason == "quotaExceeded") {
                        throw new Error("Youtube API quota exceeded");
                    }
                    if (errorReason == "forbidden") {
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


    function getThumbs() {
        return thumbs || [];
    }

    function getDurations() {
        return durations || [];
    }



    return {
        convertISODurationToSeconds: convertISODurationToSeconds,
        load: load,
        getThumbs: getThumbs,
        getDurations: getDurations,
    };

})();

async function initData(videos) {

    let cache1 = new Cache("thumb.");
    let cache2 = new Cache("duration.");
    let map = new Map();

    const resourceIds = Video.getResourceIds(videos);

    const uncached = Cache.getUncached(resourceIds, cache1, cache2);

    const batches = chunkArray(uncached, 50);


    for (const batch of batches) {

        await YouTubeData.load(batch);

        YouTubeData.getDurations().forEach(item => {
            if (item.id) {
                cache2.set(item.id, item);
                map.set("duration." + item.id, item);
            }
        });

        YouTubeData.getThumbs().forEach(item => {
            if (item.id) {
                cache1.set(item.id, item);
                map.set("thumb." + item.id, item);
            }
        });
    }

    // console.log("cache:", cache.getCacheContents());
    // console.log("map:", map);

    //return cache.isEnabled() ? cache : map;
}



export function clearThumbCache() {
    const cache = new Cache();
    cache.clear();
    console.log("cache cleared.");
}

export default initData;
export { YouTubeData };
