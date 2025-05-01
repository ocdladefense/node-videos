import React from "react";

export default function VideoDetails({ video, onBack, setRoute }) {

    let onPlay = function() {
        console.log("About to play the video!");
        setRoute("player");
    };


    return (
        <div className="video-details bg-black">
            <button className="text-white" onClick={onBack}>← Back to List</button>
            <h1 className="text-2xl text-white">{video.getVideoName()}</h1>
            <img
                src={video.getVideoThumbnail()}
                alt={'Thumbnail for ' + video.getVideoName()}
                style={{ width: '60%', height: '60%' }}
            />
            <h2 className="text-2xl text-white">{video.getVideoDescription()}</h2>

            <div className="options">
                <button className="text-xl border-2 bg-white rounded-lg px-2 py-2" onClick={onPlay}> Play Video </button>
                <button className="text-xl border-2 bg-white rounded-lg px-2 py-2" > Purchase {video.isFree() ? "Free!" : "$19.99"} </button>
                <button className="text-xl border-2 bg-white rounded-lg px-2 py-2"> Resume/Continue </button>
                <button className="text-xl border-2 bg-white rounded-lg px-2 py-2"> Start From Beginning </button>
                <button className="text-xl border-2 bg-white rounded-lg px-2 py-2"> Play Again </button>
            </div>
        </div>
    );
}
