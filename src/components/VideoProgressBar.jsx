import React, { useState, useEffect, useRef } from 'react';
import { ProgressSlider, BodyContainer, TimeContainer } from '../js/videostyles.js';
import { Box, Skeleton } from '@mui/material';
import '../css/videostyles.css';


export default function VideoProgressBar({ player }) {


    const [sliderValue, setSliderValue] = useState(player.getElapsedTime());


    // Needs a debouncer.
    const handleSliderChange = (event, newValue) => {
        console.log(newValue);
        player.stopBroadcasting();
        player.seekTo(newValue);
        setSliderValue(newValue);
    };

    useEffect(() => {
        setSliderValue(player.getElapsedTime());
    });


    if (player.isInitialized()) {
        return (
            <Box>
                <BodyContainer>
                    <ProgressSlider
                        value={sliderValue}
                        min={0}
                        max={player.getDuration()}
                        onChange={handleSliderChange}
                        onMouseUp={() => player.broadcast()}
                        valueLabelDisplay="auto"
                        valueLabelFormat={(value) => player.getFormattedTime(sliderValue)}
                    />
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
