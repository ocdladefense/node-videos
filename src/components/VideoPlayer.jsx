import React, { useEffect, useState } from 'react';
import '../css/videostyles.css';

import { Skeleton } from '@mui/material';

export default function VideoPlayer({ userWatchProgress, onReady, onStateChange }) {
    const [playerReady, setPlayerReady] = useState(false);

    useEffect(() => {
        const onYouTubeIframeAPIReady = () => {

            const config = window.ydc.configYoutubeDisplay(userWatchProgress, (event) => { onReady(event.target), onStateChange; });

            new window.YT.Player('player', config);
        };

        if (window.YT && window.YT.Player) {
            onYouTubeIframeAPIReady();
        }

        else {
            window.onYouTubeIframeAPIReady = onYouTubeIframeAPIReady;
            window.ydc.injectScriptElement();
        }

        setPlayerReady(true);
    }, [playerReady]);

    return playerReady ? (
        <div id="player-wrapper">
            <div id="player"></div>
            <div id="blocker"></div>
        </div>
    ) : (
        <Skeleton variant="rectangular" animation="wave" width={1280} height={720} />
    );
}
