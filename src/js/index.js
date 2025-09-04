import "../css/input.css";
import { createRoot } from 'react-dom/client';
import { useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import App from '../components/App';
import Home from '../components/Home.jsx';
import VideoDetails from '../components/VideoDetails.jsx';
import PlayerContainer from '../components/player/PlayerContainer.jsx';
import PurchasePage from "../components/PurchasePage.jsx";


if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1);
}




const $root = document.getElementById("app");
const root = createRoot($root);



const ScrollToTop = () => {
    const { pathname } = useLocation();

    useEffect(() => {
        window.scrollTo(0, 0);
    }, [pathname]);

    return null; // This component doesn't render anything
};



root.render(
    <BrowserRouter>
        <ScrollToTop />
        <Routes>
            <Route path="/" element={<App />}>
                <Route index element={<Home />} />
                <Route path="media">
                    <Route path=":resourceId" element={<VideoDetails />} />
                    <Route path=":resourceId/play" element={<PlayerContainer />} />
                    <Route path=":resourceId/purchase" element={<PurchasePage />} />
                </Route>
            </Route>
        </Routes>
    </BrowserRouter>
);
