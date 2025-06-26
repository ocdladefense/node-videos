import PauseCircleIcon from '@mui/icons-material/PauseCircle';
import { Tooltip } from '@mui/material';

export default function Pause({ action, tooltip }) {
    return (
        <Tooltip title={tooltip} placement="bottom">
            <PauseCircleIcon onClick={action} />
        </Tooltip>
    );
}
