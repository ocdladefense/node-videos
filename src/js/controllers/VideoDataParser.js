import Video from '../models/Video.js';


export default class VideoDataParser {
    videos = [];

    initialized = false;

    constructor(videos) {
        this.videos = videos;
    }


    parse(apiData) {
        apiData = apiData || [];

        let videos = [];
        for (let d in apiData) {
            let vd = apiData[d];
            videos.push(Video.fromApiData(vd));
        }
        this.videos = videos;
        this.initialized = true;

        return this;
    }


    isInitialized() {
        return this.initialized;
    }

    getLists() {

        return [
            { layout: "flat", value: "all", title: "All" },
            { layout: "grouped", value: "seminar", title: "By Seminar" },
            { value: "recent", title: "Recently Added" },
            { value: "coming", title: "Coming Soon" },
            { value: "favorites", title: "Favorites" },
            { value: "continue", title: "Continue Watching" },
            { value: "purchased", title: "Purchased" }, // List of all videos that have been purchased.
        ];
    }

    getList(list, seminars) {
        if (list) {
            console.log(seminars);
            let lists = this.getLists();
            if (list.includes(lists)) {
                let filtered = lists.filter((item) => list === item.value)[0];
                console.log(filtered);
                return filtered;
            } else {
                let filtered = seminars.filter((item) => list === item.value)[0];
                console.log(filtered);
                return filtered;
            }
        }
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





    getSeminars() {
        let seminars = [];
        let grouped = this.groupBySeminar()
        seminars.push({ layout: "grouped", value: "seminar", title: "All Seminars" });

        for (const key in grouped) {

            seminars.push({ layout: "grouped", value: key, title: key })
        }
        console.log(seminars);
        return seminars;
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



    groupBySeminar() {
        let grouped = Object.groupBy(this.videos, (video) => video.getSeminarName());
        const keys = Object.keys(grouped);
        const reversedKeys = keys.reverse();
        const reversedGroupedObj = {};

        reversedKeys.forEach(key => {
            reversedGroupedObj[key] = grouped[key];
        });

        return reversedGroupedObj;
    }

    sortByOldestSeminar() {
        return Object.groupBy(this.videos, (video) => video.getSeminarName());
    }


    filterSeminar(list) {
        let grouped = this.groupBySeminar();
        let filtered = Object.fromEntries(Object.entries(grouped).filter(([key]) => key === list));
        console.log(filtered);
        return filtered;
    }


    getVideo(resourceId) {
        return this.videos.filter((video) => video.resourceId === resourceId)[0];
    }


    getVideos(list, prevWatched, purchased) {

        // switch (list) {
        //     case "all":
        //         return this.getAllVideos();
        //         break;
        //     case "seminar":
        //         return this.groupBySeminar();
        //         break;
        //     case "continue":
        //         return this.filterById(prevWatched);
        //         break;
        //     case "purchased":
        //         return this.filterById(purchased);
        //     default:
        //         return this.getAllVideos();
        // }
        console.log(list);
        if (list === "all") {
            return this.getAllVideos();
        } else if (list === "seminar") {
            return this.groupBySeminar();
        } else if (list === "continue") {
            return this.filterById(prevWatched);
        } else if (list === "purchased") {
            return this.filterById(purchased);
        } else if (list !== "all" && list !== "seminar" && list !== "recent" && list !== "continue" && list !== "purchased" && list !== undefined) {
            console.log(list);
            return this.filterSeminar(list);
        } else {
            return this.getAllVideos();
        }



    }



    getRelatedVideos(resourceId) {

        if (!this.videos || this.videos.length === 0) return [];

        let grouped = this.groupBySeminar();
        let video = this.videos.filter((v) => v.getResourceId() == resourceId)[0];

        let related = video.getSeminarName() && grouped[video.getSeminarName()];

        return related || []; // At least return an empty array.
    }

}
