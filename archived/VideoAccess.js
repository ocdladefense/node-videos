const VideoAccess = (function(){
    
    
    function hasAccess(videoId) {
        var callout = ForceRemoting.invokeAction(null);
        return callout("VideoApp","getHasAccess",videoId).then(function(hasAccess){
            if(!hasAccess) {
                throw new Error("NO_ACCESS_ERROR"); 
            } else {
                return true;
            }
        });
    }
    
    
    
    function VideoAccess() {}
    
    VideoAccess.prototype = {
        hasAccess: hasAccess  
    };
    
    return VideoAccess;
})();