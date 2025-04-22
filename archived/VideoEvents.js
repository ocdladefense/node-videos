
const VideoEvents = (function(){
    
    // The player object.
    var player;
    
    // Second-timer while video is playing.
    //  Should be cancelled when player state is not playing.
    var playerTimer;
    
    
    // Slider can seek the current video forward or backward.
    var slider;
    
    
    // Play, Stop, Pause, etc.
    var controls;
    
    

    
     
    
    function doAction(e){
		var target = e.target;
        
        if(!target.dataset || !player) return false;
        
        var action = target.dataset.action;

        if(action == "play"){

            player.play();
        }
        if(action == "stop"){
			if(!player.init) onYouTubeIframeAPIReady();
            player.stop();
        }
        
        if(action == "pause"){
			if(!player.init) onYouTubeIframeAPIReady();
            player.pause();
        }
        
        player.init = true;
    }
    

    
    function loadVideo(videoId){
      
        var hasError = false;
        var errorMessage = "You don't have access to this resource.  Please login to access this video.";

        if(null == videoId) {
            console.log("No video id specified.");
            return false;
        }

        player.play(videoId).then(function(){
            beginTimer();                    
        })
        .catch(function(msg){
            alert(msg + "\n\n" + errorMessage);
        });
        
        return false;
    }
    
    
    function getVideoId(e) {
      console.log("Enter load video...");
        
        
        var _target = e.target;
        var target = eventLocator(_target);
        
        if(!target || !target.dataset) return false;
        
        var videoId = target.dataset.videoId;


        return videoId;
    }
    
    function loadFromClick(e) {
        let videoId = getVideoId(e);
        loadVideo(videoId);
    }
    
    
    

    
    function seekVideo(e) {
        clearTimeout(playerTimer);
        
        var target = e.target;
        var percentage = e.target.value;
        var newTime = getElapsedTime(player.getDuration(),percentage);
        player.seek(newTime);
        
        beginTimer(newTime);
    }
    
    function pauseEvents(e) {
        clearTimeout(playerTimer);
    }
    
    function beginTimer(start) {
        playerTimer = setTimeout(function(){
            var elapsed = start || player.getCurrentTime();
            var duration = player.getDuration();
            var percentage = getElapsedTimePercentage(duration,elapsed);
            setSliderElapsedPercentage(percentage);
            beginTimer();
        }, 1000);
    }
    
    function setSliderElapsedPercentage(percentage) {
        slider.value = percentage;
    }
    
    
    function getElapsedTime(total,percentage) {
        return total * (percentage/100);
    }
    
    
    function getElapsedTimePercentage(total,elapsed) {
        return (elapsed / total) * 100;
    }
    
    
    function init() {
        slider.addEventListener("change",seekVideo);
        slider.addEventListener("mousedown touchstart",pauseEvents);
		controller.addEventListener("click",doAction,{capture:false});
    	document.addEventListener("click",loadFromClick,{capture:true});
    }
    
    function destroy() {
        slider.removeEventListener("change",seekVideo);
        slider.removeEventListener("mousedown",pauseEvents);
    }
    
    function VideoEvents(thePlayer) {
        player = thePlayer;
        slider = document.getElementById("time-slider");
    	controller = document.getElementById("video-controls");
        init();
    }
    
    
    
    
    VideoEvents.prototype = {
        init: init,
        destroy: destroy,
        beginTimer: beginTimer,
        setSliderElapsedPercentage: setSliderElapsedPercentage,
        loadVideo: loadVideo
    };

    
    return VideoEvents;
})();


