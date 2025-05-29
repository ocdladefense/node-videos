import Video from '../models/Video.js';


export default class VideoDataParser {
    videos = [];





    /*
    const actions = {
        all: sortByOldestSeminar,
        recent: { value: "recent", title: "Most Recent", action: sortByNewestSeminar },
        oldest: { value: "oldest", title: "Oldest", action: sortByOldestSeminar },
        my: { value: "my", title: "My List", action: sortByOldestSeminar },
        favorites: { value: "favorites", title: "Favorites", action: sortByOldestSeminar },
        continue: { value: "continue", title: "Continue Watching", action: sortByOldestSeminar }
    };
    */

    // const sortByNewestSeminar = () => setFilter(parser.groupBySeminar());
    // const sortByOldestSeminar = () => setFilter(parser.sortByOldestSeminar());
    // const filterBySeminar = (seminar) => setFilter(parser.filterBySeminar(seminar));

    getLists() {

        return [
            { type: "flat", value: "all", title: "All" },
            { value: "recent", title: "Most Recent" },
            { type: "grouped", value: "seminar", title: "By Seminar" },
            { value: "oldest", title: "Oldest" },
            { value: "my", title: "My List" },
            { value: "favorites", title: "Favorites" },
            { value: "continue", title: "Continue Watching" }
        ];
    }

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

        return this;
    }



    getSeminars() {
        let seminars = [];
        let grouped = this.groupBySeminar()
        seminars.push({ title: "All Seminars", type: "grouped", value: "seminar" });

        for (const key in grouped) {

            seminars.push({ title: key, type: "grouped", value: key })
        }

        return seminars;
    }


    sortAlpha() {
        return this.videos.toSorted((a, b) => {
            let textA = a.getVideoName();
            let textB = b.getVideoName();
            return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
        });
    }

    sortSeminar() {

    }

    getVideos() {
        let v = this.videos.reverse();
        return v;
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

    filterBySeminar(seminar) {
        console.log(seminar);
        let grouped = Object.groupBy(this.videos, (video) => video.getSeminarName());
        return Object.keys(grouped).reduce((acc, key) => {
            if (seminar.includes(key)) {
                acc[key] = grouped[key];
                acc[key] = grouped[key];
            }
            return acc;
        }, {});

    }

    getVideoList(list) {
        switch (list) {
            case "all":
                return this.getVideos();
                break;
            case "seminar":
                return this.groupBySeminar();
                break;
            default:
                return this.filterBySeminar(list);

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
