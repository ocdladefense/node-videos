import { useState, useEffect } from 'react';
import TitleComponent from './TitleComponent';
import DropdownMenu from './DropdownMenu';
import { clearThumbCache } from '../js/controllers/VideoThumbs';
window.clearCache = clearThumbCache;






export default function VideoList({ parser, setSelectedVideo, setRoute, user }) {

    //user.getfavorite, user.continewatching.
    const [list, setList] = useState(null);
    // const [videos, setVideos] = useState([]);
    // const [seminars, setSeminars] = useState([]);
    let prevWatched = user.getWatchedVideos();
    let purchased = user.getPurchasedVideos();
    console.log(prevWatched);
    let videos = (parser && list && parser.getVideos(list, prevWatched, purchased)) || [];

    let seminars = (parser && list && parser.getSeminars(list)) || [];
    let listMeta = parser.getList(list, seminars);


    console.log(seminars);
    // Retrieve data from the server only once during lifecycle.
    useEffect(() => {
        async function fn() { setList("all"); }
        fn();
    }, []);

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

            {/*

//  { value: "oldest", title: "Oldest" }, // Make these two separate buttons that always display (for now);
// would probably require a separate useState("desc"), "asc"
*/}

            {listMeta && listMeta.layout == "grouped" ?

                <VideoListGroup groups={videos} setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />
                :
                <ul className="video-list grid phone:grid-cols-1 tablet:grid-cols-2 laptop:grid-cols-4 desktop:grid-cols-5 gap-8">
                    {videos && videos.map((video, index) => (
                        <TitleComponent video={video} index={index} setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />
                    ))}
                </ul>

            }

        </div>

    );

}



function VideoListGroup({ groups, setRoute, setSelectedVideo, user }) {


    return (<ul>
        {
            Object.keys(groups).map(key => {
                let theGroup = groups[key];
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


    </ul>);
}
