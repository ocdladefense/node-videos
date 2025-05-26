import VideoControlBar from './VideoControlBar';
import VideoProgressBar from './VideoProgressBar';
import { ControlBarContainer, ArrowBackButton } from '../js/videostyles.js';
import { Tooltip, Box } from '@mui/material';


export default function MediaControls({ player, playerInitialized }) {


    return (
        <Box>
            <Box>
                <VideoProgressBar player={player} />

                <ControlBarContainer playerstate={playerInitialized}>

                    <Tooltip title="Return to Video Details Page" placement="left">
                        <ArrowBackButton onClick={() => { player.destroy(); onBack(); }} variant="contained" />
                    </Tooltip>

                    <Box>
                        <VideoControlBar player={player} />
                    </Box>
                </ControlBarContainer>

            </Box>
        </Box>);

}
