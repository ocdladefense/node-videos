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
        <div className="video-details bg-zinc-900 min-h-screen px-4">
            <button className="text-zinc-100 text-3xl" onClick={onBack}>←</button>

            <div className="video-content max-w-3xl mx-auto">
                <h1 className="text-2xl text-zinc-100 text-left">{video.getVideoName()}</h1>
                <img
                    src={video.getVideoThumbnail(video.getMaxResThumb())}
                    alt={'Thumbnail for ' + video.getVideoName()}
                    className="my-4 mx-auto w-full max-w-5xl"
                />
                <h2 className="text-2xl text-zinc-100 mb-4">{video.getVideoDescription()}</h2>
                <div className="options space-y-2">
                    {
                        isPlayable ? (
                            prevWatched === null ? (
                                <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2" onClick={onPlay}>Play Video</button>
                            ) : (
                                <>
                                    <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2 mr-3" onClick={onPlay}>Resume/Continue</button>
                                    <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2" onClick={playFromBeginning}>Start From Beginning</button>
                                </>
                            )
                        ) : (
                            <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2" onClick={purchase}>Purchase $19.99</button>
                        )
                    }
                </div>
            </div>
        </div>

    );
}
