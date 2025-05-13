import React, { useState } from 'react';

import VideoPlayer from './VideoPlayer';
import VideoControlBar from './VideoControlBar';

import { videoPlayerTheme, VideoContainer, TitleContainer, ControlBarContainer, ArrowBack, ArrowBackButton } from '../js/videostyles.js';
import '../css/videostyles.css';

//import ArrowBackIcon from '@mui/icons-material/ArrowBackRounded';

import { ThemeProvider, Tooltip } from '@mui/material';

export default function VideoPlayerContainer({ resetTimestamp, video, user, onBack }) {
    const [player, setPlayer] = useState(null);

    let userWatchProgress = user.getWatchedVideo(video.resourceId);

    if (resetTimestamp === 0) {
        userWatchProgress.timeStamp = 0;

    }

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
                <h1>{video.getVideoName()}</h1>
            </TitleContainer>

            <VideoContainer>
                <VideoPlayer userWatchProgress={userWatchProgress} onReady={setPlayer} />
            </VideoContainer>

            <ControlBarContainer>
                <Tooltip title="Return to Video Details Page" placement="left">
                    <ArrowBackButton onClick={() => { onBack(); }} variant="contained">
                        <ArrowBack />
                        Return to Details
                    </ArrowBackButton>
                </Tooltip>
                <VideoControlBar user={user} player={player} userWatchProgress={userWatchProgress} handleTimestamp={handleTimestamp} />
            </ControlBarContainer>

        </ThemeProvider>

    )
}
