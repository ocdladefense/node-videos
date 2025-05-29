import { useEffect, useState } from 'react';
import VideoList from './VideoList';
import VideoDetails from './VideoDetails';
import VideoPlayerContainer from './VideoPlayerContainer';
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


export default function Home({ parser }) {

    const [selectedVideo, setSelectedVideo] = useState(null);
    const [route, setRoute] = useState("list");
    let component, hasWatched, purchasedVideo;



    if (selectedVideo != null) {
        hasWatched = user.getWatchedVideo((selectedVideo && selectedVideo.getVideoResourceId()));
        purchasedVideo = user.getPurchasedVideo((selectedVideo && selectedVideo.getVideoResourceId()));
    }
    const [hasAccess, setHasAccess] = useState(() => purchasedVideo != null || (selectedVideo && selectedVideo.isFree()));

    useEffect(() => {
        //  let s1 = new UserService(user);
        // s1.listen();

        let s2 = new WatchedVideoService(user.getUserId());
        s2.listen();
        let s3 = new PurchasedVideoService(user.getUserId());
        s3.listen();  // can listen for mediapurchase events!


        //append collected data to user object
        user.load(s2, (user, data) => {

            data.forEach(record => {
                const resourceId = record.ResourceID__c;
                const timestamp = record.Timestamp__c;

                user.addWatched({ resourceId, timestamp });
            });
        });

        s2.onSave((videoId, timestamp) => { console.log("SAVED! "); user.addWatched({ resourceId: videoId, timestamp }) });
    }, [])





    if (route == "list") {
        component = <VideoList setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />;

    }
    else if (route == "details") {

        component = <VideoDetails video={selectedVideo} setRoute={setRoute} onBack={() => { setRoute("list"); }} parser={parser} setSelectedVideo={setSelectedVideo} hasWatched={hasWatched} hasAccess={hasAccess} elapsedTime={0} />;
    }
    else if (route == "player") {
        // player.cueVideo(video);
        // player.setUserVideoPrefs(user.getWatchedVideoPrefs(video.id));
        component = <VideoPlayerContainer player={player} video={selectedVideo} user={user} onBack={() => { setRoute("details"); }} />
    }

    return component;
}
