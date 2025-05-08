import React from 'react';
import TitleComponent from './TitleComponent';


export default function VideoList({ video, videos, setSelectedVideo, setRoute, user }) {

    return (
        <div className="p-8 bg-zinc-900 min-h-screen">
            <h1 className="text-zinc-100 text-5xl font-bold mb-8">Welcome</h1>
            <ul className="video-list grid phone:grid-cols-1 tablet:grid-cols-2 laptop:grid-cols-4 desktop:grid-cols-5 gap-8 text-zinc-100">
                {videos.map((video, index) => (

                    <TitleComponent video={video} index={index} setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />

                ))}
            </ul>
        </div>

    );

}

