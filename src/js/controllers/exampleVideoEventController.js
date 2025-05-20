class VideoEventController {
    constructor(video) {
        this.video = video;
        this.initEventListeners();
    }

    initEventListeners() {
        document.getElementById('backBtn').addEventListener('click', () => {
            this.preserveVideoTimestamp();
        })
    }

    preserveVideoTimestamp() {
        //this.video.pause();
        const elapsedTime = this.video.elapsedTime;
        const resourceID = this.video.resourceID;
        
        const mediaEvent = new CustomEvent('MediaEvent.', {
            detail: {timestamp: elapsedTime, resourceId: resourceId}
        })

        document.dispatchEvent(mediaEvent);

        this.updateTimestamp(elapsedTime);
    }

    updateTimestamp(timestamp) {
        const data = {
            WatchedVideoID__c: '1234',
            UserID__c: '5678',
            ResourceID__c: resourceID,
            Timestamp__c: timestamp
        };

        fetch('url', {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        }).then(response =>  {
            if(!response.ok) {
                throw new Error('Network error: ' + response.statusText);
            }
            return response.json();
        })
            .then(data => console.log('Timestamp successfully updated:', data))
            .catch(error => console.error('Error updating timestamp:', error));
    }
}
