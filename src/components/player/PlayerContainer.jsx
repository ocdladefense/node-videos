import { useState, useEffect, useRef } from 'react';
import { useParams, useNavigate, useLocation } from "react-router";
import { useOutletContext } from 'react-router-dom';
import '../../css/videostyles.css';
import Controls from './Controls.jsx';
import { PlayerTheme, VideoContainer, TitleContainer } from '../../js/videostyles.js';
import { ThemeProvider, Box } from '@mui/material';
import { Skeleton as PlayerPlaceholder, Tooltip } from '@mui/material';
import YouTubePlayer from '../../js/player/YouTubePlayer.js';
import AudioPlayer from '../../js/player/AudioPlayer.js';

window.playerMap = {
    video: YouTubePlayer,
    audio: AudioPlayer
};

// Player instance used throughout the application lifecycle.
// let player = new YouTubePlayer();

// let user = {}; //getCurrentUser();
/*


    const toggleFullscreen = (event) => {
        if (isFullscreen) {
            document.exitFullscreen();
        } else {
            fullscreenRef.current?.requestFullscreen();
        }
    };

    useEffect(() => {

        fullscreenRef.current = document.querySelector('#playerBox');

        const handleFullscreenChange = () => {
            setIsFullscreen(!!document.fullscreenElement);
        };

        document.addEventListener('fullscreenchange', handleFullscreenChange);

        return () => {
            document.removeEventListener('fullscreenchange', handleFullscreenChange);
        };

    }, []);

*/

let thePlayer;

/**
 *  
 * @param {MediaPlayer} player The MediaPlayer or specific subclass that will be used to control this media.
 * @param {Video} video The video object that is to be played (todo for a more abstract MediaPlayerContainer use resource or even url).
 * @param {String} layout In either standard or pip; pip displays a player with a fixed position and smaller size.
 * @param {StringList} controls A comma separated list of characteristics to be applied to the MediaControls.
 * @returns 
 */
export default function PlayerContainer({ controls = "standard,float,autohide,hidden" }) {

    // Get page parameters.
    let params = useParams();
    let location = useLocation();
    let videoId = params.resourceId;

    // Use react-router-dom hook.
    let { parser, user } = useOutletContext();

    let navigate = useNavigate();

    // Start watching the video at some previously alotted time.
    let elapsedTime = location.state.start;

    // Reference to the video that will be played.
    const [video, setVideo] = useState(parser.getVideo(videoId));

    const isAudio = false; //video.getType() == "audio";

    // The player instance.
    const [player, setPlayer] = useState(thePlayer || (isAudio ? new AudioPlayer() : new YouTubePlayer()));
    thePlayer = player;
    const url = "https://ocdla.app/content/uploads/modules/player/ac-2024/chapter-1.mp3"; //video.getUrl();

    const type = "audio/mpeg";

    const previousPage = function() { player.destroy(); navigate("/media/" + videoId) };



    // Change the layout of the player: in "standard", "fullscreen" or "pip".
    const [layout, setLayout] = useState("standard");




    const [isFullscreen, setIsFullscreen] = useState(false);






    const pip = layout === "pip";
    const [width, height] = pip ? [400, 250] : [1200, 720];



    // If the video changes, then set it as the queued video that will be played.
    useEffect(() => {
        player.cue(video, (elapsedTime || 0));
    }, []);


    useEffect(() => {
        player.setSize(width, height);
    }, [layout]);


    // Initialize the player.
    // Initialization involves both downloading the YT API script and instantiating an instance of YTPlayer.
    // ***We shouldn't need to pass most of the setter functions along to the YouTube class.
    useEffect(() => {
        if (!player.isInitialized()) {
            // player.onElapsedTimeChange(setPlayerState);
            player.load("player");//.then((player) => setPlayerInitialized(true));
        }
    }, [player.isInitialized()]);



    return (

        <ThemeProvider theme={PlayerTheme} injectFirst>


            <Box id='playerBox' style={{ ...{ position: "relative", margin: "0 auto", width: width, height: height, overflow: "hidden" }, ...(!pip ? {} : { position: "fixed", top: "0px", right: "25px" }) }}>
                <TitleContainer style={{ display: "none" }}>
                    <h1>{video.getVideoName()}</h1>
                </TitleContainer>


                {isAudio ?
                    <audio id="player">
                        <source src={url} type={type} />
                    </audio>
                    :
                    (<div id="blocker">
                        <VideoContainer maxWidth={false}>
                            <div id="player-wrapper">
                                <div id="player">
                                    <PlayerPlaceholder variant="rectangular" animation="wave" width={width} height={height} />
                                </div>
                            </div>
                        </VideoContainer>
                    </div>)
                }

                <Controls player={player} previousPage={previousPage} isFullscreen={isFullscreen} toggleFullscreen={function() { }} />


            </Box>
        </ThemeProvider>

    );
}
