import VideoPlayer from '../player/VideoPlayer.js';
import AudioPlayer from '../player/AudioPlayer.js';
import { injectScriptElement } from '../utils.js';

/**
 * @jest-environment jsdom
 */


/*
const UNINITIALIZED = -9;

const UNSTARTED = -1;

const ENDED = 0;

const PLAYING = 1;

const PAUSED = 2;

const BUFFERING = 3;

const VIDEO_CUED = 5;

const PLAYER_STATE_SEEKING = 101;
*/

test('Testing YouTube Player Initilization Deprecated', () => {
    injectScriptElement("https://www.youtube.com/iframe_api");

    let allScriptTags = document.getElementsByTagName('script');
    if (allScriptTags.length < 1) {
        console.log("whoops");
    }

    //let firstScriptTag = document.getElementsByTagName('script')[0];

    //  expect(YT.Player).not.toBe(null);
});

describe('YouTubePlayer Init Deprecated', () => {
    //test deprecated for now, logic changed

    // let mockPlayer;

    // beforeEach(() => {
    //     mockPlayer = new VideoPlayer(null, null, null, null);
    //     mockPlayer.init(null, null, null, null);
    // });

    // test('should initialize with correct default values', () => {
    //     expect(mockPlayer.player).toBe('ready');
    //     expect(mockPlayer.state).toBe('unstarted');
    //     expect(mockPlayer.elapsedTime).toBe(0);
    //     expect(mockPlayer.isPolling).toBe(false);
    //     expect(mockPlayer.isPlaying).toBe(false);
    // });
});


describe('Audio Init', () => {

    // declaring variables
    let player;
    let element;
    let type = 'audio/mpeg';
    let src = 'https://ocdla.app/content/uploads/modules/player/ac-2024/chapter-1.mp3';

    beforeEach(() => {

        document.body.innerHTML = `<audio id="player"><source src="${src}" type="${type}" /></audio>`;
        // define variables for Instance of AudioPlayer & HTMLMediaElement as element
        element = document.getElementById("player");
        player = new AudioPlayer();

    });

    test('should initialize correctly', async () => {

        let result = await player.load('player');

        expect(result).toBeInstanceOf(AudioPlayer);
        expect(player.isInitialized()).toBe(true);

    });

    test('should attach player element on load', async () => {

        await player.load("player");
        expect(() => player.play()).not.toThrow();

    });
})

describe('AudioPlayer UI behavior', () => {


    // declaring variables
    let player;
    let element;
    let type = 'audio/mpeg';
    let src = 'https://ocdla.app/content/uploads/modules/player/ac-2024/chapter-1.mp3';

    beforeEach(() => {

        document.body.innerHTML = `<audio id="player"><source src="${src}" type="${type}" /></audio>`;
        // define variables for Instance of AudioPlayer & HTMLMediaElement as element
        element = document.getElementById("player");
        player = new AudioPlayer();

        element.play = jest.fn().mockImplementation(() => Promise.resolve());
        element.pause = jest.fn();

    });

    // JSDom does not support HTMLMediaElement.pause() or .play() 
    // so we can mock their fuctionality with jests's built in function mock jest.fn() 
    // we can use this function to track if the HTMLMedia event is called from the AudioPlayer Class's own definition of the play() and pause() function

    test('play() calls HTMLMediaElement.play()', async () => {

        await player.load('player');
        player.play();

        expect(element.play).toHaveBeenCalled();

    });

    test('pause() calls HTMLMediaElement.pause()', async () => {
        await player.load('player');
        player.pause();

        expect(element.pause).toHaveBeenCalled();

    });

    test('getCurrentTime and getDuration should return correct values', async () => {

        await player.load('player');


        // mock of the currentTime and duration property of variable element
        let mockElapsed = 42;
        let mockAudioDuration = 120;

        //redefining properties of the object 'element' with the property 'duration' setting configurable to true since by default JSDom for jest is read-only
        Object.defineProperty(element, 'duration', {
            configurable: true,
            get: () => mockAudioDuration
        });

        Object.defineProperty(element, 'currentTime', {
            configurable: true,
            get: () => mockElapsed,
            set: (val) => { mockElapsed = val; }
        });

        console.log(player.getCurrentTime());
        console.log(player.getDuration());

        expect(player.getCurrentTime()).toEqual(mockElapsed);
        expect(player.getDuration()).toEqual(mockAudioDuration);

    });

    // HTMLMediaElement seekTo method should only accept values between 0 and duration
    test('seekTo doesnt allow values higher or lower than duration to be seeked', async () => {

        await player.load('player');

        Object.defineProperty(element, 'duration', {
            configurable: true,
            get: () => 100
        });

        player.seekTo(150);
        expect(element.currentTime).toBe(100);

        player.seekTo(-10);
        expect(element.currentTime).toBe(0);

    });

    test('seekTo works as expected', async () => {

        await player.load('player');

        Object.defineProperty(element, 'duration', {
            configurable: true,
            get: () => 100
        });

        let currentTime = 0;
        Object.defineProperty(element, 'currentTime', {
            configurable: true,
            get: () => currentTime,
            set: (val) => { currentTime = val; }
        });

        // verify the elements property of currentTime is properly set to 100
        currentTime = 100;
        expect(element.currentTime).toBe(100);

        // verify invoking the AudioPlayer seekTo method sets the elements property of currentTime to 50
        player.seekTo(50);
        expect(element.currentTime).toBe(50);


    });

});
