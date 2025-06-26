import { useState, useEffect, useRef } from 'react';
import { ProgressSlider as MUIProgressSlider, BodyContainer, TimeContainer } from '../../../js/videostyles.js';
import { Box, Skeleton } from '@mui/material';
import '../../../css/videostyles.css';
import waitUntil from '../../../js/utils.js';
import { formatTime } from '../../../js/utils.js';






export default function ProgressSlider({ player, sensitivity = 200 }) {

    // Gets set initially to the player's elapsed time.
    const [sliderValue, setSliderValue] = useState(player.getElapsedTime());

    // Gets set initially to the player's elapsed time.
    const [timerValue, setTimerValue] = useState(player.getElapsedTime());

    // While the user is interacting with the proegress bar slider, don't attempt to refresh the component.
    const [userInteracting, setUserInteracting] = useState(false);

    // When the user slides, seek the player within the limits of `sensitivity`.
    const onSliderMoving = waitUntil(function(player, newValue) { player.seekTo(newValue); }, sensitivity);

    const handleSliderChange = (event, newValue) => {
        setUserInteracting(true);
        setSliderValue(newValue);
        setTimerValue(newValue);
        onSliderMoving(player, newValue);
    };



    // Prompt a syncing of this component to the player's elapsed time.
    // also uses state to effectively force a rerender of this component every second.
    useEffect(() => {
        !userInteracting && setSliderValue(player.getElapsedTime());
        setTimerValue(player.getElapsedTime());
    }, [player.getElapsedTime()]);


    if (player.isInitialized()) {
        return (
            <Box>
                <BodyContainer>
                    <MUIProgressSlider
                        value={sliderValue}
                        min={0}
                        max={player.getDuration()}
                        onChange={handleSliderChange}
                        onMouseDown={() => setUserInteracting(true)}
                        onMouseUp={() => setUserInteracting(false)}
                        valueLabelDisplay="auto"
                        valueLabelFormat={(value) => formatTime(sliderValue)}
                    />
                </BodyContainer>
                <TimeContainer>
                    {formatTime(timerValue)} / {formatTime(player.getDuration())}
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
