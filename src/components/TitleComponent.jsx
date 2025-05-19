import React from 'react';

export default function TitleComponent({ video, index, setSelectedVideo, setRoute }) {
    return (
        <li
            key={video.id || index}
            onClick={() => { setRoute("details"); setSelectedVideo(video); }}
            style={{ cursor: 'pointer', marginBottom: '1rem' }}
        >
            <div className="text-zinc-100">
                {/* <strong className="text-2xl">{video.getVideoName()}</strong> <br /> */}
                <h3 className='text-blue-500'>{video.getSeminarName()}</h3>
                <img
                    src={video.getVideoThumbnail(video.getMaxResThumb())}
                    alt={'Thumbnail for ' + video.getVideoName()}
                    className="w-full h-[185px] object-cover"
                /> <br />
                <strong className="text-2xl text-auto text-zinc-100">{video.getVideoName()}</strong> <br />
                <ul>
                    {/* <li>{video.isFree() ? "Free!" : 'Paid'}</li> */}
                    <li className="flex items-center space-x-2">
                        {video.isFree() ? (
                            <>
                                <span className="text-green-500">✔</span>
                                <span className="text-green-700 font-medium">Free!</span>
                            </>
                        ) : (
                            <>
                                <span className="text-gray-400">🔒</span>
                                <span className="text-gray-500">Paid</span>
                            </>
                        )}
                    </li>

                </ul>
            </div>
        </li>)
}

// if we set the video size based on media type we can fix the black bar issue. 
//
