import { useEffect, useState } from 'react';
import { useParams } from "react-router";
import Modal from './Modal.jsx';
import RelatedVideos from './RelatedVideos.jsx';
import VideoDetailsActions from './VideoDetailsActions.jsx';







export default function VideoDetails({ parser, onBack, setRoute, hasAccess, hasWatched, elapsedTime, setSelectedVideo, user }) {


    let params = useParams();
    let buttons = [];

    const [video, setVideo] = useState(null);

    const [grouped, setGrouped] = useState([]);

    const [hasAccess2, setHasAccess2] = useState(hasAccess);

    const [showModal, setShowModal] = useState(false);

    const navigate = function() { let href = "/player/" + video.getResourceId(); console.log(href); window.location.href = href; };


    // Retrieve data from the server only once during lifecycle.
    // const parserRef = useRef(null);

    useEffect(() => {
        async function fn() {
            let videoId = params.resourceId;
            setVideo(parser.getVideo(videoId));
            setGrouped(parser.groupBySeminar());
        }
        fn();
    }, []);


    // function secondsToRoundedMinutes(seconds) {
    //     if (!seconds || isNaN(seconds)) return 0;
    //     return Math.ceil(seconds / 60); // Round up
    // }
    const watched = hasWatched && elapsedTime > 0;
    const almostDone = video && (elapsedTime / video.getDuration() > 0.9);

    const playVideo = function() {
        console.log("About to play the video!");

        navigate();
    }

    const playVideoFromBeginning = function() {
        navigate();
    }

    const confirmPurchase = async () => {
        let resultOfPurchase = await Promise.resolve(true); // simulate success
        let e = new CustomEvent('mediapurchased', {
            detail: { resourceId: video.resourceId, rental: false, device: "mobile", method: "invoice", ordernumber: 1 },
            bubbles: false
        });
        if (resultOfPurchase === true) {
            document.dispatchEvent(e);
            setHasAccess2(true);
            setShowModal(false); // close modal
        }
    };


    const actions = {
        play: playVideo,
        resume: playVideo,//how much time remaining
        rewatch: playVideo,
        purchase: function() { setShowModal(true) }
    };
    // display remaining time if video has been watched
    // data: has been purchased, has been watched, if has been watched, show time remaining

    if (user.hasPurchasedVideo(video && video.getResourceId())) {
        buttons.push("play");

        if (watched && !almostDone) {
            buttons.push("resume");
        } else if (almostDone || elapsedTime > 0) {
            buttons.push("rewatch");
        }

    } else {
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

                        <VideoDetailsActions actions={actions} buttons={buttons} />

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
