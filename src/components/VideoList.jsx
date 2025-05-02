import React from 'react';
import TitleComponent from './TitleComponent';


export default function VideoList({ video, videos, setSelectedVideo, setRoute }) {

    return (
        <div>
            <ul className="video-list grid grid-cols-5 gap-7 text-white bg-black">
                {videos.map((video, index) => (
                    <TitleComponent video={video} index={index} setRoute={setRoute} setSelectedVideo={setSelectedVideo} />
                ))}
            </ul>
        </div>

    );

}
