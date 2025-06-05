import React, { useState, useEffect, useRef } from 'react';
import VideoControlBar from './VideoControlBar';
import VideoProgressBar from './VideoProgressBar';
import { ControlBarContainer, ArrowBackButton, fullscreenButton } from '../../js/videostyles.js';
import { Tooltip, Box } from '@mui/material';


export default function MediaControls({ player, onBack, isFullscreen, toggleFullscreen, playerInitialized, layout = "standard", setLayout, pip = true }) {
    const [showControls, setShowControls] = useState(true);

    useEffect(() => {
        let hideTimeout;

        const handleMouseMove = () => {
            if (!isFullscreen) return;
            setShowControls(true);

            clearTimeout(hideTimeout);
            hideTimeout = setTimeout(() => {
                setShowControls(false);
            }, 3000);
        };

        if (isFullscreen) {
            document.addEventListener('mousemove', handleMouseMove);
            hideTimeout = setTimeout(() => setShowControls(false), 3000);
        }

        return () => {
            document.removeEventListener('mousemove', handleMouseMove);
            clearTimeout(hideTimeout);
        };
    }, [isFullscreen]);

    return (
        <Box style={{ position: "absolute", bottom: "0px", left: "0px", width: "100%", zIndex: 200 }}
            sx={{
                opacity: showControls ? 1 : 0,
                pointerEvents: showControls ? 'auto' : 'none',
                transition: 'opacity 0.3s ease-in-out',
            }}>
            <Box style={{ paddingTop: 5, position: "absolute", bottom: "0", left: "50%", transform: "translate(-50%, 0%)", zIndex: 200, backgroundColor: "rgba(20,20,20,0.6)", borderRadius: "8px" }}>
                <VideoProgressBar player={player} />

                <ControlBarContainer playerstate={playerInitialized}>

                    <Tooltip style={"pip" == layout ? { display: "none" } : {}} title="Return to Video Details Page" placement="left">
                        <ArrowBackButton onClick={() => { player.destroy(); onBack(); }} variant="contained" />
                    </Tooltip>

                    <Box>
                        <VideoControlBar player={player} toggleFullscreen={toggleFullscreen} isFullscreen={isFullscreen} layout={layout} setLayout={setLayout} />
                    </Box>
                </ControlBarContainer>

            </Box>
        </Box>);


}
