import React, { useEffect, useState } from 'react';
import '../css/videostyles.css';


import { Skeleton as PlayerPlaceholder } from '@mui/material';

let sourceType = 'youtube'


export default function VideoPlayer({ userWatchProgress, onReady, onStateChange, player, handleTimestamp, setElapsed, setIsPlaying, setIsPolling }) {
    const [isInit, setIsInit] = useState(false);

    useEffect(() => {
        const PlayerClass = window.playerMap[sourceType];
        const instance = new PlayerClass();

        instance.loadPlayer(
            'player',
            userWatchProgress,
            onReady,
            onStateChange,
            handleTimestamp,
            setElapsed,
            setIsPlaying,
            setIsPolling,
        );

        setIsInit(true);
    }, [player, isInit]);

    return isInit ? (
        <div id="player-wrapper">
            <div id="player"></div>
            <div id="blocker"></div>
        </div>
    ) : (
        <PlayerPlaceholder variant="rectangular" animation="wave" width={1280} height={720} />
    );
}
