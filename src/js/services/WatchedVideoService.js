import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';



const PLAYER_STATE_SEEKING = 101;

export default class WatchedVideoService extends SalesforceRestApi {


    // User id that will be included in all inserts and updates to watched video objects.
    #userId;

    #handlers = [];

    // Only callout to the api every 10 events/seconds.
    static SAVE_INTERVAL = 10;

    counter = 0;


    constructor(instance_url, access_token) {
        super(instance_url, access_token);
    }

    setUserId(userId) {
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
        const { state, resourceId, timestamp } = event.detail;

        // playerState: UNSTARTED = -1, ENDED = 0, PLAYING = 1, PAUSED = 2, BUFFERING = 3, CUED = 5;

        this.save(resourceId, timestamp, state);
    }



    async load() {

        const query = `SELECT Name, CreatedById, ResourceId__c, Timestamp__c FROM Watched_Video__c WHERE CreatedById='${this.#userId}'`;


        return this.query(query);
    }






    //create salesforce record for watchedVideo SOBject
    async save(videoId, timestamp, state) {

        this.#handlers.forEach((callback) => {
            callback(videoId, timestamp, state);
        });

        // Only push to API endpoint if we have hit the desired endpoint.
        if (state != PLAYER_STATE_SEEKING && this.counter++ != 0 && (this.counter % WatchedVideoService.SAVE_INTERVAL > 0)) return;

        let userId = this.#userId;
        let externalId = userId + '.' + videoId;


        const payload = {
            ExternalId__c: externalId, // When this new customer Salesforce field is marked as "Use as external id" you can use it for future updates.
            ResourceId__c: videoId,
            Timestamp__c: timestamp
        };


        let resp;

        try {
            resp = await this.upsert('Watched_Video__c', payload, "ExternalId__c");

        } catch (error) {
            console.warn("Error creating watched video record: ", error);
        }
    }


}
