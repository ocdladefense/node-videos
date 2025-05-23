import React, { useState, useEffect } from 'react';
import TitleComponent from './TitleComponent';
import DropdownMenu from './DropdownMenu';
import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';
import initThumbs from '../js/controllers/VideoThumbs';
import VideoDataParser from "../js/controllers/VideoDataParser.js";
import { clearThumbCache } from '../js/controllers/VideoThumbs';
window.clearCache = clearThumbCache;




// Previously from home but this is really a type of list.
// console.log("users previously watched vids", user.getPreviouslyWatchedVideos());
// if (selectedVideo) console.log("get watched vid by id", user.getWatchedVideo(selectedVideo.resourceId));

// Top-level reference to the "parser" that can return various lists of videos.
let parser;
let seminars = [];
let groupedVideos;
const filterBySeminar = () => { };
const query = 'SELECT Id, Name, Description__c, Event__c, Event__r.Name, Event__r.Start_Date__c, Speakers__c, ResourceId__c, Date__c, Published__c, IsPublic__c FROM Media__c';

// @jbernal - previously in index.js
// Retrieve video data and related thumbnail data.
async function getVideoParser() {

    const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
    const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;

    let api = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);
    let resp = await api.query(query);
    const parser = VideoDataParser.parse(resp.records);

    let videos = parser.getVideos();

    const thumbnailMap = await initThumbs(videos);

    parser.getVideos().forEach(video => {
        const thumbs = thumbnailMap.get(video.resourceId);
        // console.log(`For video ID ${video.resourceId}, retrieved thumbnail data:`, thumbs);
        video.setThumbnail(thumbs);
    });

    groupedVideos = parser.groupBySeminar();



    return parser;
}





export default function VideoList({ setSelectedVideo, setRoute, user }) {


    const [filter, setFilter] = useState([]);
    const sortByNewestSeminar = () => setFilter(parser.groupBySeminar());
    const sortByOldestSeminar = () => setFilter(parser.sortByOldestSeminar());
    const filterBySeminar = (seminar) => setFilter(parser.filterBySeminar(seminar))


    // Retrieve data from the server only once during lifecycle.
    useEffect(() => {
        async function fn() {
            parser = await getVideoParser(); setFilter(parser.groupBySeminar());
            seminars.push({ title: "All Seminars", action: sortByNewestSeminar })
            for (const key in groupedVideos) {
                console.log(key);
                seminars.push({ title: key, action: () => filterBySeminar(key) })
            }
        }
        fn();
    }, []);



    console.log(seminars);
    return (

        <div className="p-8 bg-zinc-900 min-h-screen">

            <div className='inline-flex w-full h-[100px] justify-between'>
                <h1 className="text-zinc-100 text-4xl font-bold pb-8 mb-8 text-left">Welcome</h1>
                <div className="inline-flex">
                    <DropdownMenu
                        buttonLabel="Order By"
                        items={[
                            { title: "Most Recent", action: sortByNewestSeminar },
                            { title: "Oldest", action: sortByOldestSeminar }
                        ]}
                    />
                    <DropdownMenu
                        buttonLabel="Filter Seminar"
                        items={seminars}
                    />
                </div>
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
