import Video from '../models/Video.js';


export default class VideoDataParser {
    videos;

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
            { layout: "flat", value: "all", title: "All" },
            { layout: "grouped", value: "seminar", title: "By Seminar" },
            { value: "recent", title: "Recently Added" },
            { value: "coming", title: "Coming Soon" },
            { value: "favorites", title: "Favorites" },
            { value: "continue", title: "Continue Watching" },
            { value: "purchased", title: "Purchased" }, // List of all videos that have been purchased.
        ];
    }

    getList(list) {
        let lists = this.getLists();

        let filtered = lists.filter((item) => list === item.value)[0];
        console.log(filtered);
        return filtered;
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
        seminars.push({ title: "All Seminars", layout: "grouped", value: "seminar" });

        for (const key in grouped) {

            seminars.push({ title: key, layout: "grouped", value: key })
        }

        return seminars;
    }

    getAllVideos() {
        let videoList = [];
        let v = this.videos;
        
        for (var i = v.length - 1; i> -1; i--) {
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

    sortSeminar() {

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

    getVideos(list, prevWatched, purchased) {
        switch (list) {
            case "all":
                return this.getAllVideos();
                break;
            case "seminar":
                return this.groupBySeminar();
                break;
            case "continue":
                return this.filterById(prevWatched);
                break;
            case "purchased":
                return this.filterById(purchased);
            default:
                return this.getAllVideos();


        }
    }




}
