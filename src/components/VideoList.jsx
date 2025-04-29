import React from 'react';
import TitleComponent from './TitleComponent';


export default function VideoList({videos, setSelectedVideo, setRoute}) {

return (
    <>
        <h2>Here is the list of videos!</h2>
        <ul className="video-list">
            {videos.map((video, index) => (
                <TitleComponent video={video} index={index} setRoute={setRoute} setSelectedVideo={setSelectedVideo} />
            ))}
        </ul>
    </>

);

}
