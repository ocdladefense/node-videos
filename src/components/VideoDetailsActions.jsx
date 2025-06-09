



export default function VideoDetailsActions({ buttons = ["play", "resume", "rewatch", "purchase"], actions, remaining = "25 mins. remaining" }) {

    const showPlay = buttons.includes("play");
    const showResume = buttons.includes("resume");
    const showRewatch = buttons.includes("rewatch");
    const showPurchase = buttons.includes("purchase");

    return (
        <div className="options space-y-2">
            {showPlay && (<button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2 mr-3" onClick={actions["play"]}> Play </button>)}
            {showResume && (<button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2 mr-3" onClick={actions["resume"]}> Continue {remaining}</button>)}
            {showRewatch && (<button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2 mr-3" onClick={actions["rewatch"]}> Start From Beginning </button>)}
            {showPurchase && (<button className="text-xl border-2 bg-zinc-50 rounded-lg px-4 py-2" onClick={actions["purchase"]}> Purchase $19.99 </button>)}
        </div>
    );
}

