import Video from '../models/Video.js';


export default class VideoDataParser {
    videos;

    constructor(videos) {
        this.videos = videos;
    }


    static parse(apiData) {
        apiData = apiData || [];

        let videos = [];
        for (let d in apiData) {
            let vd = apiData[d];
            videos.push(Video.fromApiData(vd));
        }

        return new VideoDataParser(videos);
    }

    //vidData.sort((a, b) => Date.parse(b.getSeminarDate()) - Date.parse(a.getSeminarDate()));

    /*
    const alphabetical = videos.toSorted((a, b) => {
        let textA = a.getVideoName();
        let textB = b.getVideoName();
        return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
    });

    const sortAlpha = () => setFilter(alphabetical);


    const sortSeminar = () => setFilter(videos);

*/
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
        return this.videos;
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
            }
            return acc;
        }, {});
    }




}
