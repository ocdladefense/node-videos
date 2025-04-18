/** @jsx vNode */ /** @jsxFrag "Fragment" */
import { vNode, View } from "@ocdla/view";

export default function HomeHeader({heroImageSrc}) {

    return (
        <>
            <div class="relative hero-image">
                <img src={heroImageSrc} class="size-full brightness-50" />
                <div class="absolute top-0 left-0 w-full h-full opacity-50">
                    <h1 class="text-4xl text-slate-300 mx-auto font-bold text-center">2024<br />Ken Morrow<br/> Lifetime Achievement<br />Award<br />Honoring Steve Sady</h1>
                </div>
            </div>



        </>
    );

}
