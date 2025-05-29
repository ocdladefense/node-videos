import { Routes, Route } from 'react-router-dom';
import { useEffect, useState } from 'react';
import Header from "./Header";
import Footer from "./Footer";
// import Home from "./Home";
import VideoList from './VideoList';
import VideoDetails from './VideoDetails';
import VideoPlayerContainer from './VideoPlayerContainer';
import YouTubePlayer from '../js/player/YouTubePlayer.js';
import UserService from '../js/services/UserService.js';
import WatchedVideoService from '../js/services/WatchedVideoService.js';


// https://nextjs.org/docs/app/guides/migrating/from-create-react-app

window.playerMap = {
    youtube: YouTubePlayer,
};

// Player instance used throughout the application lifecycle.
const player = new YouTubePlayer();
// let user = {}; //getCurrentUser();




export function App2({ user, parser }) {


    const [selectedVideo, setSelectedVideo] = useState(null);
    const [route, setRoute] = useState("list");
    let component, hasWatched, purchasedVideo;



    if (selectedVideo != null) {
        hasWatched = user.getWatchedVideo((selectedVideo && selectedVideo.getVideoResourceId()));
        purchasedVideo = user.getPurchasedVideo((selectedVideo && selectedVideo.getVideoResourceId()));
    }
    const [hasAccess, setHasAccess] = useState(() => purchasedVideo != null || (selectedVideo && selectedVideo.isFree()));

    useEffect(() => {
        let s1 = new UserService(user);
        s1.listen();

        let s2 = new WatchedVideoService();
        s2.listen()
    }, [])




    return (
        <>
            <Header />
            <div class="container mx-auto">
                <Routes>
                    <Route path="/" element={<VideoList setRoute={setRoute} setSelectedVideo={setSelectedVideo} user={user} />} />
                    <Route path="/details/:resourceId" element={<VideoDetails setRoute={setRoute} onBack={() => { setRoute("list"); }} setSelectedVideo={setSelectedVideo} hasWatched={hasWatched} hasAccess={hasAccess} elapsedTime={0} />} />
                    <Route path="/player" element={<VideoPlayerContainer player={player} video={selectedVideo} user={user} onBack={() => { setRoute("details"); }} />} />
                </Routes>
            </div>
            <Footer />
        </>
    );
}


export default function App({ user }) {


    return (
        <>
            <Header />
            {/* typeof HeaderTwo === "function" ? <HeaderTwo /> : <></> */}
            <div class="container mx-auto">
                <Home user={user} />
            </div>
            <Footer />
        </>
    );
}
