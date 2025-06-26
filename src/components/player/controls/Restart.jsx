import RestartAltIcon from '@mui/icons-material/RestartAlt';
import { Tooltip } from '@mui/material';

export default function Restart({ action, tooltip }) {
    return (
        <Tooltip title={tooltip} placement="bottom">
            <RestartAltIcon onClick={action} />
        </Tooltip>
    );
}
