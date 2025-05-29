import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';

const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;


export default class PurchasedVideoService {


    // User id that will be included in all inserts and updates to watched video objects.
    #userId;


    constructor(userId) {
        this.#userId = userId;
    }



    listen() {
        document.addEventListener('mediapurchased', this.handleEvent);
    }


    //respond to media event based on playerstate
    handleEvent = (event) => {
        console.log(event.detail);
        const { playerState, resourceId, timestamp } = event.detail;

        // playerState: UNSTARTED = -1, ENDED = 0, PLAYING = 1, PAUSED = 2, BUFFERING = 3, CUED = 5;

        this.save(resourceId);
    }



    async load() {

        const query = `SELECT Id FROM Order WHERE Order.Contact__c = this.#user.getContactId()`;

        let api = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);
        let resp = await api.query(query);

        return resp.records;
    }






    // When the user purchases a video, we need to push that.
    // Note: not necessarily happening here, but
    async save(videoId, timestamp) {

    }


}
