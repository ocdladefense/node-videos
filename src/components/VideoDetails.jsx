import React, { useState } from "react";

export default function VideoDetails({ video, onBack, setRoute, user }) {
    const prevWatched = user.getWatchedVideo(video.getVideoResourceId());
    const purchasedVideo = user.getPurchasedVideo(video.getVideoResourceId());
    const [isPlayable, setIsPlayable] = useState(() => purchasedVideo != null || video.isFree() ? true : false);
    console.log("get purchased vids", user.getUserPurchasedVideos());
    const onPlay = function() {
        console.log("About to play the video!");
        setRoute("player");
    };

    const playFromBeginning = function() {
        prevWatched.timeStamp = 0;
        console.log(prevWatched.timeStamp);
        setRoute("player");
    }

    const purchase = function() {
        user.addToPurchasedVideos(video);
        console.log(user.getUserPurchasedVideos());
        setIsPlayable(true);
    }




    return (
        <div className="video-details bg-black min-h-screen">
            <button className="text-white" onClick={onBack}>← Back to List</button>
            <h1 className="text-2xl text-white">{video.getVideoName()}</h1>
            <img
                src={video.getVideoThumbnail(video.getMaxResThumb())}
                alt={'Thumbnail for ' + video.getVideoName()}
                style={{ width: '60%', height: '60%' }}
            />
            <h2 className="text-2xl text-white">{video.getVideoDescription()}</h2>

            <div className="options">
                {/* <button className="text-xl border-2 bg-white rounded-lg px-2 py-2" onClick={onPlay}> Play Video </button>
                <button className="text-xl border-2 bg-white rounded-lg px-2 py-2" > Purchase {video.isFree() ? "Free!" : "$19.99"} </button>
                <button className="text-xl border-2 bg-white rounded-lg px-2 py-2"> Resume/Continue </button>
                <button className="text-xl border-2 bg-white rounded-lg px-2 py-2"> Start From Beginning </button>
                <button className="text-xl border-2 bg-white rounded-lg px-2 py-2"> Play Again </button> */}

                {/* Conditional rendering depending on if the video is in the user's previously watched videos */}
                {/* TODO: Set up purchase button to display if video is not free and video is not in purchased videos 
                          Set up state so that component rerenders when video is purchased.*/}
                {
                    isPlayable ?
                        prevWatched === null ?
                            <button className="text-xl border-2 bg-white rounded-lg px-2 py-2" onClick={onPlay}> Play Video </button>
                            :
                            <>
                                <button className="text-xl border-2 bg-white rounded-lg px-2 py-2" onClick={onPlay}> Resume/Continue </button>
                                <button className="text-xl border-2 bg-white rounded-lg px-2 py-2" onClick={playFromBeginning}> Start From Beginning </button>
                            </>
                        :
                        <button className="text-xl border-2 bg-white rounded-lg px-2 py-2" onClick={purchase}>Purchase $19.99</button>
                }




            </div>
        </div>
    );
}
