import React, { useState, useEffect, useRef } from 'react';

import VideoPlayer from './VideoPlayer';
import VideoControlBar from './VideoControlBar';
import VideoProgressBar from './VideoProgressBar';

import { videoPlayerTheme, VideoContainer, TitleContainer, ControlBarContainer, ArrowBackButton } from '../js/videostyles.js';
import '../css/videostyles.css';

import { ThemeProvider, Tooltip, Box, Skeleton } from '@mui/material';

export default function VideoPlayerContainer({ resetTimestamp, video, user, onBack }) {
    const [videoDuration, setVideoDuration] = useState(0);
    const [player, setPlayer] = useState(null);
    const [isPlaying, setIsPlaying] = useState(false);
    const [isPolling, setIsPolling] = useState(false);
    const [elapsed, setElapsed] = useState(0);
    const [state, setState] = useState(0);
    const intervalRef = useRef(null);
    window.playerStatus = logPlayerStatus;

    let userWatchProgress = user.getWatchedVideo(video.resourceId);

    useEffect(() => {
        if (!userWatchProgress) return;

        if (resetTimestamp === 0) {
            userWatchProgress.timeStamp = 0;
            setElapsed(0);
        } else {
            setElapsed(userWatchProgress.timeStamp);
        }
    }, [resetTimestamp, userWatchProgress, setElapsed]);

    if (!userWatchProgress) {
        user.addToWatchedVideos(video.resourceId);
        userWatchProgress = user.getWatchedVideo(video.resourceId);
    }

    const onStateChange = (event) => {
        setState(event.data);
    }

    const handleTimestamp = (event) => {
        let runTime = elapsed;
        user.updateTimestamp(userWatchProgress.resourceId, runTime);
    };


    const handlePollingTimestamp = (event) => {
        setIsPolling(event);
    };

    const handleSliderChange = (event, newValue) => {
        player.seekTo(newValue);
        setIsPolling(false);
        player.pauseVideo();
        setIsPlaying(false);
        setElapsed(newValue);

    };

    function logPlayerStatus() {
        let sourceType = 'YouTube'

        console.groupCollapsed("=== Debug Info ===");

        console.groupCollapsed("=== Player Class Info ===")
        console.log("Player Instance:", player);
        console.log("Subclass Called: ", sourceType, "Subclass");
        console.groupEnd("=========================");

        console.groupCollapsed("=== Player State ===");
        console.log("Player State: ", window.playerState[state])
        console.log("The video is playing? ", isPlaying)
        console.log("Video elapsement is being tracked? ", isPolling)
        console.groupEnd("=========================");

        console.groupCollapsed("=== Video Metadata ===");
        console.log("Video Title: ", video.getVideoName())
        console.groupCollapsed("Video Description:")
        console.log(video.getVideoDescription())
        console.groupEnd(" === === ");
        console.log("Elapsed Video Length: ", ydc.getFormattedTime(elapsed));
        console.log("Video Length: ", ydc.getFormattedTime(player.getDuration()));
        console.groupEnd("=========================");

    }

    /*TODO:
    - get handleTimestamp() to work with onBack, 
        */

    return (

        <ThemeProvider theme={videoPlayerTheme}>

            <TitleContainer>
                {!player ? (
                    <h1>Loading Video Title...</h1>
                ) : (
                    <h1>{video.getVideoName()}</h1>
                )}
            </TitleContainer>

            <VideoContainer>
                <VideoPlayer userWatchProgress={userWatchProgress} onReady={setPlayer} onStateChange={onStateChange} player={player} handleTimestamp={handleTimestamp} handlePollingTimestamp={handlePollingTimestamp} setElapsed={setElapsed} setIsPlaying={setIsPlaying} setIsPolling={setIsPolling} />
            </VideoContainer>

            <VideoProgressBar player={player} isPolling={isPolling} handleSliderChange={handleSliderChange} handleTimestamp={handleTimestamp} setElapsed={setElapsed} elapsed={elapsed} setVideoDuration={setVideoDuration} videoDuration={videoDuration} intervalRef={intervalRef} />

            <ControlBarContainer>
                {!player ? (
                    <div />
                ) : (
                    <Tooltip title="Return to Video Details Page" placement="left">
                        <ArrowBackButton onClick={() => onBack()} variant="contained" />
                    </Tooltip>
                )}
                <Box>
                    <VideoControlBar
                        isPlaying={isPlaying}
                        player={player}
                        setElapsed={setElapsed}
                        handleTimestamp={handleTimestamp}
                        setIsPlaying={setIsPlaying}
                        handlePollingTimestamp={handlePollingTimestamp}
                        setVideoDuration={setVideoDuration}
                    />
                </Box>
            </ControlBarContainer>

        </ThemeProvider>

    )
}
