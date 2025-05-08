import React from 'react';

export default function TitleComponent({ video, index, setSelectedVideo, setRoute }) {
    return (
        <li
            key={video.id || index}
            onClick={() => { setRoute("details"); setSelectedVideo(video); }}
            style={{ cursor: 'pointer', marginBottom: '1rem' }}
        >
            <div>
                {/* <strong className="text-2xl">{video.getVideoName()}</strong> <br /> */}
                <img
                    src={video.getVideoThumbnail(video.getMaxResThumb())}
                    alt={'Thumbnail for ' + video.getVideoName()}
                    className="w-full h-[185px] object-cover"
                /> <br />
                <strong className="text-2xl text-auto text-zinc-100">{video.getVideoName()}</strong> <br />
                <ul>
                    <li>{video.isFree() ? "Free!" : 'Paid'}</li>
                </ul>
            </div>
        </li>)
}

