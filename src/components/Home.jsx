import React, { useEffect, useState } from 'react';
import VideoList from './VideoList';
import VideoDetails from './VideoDetails';
import VideoPlayerContainer from './player/VideoPlayerContainer.jsx';
import YouTubePlayer from '../js/player/YouTubePlayer.js';
import UserService from '../js/services/UserService.js';
import WatchedVideoService from '../js/services/WatchedVideoService.js'
import Video from '../js/models/Video.js';


window.playerMap = {
    youtube: YouTubePlayer,
};

// Player instance used throughout the application lifecycle.
const player = new YouTubePlayer();
// let user = {}; //getCurrentUser();


export default function Home({ parser, user }) {

    const [selectedVideo, setSelectedVideo] = useState(null);
    const [route, setRoute] = useState("list");
    let component, hasWatched, purchasedVideo;



    if (selectedVideo != null) {
        hasWatched = user.getWatchedVideo((selectedVideo && selectedVideo.getVideoResourceId()));
        purchasedVideo = user.getPurchasedVideo((selectedVideo && selectedVideo.getVideoResourceId()));
    }
    const [hasAccess, setHasAccess] = useState(() => purchasedVideo != null || (selectedVideo && selectedVideo.isFree()));

    useEffect(() => {
        let s1 = new UserService(user);
        s1.listen();

        let s2 = new WatchedVideoService();
        s2.listen()
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
