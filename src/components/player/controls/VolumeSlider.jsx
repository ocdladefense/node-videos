import { Slider, Box, Tooltip } from '@mui/material';
import { VolumeUp, VolumeDown } from '../../../js/videostyles.js';

export default function VolumeSlider({ volume, tooltip, action }) {
    return (
        <Tooltip title={tooltip} placement="bottom">
            <Box display="flex" >
                <VolumeDown />
                <Slider aria-label={tooltip} value={volume} onChange={action} min={0} max={100} />
                <VolumeUp />
            </Box>
        </Tooltip>
    );
}
