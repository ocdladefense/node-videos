import PictureInPictureIcon from '@mui/icons-material/PictureInPicture';
import { Tooltip, IconButton } from '@mui/material';

export default function PictureInPictureEnter({ tooltip, action }) {
    return (
        <Tooltip title={tooltip} placement="right">
            <IconButton onClick={action}>
                <PictureInPictureIcon />
            </IconButton>
        </Tooltip>
    );
}
