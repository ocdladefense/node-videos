import React from "react";

export default function VideoDetails({ video, onBack, setRoute, timeStamp }) {

    let onPlay = function() {
        console.log("About to play the video!");
        setRoute("player");
    };

    let buttons = [];

    if (timeStamp == 0) {
        buttons.push(<button class="text-xl" onClick={onPlay}>Play Video</button>);
    }
    else {
        buttons.push(<button onClick={onPlay}>Resume/Continue</button>);
    }
    if (timeStamp != 0) {
        buttons.push(<button>Start From Beginning</button>);
    }
    buttons.push(<button>Purchase {video.isFree() ? "Free!" : '$19.99'} </button>);

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
            <div style={{ color: 'white' }} className="options">
                {buttons}
            </div>
        </div>
    )
};

{/* <li>{video.isFree() ? "Free!" : 'N/A'}</li> */ }
