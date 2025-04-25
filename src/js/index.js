import React from 'react';
import { createRoot } from 'react-dom/client';
import videos from '../data/videos.json';
import Home from '../components/Home.jsx';
import Thumbs from '../components/Thumbs.jsx';
import Player from '../components/Player.jsx';
import VideoDataController from './controllers/VideoDataController.js';
import users from '../data/users.json';
import YoutubeDisplayController from './controllers/YoutubeDisplayController.js';
import UserController from './controllers/UserController.js';
import initThumbs from './controllers/VideoThumbs';

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

const playerData = '';

const vidData = vdc.parseVideoData(videos);
console.log(vidData);


const use = new UserController(users);

const filteredVideo = vdc.getVideoById("a2A0a000009QUh4EAG", vidData);


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


const thumbnailMap = await initThumbs(videos);

vidData.forEach(video => video.setThumbnail(thumbnailMap[video.data.resourceId]));

root.render(<div><Home videos={vidData} /></div>);