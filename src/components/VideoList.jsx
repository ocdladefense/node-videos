import React from 'react';
import { useState } from 'react';
import TitleComponent from './TitleComponent';



export default function VideoList({ parser, setSelectedVideo, setRoute, user }) {
    let videos = parser.getVideos();
    const [filter, setFilter] = useState(videos);

    const grouped = parser.groupBySeminar();
    console.log(grouped);

    return (
        <div className="p-8 bg-zinc-900 min-h-screen">
            <h1 className="text-zinc-100 text-4xl font-bold pb-8 mb-8 text-left">Welcome</h1>
            <button onClick={parser.sortAlpha()} className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2">Sort Alphabetically</button>
            <button onClick={parser.sortSeminar()} className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2 ml-2">Sort by Seminar</button>

            <ul>
                {Object.keys(grouped).map(key => {
                    let theGroup = grouped[key];
                    let numVideos = theGroup.length;

                    if (true || numVideos > 3) {

                        return (


                            <ul className="video-list grid phone:grid-cols-1 tablet:grid-cols-2 laptop:grid-cols-4 desktop:grid-cols-5 gap-8">
                                <li className='text-4xl text-zinc-100 grid col-span-full'>{key}</li>
                                {theGroup.map((video, index) => (

                                    <TitleComponent video={video} index={index} setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />

                                ))}
                            </ul>
                        )
                    }

                })}


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
