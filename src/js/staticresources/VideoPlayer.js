const VideoPlayer = (function(){
    
    
    
    // A YouTube player instance.
    // Instance can be destroyed and reassigned.
    var player = null;
           
    
    // Default access service
    //  Give everyone access, by default.
    var permissionService = { hasAccess: function(){ return Promise.resolve(true); } };
    
    
            
	function loadYouTubeApi(url) {
      // 2. This code loads the IFrame Player API code asynchronously.
      var tag = document.createElement('script');

      tag.src = url;
      var firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
	}
            
        
    
    function onYouTubeIframeAPIReady() {
      console.log("Called onYouTubeIframeAPIReady.");
      // getPlayer("Z74Fe3_zUC8");
    }
        
    function init(videoId) {

        var params = {
            width: this.width,
            height: this.height,
            videoId: videoId,
            events: {
                'onReady': onPlayerReady,
                'onStateChange': onPlayerStateChange
            },
            playerVars: {
                autoplay: 0,
                origin: "https://ocdpartial-ocdla.cs70.force.com",
                frameborder: 1,
                enablejsapi: 1,
                controls: 0,
                rel: 0,
                widget_referrer: "https://ocdpartial-ocdla.cs70.force.com"
            }
        };

        player = new YT.Player(this.targetId, params);
    }
    

    function onPlayerReady(event) {
        // event.target.playVideo();
        // VideoEvents.beginTimer();
        document.body.classList.add("with-video-player");
    }
    
    
    
    function onPlayerStateChange(event) {
        if (event.data == YT.PlayerState.PLAYING) {
          // setTimeout(stopVideo, 6000);
        }
    }
    

    
    
    function Player(targetId) {
		this.targetId = targetId;
        this.width = null;
        this.height = null;
        window.onYouTubeIframeAPIReady = function(){"YouTube API Loaded."};
    }


    
    var prototype = {
        init: init,
        load: loadYouTubeApi,
        accessChecker: function(accessService) {
           	permissionService = accessService;
        },
        setHeight: function(height) {
            this.height = height;
        },
        setWidth: function(width) {
            this.width = width;
        },
        getDuration: function() {
            return player.getDuration();
        },
        getCurrentTime: function() {
            return player.getCurrentTime();
        },
        play: function(resourceId) {
                
            if(!resourceId){
                return Promise.resolve(player.playVideo());
            }
            
            return permissionService.hasAccess(resourceId).then((hasAccess) => {
    
                if(!player) {
                    this.init(resourceId);
                }
                else if(resourceId) {
                    player.loadVideoById(resourceId); 
                    player.playVideo();
                }
            });
            

        },
        stop: function() {
            player.stopVideo();
        },
        pause: function() {
            player.pauseVideo();
        },
        seek: function(sec) {
            player.seekTo(sec);
        }
    };
    
    Player.prototype = prototype;
    
    
    
    return Player;
})();

