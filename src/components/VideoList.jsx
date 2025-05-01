import React from 'react';
import TitleComponent from './TitleComponent';


export default function VideoList({ video, videos, setSelectedVideo, setRoute }) {

    return (
        <>
            <h2>Here is the list of videos!</h2>
            <ul className="video-list grid grid-cols-4 gap-4">
                {videos.map((video, index) => (
                    <TitleComponent video={video} index={index} setRoute={setRoute} setSelectedVideo={setSelectedVideo} />
                ))}
            </ul>
        </>

    );

}
