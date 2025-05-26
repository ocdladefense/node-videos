/** @jsx vNode */ /** @jsxFrag "Fragment" */
import { vNode, View } from "@ocdla/view";

export default function HomeHeader() {

    return (
        <>
            <div class="hero-image">
                <img src="../images/mockup/hero.png" class="size-full brightness-50" />
                <div class="overlay-logo"></div>
                {/*<div class="overlay-slow-cider"></div>*/}
            </div>

            {/*
            <section class="callout bg-wb-black tablet:mb-16">
                <p class="subpixel-antialiased container text-2xl mx-auto tablet-portrait:max-w-[90%] laptop:max-w-[80%] tablet:mx-auto px-8 py-20 font-default-paragraph">
                    <span class="text-stone-300">Welcome to <strong>Waldbusser Ciderworks</strong>, where the art of traditional cider making meets modern, transparent practices. Nestled in the heart of Oregon, we specialize in crafting exceptional ciders through a meticulous slow fermentation process that captures the essence of the apples we use.</span>
                </p>
            </section>
            */}
        </>
    );

}
