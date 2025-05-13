import StopCircleIcon from '@mui/icons-material/StopCircle';
import PauseCircleIcon from '@mui/icons-material/PauseCircle';
import RestartAltIcon from '@mui/icons-material/RestartAlt';
import PlayCircleIcon from '@mui/icons-material/PlayCircle';

import { IconButton, ThemeProvider, Container, Slider, Box, Tooltip } from '@mui/material';

import { videoPlayerTheme, VolumeUp, VolumeDown } from '../js/videostyles.js';
import '../css/videostyles.css';

import React, { useState } from 'react';

export default function VideoControlBar({ player, handleTimestamp }) {

    const [isPlaying, setIsPlaying] = useState(false);
    const [volume, setVolume] = useState(50);


    const handleVolumeChange = (event, newValue) => {
        setVolume(newValue);
        player.setVolume(newValue);

    };
    const handleToggle = () => {
        if (isPlaying) {
            player.pauseVideo();
        } else {
            player.playVideo();
        }
        setIsPlaying(!isPlaying);
    };

    /*
    TODO:
        -Add fullscreen option
        -Add video playback slider with seekTo enabled
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
                                        <PauseCircleIcon onClick={() => { player.pauseVideo(); handleTimestamp(); }} />
                                    </Tooltip>

                                ) : (
                                    <Tooltip title="Play Video" placement="bottom">
                                        <PlayCircleIcon onClick={() => { player.playVideo(); handleTimestamp(); }} />
                                    </Tooltip>

                                )};
                            </IconButton>

                            <Tooltip title="End Video" placement="bottom">
                                <StopCircleIcon onClick={() => { player.stopVideo(); handleTimestamp(); setIsPlaying(false); }} />
                            </Tooltip>
                        </Box>
                    </ThemeProvider>

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
                            }}
                        />
                    </Tooltip>
                </Box>
            </Container>
        );
    }
    else {
        return (
            <div id="loading">Loading Control Bar...</div>
        )
    }
}
