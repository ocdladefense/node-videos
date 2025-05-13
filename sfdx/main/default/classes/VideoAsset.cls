public class VideoAsset {
        public Id Id;
        
        public Id Event;
        
        public String Name;
        
        public DateTime StartDate;
        
        public String Title;
        
        public Boolean PublishVideo;
        
        public String VideoURL;
        
        public String[] Speakers = new String[]{};
        
        public void addSpeaker(String name){
            this.Speakers.add(name);
        }
        
        public VideoAsset(Chapter__c chapter){
            this.Id = chapter.Id;
            this.Event = chapter.Event__c;
            this.Name = chapter.Name;
            this.StartDate = chapter.StartDate__c;
            this.Title = chapter.Title__c;
            this.PublishVideo = chapter.PublishVideo__c;
            this.VideoURL = chapter.VideoURL__c;
        }



    }