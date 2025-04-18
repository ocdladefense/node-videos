/** @jsx vNode */ /** @jsxFrag "Fragment" */
import { vNode, View } from "@ocdla/view";
import TwoColumnPanel from "@ocdla/global-components/src/TwoColumnPanel";
import ContentPanel from "@ocdla/global-components//src/ContentPanel";

export default function Home() {
    return (
        <>
            {/* <section class="pb-32 bg-wb-gray text-wb-black h-screen">
                    <img src="..\images\mockup\Banner.png" class="size-fit"/> 
                </section> */}


            <TwoColumnPanel heading="our philosophy" order="ltr">
                <img src="../images/mockup/stock-photo-1.png" class="rounded pb-8 " />
                <p class="font-default-paragraph text-default-paragraph-black font-light subpixel-antialiased text-lg mx-auto laptop:mx-0 laptop:w-full laptop:text-[17px]">
                    Great cider starts with great ingredients. Our commitment to quality begins with sourcing the finest apples from local orchards. By partnering with growers who share our passion for sustainability and excellence, we ensure that every sip of our cider is a reflection of the rich, fertile Oregon landscape. <a href="/growers">Meet the Growers.</a>
                </p>
            </TwoColumnPanel>

            <TwoColumnPanel heading="slow cider" order="rtl" striped>
                <img src="../images/mockup/stock-photo-2.png" class="rounded pb-8 " />
                <p class="font-default-paragraph text-default-paragraph-black font-light subpixel-antialiased text-lg mx-auto laptop:mx-0 laptop:w-full laptop:text-[17px]">
                    Patience is at the core of our cider-making process.
                    Unlike mass-produced ciders that rush through
                    fermentation, we embrace a slow fermentation method that
                    allows the natural flavors and aromas of the apples to
                    develop fully. This careful approach results in ciders
                    that are complex, well-balanced, and brimming with
                    character.
                </p>
            </TwoColumnPanel>

            <TwoColumnPanel heading="transparency" order="lrt">
                <img src="../images/mockup/stock-photo-3.png" class="rounded pb-8 " />
                <p class="font-default-paragraph text-default-paragraph-black font-light subpixel-antialiased text-lg mx-auto laptop:mx-0 laptop:w-full laptop:text-[17px]">
                    We take pride in our transparent production practices.
                    From apple to bottle, we invite you to see every step of
                    our process. Whether it's detailed information on our
                    apple varieties, or insights into our fermentation
                    techniques, we're dedicated to being open about how our
                    ciders are made. Transparency is not just a buzzword for
                    us; it's a commitment to our customers and a cornerstone
                    of our brand.
                </p>
            </TwoColumnPanel>


            <TwoColumnPanel heading="our ciders" order="rtl">
                <img src="../images/bottles/bottles.png" class="rounded pb-8 " />
                <p class="font-default-paragraph text-default-paragraph-black font-light subpixel-antialiased text-lg mx-auto laptop:mx-0 laptop:w-full laptop:text-[17px]">
                    Each cider we produce tells a story. From crisp,
                    refreshing styles to rich, robust blends, our range
                    caters to all palates. Every bottle is a testament to
                    our dedication to craft, quality, and tradition. Explore
                    our collection and discover your new favorite cider.
                </p>
            </TwoColumnPanel>




            <ContentPanel heading="join our community">
                <p class="font-default-paragraph text-default-paragraph-black font-light subpixel-antialiased text-lg laptop:text-[17px]">
                    Stay connected with us through our social media channels. Be the first to know about new releases, special events, and exclusive offers. Join our community of cider enthusiasts and share in the journey of crafting exceptional ciders.
                </p>
                <p class="font-default-paragraph text-default-paragraph-black font-light subpixel-antialiased text-lg laptop:text-[17px]">
                    Thank you for choosing Waldbusser Ciderworks. Cheers to slow cider!
                </p>
            </ContentPanel>

        </>
    );
}
