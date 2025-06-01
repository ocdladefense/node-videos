import { useState } from 'react';
import TitleComponent from './TitleComponent';





/**
 * 
 * @param {Array<Video>} videos
 * @param {User} user
 * @param {function} setSelectedVideo 
 * @returns 
 */
export default function VideoList({ videos, user, setSelectedVideo }) {


    return (

        <ul className="video-list grid phone:grid-cols-1 tablet:grid-cols-2 laptop:grid-cols-4 desktop:grid-cols-5 gap-8">
            {videos && videos.map((video, index) => (
                <TitleComponent video={video} index={index} setSelectedVideo={setSelectedVideo} user={user} />
            ))}
        </ul>

    );

}
