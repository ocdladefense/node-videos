import "../css/input.css";
import React from 'react';
import { createRoot } from 'react-dom/client';
import users from '../data/users.json';
import Home from '../components/Home.jsx';
import UserController from './controllers/UserController.js';
import initThumbs from './controllers/VideoThumbs';
import { clearThumbCache } from './controllers/VideoThumbs';
import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';
import VideoDataParser from "./controllers/VideoDataParser.js";



const dataUrl = "https://ocdla.my.site.com/VideoData";
const API_KEY = process.env.API_KEY;
const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;



if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1)
}

const ANOTHER_QUERY = 'SELECT Timestamp__c FROM Watched_Video__c';
// sample query
const QUERY = 'SELECT Id, Name, Description__c, Event__c, Event__r.Name, Event__r.Start_Date__c, Speakers__c, ResourceId__c, Date__c, Published__c, IsPublic__c FROM Media__c';

let api = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);

let response = await api.query(QUERY);

let anotherResponse = await api.query(ANOTHER_QUERY);

console.log('This was the response from SalesforceRestApi', response.records);

console.log(anotherResponse.records);




console.log('This is the parsed jsonp', window.videos);

window.clearCache = clearThumbCache;

//const vdc = new VideoDataController(dataUrl);

const parser = VideoDataParser.parse(response.records);


// vidData.sort((a, b) => Date.parse(b.getSeminarDate()) - Date.parse(a.getSeminarDate()));





window.clearCache = clearThumbCache;

const use = new UserController(users);
const allUsers = use.getAllUsers();
console.log("all users", allUsers);
const user = use.getUser(1);
console.log("previously watched videos", user.getPreviouslyWatchedVideos());
console.log("timestap of watched video", user.getWatchedVideo('_4xNa80IP3o'));




console.log("user.get", user.get)


const watchedVideosQuery = 'SELECT Name, UserId__c, ResourceId__c, Timestamp__c FROM Watched_Video__c';
let sfrAPI = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);
let watchedResponse = await sfrAPI.query(watchedVideosQuery);
console.log("watched video query watchedResponse", watchedResponse.records);


// without this I get an error at runtime.  babel 7 and preset env.
const regeneratorRuntime = require("regenerator-runtime");



//console.log(JSON.stringify(videos));


const $root = document.getElementById("app");
const root = createRoot($root);

const thumbnailMap = await initThumbs(videos);

//lookup depending on the data type returned by initThumbs
parser.getVideos().forEach(video => {
    const thumbs = thumbnailMap.get(video.resourceId);
    //console.log(`For video ID ${video.resourceId}, retrieved thumbnail data:`, thumbs);
    video.setThumbnail(thumbs);
});

root.render(<div><Home parser={parser} user={user} /></div>);


