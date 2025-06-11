import Video from '../models/Video';
import Cache from '../controllers/Cache';
import { convertISODurationToSeconds } from '../utils';



test("Test building resourceId arrays", async () => {


    let videos = [
        { resourceId: "_4xNa80IP3o" },
        { resourceId: "foobar" }
    ];

    let resourceIds = Video.getResourceIds(videos);
    expect(resourceIds.length).toBe(2);
    expect(resourceIds.includes("_4xNa80IP3o")).toBe(true);
    expect(resourceIds.includes("foobar")).toBe(true);
    expect(resourceIds.includes("foobar2")).toBe(false);


});



test("Test duration conversations", async () => {


    let duration1 = "PT1H"; // 3600 seconds after conversion
    let duration2 = "PT2H"; // 7200 seconds after conversion




    expect(convertISODurationToSeconds(duration1)).toBe(3600);
    expect(convertISODurationToSeconds(duration2)).toBe(7200);

    //Dont pass an integer to ISO convertion method.
    // see more information about converter here: --
    expect(convertISODurationToSeconds(3600)).toBe(NaN);


});


test("Test that caching works as expected.", async () => {
    //mock a localstorage to perform cache methods/features.
    const localStorageMock = {
        getItem: jest.fn(),
        setItem: jest.fn(),
        clear: jest.fn(),
        removeItem: jest.fn(),
    };
    global.localStorage = localStorageMock;



    let cache1 = new Cache("thumb.");
    let cache2 = new Cache("duration.");



    cache1.set("foobar", "bas");
    cache2.set("foobar", "bas");

    const uncached = Cache.getUncached(["key1", "key2", "key25", "foobar"], cache1, cache2);

    expect(uncached.includes("foobar")).toBe(false);



    cache1.set("foobar", "bas");
    cache2.set("pow", "wam");
    cache2.set("foobar", "somethingElse");

    expect(cache1.get("foobar")).toBe("bas");
    expect(cache2.get("pow")).toBe("wam");
    expect(cache1.get("foobar")).not.toBe("somethingElse");



});

