import React, { useEffect, useState } from 'react';
import '../css/videostyles.css';

import { Skeleton } from '@mui/material';

export default function YouTubePlayer({ userWatchProgress, onReady }) {
    const [playerReady, setPlayerReady] = useState(false);

    useEffect(() => {
        window.onYouTubeIframeAPIReady = () => {
            const config = window.ydc.configYoutubeDisplay(userWatchProgress, (event) => {
                onReady(event.target)
            });
            new window.YT.Player('player', config);
        }
        setPlayerReady(true);
        window.ydc.injectScriptElement();
    });

    if (window.YT) {
        onYouTubeIframeAPIReady();
    }

    return playerReady ? (
        <div id="player-wrapper">
            <div id="player"></div>
            <div id="blocker"></div>
        </div>

    ) : (
        <Skeleton variant="rectangular" animation="wave" width={1280} height={720} />
    );

}
