import { useState, useEffect } from 'react';
import FullscreenEnter from './controls/FullscreenEnter.jsx';
import FullscreenExit from './controls/FullscreenExit.jsx';
import PictureInPictureEnter from './controls/PictureInPictureEnter.jsx';
import PictureInPictureExit from './controls/PictureInPictureExit.jsx';
import Play from './controls/Play.jsx';
import Pause from './controls/Pause.jsx';
import Stop from './controls/Stop.jsx';
import Restart from './controls/Restart.jsx';
import VolumeSlider from './controls/VolumeSlider.jsx';
import ProgressSlider from './controls/ProgressSlider.jsx';
import { ControlBarContainer, ArrowBackButton } from '../../js/videostyles.js';
import { ThemeProvider, Container, Box, Tooltip } from '@mui/material';
import { PlayerTheme } from '../../js/videostyles.js';
import '../../css/videostyles.css';

/**
 * 
 * Additional MUI icons can be found at:
 * https://mui.com/material-ui/material-icons/?query=picture+in+picture&selected=PhotoCameraBack
 */
export default function Controls({ player, previousPage, isFullscreen, toggleFullscreen, playerInitialized, layout = "standard", setLayout }) {

    const [volume, setVolume] = useState(player.getVolume());

    const [isPlaying, setIsPlaying] = useState(player.isPlaying());

    const [showControls, setShowControls] = useState(true);

    const handleVolumeChange = (event, newValue) => {
        setVolume(newValue);
        player.setVolume(newValue);
    };


    // The controls can be alternately rendered based on the player's state.
    useEffect(() => {
        setIsPlaying(player.isPlaying());
    }, [player.isPlaying()]);

    return (

        <Box style={{ position: "absolute", bottom: "0px", left: "0px", width: "100%", zIndex: 200 }}
            sx={{
                opacity: showControls ? 1 : 0,
                pointerEvents: showControls ? 'auto' : 'none',
                transition: 'opacity 0.3s ease-in-out',
            }}>
            <Box style={{ paddingTop: 5, position: "absolute", bottom: "0", left: "50%", transform: "translate(-50%, 0%)", zIndex: 200, backgroundColor: "rgba(20,20,20,0.6)", borderRadius: "8px" }}>
                <ProgressSlider player={player} />

                <ControlBarContainer playerstate={playerInitialized}>

                    <Tooltip style={"pip" == layout ? { display: "none" } : {}} title="Return to Video Details Page" placement="left">
                        <ArrowBackButton onClick={previousPage} variant="contained" />
                    </Tooltip>

                    <Box>

                        <Container>
                            <Box display="flex" alignItems="center">
                                <ThemeProvider theme={PlayerTheme}>
                                    <Box display="flex" alignItems="center">


                                        {isPlaying
                                            ?
                                            <Pause tooltip="Pause" action={() => { player.pause(); setIsPlaying(false); }} />
                                            :
                                            <Play tooltip="Play" action={() => { player.play(); setIsPlaying(true); }} />
                                        }

                                        <Stop tooltip="Stop" action={() => { player.stop(); setIsPlaying(false); }} />

                                        <VolumeSlider tooltip="Volume" action={handleVolumeChange} volume={volume} />

                                        <Restart tooltip="Restart" action={() => { player.restart(); setIsPlaying(true); }} />

                                        {layout == "standard"
                                            ?
                                            <PictureInPictureEnter tooltip="Picture in Picture" action={() => setLayout("pip")} />
                                            :
                                            <PictureInPictureExit tooltip="Exit picture-in-picture" action={() => setLayout("standard")} />
                                        }

                                        {!isFullscreen
                                            ?
                                            <FullscreenEnter tooltip="Enter fullscreen" action={toggleFullscreen} />
                                            :
                                            <FullscreenExit tooltip="Exit fullscreen" action={toggleFullscreen} />
                                        }


                                    </Box>
                                </ThemeProvider>
                            </Box>
                        </Container>

                    </Box>
                </ControlBarContainer>

            </Box>
        </Box>
    );



}
