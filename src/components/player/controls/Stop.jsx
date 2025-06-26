import StopCircleIcon from '@mui/icons-material/StopCircle';
import { Tooltip } from '@mui/material';

export default function Stop({ action, tooltip }) {
    return (
        <Tooltip title={tooltip} placement="bottom">
            <StopCircleIcon onClick={action} />
        </Tooltip>
    );
}
