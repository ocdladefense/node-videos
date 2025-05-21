import React, { useState, useEffect, useRef } from 'react';
import { ProgressSlider, BodyContainer, TimeContainer } from '../js/videostyles.js';
import { Box, Skeleton } from '@mui/material';
import '../css/videostyles.css';


export default function VideoProgressBar({ player }) {


    if (player.isInitialized()) {
        return (
            <Box>
                <BodyContainer>
                    <ProgressSlider value={player.getElapsedTime()} min={0} max={player.getDuration()} onChange={(value) => player.seekTo(value)} valueLabelDisplay="auto" valueLabelFormat={(value) => player.getFormattedTime(value)} />
                </BodyContainer>
                <TimeContainer>
                    {player.getFormattedTime(player.getElapsedTime())} / {player.getFormattedTime(player.getDuration())}
                </TimeContainer>
            </Box>
        )
    }
    else {
        return (
            <Box>
                <BodyContainer>
                    <Skeleton variant="rectangular" animation="wave" width={'90%'} height={10} />
                </BodyContainer>
                <TimeContainer>
                    Loading...
                </TimeContainer>
            </Box>

        );
    }




}
