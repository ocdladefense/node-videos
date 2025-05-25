
import { vNode, View } from "@ocdla/view";
import Hamburger from "./Hamburger";

export default function Navigation() {
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


    let top = items.map(item => {
        let phoneDisplay = !!item.hidden ? "hidden phone:hidden tablet:inline-block" : "phone:inline-block";
        return (
            <li class={`hidden ${phoneDisplay} p-2 laptop:p-6`}>
                <a href={item.url}>
                    <button class={`font-marketing text-base subpixel-antialiased hover:text-wb-cordovan`}>{item.label}</button>
                </a>
            </li>
        );
    });


    let all = items.map(item => {
        // let phoneDisplay = !!item.hidden ? "hidden phone:hidden tablet:inline-block" : "phone:inline-block";
        return (
            <li className="p-3 text-center laptop:px-4">
                <a href={item.url}>
                    <button className="text-center font-marketing text-base subpixel-antialiased hover:text-wb-cordovan">{item.label}</button>
                </a>
            </li>
        );
    });

    return (
        <nav className="tablet:px-8">


            <ul className="inline-block">

                <li style={{ verticalAlign: "middle" }} className="inline-block p-3 laptop:px-4">
                    <a href="/">
                        <img className="w-[30px] h-[30px] laptop:w-[48px] laptop:h-[48px]" style={{ display: "inline-block", verticalAlign: "middle" }} src="../images/logos/logo.svg" />
                    </a>
                </li>

                {top}

            </ul>



            <Hamburger />


            <ul id="mobile-menu" className="block hidden min-h-[100vh] pt-[15vh]">


                {all}

            </ul>


        </nav>
    );
}
