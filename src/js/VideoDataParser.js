import VideoData from "./VideoData";


export default class VideoDataParser {
    videoDataArray;

    constructor(videoData) {
        this.videoData = videoData;
    }

    getVideoData() {
        this.videoDataArray = [];
        for (let d in this.videoData) {
           
            let vd = this.videoData[d];
            
            this.videoDataArray.push(new VideoData(vd));
            //console.log(this.videoDataArray);
        }
        
        return this.videoDataArray;
    }

    

}
