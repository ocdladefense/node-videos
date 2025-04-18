/** @jsx vNode */ /** @jsxFrag "Fragment" */
import { vNode, View } from "@ocdla/view";
import Social from "@ocdla/global-components/src/Social";
import ContentPanel from "@ocdla/global-components/src/ContentPanel";

export default function Contact() {
    return (
        <>
            <ContentPanel heading="contact us">
                <p class="text-default-paragraph-black font-light subpixel-antialiased text-lg mx-auto laptop:mx-0 laptop:w-full laptop:text-[17px]">
                    Lorem ipsum odor amet, consectetuer adipiscing elit. Netus senectus leo leo tristique integer curabitur elementum ex. Erat sed inceptos sapien facilisi auctor eleifend senectus inceptos. Himenaeos potenti condimentum inceptos vulputate ultrices egestas posuere. Libero porta platea scelerisque taciti nostra duis quisque nulla. Posuere a ex fringilla eros nascetur pretium mi. Posuere potenti placerat auctor cras arcu ut facilisis sem at. Litora penatibus laoreet conubia fusce sapien habitasse.
                </p>
            </ContentPanel>

            <section class="mb-8 container mx-auto flex flex-row justify-between gap-8">
                <div class="flex-1">
                    <h3 class="subpixel-antialiased mb-8 text-wb-cordovan text-[2rem] content-heading font-default-heading">send us a message</h3>
                    <form class="form flex flex-col w-full font-default-heading">
                        <div class="py-4">
                            <label class="block">Name</label>
                            <input type="text" size="45" />
                        </div>





                        <div class="py-4">
                            <label class="block">Email</label>
                            <input type="text" size="45" />
                        </div>

                        <div class="py-4">
                            <label class="block">Message</label>
                            <textarea rows="10" cols="45"></textarea>
                        </div>

                        <div class="py-4">
                            <button type="submit" class="mt-8 border-2 border-wb-cordovan bg-wb-cordovan text-wb-white w-40 rounded p-2">Submit</button>
                        </div>
                    </form>
                </div>
                <div class="flex-1 hidden tablet:block">
                    <img src="../images/logos/Waldbusser Ciderworks - Logo Cordovan.png" />
                </div>

            </section>


            <section class="mb-8 container mx-auto">
                <h3 class="subpixel-antialiased mb-8 text-wb-cordovan text-[2rem] content-heading font-default-heading">SOCIAL MEDIA</h3>
                <Social instagram-solid="/" />
            </section>



            <section class="mb-8 container mx-auto">
                <h3 class="subpixel-antialiased mb-8 text-wb-cordovan text-[2rem] content-heading font-default-heading">OUR LOCATIONS</h3>
                <ul class="text-base">
                    <li>Waldbusser Ciderworks</li>
                    <li>4473 SE 3rd St.</li>
                    <li>Corvallis, OR  97333</li>
                    <li><a href="http://ciderworks.ocdla.org/" class="hover:text-wb-lime">waldbusserciderworks.com</a></li>
                    <li><a href="tel:+14106101726" class="hover:text-wb-lime">(410) 610-1726</a></li>
                    <li><a href="mailto:info@waldbusserciderworks.com" class="hover:text-wb-lime">info@waldbusserciderworks.com</a></li>
                </ul>

            </section>
        </>
    );
}
