//import ThumbnailCache from '../controllers/VideoThumbs';
import Video from '../models/Video';
import initThumbs from '../controllers/VideoThumbs';

test("testing initThumbs", () => {
    const localStorageMock = {
        getItem: jest.fn(),
        setItem: jest.fn(),
        clear: jest.fn(),
        removeItem: jest.fn(),
    };
    global.localStorage = localStorageMock;

    const thumbnailMap = initThumbs([{ resourceId: '_4xNa80IP3o' }]);
})

describe("Thumb get/set", () => {
    test("Video model sets and retrieves thumbnails", () => {

        const video = new Video({ id: "test123", resourceId: "test123" });

        const thumbData = {
            default: { url: "https://example.com/default.jpg" },
            high: { url: "https://example.com/high.jpg" }
        };

        video.setThumbnail(thumbData);

        expect(video.getVideoThumbnail("default")).toBe("https://example.com/default.jpg");
        expect(video.getVideoThumbnail("high")).toBe("https://example.com/high.jpg");
    });

    test("getHighestRes returns the highest available resolution", () => {

        const video = new Video({ id: "test456", resourceId: "test456" });

        const thumbData = {
            default: { url: "https://example.com/default.jpg" },
            medium: { url: "https://example.com/medium.jpg" },
            high: { url: "https://example.com/high.jpg" }
        };

        video.setThumbnail(thumbData);
        expect(video.getMaxResThumb()).toBe("high");
    });

    test("getVideoThumbnail returns message if no thumbnail", () => {

        const video = new Video({ id: "test789", resourceId: "test789" });

        expect(video.getVideoThumbnail("high")).toBe("No thumbnailData for resolution: high");
    });
});

//describe("ThumbnailCache", () => {
//    //run tests with an empty initial cache
//    beforeEach(() => localStorage.clear());

//    test("store and retrieve value", () => {
//        const cache = new ThumbnailCache(true);
//        const thumbData = { default: { url: "https://example.com/default1.jpg" } };
//        cache.set("video1", thumbData);
//        expect(cache.get("video1")).toEqual(thumbData);
//    });
//});