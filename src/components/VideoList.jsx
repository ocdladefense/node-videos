import React from 'react';
import TitleComponent from './TitleComponent';


export default function VideoList({ video, videos, setSelectedVideo, setRoute, user }) {

    return (
        <div className="p-8 bg-black">
            {/* <h1 className="text-white bg-black" >Here is the list of videos!</h1> */}
            <ul className="video-list grid grid-cols-5 gap-7 text-white bg-black">
                {videos.map((video, index) => (
                    <TitleComponent video={video} index={index} setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />
                ))}
            </ul>
        </div>

    );

}

