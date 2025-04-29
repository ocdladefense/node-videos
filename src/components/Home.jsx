import React, { useEffect, useState } from 'react';
import VideoPlayer from './VideoPlayer';
import Player from './Player';
import TitleComponent from './TitleComponent';
import VideoDetails from './VideoDetails';
/*
/// Components:
- home (Master Component);                                                                   Check[X]
- app (second componet);
*/

export default function Home({ videos }) {
    const [videosState, setVideos] = useState([]);
    const [selectedVideo, setSelectedVideo] = useState(null);
    const mockIndex = 1;

    useEffect(() => {
        fetch('/data/videos.json')
            .then(res => res.json())
            .then(data => { console.log("Fetched videos:", data); setVideos(data); })
            .catch(err => console.error('Failed to load videos:', err));
    }, []);
    return (
        <div className="app">
            {!selectedVideo ? (
                <>
                    <Player videoData={videos} index={mockIndex} />
                    <h2>Here is the list of videos!</h2>
                    <ul className="video-list">
                        {videos.map((video, index) => (
                           <TitleComponent video={video} index={index} setSelectedVideo={setSelectedVideo} />
                        ))}
                    </ul>
                </>
            ) : (
                     <VideoDetails video={selectedVideo} onBack={() => setSelectedVideo(null)} />
            )}
        </div>
    );
}
