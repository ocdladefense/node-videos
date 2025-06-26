import PlayCircleIcon from '@mui/icons-material/PlayCircle';
import { Tooltip } from '@mui/material';

export default function Play({ action, tooltip }) {
    return (
        <Tooltip title={tooltip} placement="bottom">
            <PlayCircleIcon onClick={action} />
        </Tooltip>
    );
}
