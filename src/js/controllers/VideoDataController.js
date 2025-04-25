
import VideoDataParser from "./VideoDataParser";
import videos from '../../data/videos.json';

const dataUrl = "https://ocdla.my.site.com/VideoData";

export default class VideoDataController {
    constructor(dataUrl) {
        this.dataUrl = dataUrl;
    }

    // async fetchVideoData() {
    //     try {
    //         const response = await fetch(this.dataUrl);
    //         if (!response.ok) throw new Error("Failed to fetch video data.");
    //         return await response;
    //     } catch (error) {
    //         console.error("Error in fetchVideoData:", error.message);
    //         return null;
    //     }
    // }

    parseVideoData(videoData) {
        let parser = new VideoDataParser(videoData);
        let data = parser.getVideoData();
        return data;
    }

    getVideoById(videoId, videoData) {
        
        let filter = videoData.filter(video => video.id === videoId )
        return filter.length === 1 ? filter[0] : filter;
    }

    
}
