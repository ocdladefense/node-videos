import { createTheme } from '@mui/material/styles';
import { Container, styled } from '@mui/material';

import VolumeDownIcon from '@mui/icons-material/VolumeDown';
import VolumeUpIcon from '@mui/icons-material/VolumeUp';
import ArrowBackIcon from '@mui/icons-material/ArrowBackRounded';

export const ArrowBackButton = styled(ArrowBackIcon)(({ theme }) => ({
    padding: 10,
}));

export const VolumeUp = styled(VolumeUpIcon)(({ theme }) => ({
    fontSize: 40,
    paddingLeft: 10,
    color: 'white',
    '&:hover': { color: 'white' },
    '&:active': { color: 'white' }
}));

export const VolumeDown = styled(VolumeDownIcon)(({ theme }) => ({
    fontSize: 40,
    paddingRight: 10,
    color: 'white',
    '&:hover': { color: 'white' },
    '&:active': { color: 'white' }
}));

export const TitleContainer = styled(Container)(({ theme }) => ({
    marginTop: 50,
    borderTopLeftRadius: 10,
    borderTopRightRadius: 10,
}));

export const VideoContainer = styled(Container)(({ theme }) => ({
    padding: 20,
}));

export const ControlBarContainer = styled(Container)(({ theme }) => ({
    borderBottomLeftRadius: 10,
    borderBottomRightRadius: 10
}));


export const videoPlayerTheme = createTheme({
    components: {
        MuiSlider: {
            styleOverrides: {
                root: {
                    width: 150,
                    color: '#ffffff',
                },
                thumb: {
                    color: '#ffffff',
                },
                track: {
                    color: '#ffffff',
                },
                rail: {
                    color: '#888888',
                },
            },
        },
        MuiContainer: {
            styleOverrides: {
                root: {
                    width: '100%',
                    backgroundColor: '#121212',
                    display: 'flex',
                    justifyContent: 'center',
                    '#video-container': {
                        padding: '10px'
                    },
                },
            },
        },
        MuiSvgIcon: {
            styleOverrides: {
                root: {
                    fontSize: 60,
                    color: '#ffffff',
                    cursor: 'pointer',
                    alignItems: 'center',
                    paddingBottom: 10,
                    justifyContent: 'center',
                    transition: 'all 0.2s ease-in-out',
                    '&:hover': {
                        color: '#dedede',
                    },
                    '&:active': {
                        color: '#c2c2c2',
                    },
                },
            },
        },

    },
});
