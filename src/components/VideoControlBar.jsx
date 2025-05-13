import StopCircleIcon from '@mui/icons-material/StopCircle';
import PauseCircleIcon from '@mui/icons-material/PauseCircle';
import RestartAltIcon from '@mui/icons-material/RestartAlt';
import PlayCircleIcon from '@mui/icons-material/PlayCircle';

import { IconButton, ThemeProvider, Container, Slider, Box, Tooltip } from '@mui/material';

import { videoPlayerTheme, VolumeUp, VolumeDown } from '../js/videostyles.js';
import '../css/videostyles.css';

import React, { useState } from 'react';

export default function VideoControlBar({ isPlaying, player, setElapsed, handleTimestamp, setIsPlaying, handleToggle, handlePollingTimestamp, setVideoDuration }) {

    const [volume, setVolume] = useState(50);


    const handleVolumeChange = (event, newValue) => {
        setVolume(newValue);
        player.setVolume(newValue);

    };

    /*
    TODO:
        -Add fullscreen option
        -Adjust styling based on current needs 
    */

    if (player) {
        return (
            <Container id="control-bar">
                <Box display="flex" alignItems="center">
                    <ThemeProvider theme={videoPlayerTheme}>
                        <Box display="flex" alignItems="center">

                            <IconButton onClick={handleToggle}>
                                {isPlaying ? (
                                    <Tooltip title="Pause Video" placement="bottom">
                                        <PauseCircleIcon
                                            onClick={() => {
                                                player.pauseVideo();
                                                handleTimestamp();
                                                handlePollingTimestamp(false);
                                            }}
                                        />
                                    </Tooltip>
                                ) : (
                                    <Tooltip title="Play Video" placement="bottom">
                                        <PlayCircleIcon
                                            onClick={() => {
                                                player.playVideo();
                                                handleTimestamp();
                                                handlePollingTimestamp(true);
                                            }}
                                        />
                                    </Tooltip>
                                )}
                            </IconButton>

                            <Tooltip title="End Video" placement="bottom">
                                <StopCircleIcon onClick={() => { player.stopVideo(); handleTimestamp(); setIsPlaying(false); handlePollingTimestamp(false); setElapsed(0); }} />
                            </Tooltip>


                            <Tooltip title="Volume Slider" placement="bottom">
                                <Box display="flex" >
                                    <VolumeDown />
                                    <Slider aria-label="Volume" value={volume} onChange={handleVolumeChange} min={0} max={100} />
                                    <VolumeUp />
                                </Box>
                            </Tooltip>

                            <Tooltip title="Restart Video" placement="bottom">
                                <RestartAltIcon
                                    onClick={() => {
                                        player.seekTo(0, true);
                                        player.playVideo();
                                        handleTimestamp();
                                        setIsPlaying(true);
                                        handlePollingTimestamp(true);
                                    }}
                                />
                            </Tooltip>
                        </Box>
                    </ThemeProvider>
                </Box>
            </Container>
        );
    }

    return (
        <div id="loading">Loading Control Bar...</div>
    )

}
