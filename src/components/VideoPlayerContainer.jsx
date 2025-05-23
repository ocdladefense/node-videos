import React, { useState, useEffect, useRef } from 'react';
import '../css/videostyles.css';
import VideoControlBar from './VideoControlBar';
import VideoProgressBar from './VideoProgressBar';
import { videoPlayerTheme, VideoContainer, TitleContainer, ControlBarContainer, ArrowBackButton } from '../js/videostyles.js';
import { ThemeProvider, Tooltip, Box, Skeleton } from '@mui/material';
import { Skeleton as PlayerPlaceholder } from '@mui/material';

const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;

export default function VideoPlayerContainer({ player, video, onBack, pip = false }) {

    // Player initialization defaults to false.
    // This specific state of "initialized" should probably just piggy-back off the "playerState" variable.
    // I.e., playerState > -1 == initialized.
    const [playerInitialized, setPlayerInitialized] = useState(false);

    // Sync to an external system.
    // The serialize method returns the state of the player in JSON format.
    // The player "publishes" its state and this component subscribes to these events with its addListener() method.
    const [playerState, setPlayerState] = useState(player.serialize());



    // If the video changes, then set it as the queued video that will be played.
    useEffect(() => {
        player.cue(video);
        if (pip) {
            player.setSize(400, 250);
        }
    });



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

    useEffect(() => {
        //define handler
        const handleMediaStateChange = (event) => {
            const { resourceId, timestamp } = event.detail;
            console.log("recieved mediastatechange event", resourceId, timestamp);

            updateUserTimestamp(resourceId, timestamp);
        }

        //attach listener
        const playerElement = document.getElementById('player');
        if (playerElement) {
            playerElement.addEventListener('mediastatechange', handleMediaStateChange);
        }

        //cleanup on reinitialize
        return () => {
            if (playerElement) {
                playerElement.removeEventListener('mediastatechange', handleMediaStateChange);
            }
        }

    }, [playerInitialized]);

    function updateUserTimestamp(resourceId, timestamp) {
        console.log("updating user timestamp data", resourceId, timestamp);

        const watchedVideoRecordId = getWatchedVideoRecordIdForResource(resourceId);

        if (!watchedVideoRecordId) {
            console.error("No watched video record found for resource", resourceId);
            // maybe make a new record if existing no existing WatchedVideo for resource
            return;
        }

        const payload = { Timestamp__c: timestamp };
        const url = `${SF_INSTANCE_URL}/services/data/v57.0/sobjects/Watched_Video__c/${watchedVideoRecordId}`;

        fetch(url, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${SF_ACCESS_TOKEN}`
            },
            body: JSON.stringify(payload)
        }).then(response => {
            if (!response.ok) {
                throw new Error(`Record update failed: ${response.statusText}`);
            }
            return response.json();
        }).then(data => {
            console.log('Watched video record updated successfully:', data);
        }).catch(error => {
            console.error('Error updating record:', error);
        });
    }

    function getWatchedVideoRecordIdForResource(resourceId) {
        // this should be a salesforce query for a WatchedVideo id
        return "1";
    }


    return (

        <ThemeProvider theme={videoPlayerTheme}>

            <TitleContainer>
                <h1>{video.getVideoName()}</h1>
            </TitleContainer>

            <VideoContainer>
                <div id="player-wrapper" style={pip ? { position: "fixed", top: "0px", right: "0px" } : {}} >
                    <div id="player">
                        <PlayerPlaceholder variant="rectangular" animation="wave" width={1280} height={720} />
                    </div>
                    <div id="blocker"></div>
                </div>
            </VideoContainer>

            <VideoProgressBar player={player} />

            <ControlBarContainer playerstate={playerInitialized}>

                <Tooltip title="Return to Video Details Page" placement="left">
                    <ArrowBackButton onClick={() => { player.destroy(); onBack(); }} variant="contained" />
                </Tooltip>

                <Box>
                    <VideoControlBar player={player} />
                </Box>
            </ControlBarContainer>

        </ThemeProvider>

    )
}
