import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';

const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;


export default class WatchedVideoService {

    //assume I have access to user globally when they are signed in?
    getCurrentUserId() {
        //return window.currentUserId;
    }

    //respond to media event based on playerstate
    handleMediaStateChange = (event) => {
        
        const { playerState, videoId, timestamp } = event.detail;

        //playerState: UNSTARTED = -1, ENDED = 0, PLAYING = 1, PAUSED = 2, BUFFERING = 3, CUED = 5;
        
        if(playerState == -1) {
            this.createWatchedVideo(videoId, timestamp);
        } else {
            this.updateUserTimestamp(videoId, timestamp);
        }
    }


    //might still be needed just to edit timestamps while NOT persisting
    updateUserTimestamp(videoId, timestamp) {
        console.log("updating user timestamp data", videoId, timestamp);
    }


    listen() {
        document.addEventListener('mediastatechange', this.handleMediaStateChange);
    }


    //create salesforce record for watchedVideo SOBject
    async createWatchedVideo(videoId, timestamp) {

        const payload = {
            UserId__c: 3, //temporarily hardcoding UserId__c
            ResourceId__c: videoId,
            Timestamp__c: timestamp
        };

        let sfrAPI = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);

        try {
            const createResponse = await sfrAPI.create('Watched_Video__c', payload);
            return createResponse;
        } catch(error) {
            console.log("Error creating watched video record", error);
        }
    }


    //update salesforce record for watchedVideo SOBject
    async updateWatchedVideo(videoId, timestamp) {
        
        console.log("Updating Watched Video Record");

        //find recordId required for update restApi call
        const recordId = await this.getWatchedVideoRecordId(userId, videoId);

        if (!recordId) {
            console.log("No existing record found");
            return null;
        }

        const payload = {
            Timestamp__c: timestamp
        };

        let sfrAPI = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);

        try {
            const updateResponse = await sfrAPI.update("Watched_Video__c", recordId, payload);
            console.log("Updated watched video record:", updateResponse);
            return updateResponse;
        } catch (error) {
            console.error("Error updating watched video record", error);
            throw error;
        }
    }


    //collect watchedVideo record for update call
    async getWatchedVideoRecordId(userId, videoId) {
        const query = `SELECT Id FROM Watched_Video__c WHERE UserId__c = '${userId}' AND ResourceId__c = '${videoId}'`;

        let sfrAPI = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);

        try {
            const response = await sfrAPI.query(query);
            return response;
        } catch (error) {
            console.error("Error getting watched video record id:", error);
            return null;
        }
    }

}
