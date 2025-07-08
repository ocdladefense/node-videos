import { chunkArray } from '../utils';
import { convertISODurationToSeconds } from '../utils';



let thumbs = [], durations = [];



export function getThumbs() {
    return thumbs || [];
}


export function getDurations() {
    return durations || [];
}


const YouTubeData = (function() {


    const YOUTUBE_DATA_API_LIMIT = 50;

    var parts = "snippet,contentDetails";
    var apiKey = process.env.API_KEY;
    var endpoint = "https://www.googleapis.com/youtube/v3/videos";


    async function load(ids) {

        const batches = chunkArray(ids, YOUTUBE_DATA_API_LIMIT);

        for (const batch of batches) {

            let resp = await doCallout(batch);

            let tmp1 = resp.map(item => ({
                id: item.id,
                thumbs: item.thumbs
            }));

            let tmp2 = resp.map(item => ({
                id: item.id,
                durations: item.duration
            }));

            thumbs.push(...tmp1);
            durations.push(...tmp2);

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





    return { load };

})();




export { YouTubeData };
