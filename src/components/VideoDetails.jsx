import React, { useState, useRef } from "react";

export default function VideoDetails({ video, onBack, setRoute, user, parser, setSelectedVideo }) {
    const prevWatched = user.getWatchedVideo(video.getVideoResourceId());
    const purchasedVideo = user.getPurchasedVideo(video.getVideoResourceId());
    const [isPlayable, setIsPlayable] = useState(() => purchasedVideo != null || video.isFree());

    console.log("get purchased vids", user.getUserPurchasedVideos());

    const playVideo = function() {
        console.log("About to play the video!");
        setRoute("player");
    }

    const playVideoFromBeginning = function() {
        setRoute("resetPlayer");
    }

    const purchase = function() {
        user.addToPurchasedVideos(video);
        setIsPlayable(true);
    }

    const grouped = parser.groupBySeminar();

    let currentSeminar = null;
    for (const seminar in grouped) {
        if (grouped[seminar].some(v => v.getVideoResourceId() === video.getVideoResourceId())) {
            currentSeminar = seminar;
            break;
        }
    }
    const seminarVideos = currentSeminar ? grouped[currentSeminar] : [];


    const scrollRef = useRef(null);
    const scroll = (dir) => {
        if (scrollRef.current) {
            scrollRef.current.scrollBy({
                left: dir === "left" ? -300 : 300,
                behavior: "smooth",
            });
        }
    };

    return (
        <div className="video-details bg-zinc-900 min-h-screen">
            <button className="absolute top-4 left-4 text-zinc-300 text-3xl z-20" onClick={onBack}>←</button>


            <div className="video-content relative w-full">
                {/* <h1 className="text-2xl text-zinc-100 text-left">{video.getVideoName()}</h1> */}
                <img
                    src={video.getVideoThumbnail(video.getMaxResThumb())}
                    alt={'Thumbnail for ${video.getVideoName()}'}
                    className="w-full object-cover h-[700px] md:h-[400px] lg:h-[300px]"
                />
                <div className="absolute bottom-0 left-0 p-6 bg-gradient-to-t from-black to-transparent w-full md:w-3/4">
                    <h1 className="text-4xl font-bold mb-2 text-left">{video.getVideoName()}</h1>
                    {currentSeminar && (
                        <p className="text-lg text-zinc-300 mb-2">Included in Seminar: <span className="font-semibold">{currentSeminar}</span></p>
                    )}
                    <p className="text-md text-zinc-200 mb-4">{video.getVideoDescription()}</p>
                    <div className="options space-y-2">
                        {
                            isPlayable ? (
                                prevWatched === null ? (
                                    <p>
                                        <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2" onClick={playVideo}>Play Video</button>
                                    </p>


                                ) : (
                                    <>
                                        <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2 mr-3" onClick={playVideo}>Resume/Continue</button>
                                        <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2" onClick={playVideoFromBeginning}>Start From Beginning</button>
                                    </>
                                )
                            ) : (
                                <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2" onClick={purchase}>Purchase $19.99</button>
                            )
                        }
                    </div>
                </div>
            </div>
            {/* Related videos section */}
            {seminarVideos.length > 1 && (
                <div className="mt-10 px-4 text-zinc-300">
                    <h2 className="text-3xl mb-4">Other videos in "{currentSeminar}"</h2>
                    <div className="relative">
                        {seminarVideos.length > 4 && (
                            <>
                                <button
                                    className="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-black bg-opacity-60 hover:bg-opacity-90 text-white px-3 py-14 rounded-lg flex items-center justify-center"
                                    onClick={() => scroll("left")}
                                >
                                    ←
                                </button>
                                <button
                                    className="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-black bg-opacity-60 hover:bg-opacity-90 text-white px-3 py-14 rounded-lg flex items-center justify-center"
                                    onClick={() => scroll("right")}
                                >
                                    →
                                </button>
                            </>
                        )}

                        <div
                            ref={scrollRef}
                            className="flex space-x-4 overflow-x-auto pb-4 scroll-smooth"
                            style={{ scrollBehavior: "smooth" }}
                        >
                            {seminarVideos.map((vid) => (
                                <div
                                    key={vid.getVideoResourceId()}
                                    className={`flex-shrink-0 w-64 cursor-pointer p-2 rounded
                                        ${vid.getVideoResourceId() === video.getVideoResourceId()
                                            ? "bg-zinc-700"
                                            : "bg-zinc-800 hover:bg-zinc-600"}`}
                                    onClick={() => setSelectedVideo(vid)}
                                >
                                    <img
                                        src={vid.getVideoThumbnail(vid.getMaxResThumb())}
                                        alt={vid.getVideoName()}
                                        className="w-full h-36 object-cover rounded"
                                    />
                                    <p className="text-lg font-semibold mt-2">{vid.getVideoName()}</p>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            )}
        </div>

    );
};
