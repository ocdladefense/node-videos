


// Uncomment when ready to use components to display the weather data.
import React from 'react';
import { createRoot } from 'react-dom/client';
import videos from '../data/videos.json';
import Home from '../components/Home.jsx';
import Thumbs from '../components/Thumbs.jsx';
// import Controller from './Controller.js';
import VideoThumbnails from '../js/VideoThumbs';
import VideoDataController from './VideoDataController.js';
import VideoDataParser from './VideoDataParser.js';
import VideoData from './VideoData.js';
import users from '../data/users.json';


const API_KEY = process.env.API_KEY;
console.log(API_KEY);
if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1)
}


//console.log strignify videos
console.log(videos);

// window.c = new Controller(API_KEY);

// without this I get an error at runtime.  babel 7 and preset env.
const regeneratorRuntime = require("regenerator-runtime");


/**
 * Uncomment when ready to use components to display the weather data.
 */
const $root = document.getElementById("app");
const root = createRoot($root);



// const { lat, lon } = await window.c.fetchLatLon("97405");
// const weatherData = await window.c.fetchRawData(lat, lon);
// let forecast = window.c.sendRawWeatherDataToParser(weatherData);

//add thumbnail metadeta as function for appending data
let videoIDs = videos.map(video => video.resourceId);
VideoThumbnails.getThumbs(videoIDs.slice(0, 49)).then(data => {
    console.log(data);

    const urls = data.map(thumbData => thumbData.thumbs.default.url);

    root.render(<div><Thumbs urls={urls} /><Home videos={videos} /></div>);
});




// Initialize the Weather class on window load
//window.onload = () => { new Main(); }
