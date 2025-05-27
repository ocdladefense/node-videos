import Video from '../models/Video';
import initThumbs from '../controllers/VideoThumbs';
import { VideoThumbnails } from '../controllers/VideoThumbs';



test("testing initThumbs", async () => {
    const localStorageMock = {
        getItem: jest.fn(),
        setItem: jest.fn(),
        clear: jest.fn(),
        removeItem: jest.fn(),
    };
    global.localStorage = localStorageMock;

    const thumbnailMap = await initThumbs([{ resourceId: '_4xNa80IP3o' }, {resourceId: 'foobar'}]);
    console.log("thumbnailMap:", thumbnailMap);
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

describe("Thumbs API Error Handling", () => {

    test("Handles 400 response: Missing Required Parameter", async () => {

        //craft mock error
        const mockErrorResponse = {
            error: {
                code: 400,
                message: "A required parameter is missing.",
                errors: [
                    {reason: "missingRequiredParameter", message: "Missing required parameter - id."}
                ],
            }
        };

        //resolve with mocked values
        fetch.mockResolvedValue({
            ok: false,
            status: 400,
            statusText: "Bad Request",
            json: () => Promise.resolve(mockErrorResponse)
        });

        //assert error is thrown
        await expect(VideoThumbnails.getThumbs(["dummyId"])).rejects.toThrow(/Missing Required Parameter/);

    });

    test("Handles 403 response: Forbidden", async () => {

        //craft mock error
        const mockErrorResponse = {
            error: {
                code: 403,
                message: "Access forbidden",
                errors: [
                    {reason: "forbidden", message: "Authorization failed, access is forbidden"}
                ],
            }
        };

        //resolve with mocked values
        fetch.mockResolvedValue({
            ok: false,
            status: 403,
            statusText: "Forbidden",
            json: () => Promise.resolve(mockErrorResponse)
        });

        //assert error is thrown
        await expect(VideoThumbnails.getThumbs(["dummyId"])).rejects.toThrow(/Authorization failed, access is forbidden/);
        
    });

    test("Handles 403 response: Quota Exceeded", async () => {
        
    });

});
