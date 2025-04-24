


// Uncomment when ready to use components to display the weather data.
import React from 'react';
import { createRoot } from 'react-dom/client';
import videos from '../data/videos.json';
// import morevideos from '../data/morevideos.json'
import Home from '../components/Home.jsx';
import Controller from './Controller.js';
import VideoDataController from './VideoDataController.js';
import VideoDataParser from './VideoDataParser.js';
import VideoData from './VideoData.js';
import users from '../data/users.json';
import UserController from './UserController.js';

const API_KEY = process.env.API_KEY;
console.log(API_KEY);
if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1)
}
const dataUrl = "https://ocdla.my.site.com/VideoData";

window.c = new Controller(API_KEY);



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


const c = new Controller();
const vdc = new VideoDataController(dataUrl);
const vdp = new VideoDataParser(videos);
const u = new UserController(users);

const user1 = u.getUser(1);
console.log(user1);
console.log(users);



const vidData = vdc.parseVideoData(videos);




const vd = vdp.getVideoData();

const filteredVideo = vdc.getVideoById("a2A0a000009QUh4EAG", vd);
console.log(filteredVideo);



root.render(<Home videos={vd} />);




// Initialize the Weather class on window load
//window.onload = () => { new Main(); }
