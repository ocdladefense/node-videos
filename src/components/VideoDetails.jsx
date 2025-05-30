import { useEffect, useState } from 'react';
import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';
import Video from '../js/models/Video.js';
import initThumbs from '../js/controllers/VideoThumbs';
import VideoDataParser from "../js/controllers/VideoDataParser.js";
import Modal from './Modal.jsx';
import RelatedVideos from './RelatedVideos.jsx';
import VideoDetailsActions from './VideoDetailsActions.jsx';





// Top-level reference to the "parser" that can return various lists of videos.
let parser = new VideoDataParser();

const query = 'SELECT Id, Name, Description__c, Event__c, Event__r.Name, Event__r.Start_Date__c, Speakers__c, ResourceId__c, Date__c, Published__c, IsPublic__c FROM Media__c';

// @jbernal - previously in index.js
// Retrieve video data and related thumbnail data.
async function getVideoParser() {

    const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
    const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;

    let api = new SalesforceRestApi(SF_INSTANCE_URL, SF_ACCESS_TOKEN);
    let resp = await api.query(query);
    parser.parse(resp.records);

    let videos = parser.getVideos();

    // Default thumb in case there is no available image.
    Video.setDefaultThumbnail('http:/foobar');

    const thumbnailMap = await initThumbs(videos); // should be initThumbs(parser.getVideoIds());

    parser.getVideos().forEach(video => {
        const thumbs = thumbnailMap.get(video.resourceId);
        // console.log(`For video ID ${video.resourceId}, retrieved thumbnail data:`, thumbs);
        video.setThumbnail(thumbs);
    });


    return parser;
}




export default function VideoDetails({ video, onBack, setRoute, hasAccess, hasWatched = true, elapsedTime = 0, setSelectedVideo, user }) {


    const [grouped, setGrouped] = useState([]);
    const [hasAccess2, setHasAccess2] = useState(hasAccess);
    const [showModal, setShowModal] = useState(false);
    let buttons = [];

    // Retrieve data from the server only once during lifecycle.
    useEffect(() => {
        async function fn() { parser = await getVideoParser(); setGrouped(parser.groupBySeminar()); }
        fn();
    }, []);



    const playVideo = function() {
        console.log("About to play the video!");

        setRoute("player");
    }

    const playVideoFromBeginning = function() {
        setRoute("player");
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

    if (user.hasPurchasedVideo(video.getResourceId())) {
        buttons.push("play");
    } else {
        buttons.push("purchase");
    }


    let currentSeminar = video.getSeminarName();
    const seminarVideos = parser.getRelatedVideos(video.getResourceId());

    return (
        <div className="video-details bg-zinc-900 min-h-screen">
            <button className="absolute top-4 left-4 text-zinc-300 text-3xl z-20" onClick={onBack}>←</button>


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
            {/* Related videos section */}
            {seminarVideos.length > 1 && (
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
