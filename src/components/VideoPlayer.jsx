import VideoControlBar from './VideoControlBar.jsx';
import React, { useEffect, useState } from 'react';

export default function YouTubePlayer({ video, user, onBack }) {
    const [player, setPlayer] = useState(null);
    const [timeStamp, setTimeStamp] = useState(null);
    const handlePlayerReady = (event) => {
        setPlayer(event.target)
    }

    let elapsedTime = user.previouslyWatched[0].timeStamp;

    useEffect(() => {
        window.onYouTubeIframeAPIReady = () => {
            const config = window.ydc.configYoutubeDisplay(video, elapsedTime, handlePlayerReady);
            const newPlayer = new window.YT.Player('player', config);
            setPlayer(newPlayer);
        }
        window.ydc.injectScriptElement();
    });
    return (
        <div id="videoPlayer">

            <div id="player"></div><br />
            <VideoControlBar player={player} setTime={setTimeStamp} />
        </div>

    );
}
