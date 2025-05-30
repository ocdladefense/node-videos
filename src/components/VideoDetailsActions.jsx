import User from "../js/models/User";


export default function VideoDetailsActions({ buttons = ["play", "resume", "rewatch", "purchase"], actions }) {

    let hasAccess2 = true;
    let hasWatched = false;
    let showPlay = buttons.includes("play");
    let showResume = buttons.includes("resume");
    let showRewatch = buttons.includes("rewatch");
    let showPurchase = buttons.includes("purchase");
    return (
        <div className="options space-y-2">

            {showPlay && <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2 mr-3" onClick={actions["play"]}>Play Video</button>}

            {showResume && <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2 mr-3" onClick={actions["resume"]}>Resume/Continue</button>}

            {showRewatch && <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2 mr-3" onClick={actions["rewatch"]}>Start From Beginning</button>}

            {showPurchase && <button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2" onClick={actions["purchase"]}>Purchase $19.99</button>}

        </div>
    )
}
