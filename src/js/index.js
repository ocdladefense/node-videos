import "../css/input.css";
import React, {useState}  from 'react';
import { createRoot } from 'react-dom/client';
import users from '../data/users.json';
import App from '../components/App';
import UserController from './controllers/UserController.js';
import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';



const regeneratorRuntime = require("regenerator-runtime");
const dataUrl = "https://ocdla.my.site.com/VideoData";
const API_KEY = process.env.API_KEY;
const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;



if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1)
}






const use = new UserController(users);
const allUsers = use.getAllUsers();
const user = use.getUser(1);
//console.log("previously watched videos", user.getPreviouslyWatchedVideos());
//console.log("timestap of watched video", user.getWatchedVideo('_4xNa80IP3o'));



const watchedVideosQuery = 'SELECT Name, UserId__c, ResourceId__c, Timestamp__c FROM Watched_Video__c';
let sfrAPI = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);
let watchedResponse = await sfrAPI.query(watchedVideosQuery);
//console.log("watched video query watchedResponse", watchedResponse.records);





const $root = document.getElementById("app");
const root = createRoot($root);
root.render(<App user={user} />);


