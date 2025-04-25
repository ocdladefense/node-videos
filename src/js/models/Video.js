
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
        return this.data.id;
    }

    getVideoResourceId() {
        return this.data.resourceId;
    }

    getVideoName() {
        return this.data.name;
    }

    getVideoDescription() {
        if (this.data.description != null) {
            return this.data.description;
        } else return "No description given."
    }

    getVideoOriginalDate() {
        return this.data.originalDate;
    }

    isFree() {
        return this.data.free;
    }
    getVideoPublished() {
        return this.data.published;
    }

    getVideoSpeakers() {
        return this.data.speakers;
    }

    getVideoSubject() {
        return this.data.subject;
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
