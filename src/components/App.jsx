import { Routes, Route } from 'react-router-dom';
import { useEffect, useState } from 'react';
import Header from "./Header";
import Footer from "./Footer";
// import Home from "./Home";
import VideoList from './VideoList';
import VideoDetails from './VideoDetails';
import VideoPlayerContainer from './player/VideoPlayerContainer';
import YouTubePlayer from '../js/player/YouTubePlayer.js';
import WatchedVideoService from '../js/services/WatchedVideoService.js'
import PurchasedVideoService from '../js/services/PurchasedVideoService.js'
import User from '../js/models/User.js';


window.playerMap = {
    youtube: YouTubePlayer,
};

// Player instance used throughout the application lifecycle.
const player = new YouTubePlayer();
// let user = {}; //getCurrentUser();




let user = new User("005VC00000ET8LZ");


export function App2() {


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
                const timestamp = record.Timestamp__c;

                user.addPurchased({ resourceId, timestamp });
            });
        });

        s1.onSave((videoId, timestamp) => { console.log("SAVED! "); user.addWatched({ resourceId: videoId, timestamp }) });
        s2.onSave((videoId, timestamp) => { console.log("SAVED! "); user.addPurchased({ resourceId: videoId, timestamp }) });
    }, [])



    return (
        <>
            <Header />
            <div class="container mx-auto">
                <Routes>
                    <Route path="/" element={<VideoList setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />} />
                    <Route path="/details/:resourceId" element={<VideoDetails setRoute={setRoute} user={user} onBack={() => { setRoute("list"); }} setSelectedVideo={setSelectedVideo} hasWatched={hasWatched} hasAccess={hasAccess} elapsedTime={0} />} />
                    <Route path="/player" element={<VideoPlayerContainer player={player} video={selectedVideo} user={user} onBack={() => { setRoute("details"); }} />} />
                </Routes>
            </div>
            <Footer />
        </>
    );
}


export default function App() {


    return (
        <>
            <Header />
            {/* typeof HeaderTwo === "function" ? <HeaderTwo /> : <></> */}
            <div class="container mx-auto">
                <Home />
            </div>
            <Footer />
        </>
    );
}
