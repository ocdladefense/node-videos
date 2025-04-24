
/**
 * YouTube IFrame API loader.
 *
 * 
 */


const YouTube = (function(window) {

	// Where we get the YouTube API script.
	var YT_SCRIPT_SRC = "https://www.youtube.com/iframe_api";


	// Default parameters for our player instances.
	var defaultPlayerParams = {
		autoplay: 0,
		loop: 0,
		enablejsapi: 1,
		controls: 0,
		
	};


	// References to multiple players if we need them.
	var players = {};
	
	
	// Includes playlist actions.
	// For additional play properties
	// and methods see:
	// https://developers.google.com/youtube/iframe_api_reference
	/*
	var actions = {
		play: playVideo,
		pause: pauseVideo,
		stop: stopVideo,
		seekTo: seek,
		nextVideo: next,
		previousVideo: previous,
		playVideoAt: play
		// getIframe()
		// destroy()
	
	};
	*/
    
    




	// player.pauseVideo();
	// player.playVideo();
	function doVideoAction(e) {
		var target = e.target;
		var videoId = target.dataset.videoId;
		var action = target.dataset.action;
		var player = players[videoId];
		
		actions[action](player);
	}




	function ytLoadAsync() {
		var script, firstScriptTag;
		
		script = document.createElement('script');
		script.src = YT_SCRIPT_SRC;
		
		firstScriptTag = document.getElementsByTagName('script')[0];
		firstScriptTag.parentNode.insertBefore(script, firstScriptTag);
	}



      
      

	
	
	function newOriginPlayer(videoId, origin) {
		var params = playerParams(videoId);//, "https://ocdpartial-ocdla.cs70.force.com");
		return newPlayer(params);
	}
	
	
	
	
	function playerParams(videoId, origin) {
		var params = {
			height: '390',
			width: '640',
			videoId: videoId,
			playerVars: defaultPlayerParams,
			events: {
				'onReady': onPlayerReady,
				'onStateChange': onPlayerStateChange
			}
		};
		
		if(null != origin) {
			params.origin = origin;
		}
		
		return params;
	}
	
	
	
	
	function newPlayer(params) {
		return new YT.Player('player', params);
	}
	
	
	


	/**
	 * Begin YouTube API player callbacks.
	 *
	 * Apparently, there are no callbacks in the traditional sense.
	 *  Instead when the API is done loading it call this function.
	 */
	var onYouTubeIframeAPIReady = function() {
		alert('YouTube API has finished loading.');
	};



	/**
	*
	* The API will pass an event object as the sole argument to each of those functions.
	* The event object has the following properties:
	*  -- The event's target identifies the video player that corresponds to the event.
	*  -- The event's data specifies a value relevant to the event.
	*
	* Note that the onReady event does not specify a data property.
	*/
	function onPlayerReady(e) {
			console.log(document);
			
			let share_buttons = document.querySelectorAll('.ytp-share-button-visible');
			
			console.log(share_buttons);
			
			for(var i = 0; i< share_buttons.length; i++){
				share_buttons.item(i).setAttribute('style','display:none;');

			}
	}
   
   
   
   
    
    function init() {
        let cb = {
            // onPlayerReady: onPlayerReady,
            onYouTubeIframeAPIReady: onYouTubeIframeAPIReady
        };
        
        for(var name in cb) {
            window[name] = cb;
        }
        
        ytLoadAsync();
    }

    
    
    return {
        init: init
    };
    
})(window);

