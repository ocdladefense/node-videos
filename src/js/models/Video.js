
export default class Video {
    id;
    resourceId;
    name;
    description;
    date;
    published;
    public;
    speakers;
    eventId;
    seminar;
    free;
    thumbnail;


    constructor(title) {
        this.name = title;
    }

    static fromApiData(data) {
        let video = new Video(data.Name);
        video.id = data.Id;
        video.resourceId = data.ResourceId__c;
        video.name = data.Name;
        video.description = data.Description__c;
        video.date = data.Date;
        video.published = data.Published__c;
        video.public = data.IsPublic__c;
        video.speakers = data.Speakers__c;
        video.eventId = data.Event__c;
        video.seminar = data.Event__r;
        video.free = true;

        return video;
    }


    // ------------------- Get all the data fields ------------------- //
    getVideoId() {
        return this.id;
    }

    getVideoResourceId() {
        return this.resourceId;
    }

    getVideoName() {
        return this.name;
    }

    getVideoDescription() {
        if (this.description != null) {
            return this.description;
        } else return "No description given."
    }

    getVideoDate() {
        return this.date;
    }

    getVideoPublished() {
        return this.published;
    }

    getVideoPublic() {
        return this.public;
    }

    getVideoSpeakers() {
        return this.speakers;
    }

    getSeminarId() {
        return this.eventId;
    }

    getSeminarName() {
        if (this.seminar == null) {
            return "No seminar data";
        }
        //console.log(
        //    `getSeminarName: ${)
        return this.seminar.Name;
    }

    getSeminarDate() {
        if (this.seminar == null) {
            return "No seminar data";
        }
        return this.seminar.Start_Date__c;
    }

    isFree() {
        return this.free;
    }

    
    // ------------------- Video Thumbnails ------------------- //

    getVideoThumbnail(resolution = "default") {
        if (this.thumbnail && this.thumbnail[resolution]) {
            return this.thumbnail[resolution].url;
        } else {
            return `No thumbnailData for resolution: ${resolution}`;
        }
    }

    getMaxResThumb() {
        const resolutionOrder = ["maxres", "standard", "high", "medium", "default"];

        if (this.thumbnail) {
            for (let resolution of resolutionOrder) {
                if (this.thumbnail[resolution] && this.thumbnail[resolution].url) {
                    return resolution;
                }
            }
        }

        return "default";
        }

    setThumbnail(thumbnailData) {
        this.thumbnail = thumbnailData;
    }

}
