import Thumbnail from "./Thumbnail";

export default class Video {


    id;

    resourceId;

    name;

    description;

    date;

    published;

    public;

    free;

    thumbnails;

    speakers;

    seminarId;

    seminarName;

    startDate;

    duration;



    static defaultThumbnail;


    constructor(title) {
        this.name = title;
    }



    static fromApiData(data) {
        let relatedSeminar = data.Event__r || null;

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
        video.seminar = relatedSeminar && relatedSeminar.Name;
        video.seminarId = data.Event__c;
        video.startDate = relatedSeminar && relatedSeminar.Start_Date__c;
        video.free = true;

        return video;
    }


    getDuration() {
        return this.duration;
    }

    setDuration(duration) {
        this.duration = duration;
    }

    getProgress(timestamp) {
        if (!timestamp) {
            return "0%";
        }
        const progress = timestamp / this.getDuration();
        let intProgress = Math.round(progress * 100);
        return intProgress.toString() + "%";
    }

    // ------------------- Get all the data fields ------------------- //
    getVideoId() {
        return this.id;
    }

    getVideoResourceId() {
        return this.resourceId;
    }

    getResourceId() {
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
        return this.seminarId;
    }

    getSeminarName() {
        return this.seminar || "";
    }

    getSeminarDate() {
        if (this.seminar == null) {
            return "No seminar data";
        }
        return this.seminar.Start_Date__c;
    }

    isFree() {
        return this.public;
    }


    // ------------------- Video Thumbnails ------------------- //


    getThumbnailUrl(size = Thumbnail.SMALL) {
        let resolutionOrder = ["maxres", "standard", "high", "medium", "default"];

        if (size == Thumbnail.SMALL) {
            resolutionOrder = resolutionOrder.reverse();
        }

        if (this.thumbnails) {
            for (let resolution of resolutionOrder) {
                if (this.thumbnails[resolution] && this.thumbnails[resolution].url) {
                    return this.thumbnails[resolution].url;
                }
            }
        }

        return `Default thumb if there is no available image: ${size}`;
    }


    setThumbnail(thumbnailData) {
        this.thumbnails = thumbnailData;
    }

    static setDefaultThumbnail(url) {
        Video.defaultThumbnail = url;
    }

    static getResourceIds(videos) {
        return videos.filter(video => !!video.resourceId).map(video => video.resourceId);
    }

}
