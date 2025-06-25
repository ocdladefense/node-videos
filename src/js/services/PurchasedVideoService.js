import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';

const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;

const mock = [
    {
        "ResourceId__c": "Q6TRolTHbKY"
    },
    {
        "ResourceId__c": "9w-ROKc0BWU"
    },
    {
        "ResourceId__c": "1CgKDovCgZQ"
    },
    {
        "ResourceId__c": "hLm9-mEvhJw"
    }
];

export default class PurchasedVideoService extends SalesforceRestApi {


    // User id that will be included in all inserts and updates to watched video objects.
    #userId;

    #handlers = [];



    constructor(instance_url, access_token) {
        super(instance_url, access_token);
    }


    setUserId(userId) {
        this.#userId = userId;
    }


    onSave(fn) {
        this.#handlers.push(fn);
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

        let req = new Promise((resolve, reject) => {
            let query = "SELECT Id FROM OrderItem WHERE Product2.IsMedia = True AND Order.StatusCategory = 'Active' AND Contact__c ='" + this.#userId + "'";
            resolve({ records: mock }); //
        });
        return Promise.resolve(req);
    }






    // When the user purchases a video, we need to push that.
    // Note: not necessarily happening here, but
    async save(videoId, timestamp) {

        let resp;
        // Mock of an actual REST callout for purchased videos.
        let api = new Promise((resolve, reject) => {
            resolve({ success: true, resourceId: videoId, timestamp: timestamp });
            // reject("This is testing code...");
        });

        try {
            resp = await api; //.upsert('Watched_Video__c', payload, "ExternalId__c");
            this.#handlers.forEach((callback) => {
                callback(videoId, timestamp);
            });
        } catch (error) {
            console.warn("Error creating watched video record: ", error);
        }

    }


}
