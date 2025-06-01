import { useState, useEffect, useRef } from 'react';
import { useParams } from "react-router";
import '../../css/videostyles.css';
import MediaControls from './MediaControls';
import MediaControlsFloating from './MediaControlsFloating';
import { PlayerTheme, VideoContainer, TitleContainer } from '../../js/videostyles.js';
import { ThemeProvider, Box } from '@mui/material';
import { Skeleton as PlayerPlaceholder, Tooltip } from '@mui/material';




/**
 *  
 * @param {MediaPlayer} player The MediaPlayer or specific subclass that will be used to control this media.
 * @param {Video} video The video object that is to be played (todo for a more abstract MediaPlayerContainer use resource or even url).
 * @param {String} layout In either standard or pip; pip displays a player with a fixed position and smaller size.
 * @param {StringList} controls A comma separated list of characteristics to be applied to the MediaControls.
 * @returns 
 */
export default function VideoPlayerContainer({ parser, player, onBack, controls = "standard,float,autohide,hidden" }) {

    // Get page parameters.
    let params = useParams();

    let videoId = params.resourceId;

    // Reference to the video that will be played.
    const [video, setVideo] = useState(parser.getVideo(videoId));

    // Player initialization defaults to false.
    // This specific state of "initialized" should probably just piggy-back off the "playerState" variable.
    // I.e., playerState > -1 == initialized.
    const [playerInitialized, setPlayerInitialized] = useState(false);

    // Change the layout of the player: in "standard", "fullscreen" or "pip".
    const [layout, setLayout] = useState("standard");

    // Sync to an external system.
    // The serialize method returns the state of the player in JSON format.
    // The player "publishes" its state and this component subscribes to these events with its addListener() method.
    const [playerState, setPlayerState] = useState(JSON.stringify(player.getPlayerState()));

    const fullscreenRef = useRef(null);
    const [isFullscreen, setIsFullscreen] = useState(false);




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

    const pip = layout === "pip";
    const [width, height] = pip ? [400, 250] : [1200, 720];



    // If the video changes, then set it as the queued video that will be played.
    useEffect(() => {
        player.cue(video);
    }, []);


    useEffect(() => {
        player.setSize(width, height);
    }, [layout]);


    // Initialize the player.
    // Initialization involves both downloading the YT API script and instantiating an instance of YTPlayer.
    // ***We shouldn't need to pass most of the setter functions along to the YouTube class.
    useEffect(() => {
        if (!player.isInitialized()) {
            player.addListener(setPlayerState);
            // player.init(setPlayerInitialized);
            player.load("player", setPlayerInitialized);
        }
    }, [player.isInitialized()]);



    return (

        <ThemeProvider theme={PlayerTheme} injectFirst>


            <Box id='playerBox' style={{ ...{ position: "relative", margin: "0 auto", width: width, height: height, overflow: "hidden" }, ...(!pip ? {} : { position: "fixed", top: "0px", right: "25px" }) }}>
                <TitleContainer style={{ display: "none" }}>
                    <h1>{video.getVideoName()}</h1>
                </TitleContainer>



                <div id="blocker">
                    <VideoContainer maxWidth={false}>
                        <div id="player-wrapper">
                            <div id="player">
                                <PlayerPlaceholder variant="rectangular" animation="wave" width={width} height={height} />
                            </div>
                        </div>
                    </VideoContainer>
                </div>

                <MediaControls player={player} onBack={onBack} isFullscreen={isFullscreen} toggleFullscreen={toggleFullscreen} playerInitialized={playerInitialized} />


            </Box>
        </ThemeProvider>

    )
}
/* 
-PIP stuff

*/
