


// Uncomment when ready to use components to display the weather data.
import React from 'react';
import { createRoot } from 'react-dom/client';
import videos from '../data/videos.json';
import Home from '../components/Home.jsx';
import Controller from './Controller.js';

const API_KEY = process.env.API_KEY;
console.log(API_KEY);
if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1)
}


window.c = new Controller(API_KEY);

// without this I get an error at runtime.  babel 7 and preset env.
const regeneratorRuntime = require("regenerator-runtime");


/**
 * Uncomment when ready to use components to display the weather data.
 */
const $root = document.getElementById("app");
const root = createRoot($root);

// temporarily fetching a forecast for the zipcode 97477 
const c = new Controller();

// const { lat, lon } = await window.c.fetchLatLon("97405");
// const weatherData = await window.c.fetchRawData(lat, lon);
// let forecast = window.c.sendRawWeatherDataToParser(weatherData);


root.render(<Home videos={videos} />);




// Initialize the Weather class on window load
//window.onload = () => { new Main(); }
