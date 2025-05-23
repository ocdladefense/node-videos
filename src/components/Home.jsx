import React, { useEffect, useState } from 'react';
import VideoList from './VideoList';
import VideoDetails from './VideoDetails';
import VideoPlayerContainer from './VideoPlayerContainer';
import YouTubePlayer from '../js/player/YouTubePlayer.js';



window.playerMap = {
    youtube: YouTubePlayer,
};

// Player instance used throughout the application lifecycle.
let player = new YouTubePlayer();
// let user = {}; //getCurrentUser();


export default function Home({ parser, user }) {

    const [selectedVideo, setSelectedVideo] = useState(null);
    const [route, setRoute] = useState("list");

    // Component to be returned as part of our rudimentary router, below.
    let component = null;


    if (route == "list") {
        component = <VideoList setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />;

    }
    else if (route == "details") {
        component = <VideoDetails video={selectedVideo} setRoute={setRoute} onBack={() => { setRoute("list"); }} user={user} parser={parser} setSelectedVideo={setSelectedVideo} />;

    }
    else if (route == "player") {
        // player.cueVideo(video);
        // player.setUserVideoPrefs(user.getWatchedVideoPrefs(video.id));
        component = <VideoPlayerContainer player={player} video={selectedVideo} user={user} onBack={() => { setRoute("details"); }} />
    }

    return (
        <div className="app">{component}</div>
    );
}
