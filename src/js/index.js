


// Uncomment when ready to use components to display the weather data.
import React from 'react';
import { createRoot } from 'react-dom/client';
import videos from '../data/videos.json';
// import morevideos from '../data/morevideos.json'
import Home from '../components/Home.jsx';
import Thumbs from '../components/Thumbs.jsx';
// import Controller from './Controller.js';
import VideoThumbnails from '../js/VideoThumbs';
import VideoDataController from './VideoDataController.js';
import VideoDataParser from './VideoDataParser.js';
import VideoData from './VideoData.js';
import users from '../data/users.json';

const dataUrl = "https://ocdla.my.site.com/VideoData";

const API_KEY = process.env.API_KEY;
console.log(API_KEY);
if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1)
}


//console.log strignify videos
console.log(videos);


const vdc = new VideoDataController(dataUrl);
const vdp = new VideoDataParser(videos);
const test = new VideoData(videos[0]);



const vidData = vdc.parseVideoData(videos);

console.log(vidData);


const allData = vdp.getVideoData();
console.log(allData);

const filteredVideo = vdc.getVideoById("a2A0a000009QUh4EAG", allData);
console.log(filteredVideo);





// without this I get an error at runtime.  babel 7 and preset env.
const regeneratorRuntime = require("regenerator-runtime");

for (let i = 0; i < videos.length; i++) {
    if (i % 2 === 0) {
        videos[i].free = true;
    } else videos[i].free = false;
}

//console.log(JSON.stringify(videos));
console.log(users);

const $root = document.getElementById("app");
const root = createRoot($root);



const user1 = u.getUser(1);
console.log(user1);
console.log(users);

//add thumbnail metadeta as function for appending data
let videoIDs = videos.map(video => video.resourceId);
VideoThumbnails.getThumbs(videoIDs.slice(0, 49)).then(data => {
    console.log(data);

    const urls = data.map(thumbData => thumbData.thumbs.default.url);

    root.render(<div><Thumbs urls={urls} /><Home videos={vidData} /></div>);
});




// Initialize the Weather class on window load
//window.onload = () => { new Main(); }
