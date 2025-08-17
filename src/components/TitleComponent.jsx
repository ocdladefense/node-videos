import { useNavigate } from "react-router";
import ProgressBar from "./ProgressBar";
import Thumbnail from "../js/models/Thumbnail";

export default function TitleComponent({ video, index, user }) {
    const hasAccess = video.isFree() || user.getPurchasedVideo(video.getVideoResourceId());
    let navigate = useNavigate();

    //  const doNavigation = function() { let href = "/details/" + video.getResourceId(); console.log(href); window.location.href = href; };

    const watchedVid = user.getWatchedVideo(video.getResourceId());
    const strProgress = video.getProgress(watchedVid.timestamp);

    return (
        <li
            key={video.id || index}
            onClick={() => navigate("/media/" + video.getResourceId())}
            style={{ cursor: 'pointer', marginBottom: '1rem' }}
            data-video-id={video.getVideoResourceId()}
        >
            <div className="text-zinc-100 hover-1 title">
                {/* <strong className="text-2xl">{video.getVideoName()}</strong> <br /> */}

                <div className="relative w-full h-[185px]">
                    <img
                        src={video.getThumbnailUrl(Thumbnail.SMALL)}
                        alt={'Thumbnail for ' + video.getVideoName()}
                        className="w-full h-full object-cover"
                    />
                    <ProgressBar progress={strProgress} />
                    {!hasAccess && (
                        <div className="absolute inset-0 bg-zinc-800 bg-opacity-60 flex items-center justify-center">
                            <span className="text-white text-sm font-bold">🔒Purchase</span>
                        </div>
                    )}
                </div>
                <br />
                <strong className="text-lg text-auto text-zinc-100">{video.getVideoName()}</strong> <br />
                {/* <p className="text-xl text-zinc-100">{video.getLocation()}</p>
                <p className="text-zinc-400 text-sm">{new Date(video.getDate()).toLocaleDateString()}</p> */}
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
