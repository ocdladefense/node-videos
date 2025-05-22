import React from 'react';
import { useState } from 'react';
import TitleComponent from './TitleComponent';
import DropdownMenu from './DropdownMenu';



export default function VideoList({ parser, setSelectedVideo, setRoute, user }) {
    let videos = parser.getVideos();
    const grouped = parser.groupBySeminar();
    const [filter, setFilter] = useState(grouped);

    const sortByNewestSeminar = () => setFilter(parser.groupBySeminar());
    const sortByOldestSeminar = () => setFilter(parser.sortByOldestSeminar());

    console.log(filter);

    return (
        <div className="p-8 bg-zinc-900 min-h-screen">
            <div className='inline-flex justify-between w-full h-[100px]'>
                <h1 className="text-zinc-100 text-4xl font-bold pb-8 mb-8 text-left">Welcome</h1>
                <DropdownMenu
                    buttonLabel="Order By"
                    items={[
                        { title: "Most Recent", action: sortByNewestSeminar },
                        { title: "Oldest", action: sortByOldestSeminar }
                    ]}
                />
            </div>

            <ul>
                {
                    Object.keys(filter).map(key => {
                        let theGroup = filter[key];
                        let numVideos = theGroup.length;

                        if (true || numVideos > 2) {

                            return (


                                <ul className="video-list grid phone:grid-cols-1 tablet:grid-cols-2 laptop:grid-cols-4 desktop:grid-cols-5 gap-8">
                                    <li className='text-4xl text-zinc-100 grid col-span-full mt-10'>{key}</li>
                                    <hr className='grid col-span-full text-zinc-100 -mt-5' />
                                    {theGroup.map((video, index) => (

                                        <TitleComponent video={video} index={index} setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />

                                    ))}
                                </ul>
                            )
                        }
                    })
                }


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
