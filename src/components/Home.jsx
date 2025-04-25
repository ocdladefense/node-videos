import React, { useEffect, useState } from 'react';
import VideoPlayer from './VideoPlayer';
/*
/// Components:
- home (Master Component);                                                                   Check[X]
- app (second componet);
*/

export default function Home({ videos }) {
    const [videosState, setVideos] = useState([]);
    const [selectedVideo, setSelectedVideo] = useState(null);

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
                    <h2>Here is the list of videos!</h2>
                    <ul className="video-list">
                        {videos.map((video, index) => (
                            <li
                                key={video.id || index}
                                onClick={() => setSelectedVideo(video)}
                                style={{ cursor: 'pointer', marginBottom: '1rem' }}
                            >
                                <div>
                                    <img
                                        src={video.thumbnail}
                                        alt={'Thumbnail for ${video.title}'}
                                    />
                                    <strong>{video.getVideoName ? video.getVideoName() : video.title}</strong>
                                    <ul>
                                        <li>{video.getVideoDescription ? video.getVideoDescription() : video.description}</li>
                                        <li>{video.getVideoFree ? String(video.getVideoFree()) : 'N/A'}</li>
                                    </ul>
                                </div>
                            </li>
                        ))}
                    </ul>
                </>
            ) : (
                    <VideoPlayer video={selectedVideo} onBack={() => setSelectedVideo(null)} />
            )}
        </div>
    );
}