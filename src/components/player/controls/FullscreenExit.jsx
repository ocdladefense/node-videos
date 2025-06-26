import FullscreenExitIcon from '@mui/icons-material/FullscreenExit';
import { Tooltip, IconButton } from '@mui/material';

export default function FullscreenExit({ tooltip, action }) {
    return (
        <Tooltip title={tooltip} placement="right">
            <IconButton onClick={action}>
                <FullscreenExitIcon />
            </IconButton>
        </Tooltip>
    );
}
