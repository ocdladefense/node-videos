import "../css/input.css";
import React from 'react';
import { createRoot } from 'react-dom/client';
import videos from '../data/videos.json';
import users from '../data/users.json';
import Home from '../components/Home.jsx';
import VideoDataController from './controllers/VideoDataController.js';
import YoutubeDisplayController from './controllers/YoutubeDisplayController.js';
import UserController from './controllers/UserController.js';
import initThumbs from './controllers/VideoThumbs';
import { clearThumbCache } from './controllers/VideoThumbs';
import SalesforceRestApi  from '@ocdla/salesforce/SalesforceRestApi.js';

const dataUrl = "https://ocdla.my.site.com/VideoData";
const API_KEY = process.env.API_KEY;
const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;

//console.log(API_KEY);

if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1)
}

window.clearCache = clearThumbCache;
window.ydc = new YoutubeDisplayController();
const vdc = new VideoDataController(dataUrl);
const vidData = vdc.parseVideoData(videos);
console.log("vidData", vidData);

window.clearCache = clearThumbCache;

const use = new UserController(users);
const allUsers = use.getAllUsers();
console.log("all users", allUsers);
const user = use.getUser(1);
console.log("previously watched videos", user.getPreviouslyWatchedVideos());
console.log("timestap of watched video", user.getWatchedVideo('_4xNa80IP3o'));

const filteredVideo = vdc.getVideoById("a2A0a000009QUh4EAG", vidData);


console.log("user.get", user.get)



window.ydc = new YoutubeDisplayController();


const watchedVideosQuery = 'SELECT Timestamp__c FROM Watched_Video__c';
let sfrAPI = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);
let response = await sfrAPI.query(watchedVideosQuery);
console.log("watched video query response", response);


// without this I get an error at runtime.  babel 7 and preset env.
const regeneratorRuntime = require("regenerator-runtime");



//console.log(JSON.stringify(videos));


const $root = document.getElementById("app");
const root = createRoot($root);

const thumbnailMap = await initThumbs(videos);

//lookup depending on the data type returned by initThumbs
vidData.forEach(video => {
    const thumbs = thumbnailMap.get(video.resourceId);
    //console.log(`For video ID ${video.resourceId}, retrieved thumbnail data:`, thumbs);
    video.setThumbnail(thumbs);
});

root.render(<div><Home videos={vidData} user={user} /></div>);


