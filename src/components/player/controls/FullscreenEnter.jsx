import FullscreenEnterIcon from '@mui/icons-material/Fullscreen';
import { Tooltip, IconButton } from '@mui/material';

export default function FullscreenEnter({ tooltip, action }) {
    return (
        <Tooltip title={tooltip} placement="right">
            <IconButton onClick={action}>
                <FullscreenEnterIcon />
            </IconButton>
        </Tooltip>
    );
}
