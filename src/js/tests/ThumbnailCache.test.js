import ThumbnailCache from '../controllers/VideoThumbs';

describe("ThumbnailCache", () => {
    //run tests with an empty initial cache
    beforeEach(() => localStorage.clear());

    test("store and retrieve value", () => {
        const cache = new ThumbnailCache(true);
        const thumbData = { default: { url: "https://example.com/default1.jpg" } };
        cache.set("video1", thumbData);
        expect(cache.get("video1")).toEqual(thumbData);
    });
});