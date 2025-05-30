import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';

const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;


export default class WatchedVideoService {


    // User id that will be included in all inserts and updates to watched video objects.
    #userId;

    #handlers = [];


    constructor(userId) {
        this.#userId = userId;
    }



    listen() {
        document.addEventListener('mediastatechange', (e) => this.handleEvent(e));
    }


    onSave(fn) {
        this.#handlers.push(fn);
    }


    //respond to media event based on playerstate
    handleEvent = (event) => {
        console.log(event.detail);
        const { playerState, resourceId, timestamp } = event.detail;

        // playerState: UNSTARTED = -1, ENDED = 0, PLAYING = 1, PAUSED = 2, BUFFERING = 3, CUED = 5;

        this.save(resourceId, timestamp);
    }



    async load() {

        const query = `SELECT Name, CreatedById, ResourceId__c, Timestamp__c FROM Watched_Video__c WHERE CreatedById = '${this.#userId}'`;

        let api = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);
        return api.query(query);
    }






    //create salesforce record for watchedVideo SOBject
    async save(videoId, timestamp) {
        let userId = this.#userId;
        let externalId = userId + '.' + videoId;


        const payload = {
            ExternalId__c: externalId, // When this new customer Salesforce field is marked as "Use as external id" you can use it for future updates.
            ResourceId__c: videoId,
            Timestamp__c: timestamp
        };

        let api = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);

        let resp;

        try {
            resp = await api.upsert('Watched_Video__c', payload, "ExternalId__c");
            this.#handlers.forEach((callback) => {
                callback(videoId, timestamp);
            });
        } catch (error) {
            console.warn("Error creating watched video record: ", error);
        }
    }


}
