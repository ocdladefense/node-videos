
/**
 * Application to play media using the specified media player.
 *   @accessService - External service to determine whether  
 */
domReady(function(){
    
	const accessService = new VideoAccess();
    
	const player = new VideoPlayer("player");
    player.accessChecker(accessService);
    player.setWidth("800");
    player.setHeight("500");
    player.load("https://www.youtube.com/iframe_api");
    
    const playerEvents = new VideoEvents(player);
    playerEvents.init();



    // Keep track of our clicks on the picker.
    window.eventLocator = Component.nodeLocatorNew(".video-asset-container");

    if(initialSubjectId && initialVideoId) {
		loadThumbnails(initialSubjectId); // Initial subjectId is the Event id - this loads up thumbnails in the "picker" (area to the right)
    	playerEvents.loadVideo(initialVideoId); // Is the lookup we do from the id we pass in the query string. 
    	// If an id is passed in, we're looking up the resource id for it and immediately attempting to play that video.
    	// NOTE: If the customer hasn't purchased the video, then an access error will be displayed.
    }
    
    var filter = document.querySelector("select.subject-picker");
    filter.addEventListener("change",function(e){
       var target = e.target;
       var eventId = target.options[target.selectedIndex].value;
       loadThumbnails(eventId);
    });
});



// We are missing a line of code that sets the appropriate <option> in the select element.
// This needs to be a "two-way" street: the user can select an event from the dropdown; or
// we can pass in the event id from some other mechanism (like the url). TODOFOOBAR
function loadThumbnails(initialSubject) {
        
    const assets = new VideoAssetServiceSalesforce();
    
    
    console.log("This is the initialsub");
    console.log(initialSubject);
    //Code that changes the 
    //const initialSubjectId = '{!subjectId}'; // Rename to EventId?
    const picker = [document.querySelector(".subject-picker").children];
    picker.forEach((selection) => {
        console.log(selection.value);
        if (selection.value == initialSubject) {
            picker.selectedIndex = selection;
        }
    });
    
    let thumbs = assets.getThumbnails(initialSubject);
     
    thumbs.then(function(thumbs){
		document.querySelector("#picker #picker-list").innerHTML = "";
        console.log("Media assets are: ", thumbs);
        return thumbs.map(VideoComponent.Thumbnail);
    })
    .then(function(vNodes){
        let container = Render.vNode('div',{id: 'media-asset-container'}, vNodes);
        let elem = Render.createElement(container);

        document.querySelector("#picker #picker-list").appendChild(elem);  
    });

}



