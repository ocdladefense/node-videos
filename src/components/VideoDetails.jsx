import React, { useState } from "react";

export default function VideoDetails({ video, onBack, setRoute, user }) {
    const prevWatched = user.getWatchedVideo(video.getVideoResourceId());
    const purchasedVideo = user.getPurchasedVideo(video.getVideoResourceId());
    const [isPlayable, setIsPlayable] = useState(() => purchasedVideo != null || video.isFree());

    console.log("get purchased vids", user.getUserPurchasedVideos());

    const playVideo = function() {
        console.log("About to play the video!");
        setRoute("player");
    }

    const playVideoFromBeginning = function() {
        setRoute("resetPlayer");
    }

    const purchase = function() {
        user.addToPurchasedVideos(video);
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
                <p className="text-2xl text-zinc-100 mb-4">{video.getVideoDescription()}</p>
                <div className="options space-y-2">
                    {
                        isPlayable ? (
                            prevWatched === null ? (
                                <p>
                                    <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2" onClick={playVideo}>Play Video</button>
                                </p>


                            ) : (
                                <>
                                    <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2 mr-3" onClick={playVideo}>Resume/Continue</button>
                                    <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2" onClick={playVideoFromBeginning}>Start From Beginning</button>
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
};
