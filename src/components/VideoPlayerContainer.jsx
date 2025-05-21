import React, { useState, useEffect, useRef } from 'react';
import '../css/videostyles.css';
import VideoControlBar from './VideoControlBar';
import VideoProgressBar from './VideoProgressBar';
import { videoPlayerTheme, VideoContainer, TitleContainer, ControlBarContainer, ArrowBackButton } from '../js/videostyles.js';
import { ThemeProvider, Tooltip, Box, Skeleton } from '@mui/material';
import { Skeleton as PlayerPlaceholder } from '@mui/material';
import YouTubePlayer from '../js/player/YouTubePlayer.js';

let sourceType = 'youtube';

export default function VideoPlayerContainer({ resetTimestamp, video, user, onBack }) {

    // Only needs to be instantiated once during the player lifecycle.
    const [player, updatePlayer] = useState(new YouTubePlayer());

    // Player initialization defaults to false.
    const [playerInitialized, setPlayerInitialized] = useState(false);

    // All of these values should be gotten from the player.
    const [videoDuration, setVideoDuration] = useState(0);
    const [isPlaying, setIsPlaying] = useState(false);
    const [isPolling, setIsPolling] = useState(false);
    const [elapsed, setElapsed] = useState(0);
    const intervalRef = useRef(null);



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
    };

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





    // If the video changes, then set it as the queued video that will be played.
    useEffect(() => {
        player.queueVideo(video);
    }, [video]);


    // Initialize the player.
    // Initialization involves both downloading the YT API script and instantiating an instance of YTPlayer.
    useEffect(() => {
        player.loadPlayer(
            'player',
            setPlayerInitialized,
            function() { console.log("Player is ready!") },
            userWatchProgress,
            function() { console.log("State changed!") },
            handleTimestamp,
            setElapsed,
            setIsPlaying,
            setIsPolling
        );
    }, []);



    return (

        <ThemeProvider theme={videoPlayerTheme}>

            <TitleContainer>
                <h1>{video.getVideoName()}</h1>
            </TitleContainer>

            <VideoContainer>
                <div id="player-wrapper">
                    <div id="player">
                        <PlayerPlaceholder variant="rectangular" animation="wave" width={1280} height={720} />
                    </div>
                    <div id="blocker"></div>
                </div>
                {/* <VideoPlayer userWatchProgress={userWatchProgress} onReady={setPlayer} onStateChange={onStateChange} player={player} handleTimestamp={handleTimestamp} handlePollingTimestamp={handlePollingTimestamp} setElapsed={setElapsed} setIsPlaying={setIsPlaying} setIsPolling={setIsPolling} /> */}
            </VideoContainer>

            <VideoProgressBar playerstate={playerInitialized} player={player} isPolling={isPolling} handleSliderChange={handleSliderChange} handleTimestamp={handleTimestamp} setElapsed={setElapsed} elapsed={elapsed} setVideoDuration={setVideoDuration} videoDuration={videoDuration} intervalRef={intervalRef} />

            <ControlBarContainer playerstate={playerInitialized}>

                <Tooltip title="Return to Video Details Page" placement="left">
                    <ArrowBackButton onClick={() => onBack()} variant="contained" />
                </Tooltip>

                <Box>
                    <VideoControlBar
                        playerstate={playerInitialized}
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
