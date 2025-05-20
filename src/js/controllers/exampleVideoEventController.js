class VideoEventController {
    constructor(video) {
        this.video = video;
        this.initEventListeners();
    }

    initEventListeners() {
        document.getElementById('pauseBtn').addEventListener('click', () => {
            this.pauseVideo();
        })
    }

    pauseVideo() {
        this.video.pause();
        const elapsedTime = this.video.elapsedTime;
        
        const pauseEvent = new CustomEvent('video paused', {
            detail: {timestamp: elapsedTime, resourceId: resourceId}
        })

        document.dispatchEvent(pauseEvent);

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
