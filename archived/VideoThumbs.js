const VideoThumbnails = (function(){
    
    
    var parts = "snippet,contentDetails,statistics";
    var videoId = ["4mxFb5VH12Y"];
    var apiKey = "AIzaSyB95m4ud1CBRSP-4evnK_ng8CkMBG6Hyu0";
    var endpoint = "https://www.googleapis.com/youtube/v3/videos";
    
   function getThumbs(ids) {
       ids = ids.join(",");
       
       let url = endpoint + "?part="+parts+"&id="+ids+"&key="+apiKey;
       
        $thumbs = fetch(url);
        
        return $thumbs.then( function(resp) {
            return resp.json();
        })
        .then( function(json) {
            console.log(json);
            return json.items.map(function(item){
                console.log(item);
                var obj = {};
                var id = item.id;
                obj["id"] = id;
                obj["image"] = item.snippet.thumbnails.medium;
                return obj;
            });
        });

   }  
   
    
    
    function getThumbById(thumbs,id){
        if(null == id) return {};
        for(var i = 0; i < thumbs.length; i++){
            if(id == thumbs[i].id) return thumbs[i];
        }
        return {};
    }
    
    var prepareThumbnailData = function(chapters){

        var published = chapters.filter(function(chapter){return chapter.VideoURL != null && chapter.PublishVideo != false;});
        console.log("Chapters are: ",published);
        
        videoIds = published.map(function(chapter){
            return chapter.VideoURL;
        });
        return getThumbs(videoIds).then(function(thumbs){
            console.log("Thumbs are: ",thumbs);
            return chapters.map(function(chapter){
           		chapter.thumb = getThumbById(thumbs,chapter.VideoURL);
                return chapter;
            });
        });
    };

    
    
    
    
    
    
    
    
   return {
       getThumbs: getThumbs,
       prepareThumbnailData: prepareThumbnailData
   };
    
})();