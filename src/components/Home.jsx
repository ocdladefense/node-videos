import { useState } from 'react';
import { useOutletContext } from 'react-router-dom';
import DropdownMenu from './DropdownMenu';
import VideoList from './list/VideoList';
import Group from './list/Group';
import VideoDataParser from '../js/controllers/VideoDataParser';






export default function Home() {

    // user.getfavorite, user.continewatching.
    const [list, setList] = useState("all");

    // Define a parameter p1, that can be passed to the list filter callback.
    const [p1, setSeminarId] = useState(null);

    // Use react-router-dom hook.
    let { parser, user } = useOutletContext();

    // Metadata about the given list.
    let { label, groupBy, layout, filterFn } = parser.getList(list);

    // Videos to be displayed for the current list.
    let videos = [];

    // Execute any additional filters that are defined for this list.
    // Pass user and p1, p2, p3... etc. as needed.
    // Don't make this component need to know about how to get the filtered data.
    // That's what our data parser is for.
    let filterIds = (filterFn && filterFn(user, p1) || []);


    if (parser.isInitialized()) {
        videos = parser.getVideos(filterIds);
    }


    // A list of seminars to filter by.
    let seminarFilterOptions = (parser && parser.getSeminarOptions()) || [];

    // Map of seminars.
    let seminars = parser && parser.getSeminars();







    return (

        <div className="p-8 bg-zinc-900 min-h-screen">

            <div className='inline-flex w-full h-[100px] justify-between'>
                <h1 className="text-zinc-100 text-4xl font-bold pb-8 mb-8 text-left">Welcome</h1>
                <div className="inline-flex phone:flex-wrap">
                    <DropdownMenu
                        label={label || "Select"}
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

            {layout == "grouped" ? <Group labels={seminars} groups={VideoDataParser.group(videos, groupBy)} user={user} /> : <VideoList videos={videos} user={user} />}

        </div>

    );

}
