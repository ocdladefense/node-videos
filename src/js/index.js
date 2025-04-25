import React from 'react';
import { createRoot } from 'react-dom/client';
import videos from '../data/videos.json';
// import morevideos from '../data/morevideos.json'
import Home from '../components/Home.jsx';
import Thumbs from '../components/Thumbs.jsx';
import Player from '../components/Player.jsx';
// import Controller from './Controller.js';
import VideoThumbnails from '../js/VideoThumbs';
import VideoDataController from './VideoDataController.js';
import VideoDataParser from './VideoDataParser.js';
import VideoData from './VideoData.js';
import users from '../data/users.json';
import YoutubeDisplayController from './YoutubeDisplayController.js';
import UserController from './UserController.js';

const dataUrl = "https://ocdla.my.site.com/VideoData";
const API_KEY = process.env.API_KEY;

//console.log(API_KEY);

if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1)
}

//console.log strignify videos
//console.log(videos);

window.ydc = new YoutubeDisplayController();
const vdc = new VideoDataController(dataUrl);
const vdp = new VideoDataParser(videos);
const test = new VideoData(videos[0]);

const playerData = '';

const vidData = vdc.parseVideoData(videos);
console.log(vidData);


const use = new UserController(users);

const filteredVideo = vdc.getVideoById("a2A0a000009QUh4EAG", vidData);
const allData = vdp.getVideoData();
//console.log(allData);


console.log(filteredVideo);

window.ydc = new YoutubeDisplayController
const u = use.getUser(1);
console.log(u);





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


//add thumbnail metadeta as function for appending data
let videoIDs = videos.map(video => video.resourceId);
VideoThumbnails.getThumbs(videoIDs.slice(0, 50)).then(data => {
    const thumbnailMap = data.reduce((acc, thumbData) => {
        acc[thumbData.id] = thumbData.thumbs.default.url;
        return acc;
    }, {});

    //console.log("Thumbnail Map:", thumbnailMap);

    const mergedData = vidData.map(video => ({
        ...video.data,
        thumbnail: thumbnailMap[video.data.resourceId],
    }));

    //console.log("Video Data w/ Thumbs", mergedData);

    root.render(<div><Home videos={mergedData} /></div>);
});