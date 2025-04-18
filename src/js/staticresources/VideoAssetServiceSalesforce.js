const VideoAssetServiceSalesforce = (function(){
    
    
	let callout;
    
    
    function getThumbById(thumbs, resourceId){
        if(null == resourceId) return {};
        for(var i = 0; i < thumbs.length; i++){
            if(resourceId == thumbs[i].resourceId) return thumbs[i];
        }
        return {};
    }
    
    
    var VideoAssetServiceSalesforce = function() {
        // Prepare a Visualforce remoting callout to fetch Media assets
        callout = ForceRemoting.invokeAction(null);
    }

    
    function getThumbnails(initialSubjectId) {
        
        // Execute it.
        $assets = callout("VideoApp","getAssets",initialSubjectId);

        // Render the resources and thumbnails.
        //  Only render those where published flag = true.
        return $assets.then(function(assets) {
            return assets.filter(function(asset){
                return asset.resourceId != null && asset.published == true;
            });
        })
        .then(function(assets){
            let resourceIds = assets.map(function(asset){
                return asset.resourceId;
            });
    
            let thumbs = VideoComponent.getYTthumbs(resourceIds);
            
            let compose = function(thumbs) {
                return assets.map(function(asset) {
                            var thumb = getThumbById(thumbs, asset.resourceId);
                            asset.src = thumb.src;
                            return asset;
                });
            };
            
            return thumbs.then(compose);
        });
    }
      
    

    VideoAssetServiceSalesforce.prototype = {
        getThumbnails: getThumbnails
    };
    
    
    return VideoAssetServiceSalesforce;
})();
    
    
