import StopCircleIcon from '@mui/icons-material/StopCircle';
import PauseCircleIcon from '@mui/icons-material/PauseCircle';
import RestartAltIcon from '@mui/icons-material/RestartAlt';
import PlayCircleIcon from '@mui/icons-material/PlayCircle';

import { createTheme, ThemeProvider } from '@mui/system';

import React from 'react';

const controlBarTheme = createTheme({
    components: {
        MuiSvgIcon: {
            styleOverrides: {
                root: {
                    fontSize: '60px',
                    color: '#3c3c3c',
                    cursor: 'pointer',
                    transition: 'all 0.2s ease-in-out',
                    '&:hover': {
                        color: '#606060',
                    },
                    '&:active': {
                        color: '#818181',
                    },
                },
            },
        },
    },
});

export default function VideoControlBar({ player }) {
    return (
        <div id="controlBar">
            <ThemeProvider theme={controlBarTheme}>
                <PlayCircleIcon onClick={() => player.playVideo()} />

                <PauseCircleIcon onClick={() => player.pauseVideo()} />

                <StopCircleIcon onClick={() => player.stopVideo()} />

                <RestartAltIcon onClick={() => {
                    player.seekTo(0, true);
                    player.playVideo();
                }}>
                </RestartAltIcon>
            </ThemeProvider>
        </div>
    )
}
