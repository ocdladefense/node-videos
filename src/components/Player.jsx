import React, { useEffect, useState } from 'react';

export default function YoutubePlayer({ videoData, index }) {
    const [player, setPlayer] = useState(null);
    const handlePlayerReady = (event) => {
        setPlayer(event.target)
    }

    useEffect(() => {
        window.onYouTubeIframeAPIReady = () => {
            const config = window.ydc.configYoutubeDisplay(videoData, index , handlePlayerReady);
            const newPlayer = new window.YT.Player('player', config);
            window.newPlayer = newPlayer;
            setPlayer(newPlayer);
        }
        window.ydc.injectScriptElement();
    });
    return (
        <div id="controls">
            <div id="player"></div>
            <div className="controls">
                <button onClick={() => newPlayer.playVideo()}>Start</button>
                <button onClick={() => newPlayer.pauseVideo()}>Pause</button>
                <button onClick={() => newPlayer.stopVideo()}>Stop</button>
                <button onClick={() => {
                    newPlayer.seekTo(0, true);
                    newPlayer.playVideo();
                }}>Restart</button>
            </div>
        </div>
    );
}
