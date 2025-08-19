import React, { useRef } from 'react';
import Thumbnail from '../js/models/Thumbnail';

export default function RelatedVideos({ video, currentSeminar, seminarVideos }) {

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
                            className={`flex-shrink-0 w-64 cursor-pointer p-2 roundedF
                    ${vid.getVideoResourceId() === video.getVideoResourceId()
                                    ? "bg-zinc-700"
                                    : "bg-zinc-800 hover:bg-zinc-600"}`}
                            onClick={() => setSelectedVideo(vid)}
                        >
                            <img
                                src={vid.getThumbnailUrl(Thumbnail.SMALL)}
                                alt={vid.getVideoName()}
                                className="w-full h-36 object-cover rounded"
                            />
                            <p className="text-lg font-semibold mt-2">{vid.getVideoName()}</p>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    )
}
