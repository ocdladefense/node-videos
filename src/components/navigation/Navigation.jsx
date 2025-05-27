
import { vNode, View } from "@ocdla/view";
import Hamburger from "./Hamburger";

export default function Navigation() {
    let items = [
        {
            url: "/",
            label: "home"
        },
        {
            url: "/videos",
            label: "videos"
        },
        {
            url: "/audio",
            label: "audio",
            hidden: true
        },
        {
            url: "/login",
            label: "login",
            hidden: true
        },
        {
            url: "/settings",
            label: "settings",
            hidden: true
        }
    ];


    let top = items.map(item => {
        let phoneDisplay = !!item.hidden ? "hidden phone:hidden tablet:inline-block" : "phone:inline-block";
        return (
            <li class={`hidden ${phoneDisplay} p-2 laptop:p-6`}>
                <a href={item.url}>
                    <button class={`font-marketing text-white subpixel-antialiased hover:text-wb-cordovan`}>{item.label}</button>
                </a>
            </li>
        );
    });


    let all = items.map(item => {
        // let phoneDisplay = !!item.hidden ? "hidden phone:hidden tablet:inline-block" : "phone:inline-block";
        return (
            <li className="p-3 text-center laptop:px-4">
                <a href={item.url}>
                    <button className="text-center font-marketing text-white subpixel-antialiased hover:text-wb-cordovan">{item.label}</button>
                </a>
            </li>
        );
    });

    return (
        <nav className="tablet:px-8">


            <ul className="inline-block" style={{ width: "100%" }}>

                <li style={{ verticalAlign: "middle" }} className="inline-block p-3 laptop:px-4">
                    <a href="/">
                        <img className="w-[130px] h-[50px] laptop:w-[148px] laptop:h-[42px]" style={{ display: "inline-block", verticalAlign: "middle" }} src="../images/logos/logo.png" />
                    </a>
                </li>

                {top}

                <li style={{ float: "right" }} class={`hidden phone:hidden tablet:inline-block`}>
                    <Hamburger />
                </li>
            </ul>






            <ul id="mobile-menu" className="text-slate-50 block hidden min-h-[100vh] pt-[15vh]">


                {all}



            </ul>


        </nav>
    );
}
