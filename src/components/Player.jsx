import VideoControlBar from './VideoControlBar.jsx';
import React, { useEffect, useState } from 'react';

export default function YoutubePlayer({ videoData, index }) {
    const [player, setPlayer] = useState(null);
    const handlePlayerReady = (event) => {
        setPlayer(event.target)
    }

    useEffect(() => {
        window.onYouTubeIframeAPIReady = () => {
            const config = window.ydc.configYoutubeDisplay(videoData, index, handlePlayerReady);
            const newPlayer = new window.YT.Player('player', config);
            setPlayer(newPlayer);
        }
        window.ydc.injectScriptElement();
    });
    return (
        <div id="videoPlayer">
            <div id="player"></div><br />
            <VideoControlBar player={player} />
        </div>

    );
}
