import Video from '../models/Video.js';


export default class VideoDataParser {
    videos;

    constructor(videos) {
        this.videos = videos;
    }


    static parse(apiData) {
        console.log(apiData[0].Event__r.Name);
        let videos = [];
        for (let d in apiData) {
           
            let vd = apiData[d];

            videos.push(Video.fromApiData(vd));
            //console.log(this.videoDataArray);
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

    }

    sortSeminar() {
        
    }

    getVideos() {
        return this.videos;
    }

    groupBySeminar() {
        
        return Object.groupBy(this.videos, (video) => video.getSeminarName());
    }

    
    

}
