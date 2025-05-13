import React, { useState, useEffect } from 'react';
import { ProgressSlider, BodyContainer, TimeContainer } from '../js/videostyles.js';
import { Box, Skeleton } from '@mui/material';
import '../css/videostyles.css';


export default function VideoProgressBar({ player, isPolling, handleSliderChange, handleTimestamp, setElapsed, elapsed, setVideoDuration, videoDuration }) {

    useEffect(() => {
        let intervalId;

        if (player) {

            const rawDuration = ydc.getVideoDuration(player)
            setVideoDuration(rawDuration);

            if (isPolling) {
                intervalId = setInterval(() => {
                    const currentTime = Math.floor(player.getCurrentTime());
                    setElapsed(currentTime);
                }, 1000);
            }
        }

        return () => {
            if (intervalId) clearInterval(intervalId);
        };
    }, [player, isPolling, setElapsed]);

    if (player) {
        return (
            <Box>
                <BodyContainer>
                    <ProgressSlider value={elapsed} min={0} max={videoDuration} onChange={handleSliderChange} valueLabelDisplay="auto" valueLabelFormat={(value) => ydc.getFormattedTime(value)} />
                </BodyContainer>
                <TimeContainer>
                    {ydc.getFormattedTime(elapsed)} / {ydc.getFormattedTime(player.getDuration())}
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
