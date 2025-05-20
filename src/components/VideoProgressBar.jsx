import React, { useState, useEffect, useRef } from 'react';
import { ProgressSlider, BodyContainer, TimeContainer } from '../js/videostyles.js';
import { Box, Skeleton } from '@mui/material';
import '../css/videostyles.css';


export default function VideoProgressBar({ player, isPolling, handleSliderChange, handleTimestamp, setElapsed, elapsed, setVideoDuration, videoDuration, intervalRef }) {


    useEffect(() => {
        if (!player) return;
        let rawDuration = player.getDuration();
        setVideoDuration(rawDuration);
    }, [player, setVideoDuration, setElapsed]);

    useEffect(() => {

        clearInterval(intervalRef.current);
        intervalRef.current = null;

        if (isPolling) {
            intervalRef.current = setInterval(() => {
                setElapsed(prev => prev + 1);
            }, 1000);
        }

        return () => {
            clearInterval(intervalRef.current);
            intervalRef.current = null;
        };
    }, [isPolling]);

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
