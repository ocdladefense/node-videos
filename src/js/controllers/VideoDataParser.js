import Video from '../models/Video.js';


export default class VideoDataParser {
    videoDataArray;

    constructor(videoData) {
        this.videoData = videoData;
    }

    getVideoData() {
        console.log(this.videoData[0].Event__r.Name);
        this.videoDataArray = [];
        for (let d in this.videoData) {
           
            let vd = this.videoData[d];

            this.videoDataArray.push(Video.fromApiData(vd));
            //console.log(this.videoDataArray);
        }
        
        return this.videoDataArray;
    }

    
    

}
