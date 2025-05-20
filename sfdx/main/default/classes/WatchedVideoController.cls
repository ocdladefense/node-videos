public class WatchedVideoController {
    public List<Watched_Video__c> watchedVideos {get; set;}

    public WatchedVideoController() {
        watchedVideos = [
            SELECT User_ID__c, Video_ID__c, Watch_Timestamp__c
            FROM Watched_Video__c
        ];
    }
}
