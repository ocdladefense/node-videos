
export default class Video {
    constructor(title) {
        this.name = title;
    }

    static fromApiData(data) {
        let video = new Video(data.name);
        video.id = data.id;
        video.resourceId = data.resourceId;
        video.name = data.name;
        video.description = data.description;
        video.originalDate = data.originalDate;
        video.published = data.published;
        video.speakers = data.speakers;
        video.subject = data.subject;
        video.free = data.free;

        return video;
    }

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
        if (this.data.description != null) {
            return this.description;
        } else return "No description given."
    }

    getVideoOriginalDate() {
        return this.originalDate;
    }

    isFree() {
        return this.free;
    }
    getVideoPublished() {
        return this.published;
    }

    getVideoSpeakers() {
        return this.speakers;
    }

    getVideoSubject() {
        return this.subject;
    }

    getVideoThumbnail() {
        if (this.thumbnail != null) {
            return this.thumbnail;
        } else {
            return "No thumbnail data";
        }
    }

    setThumbnail(url) {
        this.thumbnail = url;
    }
}
