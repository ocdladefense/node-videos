import Video from '../models/Video.js';


export default class VideoDataParser {
    videoDataArray;

    constructor(videoData) {
        this.videoData = videoData;
    }

    getVideoData() {
        this.videoDataArray = [];
        for (let d in this.videoData) {
           
            let vd = this.videoData[d];

            this.videoDataArray.push(Video.fromApiData(vd));
            //console.log(this.videoDataArray);
        }
        
        return this.videoDataArray;
    }

    

}
