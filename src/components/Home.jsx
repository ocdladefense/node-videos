import React, { useEffect, useState } from 'react';
import VideoList from './VideoList';
import VideoDetails from './VideoDetails';
import VideoPlayerContainer from './VideoPlayerContainer';
import VideoPlayer from './VideoPlayer';

/*
/// Components:
- home (Master Component);                                                                   Check[X]
- app (second componet);
*/

export default function Home({ videos, user }) {
    const [videosState, setVideos] = useState([]);
    const [selectedVideo, setSelectedVideo] = useState(null);
    const mockIndex = 1;

    const [route, setRoute] = useState("list");
    // For now, we need a way to reliably switch to the "player" scene.
    // route = "player";

    let component = null;

    useEffect(() => {
        fetch('/data/videos.json')
            .then(res => res.json())
            .then(data => { console.log("Fetched videos:", data); setVideos(data); })
            .catch(err => console.error('Failed to load videos:', err));
    }, []);

    if (route == "list") {
        component = <VideoList videos={videos} setRoute={setRoute} setSelectedVideo={setSelectedVideo} />;
    } else if (route == "details") {
        component = <VideoDetails video={selectedVideo} setRoute={setRoute} onBack={() => { setRoute("list"); setSelectedVideo(null); }} />;
    } else if (route == "player") {
        // component = <VideoPlayerContainer video={selectedVideo} index={mockIndex} />;
        console.log()
        component = <VideoPlayer video={selectedVideo} user={user} />
    }

    return (
        <div className="app">{component}</div>
    );
}
