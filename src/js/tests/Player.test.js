import VideoPlayer from '../player/VideoPlayer.js';
import { injectScriptElement } from '../utils.js';

/**
 * @jest-environment jsdom
 */

test('Testing Player Initilization', () => {
    injectScriptElement("https://www.youtube.com/iframe_api");

    let allScriptTags = document.getElementsByTagName('script');
    if (allScriptTags.length < 1) {
        console.log("whoops");
    }

    //let firstScriptTag = document.getElementsByTagName('script')[0];

    //  expect(YT.Player).not.toBe(null);
});

describe('Player Init', () => {
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
