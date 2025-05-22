import React, { useEffect, useState } from 'react';
import VideoList from './VideoList';
import VideoDetails from './VideoDetails';
import VideoPlayerContainer from './VideoPlayerContainer';
import YouTubePlayer from '../js/player/YouTubePlayer.js';

/*
/// Components:
- home (Master Component);                                                                   Check[X]
- app (second componet);
*/


window.playerMap = {
    youtube: YouTubePlayer,
};


export default function Home({ parser, user }) {
    const [videosState, setVideos] = useState([]);
    const [selectedVideo, setSelectedVideo] = useState(null);
    const resetTimestamp = 0;

    const [route, setRoute] = useState("list");
    // For now, we need a way to reliably switch to the "player" scene.
    // route = "player";

    let component = null;



    if (route == "list") {
        component = <VideoList parser={parser} setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />;

    } else if (route == "details") {
        component = <VideoDetails video={selectedVideo} setRoute={setRoute} onBack={() => { setRoute("list"); setSelectedVideo(null); }} user={user} />;

    } else if (route == "player") {

        // Only needs to be instantiated once during the player lifecycle.
        let player = new YouTubePlayer();
        // let user = {}; //getCurrentUser();
        // player.queueVideo(video);
        // player.setUserVideoPrefs(user.getWatchedVideoPrefs(video.id));
        component = <VideoPlayerContainer player={player} video={selectedVideo} user={user} onBack={() => { setRoute("details"); }} />

    }

    else if (route == "resetPlayer") {
        component = <VideoPlayerContainer resetTimestamp={resetTimestamp} video={selectedVideo} user={user} onBack={() => { setRoute("details"); }} />
    }


    console.log("users previously watched vids", user.getPreviouslyWatchedVideos());
    if (selectedVideo) console.log("get watched vid by id", user.getWatchedVideo(selectedVideo.resourceId));
    return (
        <div className="app">{component}</div>
    );
}
