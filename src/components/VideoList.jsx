import React from 'react';
import { useState } from 'react';
import TitleComponent from './TitleComponent';


export default function VideoList({ video, videos, setSelectedVideo, setRoute, user }) {
    const [filter, setFilter] = useState(videos);

    const alphabetical = videos.toSorted((a, b) => {
        let textA = a.getVideoName();
        let textB = b.getVideoName();
        return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
    });

    const sortAlpha = () => setFilter(alphabetical);


    const sortSeminar = () => setFilter(videos);

    return (
        <div className="p-8 bg-zinc-900 min-h-screen">
            <h1 className="text-zinc-100 text-4xl font-bold pb-8 mb-8 text-left">Welcome</h1>
            <button onClick={sortAlpha} className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2">Sort Alphabetically</button>
            <button onClick={sortSeminar} className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2 ml-2">Sort by Seminar</button>

            <ul>
                { }
                <li className='text-4xl text-zinc-100 grid grid-cols-1'>{videos[0].getSeminarName()}</li>
                <ul className="video-list grid phone:grid-cols-1 tablet:grid-cols-2 laptop:grid-cols-4 desktop:grid-cols-5 gap-8">
                    {filter.map((video, index) => (

                        <TitleComponent video={video} index={index} setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />

                    ))}
                </ul>

            </ul>


        </div>

    );

}
/* 
forEach(seminar in videos) {
    <li>{Seminar title}</li>
    <ul>
        <li> map of videos in that seminar </li>
    </ul>
}
*/
