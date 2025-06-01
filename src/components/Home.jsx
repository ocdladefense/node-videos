import { useState, useEffect } from 'react';
import VideoList from './VideoList';
import DropdownMenu from './DropdownMenu';
import VideoListGroup from './VideoListGroup';






export default function Home({ parser, user, setSelectedVideo }) {

    // user.getfavorite, user.continewatching.
    const [list, setList] = useState("all");
    let prevWatched = user.getWatchedVideos();
    let purchased = user.getPurchasedVideos();
    let videos = (parser && list && parser.getVideos(list, prevWatched, purchased)) || [];
    let seminars = (parser && list && parser.getSeminars(list)) || [];
    let listMeta = parser.getList(list, seminars);


    return (

        <div className="p-8 bg-zinc-900 min-h-screen">

            <div className='inline-flex w-full h-[100px] justify-between'>
                <h1 className="text-zinc-100 text-4xl font-bold pb-8 mb-8 text-left">Welcome</h1>
                <div className="inline-flex">
                    <DropdownMenu
                        label="Show"
                        items={parser.getLists()}
                        action={setList}
                    />
                    <DropdownMenu
                        label="Seminars"
                        items={seminars}
                        action={setList}
                    />
                </div>
            </div>

            {listMeta && listMeta.layout == "grouped" ? <VideoListGroup groups={videos} setSelectedVideo={setSelectedVideo} user={user} /> : <VideoList videos={videos} setSelectedVideo={setSelectedVideo} user={user} />}

        </div>

    );
    q
}
