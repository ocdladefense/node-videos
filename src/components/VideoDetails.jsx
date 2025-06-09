import { useEffect, useState } from 'react';
import { useParams, useNavigate } from "react-router";
import Modal from './Modal.jsx';
import RelatedVideos from './RelatedVideos.jsx';
import VideoDetailsActions from './VideoDetailsActions.jsx';



export default function VideoDetails({ parser, user, setSelectedVideo }) {


    let params = useParams();

    let videoId = params.resourceId;

    let buttons = [];

    let navigate = useNavigate();

    const video = parser.getVideo(videoId);

    const [watched, setWatched] = useState(user.hasWatched(videoId)); //change this line

    // const [elapsedTime, setElapsedTime] = useState(user.); //change  this line

    const [hasWatched, setHasWatched] = useState(false); //change this line

    const [hasAccess, setHasAccess] = useState(watched || user.hasPurchased(videoId));

    const [showModal, setShowModal] = useState(false);

    const w = user.getWatchedVideo(videoId);
    let elapsed = w.timestamp;
    console.log(elapsed);
    let remaining = video.getDuration() - elapsed;

    const continueWatching = () => {
        navigate("/player/" + video.getResourceId());
    };


    // Navigate to the player or back again.

    const onBack = function() { navigate("/"); };

    //this is the code where it rounds the time then showing the exact number(only showing time watched then left)
    function formatElapsedTime(seconds) {
        console.log(seconds);
        // return "20 mins.";
        if (!seconds || isNaN(seconds)) return '';
        const minutes = Math.ceil(seconds / 60);
        // return `${minutes} minute${minutes > 1 ? 's' : ''}`;
        return `${minutes} mins. remaining`;
    }

    //this alos tries and make the rewatch pop up with no effect
    // const almostDone = video && video.getDuration() > 0 && (elapsedTime / video.getDuration() > 0.9);


    const playVideo = function() {
        console.log("About to play the video!");

        let state = { start: elapsed || 0 };
        navigate("/player/" + video.getResourceId(), { state });
    }

    const playVideoFromBeginning = function() {
        navigate("/player/" + video.getResourceId());
    }

    const confirmPurchase = async () => {
        let resultOfPurchase = await Promise.resolve(true); // simulate success
        let e = new CustomEvent('mediapurchased', {
            detail: { resourceId: video.resourceId, rental: false, device: "mobile", method: "invoice", ordernumber: 1 },
            bubbles: false
        });
        if (resultOfPurchase === true) {
            document.dispatchEvent(e);
            setHasAccess(true);
            setShowModal(false); // close modal
        }
    };


    /*
        // Helper function here to get at the remainig time.  Let's evaluate after merge with gabe's code.
        useEffect(() => {
            const w = user.getWatchedVideo(videoId);
            setWatched(w);
            setElapsedTime(w.timestamp || 0);
            setHasWatched(!!w.resourceId);
            setHasAccess(w || user.hasPurchased(videoId));
        }, [videoId, user]);
    */





    const actions = {
        play: playVideo,
        resume: playVideo,
        rewatch: continueWatching,
        purchase: function() { setShowModal(true) }
    };


    if (hasAccess && hasWatched) {
        buttons.push("resume");
        buttons.push("rewatch");
    }
    else if (hasAccess) {
        buttons.push("play");
    }
    else {
        buttons.push("purchase");
    }




    let currentSeminar = video && video.getSeminarName();
    const seminarVideos = parser.getRelatedVideos(video && video.getResourceId());

    return (

        <div className="video-details bg-zinc-900 min-h-screen">
            <button className="absolute top-4 left-4 text-zinc-300 text-3xl z-20" onClick={onBack}>←</button>

            {video ?
                <div className="video-content relative w-full">
                    {/* <h1 className="text-2xl text-zinc-100 text-left">{video.getVideoName()}</h1> */}
                    <img
                        src={video.getVideoThumbnail(video.getMaxResThumb())}
                        alt={'Thumbnail for ${video.getVideoName()}'}
                        className="w-full object-cover h-[700px] md:h-[400px] lg:h-[300px]"
                    />
                    <div className="absolute bottom-0 left-0 p-6 bg-black/70 w-full md:w-3/4">
                        <h1 className="text-4xl font-bold mb-2 text-left">{video.getVideoName()}</h1>
                        {currentSeminar && (
                            <p className="text-lg text-zinc-300 mb-2">Included in Seminar: <span className="font-semibold">{currentSeminar}</span></p>
                        )}
                        <p className="text-md text-zinc-200 mb-4">{video.getVideoDescription()}</p>

                        <VideoDetailsActions actions={actions} buttons={buttons} remaining={formatElapsedTime(remaining)} />

                    </div>
                </div>
                : ""}
            {/* Related videos section */}
            {video && seminarVideos.length > 1 && (
                <RelatedVideos video={video} currentSeminar={currentSeminar} seminarVideos={seminarVideos} setSelectedVideo={setSelectedVideo} />
            )}
            {showModal && (
                <Modal setShowModal={setShowModal} confirmAction={confirmPurchase}>
                    <p className="mb-6">Would you like to purchase this video for <strong>$19.99</strong>?</p>
                </Modal>
            )}

        </div>

    );
};
