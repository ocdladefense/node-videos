import { useState, useEffect } from 'react';
import DropdownMenu from './DropdownMenu';
import VideoList from './list/VideoList';
import Group from './list/Group';
import VideoDataParser from '../js/controllers/VideoDataParser';






export default function Home({ parser, user, setSelectedVideo }) {

    // user.getfavorite, user.continewatching.
    const [list, setList] = useState("all");
    const [seminarId, setSeminarId] = useState(null);

    // The array of watched videos.
    let watched = user.getWatchedVideos();

    // The array of purchased videos.
    let purchased = user.getPurchasedVideos();

    // Videos to be displayed for the current list.
    let videos = [];

    let filterIds = null;

    if ("purchased" == list) {
        filterIds = user.getPurchasedIds();
    }
    else if ("watched" == list) {
        filterIds = user.getWatchedIds();
    } else if ("seminar" == list) {

        filterIds = parser.filterBySeminarId(seminarId, TRUE); // second parameter of true return ids only! which is what we want here, for now, I guess, maybe, sorta.
    }

    // (parser && parser.getVideos(list)) || [];
    if (parser.isInitialized()) {

        videos = parser.getVideos(filterIds);
    }


    // A list of seminars to filter by.
    let seminarFilterOptions = (parser && parser.getSeminarOptions()) || [];

    // Map of seminars.
    let seminars = parser && parser.getSeminars();


    // Metadata about the given list.
    // Not sure why seminars get passed here?
    let listAttributes = parser.getList(list);
    let listLabel = listAttributes.label;
    let groupBy = listAttributes.groupBy;




    return (

        <div className="p-8 bg-zinc-900 min-h-screen">

            <div className='inline-flex w-full h-[100px] justify-between'>
                <h1 className="text-zinc-100 text-4xl font-bold pb-8 mb-8 text-left">Welcome</h1>
                <div className="inline-flex phone:flex-wrap">
                    <DropdownMenu
                        label={listLabel || "Select"}
                        items={parser.getLists()}
                        action={setList}
                    />
                    <DropdownMenu
                        label="Seminars"
                        items={seminarFilterOptions}
                        action={setSeminarId}
                    />
                </div>
            </div>

            {listAttributes && listAttributes.layout == "grouped" ? <Group labels={seminars} groups={VideoDataParser.group(videos, groupBy)} user={user} /> : <VideoList videos={videos} user={user} />}

        </div>

    );
    q
}
