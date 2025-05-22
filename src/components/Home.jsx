import React, { useEffect, useState } from 'react';
import VideoList from './VideoList';
import VideoDetails from './VideoDetails';
import VideoPlayerContainer from './VideoPlayerContainer';
import YouTubePlayer from '../js/player/YouTubePlayer.js';



window.playerMap = {
    youtube: YouTubePlayer,
};




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

        // Only needs to be instantiated once during the player lifecycle.
        let player = new YouTubePlayer();
        // let user = {}; //getCurrentUser();
        // player.queueVideo(video);
        // player.setUserVideoPrefs(user.getWatchedVideoPrefs(video.id));
        component = <VideoPlayerContainer player={player} video={selectedVideo} user={user} onBack={() => { setRoute("details"); }} />
    }

    /*
    else if (route == "resetPlayer") {
        component = <VideoPlayerContainer resetTimestamp={resetTimestamp} video={selectedVideo} user={user} onBack={() => { setRoute("details"); }} />
    }
    */


    return (
        <div className="app">{component}</div>
    );
}
