import Video from '../models/Video.js';


export default class VideoDataParser {
    videos = [];

    seminars = new Map();

    initialized = false;

    lists = [
        { layout: "flat", value: "all", label: "All" },
        { layout: "grouped", groupBy: "seminar", value: "seminar", label: "By Seminar", filterFn: (user, p1) => this.filterBySeminarId(p1, true) },
        { layout: "grouped", groupBy: "year", value: "year", label: "By Year" },
        { value: "watched", label: "Continue Watching", filterFn: (user, p1) => user.getWatchedIds() },
        { value: "purchased", label: "Purchased", filterFn: (user, p1) => user.getPurchasedIds() }, // List of all videos that have been purchased.
        { value: "recent", label: "Recently Added" },
        { value: "coming", label: "Coming Soon" },
        { value: "favorites", label: "Favorites" }
    ];



    constructor(videos) {
        this.videos = videos || [];
    }


    getSeminars() {
        return this.seminars;
    }

    parse(apiData) {
        apiData = apiData || [];

        for (let i = 0; i < apiData.length; i++) {
            let record = apiData[i];
            let video = Video.fromApiData(record);
            this.videos.push(video);
            this.seminars.set(video.getSeminarId(), video.getSeminarName());
        }
        this.initialized = true;

        return this;
    }


    isInitialized() {
        return this.initialized;
    }

    getLists() {
        return this.lists;

    }

    getList(list) {
        return this.lists.filter((l) => l.value === list)[0];
    }

    filterById(data) {

        let id = [];
        for (let i = 0; i < data.length; i++) {
            id.push(data[i].resourceId);
        }


        let filter = this.videos.filter(video => {
            if (id.includes(video.getResourceId())) {
                return video;
            }
        });
        console.log(filter);

        return filter;
    }





    getSeminarOptions() {

        return [...this.seminars.keys()].map((id) => { return { value: id, label: this.seminars.get(id) } });
    }


    getAllVideos() {
        let videoList = [];
        let v = this.videos;

        for (var i = v.length - 1; i > -1; i--) {
            videoList.push(v[i]);
        }
        return videoList;
    }


    sortAlpha() {
        return this.videos.toSorted((a, b) => {
            let textA = a.getVideoName();
            let textB = b.getVideoName();
            return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
        });
    }



    static group(videos = [], by = "seminar") {



        let filtered = videos.filter((video) => video.getSeminarId());

        return Object.groupBy(filtered, (video) => video.getSeminarId());

        // if by == "year" then return  something else.
    }



    sortByOldestSeminar() {
        return Object.groupBy(this.videos, (video) => video.getSeminarName());
        /*
        const keys = Object.keys(grouped);
        const reversedKeys = keys.reverse();
        const reversedGroupedObj = {};

        reversedKeys.forEach(key => {
            reversedGroupedObj[key] = grouped[key];
        });

        return reversedGroupedObj;
        */
    }


    filterBySeminarId(seminarId, IDS_ONLY = false) {

        let videos = this.videos.filter((video) => video.getSeminarId() == seminarId && seminarId != null);

        return IDS_ONLY ? videos.map((video) => video.getResourceId()) : videos;
    }


    getVideo(resourceId) {
        return this.videos.filter((video) => video.resourceId === resourceId)[0];
    }


    getVideosById(ids = []) {

        return this.videos.filter((video) => ids.includes(video.resourceId));
    }


    getVideos(filterIds = null) {

        return this.videos.filter((video) => (null == filterIds || filterIds.length < 1) ? true : filterIds.includes(video.getResourceId()));
    }



    getRelatedVideos(resourceId) {

        let video = this.videos.filter((v) => v.getResourceId() == resourceId)[0];

        return this.filterBySeminarId(video.getSeminarId());
    }

}
