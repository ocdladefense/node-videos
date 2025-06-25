import { Outlet } from 'react-router-dom';
import { useEffect, useState } from 'react';
import Header from "./Header";
import Footer from "./Footer";
import WatchedVideoService from '../js/services/WatchedVideoService.js'
import PurchasedVideoService from '../js/services/PurchasedVideoService.js'
import User from '../js/models/User.js';
import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';
import Video from '../js/models/Video.js';
import VideoDataParser from "../js/controllers/VideoDataParser.js";
import Cache, { clearThumbCache } from '../js/controllers/Cache.js';
import { YouTubeData } from '../js/controllers/YouTubeData.js';
window.clearCache = clearThumbCache;


const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;
const SF_USER_ID = process.env.SF_USER_ID;




let user = new User(SF_USER_ID || "005VC00000ET8LZ");
window.user = user;


// Top-level reference to the "parser" that can return various lists of videos.
let parser = new VideoDataParser();

/**
 * 
 * applicatonData
 * appData = new ApplicationData();
 * 
 * let media = appData.get('media');
 * let seminars = appData.get('seminars');
 * let lists = appData.get('lists');
 * let videos = appData.get('media').filter();
 * let audio ....
 * let thumbs = appData.get('thumbs');
 * 
 * class ApplicationData {
 * 
 * 
 * 
 * 
 * get(key, useCache?) {
 * 
 *    return !useCache ? this[key]() : 
 * 
 * }
 * 
 * 
 * 
 * }
 * 
 */




let access_token, instance_url;


const query = 'SELECT Id, Name, Description__c, Event__c, Event__r.Name, Event__r.Start_Date__c, Speakers__c, ResourceId__c, Date__c, Published__c, IsPublic__c FROM Media__c ORDER BY Event__r.Start_Date__c DESC NULLS LAST';

// @jbernal - previously in index.js
// Retrieve video data and related thumbnail data.
async function getVideoParser() {

    let tokens = await fetch("/connect").then(resp => resp.json());
    ({ access_token, instance_url } = tokens);


    let cache1 = new Cache("thumbs.");
    let cache2 = new Cache("durations.");


    let api = new SalesforceRestApi(instance_url, access_token);
    let resp = await api.query(query);
    parser.parse(resp.records);

    // Default thumb in case there is no available image.
    Video.setDefaultThumbnail('http:/foobar');


    let videos = parser.getVideos();


    videos.forEach(video => {
        const thumbData = cache1.get(video.resourceId);
        const durationData = cache2.get(video.resourceId);

        if (thumbData) {
            video.setThumbnail(thumbData.thumbs);
        }

        if (durationData) {
            video.setDuration(durationData.durations);
        }

    });


    const resourceIds = Video.getResourceIds(videos);

    const uncached = Cache.getUncached(resourceIds, cache1, cache2);



    await YouTubeData.load(uncached);


    YouTubeData.getThumbs().forEach(item => {
        if (item.id) {
            cache1.set(item.id, item);
            map.set("thumb." + item.id, item);
        }
    });


    YouTubeData.getDurations().forEach(item => {
        if (item.id) {
            cache2.set(item.id, item);
            map.set("duration." + item.id, item);
        }
    });

    return parser;
}




export default function App() {

    const [appReady, setAppReady] = useState(false);


    useEffect(() => {

        if (!appReady) return;

        let s1 = new WatchedVideoService(instance_url, access_token);
        s1.setUserId(user.getUserId());
        s1.listen();

        let s2 = new PurchasedVideoService(instance_url, access_token);
        s2.setUserId(user.getUserId());
        s2.listen();  // can listen for mediapurchase events!

        // Get data from each Service's load() method,
        // and use it consistent with this application's logic.
        // Specifically, we add data to the user object for future use.

        // WatchedVideoService
        s1.load().then((resp) => {

            let records = resp.records;

            records.forEach(record => {
                const resourceId = record.ResourceID__c;
                const timestamp = record.Timestamp__c;

                user.addWatched({ resourceId, timestamp });
            });
        });

        // PurchasedVideoService
        s2.load().then((resp) => {
            let records = resp.records;

            records.forEach(record => {
                const resourceId = record.ResourceID__c;
                const timestamp = 0;//record.Timestamp__c;

                user.addPurchased({ resourceId, timestamp });
            });
        });

        s1.onSave((videoId, timestamp) => { user.addWatched({ resourceId: videoId, timestamp }) });
        s2.onSave((videoId, timestamp) => { user.addPurchased({ resourceId: videoId, timestamp }) });
    }, [appReady]);


    useEffect(() => {
        async function fn() {
            parser = await getVideoParser();
            setAppReady(true);
        }
        fn();
    }, []);


    //  
    return (
        <>
            <Header />
            <div class="container mx-auto">
                {!parser.isInitialized() ? <h1>My splash screen</h1> : <Outlet context={{ parser, user }} />}
            </div>
            <Footer />
        </>
    );
}

