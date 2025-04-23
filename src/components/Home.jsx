import React, { useEffect, useState } from 'react';
import VideoPlayer from './VideoPlayer';
//import forecast from '../data/data.json';
/*

/// Components:
- home (Master Component);                                                                   Check[X]
- app (second componet);
-
*/

export default function Home() {
  const [videos, setVideos] = useState([]);
  const [selectedVideo, setSelectedVideo] = useState(null);

  useEffect(() => {
    fetch('/data/videos.json')
      .then(res => res.json())
      .then(data => {console.log("Fetched videos:", data); setVideos(data);})
      .catch(err => console.error('Failed to load videos:', err));
  }, []);

  return (
    <div className="app">
      {!selectedVideo ? (
        <>
          <h2>Here is the list off videos!</h2>
          <ul className="video-list">
            {videos.map(video => (
              <li key={video.id} onClick={() => setSelectedVideo(video)} style={{ cursor: 'pointer', marginBottom: '1rem' }}>
                <div><strong>{video.description}</strong></div>
              </li>
            ))}
          </ul>
        </>
      ) : (
        <VideoPlayer video={selectedVideo} onBack={() => setSelectedVideo(null)} />
        //if video is selected and is not null it will show componet called VideoPlayer 
      )}


<>
<h2>Here is the list of videos!</h2>

<ul>
  {videos.map((video, index) => (
    <li key={index}>{video.getVideoName()}
        <ul>
            <li>{video.getVideoDescription()}</li>
            <li>{String(video.getVideoFree())}</li>
        </ul>
    </li>
  ))}
</ul>
</>
    </div>
  );
}
