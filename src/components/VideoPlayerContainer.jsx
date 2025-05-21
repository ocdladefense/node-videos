import React, { useState, useEffect, useRef } from 'react';
import '../css/videostyles.css';
import VideoControlBar from './VideoControlBar';
import VideoProgressBar from './VideoProgressBar';
import { videoPlayerTheme, VideoContainer, TitleContainer, ControlBarContainer, ArrowBackButton } from '../js/videostyles.js';
import { ThemeProvider, Tooltip, Box, Skeleton } from '@mui/material';
import { Skeleton as PlayerPlaceholder } from '@mui/material';



export default function VideoPlayerContainer({ player, video, onBack }) {

    // Player initialization defaults to false.
    const [playerInitialized, setPlayerInitialized] = useState(false);

    // Sync to an external system.
    // The serialize method returns the state of the player in JSON format.
    // The player "broadcasts" its state using the setPlayerState function, below.
    const [playerState, setPlayerState] = useState(player.serialize());

    // All of these values should be gotten from the player
    // and serialized as part of the YouTubePlayer.serialize() method.

    const [isPlaying, setIsPlaying] = useState(false);




    // We do need something that does this.
    // In the VideoControlBar itself though.
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
    // ***We shouldn't need to pass most of the setter functions along to the YouTube class.
    useEffect(() => {
        player.loadPlayer('player', setPlayerInitialized, setPlayerState);
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
            </VideoContainer>

            <VideoProgressBar player={player} />

            <ControlBarContainer playerstate={playerInitialized}>

                <Tooltip title="Return to Video Details Page" placement="left">
                    <ArrowBackButton onClick={() => onBack()} variant="contained" />
                </Tooltip>

                <Box>
                    {/* Shouldn't need to pass these setters; let the player do the work */}
                    <VideoControlBar
                        isPlaying={isPlaying}
                        player={player}
                    />
                </Box>
            </ControlBarContainer>

        </ThemeProvider>

    )
}
