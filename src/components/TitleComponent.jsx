import React from 'react';

export default function TitleComponent({ video, index }) {
    return (
        <li
            key={video.id || index}
            onClick={() => setSelectedVideo(video)}
            style={{ cursor: 'pointer', marginBottom: '1rem' }}
        >
            <div>
                <strong>{video.getVideoName()}</strong> <br />
                <img
                    src={video.getVideoThumbnail()}
                    alt={'Thumbnail for ' + video.getVideoName()}
                /> <br/>
                <ul>
                    <li>{video.isFree() ? "Free!" : 'N/A'}</li>
                </ul>
            </div>
        </li>)
}

