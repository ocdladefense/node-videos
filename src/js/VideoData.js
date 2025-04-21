
export default class VideoData {
    constructor(data) {
        this.data = data;
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

    getVideoPublished() {
        return this.data.published;
    }

    getVideoSpeakers() {
        return this.data.speakers;
    }

    getVideoSubject() {
        return this.data.subject;
    }

}
