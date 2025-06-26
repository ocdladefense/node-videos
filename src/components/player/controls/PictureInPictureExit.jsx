import PhotoCameraBackIcon from '@mui/icons-material/PhotoCameraBack';
import { Tooltip, IconButton } from '@mui/material';

export default function PictureInPictureExit({ tooltip, action }) {
    return (
        <Tooltip title={tooltip} placement="right">
            <IconButton onClick={action}>
                <PhotoCameraBackIcon />
            </IconButton>
        </Tooltip>
    );
}
