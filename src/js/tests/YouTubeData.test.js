import Video from '../models/Video';
import initData from '../controllers/YouTubeData';



test("testing initData", async () => {
    //mock a localstorage to perform cache methods/features.
    const localStorageMock = {
        getItem: jest.fn(),
        setItem: jest.fn(),
        clear: jest.fn(),
        removeItem: jest.fn(),
    };
    global.localStorage = localStorageMock;

    //simulate a response for a real id and a fake foobar
    const sampleApiResponse = {
        items: [
            {
                id: "_4xNa80IP3o",
                snippet: {
                    thumbnails: {
                        default: { url: "http://example.com/default1.jpg" },
                        high: { url: "http://example.com/high1.jpg" },
                        medium: { url: "http://example.com/medium1.jpg" },
                        standard: { url: "http://example.com/standard1.jpg" },
                        maxres: { url: "http://example.com/maxres1.jpg" },
                    }
                }, contentDetails: {
                    duration: "PT1H" // 3600 seconds after conversion
                }
            },
            {
                id: "foobar",
                snippet: {
                    thumbnails: {
                        default: { url: "http://example.com/default2.jpg" },
                        high: { url: "http://example.com/high2.jpg" },
                        medium: { url: "http://example.com/medium2.jpg" },
                        standard: { url: "http://example.com/standard2.jpg" },
                        maxres: { url: "http://example.com/maxres2.jpg" },
                    }
                }, contentDetails: {
                    duration: "PT2H" // 7200 seconds after conversion
                }
            }
        ]
    };

    //200 status so our sample reponse is a pass
    global.fetch = jest.fn(() =>
        Promise.resolve({
            status: 200,
            ok: true,
            json: () => Promise.resolve(sampleApiResponse)
        })
    );

    const data = await initData([
        { resourceId: "_4xNa80IP3o" },
        { resourceId: "foobar" }
    ]);

    console.log("data:", data);

    expect(data).toBeDefined();
    expect(data.get("thumb._4xNa80IP3o")).toBeDefined();
    expect(data.get("duration._4xNa80IP3o")).toBeDefined();
    expect(data.get("thumb.foobar")).toBeDefined();
    expect(data.get("duration.foobar")).toBeDefined();

    const thumbData = data.get("thumb._4xNa80IP3o");
    const durationData = data.get("duration.foobar");
    expect(thumbData.thumbs).toBeDefined();
    expect(durationData.durations).toBe(7200); //should be 7200 post-conversion
});


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
                    { reason: "missingRequiredParameter", message: "Missing required parameter - id." }
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
        await expect(initData(["dummyId"])).rejects.toThrow(/Missing Required Parameter/);

    });

    test("Handles 403 response: Forbidden", async () => {

        //craft mock error
        const mockErrorResponse = {
            error: {
                code: 403,
                message: "Access forbidden",
                errors: [
                    { reason: "forbidden", message: "Authorization failed, access is forbidden" }
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
        await expect(initData(["dummyId"])).rejects.toThrow(/Authorization failed, access is forbidden/);

    });

});
