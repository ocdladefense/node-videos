/** @jsx vNode */ /** @jsxFrag "Fragment" */
import { vNode, View } from "@ocdla/view";
// import Header from "./components/Header";
import Navigation from "@ocdla/global-components/src/navigation/Navigation";
import Footer from "../components/Footer";
import routes from "../data/routes.js";
import Router from "@ocdla/lib-routing/src/Router.js";

let router = new Router();
router.setBasePath("/");
router.setDefaultPage("Home");
router.setNotFoundCallback("Home");
routes.forEach(route => {
    router.addRoute(route.path, route.callback);
});

// component = NotFound
const [componentName] = router.match(
    window.location.pathname
);
let module = await import(`../components/pages/${componentName}`);
const Page = module.default;
let HeaderTwo;

if (["Home", ""].includes(router.getRoute())) {
    let h = await import("../components/HomeHeader");
    HeaderTwo = h.default;
}


console.log(Page, HeaderTwo);
let location = router.getLocation();

export default function App() {
    let items = [
        {
            url: "/",
            label: "home"
        },
        {
            url: "/ciders",
            label: "ciders"
        },
        {
            url: "/growers",
            label: "growers",
            hidden: true
        },
        {
            url: "/drink",
            label: "drink",
            hidden: false
        },
        {
            url: "/how-its-made",
            label: "how it's made",
            hidden: true
        },
        {
            url: "/about",
            label: "about",
            hidden: true
        },
        {
            url: "/contact",
            label: "contact us",
            hidden: true
        },
        {
            url: "/order-progress",
            label: "orders",
            hidden: true
        }
    ];

    return (
        <>
            <header class="w-full mb-0 pb-1 p-[10px] sticky top-0 bg-wb-black z-50">
                <Navigation routes={items} />
            </header>
            {typeof HeaderTwo === "function" ? <HeaderTwo /> : <></>}
            <main class={`grow overflow-x-hidden font-default-paragraph ${location}`}>
                <i>No module provided.</i>
                <Page />
            </main>
            <Footer />
        </>
    );
}
