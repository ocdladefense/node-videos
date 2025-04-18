/** @jsx vNode */ /** @jsxFrag "Fragment" */
import { vNode, View } from "@ocdla/view";
import Header from "@ocdla/global-components/src/Header";
import Footer from "@themes/active/components/Footer";

// Get routes for this installation.
import routes from "./data/routes.js";
import Router from "@ocdla/lib-routing/src/Router.js";

import menus from "@themes/active/data/menus.js";
import heroImage from "@themes/active/images/mockup/hero.webp";
import logo from "@themes/active/images/logos/logo-header.png";

let router = new Router();
router.setBasePath("/");
router.setDefaultPage("Home");
router.setNotFoundCallback("Home");
// router.setComponentPath("../../../../src/components/pages");
routes.forEach(route => {
    router.addRoute(route.path, route.callback);
});

// component = NotFound


// let Page = await router.getPage();
const [componentName] = router.match(
    window.location.pathname
);
let module = await import(`./components/pages/${componentName}`);
const Page = module.default;
let HeaderTwo;

if (["Home", ""].includes(router.getRoute())) {
    let h = await import("@themes/active/components/HomeHeader.jsx");
    HeaderTwo = h.default;
}


console.log(Page, HeaderTwo);
let location = router.getLocation();

export default function App() {
    let menuId = "main";
    let items = menus[menuId];

    return (
        <>
            <Header navItems={items} logo={logo} logoWidth="30" logoHeight="30" />
            {typeof HeaderTwo === "function" ? <HeaderTwo heroImageSrc={heroImage} /> : <></>}
            <main class={`grow overflow-x-hidden font-default-paragraph ${location}`}>
                <Page />
            </main>
            <Footer />
        </>
    );
}
