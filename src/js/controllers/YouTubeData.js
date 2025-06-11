import { chunkArray } from '../utils';
import { convertISODurationToSeconds } from '../utils';

const YouTubeData = (function() {


    const YOUTUBE_DATA_API_LIMIT = 50;

    var parts = "snippet,contentDetails";
    var apiKey = process.env.API_KEY;
    var endpoint = "https://www.googleapis.com/youtube/v3/videos";
    let thumbs = [];
    let durations = [];

    async function load(ids) {

        const batches = chunkArray(ids, YOUTUBE_DATA_API_LIMIT);

        for (const batch of batches) {

            let response = await doCallout(batch);

            let tmp1 = response.map(item => ({
                id: item.id,
                thumbs: item.thumbs
            }));

            let tmp2 = response.map(item => ({
                id: item.id,
                durations: item.duration
            }));

            thumbs.concat(tmp1);
            durations.concat(tmp2);

        }

    }


    async function doCallout(ids) {
        ids = ids.join(",");
        let url = endpoint + "?part=" + parts + "&id=" + ids + "&key=" + apiKey;
        let statusCode;
        let ok;


        return await fetch(url)
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
        load: load,
        getThumbs: getThumbs,
        getDurations: getDurations,
    };

})();




export { YouTubeData };
