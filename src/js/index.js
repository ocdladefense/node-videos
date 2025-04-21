


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

const API_KEY = process.env.API_KEY;
console.log(API_KEY);
if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1)
}
const dataUrl = "https://ocdla.my.site.com/VideoData";

window.c = new Controller(API_KEY);

console.log(videos);

// without this I get an error at runtime.  babel 7 and preset env.
const regeneratorRuntime = require("regenerator-runtime");

for (let i = 0; i < videos.length; i++) {
    if (i % 2 === 0) {
        videos[i].free = true;
    } else videos[i].free = false;
}

console.log(JSON.stringify(videos));

/**
 * Uncomment when ready to use components to display the weather data.
 */
const $root = document.getElementById("app");
const root = createRoot($root);

// temporarily fetching a forecast for the zipcode 97477 
const c = new Controller();
const vdc = new VideoDataController(dataUrl);
const vdp = new VideoDataParser(videos);
const test = new VideoData(videos[0]);


// const { lat, lon } = await window.c.fetchLatLon("97405");
// const weatherData = await window.c.fetchRawData(lat, lon);
// let forecast = window.c.sendRawWeatherDataToParser(weatherData);
let d = vdc.fetchVideoData();
console.log(d);

let vidData = vdc.parseVideoData(videos);
console.log(videos);
let vd = vdp.getVideoData();

// let testDescription = test.getVideoDescription();
// let testName = test.getVideoName();
// let testId = test.getVideoId();
// let testResourceId = test.getVideoResourceId();
// let testOriginalDate = test.getVideoOriginalDate();
// let testPublished = test.getVideoPublished();
// let testSpeakers = test.getVideoSpeakers();
// let testSubject = test.getVideoSubject();
// console.log(testDescription);
// console.log(testName);
// console.log(testId);
// console.log(testResourceId);
// console.log(testOriginalDate);
// console.log(testPublished);
// console.log(testSpeakers);
// console.log(testSubject);
//console.log(vd);


root.render(<Home videos={vd} />);




// Initialize the Weather class on window load
//window.onload = () => { new Main(); }
