import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';

const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;

export default class UserService {


    // The user this service is configured for.
    #user;


    constructor(user) {
        this.#user = user;
    }


    listen() {
        document.addEventListener('mediastatechange', (e) => this.addToWatched(e));
        document.addEventListener('mediapurchased', (e) => this.addToPurchased(e));
    }

    addToPurchased(event) {
        let videoId = event.detail.videoId; // change to resourceId or event just id.
        this.#user.addToPurchasedVideos(videoId); // same here
        console.log('Added to purchased video!')
    }

    addToWatched(event) {
        let videoId = event.detail.videoId;
        let timestamp = event.detail.timestamp; // change to elapsedTime.  Timestamp should be associated with when the event occurred.
        this.#user.addToWatchedVideos(videoId, timestamp);
        console.log('Added to watched video!');
    }

    //collect video records from salesforce
    async fetchWatchedVideos() {

        const userId = this.#user.getUserId();


        const watchedVideosQuery = `SELECT Name, UserId__c, ResourceId__c, Timestamp__c 
            FROM Watched_Video__c WHERE UserId__c = '${userId}'`;
    
        let sfrAPI = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);
        let watchedResponse = await sfrAPI.query(watchedVideosQuery);

        console.log("watched video query watchedResponse", watchedResponse.records);
        return watchedResponse.records;
    }

    //append collected data to user object
    attachWatchedVideos(watchedVideosApiData) {
      
        watchedVideosApiData.forEach(record => {
          const resourceId = record.ResourceID__c;
          const timestamp = record.Timestamp__c;
          
          this.#user.addToWatchedVideos(resourceId, timestamp);
        });
    
        console.log("Attached watched videos to user:", this.#user.userId);
    }
}


