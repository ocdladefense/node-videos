
export default class Video {
    id;
    resourceId;
    name;
    description;
    originalDate;
    published;
    speakers;
    subject;
    free;
    


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
        if (this.description != null) {
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

    getVideoThumbnail(resolution = "default") {
        if (this.thumbnail && this.thumbnail[resolution]) {
            return this.thumbnail[resolution].url;
        } else {
            return `No thumbnailData for resolution: ${resolution}`;
        }
    }

    setThumbnail(thumbnailData) {
        this.thumbnail = thumbnailData;
    }
}
