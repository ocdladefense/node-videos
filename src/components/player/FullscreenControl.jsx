import React from 'react';
import FullscreenEnterIcon from '@mui/icons-material/Fullscreen';
import FullscreenExitIcon from '@mui/icons-material/FullscreenExit';
import { Tooltip, IconButton } from '@mui/material';

export default function FullscreenControl({ toggleFullscreen, isFullscreen }) {
    return (
        <Tooltip title={isFullscreen ? "Exit Fullscreen" : "Enter Fullscreen"} placement="right">
            <IconButton onClick={toggleFullscreen}>
                {isFullscreen ? <FullscreenExitIcon /> : <FullscreenEnterIcon />}
            </IconButton>
        </Tooltip>
    );
}
