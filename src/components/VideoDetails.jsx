import React from "react";

export default function VideoDetails({ video, onBack, setRoute }) {

    let onPlay = function() {
        console.log("About to play the video!");
        setRoute("player");
    };


    return (
        <div style={{ backgroundColor: 'black' }} className="video-details">
            <button style={{ color: 'white' }} onClick={onBack}>← Back to List</button>
            <h1 style={{ color: 'white' }}>{video.getVideoName()}</h1>
            <img
                src={video.getVideoThumbnail()}
                alt={'Thumbnail for ' + video.getVideoName()}
                style={{ width: '50%', height: '50%' }}
            />
            <h2 style={{ color: 'white' }}>{video.getVideoDescription()}</h2>

            <div className="options space-y-4 text-white">
                <button
                    className="text-xl border-2 border-white rounded-lg px-2 py-2"
                    onClick={onPlay}
                >
                    Play Video
                </button>
                <button
                    className="text-xl border-2 border-white rounded-lg px-6 py-2"
                >
                    Purchase {video.isFree() ? "Free!" : "$19.99"}
                </button>
                <button
                    className="text-xl border-2 border-white rounded-lg px-6 py-2"
                >
                    Resume/Continue
                </button>
                <button
                    className="text-xl border-2 border-white rounded-lg px-6 py-2"
                >
                    Start From Beginning
                </button>
                <button
                    className="text-xl border-2 border-white rounded-lg px-6 py-2"
                >
                    Play Again
                </button>
            </div>
        </div>
    );
}
{/* <li>{video.isFree() ? "Free!" : 'N/A'}</li> */ }
