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
        <footer className="text-slate-200 bg-wb-black p-8 tablet:p-16 laptop:p-32 laptop:pt-16">


            {/*
            <section className="shape-section">
                <div className="container diamond-shape">
                    <div className="item-count">99</div>
                </div>
            </section>
*/}

            <div className="container text-slate-200 text-center text-4xl mb-20" style={{ lineHeight: "1.0rem" }}>
                <span className="font-smoothy-cursive text-slate-300 inline-block">Video</span>&nbsp;<span className="font-marketing text-xl text-slate-300 inline-block">app</span>
                <span className="pl-8 font-smoothy-cursive text-slate-300 inline-block">Video</span>&nbsp;<span className="font-marketing text-xl text-slate-300 inline-block">app</span>
            </div>

            <div className="container tablet:grid tablet:grid-cols-6">

                <div className="col-start-1 pb-8">
                    <a href='/'>
                        <img src="../images/logos/logo.png" />
                    </a>
                </div>

                <div className="col-start-3 pb-8">
                    <h3 className="text-wb-red text-lg">Contact</h3>
                    <ul className="text-slate-400">
                        <li>OCDLA</li>
                        <li><a href="http://ciderworks.ocdla.org/" className="hover:text-wb-lime">info@ocdla.org</a></li>
                        <li><a href="tel:+14106101726" className="hover:text-wb-lime">(410) 610-1726</a></li>
                        <li><a href="mailto:info@ocdla.org" className="hover:text-wb-lime">info@ocdla.org</a></li>
                    </ul>
                    <Social instagram="waldbusserciderworks" />
                </div>

                <Sitemap classNames="col-start-5 text-nowrap text-stone-400 pb-8" style={{ fontWeight: 200 }}>
                    <SitemapCategory title="OCDLA" path="/" classNames="hover:text-stone-500"
                        Home="/"
                        About="/about"
                        Contact_Us="/contact"
                    />
                </Sitemap>

            </div>

        </footer >
    );
}

