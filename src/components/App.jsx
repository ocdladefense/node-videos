import { Outlet } from 'react-router-dom';
import { useEffect, useState } from 'react';
import Header from "./Header";
import Footer from "./Footer";
import User from '../js/models/User.js';
import Video from '../js/models/Video.js';
import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';
import { getCookie } from '@ocdla/salesforce/CookieUtils.js';
import WatchedVideoService from '../js/services/WatchedVideoService.js'
import PurchasedVideoService from '../js/services/PurchasedVideoService.js'
import VideoDataParser from "../js/controllers/VideoDataParser.js";
import Cache from '../js/controllers/Cache.js';
import { YouTubeData, getThumbs, getDurations } from '../js/controllers/YouTubeData.js';



const SF_USER_ID = process.env.SF_USER_ID;
const query = 'SELECT Id, Name, Description__c, Event__c, Event__r.Name, Event__r.Start_Date__c, Speakers__c, ResourceId__c, Date__c, Published__c, IsPublic__c FROM Media__c ORDER BY Event__r.Start_Date__c DESC NULLS LAST';



let user = new User(SF_USER_ID || "005VC00000ET8LZ");
let parser = new VideoDataParser();
let access_token, instance_url;
window.user = user;




function isLoggedIn() {

    let sessionInstanceUrl = getCookie("instanceUrl");
    let sessionAccessToken = getCookie("accessToken");

    if (process.env.SF_OAUTH_SESSION_ACCESS_TOKEN_OVERRIDE) {
        sessionInstanceUrl = process.env.SF_OAUTH_SESSION_INSTANCE_URL_OVERRIDE;
        sessionAccessToken = process.env.SF_OAUTH_SESSION_ACCESS_TOKEN_OVERRIDE;
    }

    return !!sessionAccessToken;
}

// @jbernal - previously in index.js
// Retrieve video data and related thumbnail data.
async function getVideoParser() {

    let sessionInstanceUrl, sessionAccessToken;
    let applicationInstanceUrl, applicationAccessToken;

    // Check if there are cookies to use for instance_url and access_token.
    if (process.env.NODE_ENV == 'production') {
        console.log("NODE PRODUCTION ENV!");
        let applicationTokens = await fetch("/connect").then(resp => resp.json());
        applicationInstanceUrl = applicationTokens.instance_url;
        applicationAccessToken = applicationTokens.access_token;
    }

    sessionInstanceUrl = getCookie("instanceUrl");
    sessionAccessToken = getCookie("accessToken");



    if (process.env.SF_OAUTH_SESSION_ACCESS_TOKEN_OVERRIDE) {
        sessionInstanceUrl = process.env.SF_OAUTH_SESSION_INSTANCE_URL_OVERRIDE;
        sessionAccessToken = process.env.SF_OAUTH_SESSION_ACCESS_TOKEN_OVERRIDE;
    }


    let cache1 = new Cache("thumb");
    let cache2 = new Cache("duration");


    let session = new SalesforceRestApi(sessionInstanceUrl, sessionAccessToken);
    let application = new SalesforceRestApi(applicationInstanceUrl, applicationAccessToken);
    user.setApi(session);

    let resp = await application.query(query);
    parser.parse(resp.records);

    // Default thumb in case there is no available image.
    Video.setDefaultThumbnail('http:/foobar');


    let videos = parser.getVideos();



    const resourceIds = Video.getResourceIds(videos);
    const uncached = resourceIds;//Cache.getUncached(, cache1, cache2);

    let foo = await YouTubeData.load(uncached);

    let thumbs = getThumbs();
    let durations = getDurations();

    thumbs.forEach(item => {
        cache1.set(item.id, item);
    });

    durations.forEach(item => {
        cache2.set(item.id, item);
    });



    videos.forEach(video => {
        const thumbs = cache1.get(video.resourceId);
        const durations = cache2.get(video.resourceId);

        if (thumbs) {
            video.setThumbnail(thumbs.thumbs);
        }

        if (durations) {
            video.setDuration(durations.durations);
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

            if (records == null) {
                //throw new Error("No records found. Check access token.")
                console.error("No records found. Check access token.");
            }

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




    return (
        <>
            <Header loggedIn={isLoggedIn()} />
            <div className="container mx-auto">
                {!parser.isInitialized() ? <h1>My splash screen</h1> : <Outlet context={{ parser, user }} />}
            </div>
            <Footer />
        </>
    );
}

