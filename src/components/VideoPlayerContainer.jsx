import React, { useState, useEffect } from 'react';

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

    const handleTimestamp = (event) => {
        let runTime = Math.floor(player.getCurrentTime());
        console.log('Runtime:', runTime);
        user.updateTimestamp(userWatchProgress.resourceId, runTime);
    };

    const handleToggle = () => {
        if (isPlaying) {
            player.pauseVideo();
        } else {
            player.playVideo();
        }
        setIsPlaying(!isPlaying);
    };

    const handlePollingTimestamp = (event) => {
        if (resetTimestamp === 0) {
            setElapsed(0);
        } else {
            setElapsed(userWatchProgress.timeStamp);
        }

        setIsPolling(event);
    };

    const handleSliderChange = (event, newValue) => {
        player.seekTo(newValue);
        player.pauseVideo();
        setIsPlaying(false);
        setElapsed(newValue);

    };

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
                <VideoPlayer userWatchProgress={userWatchProgress} onReady={setPlayer} />
            </VideoContainer>

            <VideoProgressBar player={player} isPolling={isPolling} handleSliderChange={handleSliderChange} handleTimestamp={handleTimestamp} setElapsed={setElapsed} elapsed={elapsed} setVideoDuration={setVideoDuration} videoDuration={videoDuration} />

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
                        handleToggle={handleToggle}
                        handlePollingTimestamp={handlePollingTimestamp}
                        setVideoDuration={setVideoDuration}
                    />
                </Box>
            </ControlBarContainer>

        </ThemeProvider>

    )
}
