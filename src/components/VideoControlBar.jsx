import React, { useState, useEffect } from 'react';
import StopCircleIcon from '@mui/icons-material/StopCircle';
import PauseCircleIcon from '@mui/icons-material/PauseCircle';
import RestartAltIcon from '@mui/icons-material/RestartAlt';
import PlayCircleIcon from '@mui/icons-material/PlayCircle';
import { IconButton, ThemeProvider, Container, Slider, Box, Tooltip } from '@mui/material';
import { videoPlayerTheme, VolumeUp, VolumeDown } from '../js/videostyles.js';
import '../css/videostyles.css';





export default function VideoControlBar({ player }) {


    const [volume, setVolume] = useState(player.getVolume());
    const [isPlaying, setIsPlaying] = useState(player.isPlaying());
    const handleVolumeChange = (event, newValue) => {
        setVolume(newValue);
        player.setVolume(newValue);
    };

    // The controls can be alternately rendered based on the player's state.
    useEffect(() => {
        setIsPlaying(player.isPlaying());
    }, [player.isPlaying()]);





    return (
        <Container id="control-bar">
            <Box display="flex" alignItems="center">
                <ThemeProvider theme={videoPlayerTheme}>
                    <Box display="flex" alignItems="center">

                        <IconButton>
                            {isPlaying ? (
                                <Tooltip title="Pause Video" placement="bottom">
                                    <PauseCircleIcon
                                        onClick={() => {
                                            player.pause();
                                        }}
                                    />
                                </Tooltip>
                            ) : (
                                <Tooltip title="Play Video" placement="bottom">
                                    <PlayCircleIcon
                                        onClick={() => {
                                            player.play();
                                        }}
                                    />
                                </Tooltip>
                            )}
                        </IconButton>

                        <Tooltip title="End Video" placement="bottom">
                            <StopCircleIcon onClick={() => { player.stop(); }} />
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
                                    player.restart();
                                }}
                            />
                        </Tooltip>
                    </Box>
                </ThemeProvider>
            </Box>
        </Container>
    );



}
