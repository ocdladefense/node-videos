import { Outlet } from 'react-router-dom';
import { useEffect, useState } from 'react';
import Header from "./Header";
import Footer from "./Footer";
import YouTubePlayer from '../js/player/YouTubePlayer.js';
import WatchedVideoService from '../js/services/WatchedVideoService.js'
import PurchasedVideoService from '../js/services/PurchasedVideoService.js'
import User from '../js/models/User.js';
import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';
import Video from '../js/models/Video.js';
import initThumbs from '../js/controllers/VideoThumbs';
import VideoDataParser from "../js/controllers/VideoDataParser.js";
import { clearThumbCache } from '../js/controllers/VideoThumbs';
window.clearCache = clearThumbCache;


const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;
const SF_USER_ID = process.env.SF_USER_ID;


window.playerMap = {
    youtube: YouTubePlayer,
};

// Player instance used throughout the application lifecycle.
const player = new YouTubePlayer();
// let user = {}; //getCurrentUser();




let user = new User(SF_USER_ID || "005VC00000ET8LZ");
window.user = user;


// Top-level reference to the "parser" that can return various lists of videos.
let parser = new VideoDataParser();

const query = 'SELECT Id, Name, Description__c, Event__c, Event__r.Name, Event__r.Start_Date__c, Speakers__c, ResourceId__c, Date__c, Published__c, IsPublic__c FROM Media__c ORDER BY Event__r.Start_Date__c DESC NULLS LAST';

// @jbernal - previously in index.js
// Retrieve video data and related thumbnail data.
async function getVideoParser() {

    let api = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);
    let resp = await api.query(query);
    parser.parse(resp.records);

    let videos = parser.getVideos();

    // Default thumb in case there is no available image.
    Video.setDefaultThumbnail('http:/foobar');

    const videoDataMap = await initThumbs(videos); // should be initThumbs(parser.getVideoIds());
    console.log("init thumbs returned:", videoDataMap);

    parser.getVideos().forEach(video => {
        const videoData = videoDataMap.get(video.resourceId);

        if (videoData) {
            video.setThumbnail(videoData.thumbs);
            video.setDuration(videoData.duration);
        }
    });


    return parser;
}




export default function App() {

    const [appReady, setAppReady] = useState(false);
    const [selectedVideo, setSelectedVideo] = useState(null);
    const [route, setRoute] = useState("list");
    let component, hasWatched, purchasedVideo;



    if (selectedVideo != null) {
        hasWatched = user.getWatchedVideo((selectedVideo && selectedVideo.getVideoResourceId()));
        purchasedVideo = user.getPurchasedVideo((selectedVideo && selectedVideo.getVideoResourceId()));
    }
    const [hasAccess, setHasAccess] = useState(() => purchasedVideo != null || (selectedVideo && selectedVideo.isFree()));

    useEffect(() => {

        let s1 = new WatchedVideoService(user.getUserId());
        s1.listen();
        let s2 = new PurchasedVideoService(user.getUserId());
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
    }, []);


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
                {!parser.isInitialized() ? <h1>My splash screen</h1> : <Outlet context={{ parser, user, player }} />}
            </div>
            <Footer />
        </>
    );
}

