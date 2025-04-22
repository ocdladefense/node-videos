const VideoComponent = (function(){
    
    
    
    var parts = "snippet,contentDetails,statistics";
    var videoId = ["4mxFb5VH12Y"];
    var apiKey = "AIzaSyB95m4ud1CBRSP-4evnK_ng8CkMBG6Hyu0";
    var endpoint = "https://www.googleapis.com/youtube/v3/videos";
    
    
    
    const Thumbnail = function(item){
//        let src = item.src(item.thumb && item.thumb.image && item.thumb.image.url) || item.videoThumbnailDefault;
        let title = Render.vNode('div',{className:'video-asset-title'},item.name);
        let img = Render.vNode('img',{className:'video-asset-thumbnail',src:item.src});
        let speakers = Render.vNode('div',{className:'video-asset-speakers'},item.speakers);
        let description = Render.vNode('div',{className:'video-asset-description'},item.description);
        let props = {
            className: 'video-asset-container',
            "data-video-id":item.resourceId
        };
        let data = {
            published: true,
            resourceId: item.resourceId
        };
        
        let vNode = Render.vNode('div',props,[img,title,speakers,description]);
        vNode.data = data;
        
        return vNode;
    };
    
    
        

        
    
    
   function getThumbs(resourceIds) {

       return resourceIds.map(function(id) { return {resourceId: id, src: videoThumbnailDefault}; });
	}
                                   
          
                                   
   function getYTthumbs(resourceIds) {                         
                                   
        let params = resourceIds.join(",");
        let url = endpoint + "?part="+parts+"&id="+params+"&key="+apiKey;
       
        $thumbs = fetch(url);
        
        return $thumbs.then( function(resp) {
            return resp.json();
        })
        .then( function(json) {

            return json.items.map(function(item){
                return {
                    resourceId: item.id,
                    src: item.snippet.thumbnails.medium.url
                };
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
    

    
    
    /**
     * Return a data structure that combines the thumbnail data
     *   with the item data.
     */
    var prepareThumbnailData = function(resourceIds){

        let callout = getThumbs(resourceIds);
        
        return callout.then(function(thumbs){
            // console.log("Thumbs are: ",thumbs);
            return resources.map(function(chapter){
                chapter.thumb = getThumbById(thumbs,chapter.VideoURL);
                return chapter;
            });
        });
    };

    
    
    
   return {
       Thumbnail: Thumbnail,
       getYTthumbs: getYTthumbs,
       getThumbs: getThumbs
   };
    
    
})();