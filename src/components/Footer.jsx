import { vNode, View } from "@ocdla/view";
import Legal from "@ocdla/global-components/src/Legal";
import Sitemap from "@ocdla/global-components/src/Sitemap";
import SitemapCategory from "@ocdla/global-components/src/SitemapCategory";
import Social from "@ocdla/global-components/src/Social";
import Contacts from "@ocdla/global-components/src/Contacts";
import Logo from "@ocdla/global-components/src/Logo";
import GoogleMaps from "@ocdla/global-components/src/GoogleMaps";




export default function Footer() {


    return (
        <footer class="container mx-auto border border-b-0 p-4 pb-16 lg:p-8 lg:pb-32">

            <ul id="ul-depth-1" class="flex flex-col gap-4">
                <li>

                    <ul class="flex flex-col gap-4 lg:flex-row lg:gap-8">
                        <li>

                            <ul id="ul-depth-2" class="flex flex-col gap-1">
                                <li>

                                    <ul id="ul-depth-3" class="flex items-center gap-1">
                                        <li class=""><a class="" href="/"><img class="h-16" src="/images/logo_ocdla.png" /></a></li>
                                        <li><a class="hover:opacity-[67.5%]" href="https://facebook.com/OregonCriminalDefenseLawyersAssociation"><img class="w-8" src="/images/logo_facebook.png" alt="Facebook logo" /></a></li>
                                        <li><a class="hover:opacity-[67.5%]" href="https://x.com/oregondefense"><img class="w-8" src="/images/logo_twitter.png" alt="Twitter logo" /></a></li>
                                        <li></li>
                                    </ul>
                                </li>
                                <li>

                                    <ul id="ul-depth-3" class="text-[0.625rem] font-thin leading-[0.75rem] text-neutral-500">
                                        <li>©2024 Oregon Criminal Defense Lawyers Association</li>
                                        <li class="size-full text-wrap">Oregon Criminal Defense Lawyers Association is a 501(c)(3) nonprofit educational association. Contributions to OCDLA may be tax deductible - check with your tax advisor. Electronic downloads are for the sole use of the purchasing member. Files may not be distributed to others.</li>
                                    </ul>
                                </li>
                                <li>

                                    <ul class="text-neutral-300">
                                        <li>
                                            <a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="https://ocdla.org">ocdla.org</a>
                                        </li>
                                        <li>
                                            <a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="mailto:info@ocdla.org">info@ocdla.org</a>
                                        </li>
                                        <li>
                                            <a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="tel:+15416868716">(+1) 541-686-8716</a>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                        <li class="size-full">

                            <ul class="flex flex-col gap-8 text-nowrap text-[#516490] lg:flex-row lg:gap-16">
                                <li>

                                    <ul class="flex flex-col gap-1">
                                        <li>
                                            <p class="text-base font-bold">SERVICES</p>
                                        </li>
                                        <li><a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="https://pubs.ocdla.org/directory/members">Membership Directory</a></li>
                                        <li><a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="https://pubs.ocdla.org/directory/experts">Expert Directory</a></li>
                                        <li><a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="/">Online store</a></li>
                                    </ul>
                                </li>
                                <li>

                                    <ul class="flex flex-col gap-1">
                                        <li>
                                            <p class="text-base font-bold">RESEARCH</p>
                                        </li>
                                        <li><a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="https://pubs.ocdla.org/car/list">Research Criminal Appellate Review</a></li>
                                        <li><a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="https://lod.ocdla.org/">Library of Defense</a></li>
                                        <li><a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="https://lod.ocdla.org/Public:Subscriptions">Books Online</a></li>
                                    </ul>
                                </li>
                                <li>

                                    <ul class="flex flex-col gap-1">
                                        <li>
                                            <p class="text-base font-bold">RESOURCES</p>
                                        </li>
                                        <li><a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="/">CLEs</a></li>
                                        <li><a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="/">Videos</a></li>
                                        <li><a class="hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2" href="/">Seminars &amp; Events</a></li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </li>

            </ul>
        </footer>
    );
}

