import React, { useState } from 'react';

import VideoPlayer from './VideoPlayer';
import VideoControlBar from './VideoControlBar';

import { videoPlayerTheme, VideoContainer, TitleContainer, ControlBarContainer, ArrowBackButton } from '../js/videostyles.js';
import '../css/videostyles.css';

import { ThemeProvider, Tooltip } from '@mui/material';

export default function VideoPlayerContainer({ video, user, onBack }) {
    const [player, setPlayer] = useState(null);

    let userWatchProgress = user.getWatchedVideo(video.resourceId);

    if (!userWatchProgress) {
        user.addToWatchedVideos(video.resourceId);
        userWatchProgress = user.getWatchedVideo(video.resourceId);
    }

    const handleTimestamp = (event) => {
        let runTime = Math.floor(player.getCurrentTime());
        user.updateTimestamp(userWatchProgress.resourceId, runTime);
        console.log(runTime)
    }

    /*TODO:
    - get handleTimestamp() to work with onBack, 
    - figure out work-around to have my component rerender 
    */

    return (

        <ThemeProvider theme={videoPlayerTheme}>

            <TitleContainer>
                <Tooltip title="Return to Video Details Page" placement="left">
                    <ArrowBackButton onClick={() => { onBack(); }} />
                </Tooltip>
                <h1>{video.getVideoName()}</h1>
            </TitleContainer>

            <VideoContainer>
                <VideoPlayer userWatchProgress={userWatchProgress} onReady={setPlayer} />
            </VideoContainer>

            <ControlBarContainer>
                <VideoControlBar user={user} player={player} userWatchProgress={userWatchProgress} handleTimestamp={handleTimestamp} />
            </ControlBarContainer>

        </ThemeProvider>

    )
}
