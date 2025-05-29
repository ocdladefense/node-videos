import { useState, useEffect } from 'react';
import TitleComponent from './TitleComponent';
import DropdownMenu from './DropdownMenu';
import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';
import initThumbs from '../js/controllers/VideoThumbs';
import VideoDataParser from "../js/controllers/VideoDataParser.js";
import { clearThumbCache } from '../js/controllers/VideoThumbs';
import Video from '../js/models/Video.js';
window.clearCache = clearThumbCache;




// Previously from home but this is really a type of list.
// console.log("users previously watched vids", user.getPreviouslyWatchedVideos());
// if (selectedVideo) console.log("get watched vid by id", user.getWatchedVideo(selectedVideo.resourceId));

// Top-level reference to the "parser" that can return various lists of videos.
let parser = new VideoDataParser();


const query = 'SELECT Id, Name, Description__c, Event__c, Event__r.Name, Event__r.Start_Date__c, Speakers__c, ResourceId__c, Date__c, Published__c, IsPublic__c FROM Media__c';

// @jbernal - previously in index.js
// Retrieve video data and related thumbnail data.
async function getVideoParser() {

    const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
    const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;

    let api = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);
    let resp = await api.query(query);
    parser.parse(resp.records);

    let videos = parser.getVideos();

    // Default thumb in case there is no available image.
    Video.setDefaultThumbnail('http:/foobar');

    const thumbnailMap = await initThumbs(videos); // should be initThumbs(parser.getVideoIds());

    parser.getVideos().forEach(video => {
        const thumbs = thumbnailMap.get(video.resourceId);
        // console.log(`For video ID ${video.resourceId}, retrieved thumbnail data:`, thumbs);
        video.setThumbnail(thumbs);
    });


    return parser;
}





export default function VideoList({ setSelectedVideo, setRoute, user }) {

    //user.getfavorite, user.continewatching.
    const [list, setList] = useState(null);
    // const [videos, setVideos] = useState([]);
    // const [seminars, setSeminars] = useState([]);
    let prevWatched = user.getPreviouslyWatchedVideos();
    let purchased = user.getUserPurchasedVideos();
    console.log(purchased);
    let videos = (parser && list && parser.getVideos(list, prevWatched, purchased)) || [];


    let listMeta = parser.getList(list);
    let seminars = (parser && list && parser.getSeminars(list)) || [];

    // Retrieve data from the server only once during lifecycle.
    useEffect(() => {
        async function fn() { parser = await getVideoParser(); setList("all"); }
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
