import React from 'react';
import TitleComponent from './TitleComponent';


export default function VideoList({ video, videos, setSelectedVideo, setRoute, user }) {

    return (
        <div className="p-8 bg-black min-h-screen">
            <h1 className="text-white text-3xl font-bold mb-8">Welcome</h1>
            <ul className="video-list grid grid-cols-5 gap-8 text-white bg-black">
                {videos.map((video, index) => (

                    <TitleComponent video={video} index={index} setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />

                ))}
            </ul>
        </div>

    );

}

