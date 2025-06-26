import { MenuTop, MenuMobile } from "./navigation/Menus";
import Hamburger from "./navigation/Hamburger";


export default function Header() {

    let items = [
        {
            url: "/",
            label: "home"
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


    return (
        <header class="w-full mb-0 pb-1 p-[10px] sticky top-0 bg-wb-black z-50">
            <nav className="tablet:px-8">

                <ul className="text-zinc-100 inline-block" style={{ width: "100%" }}>

                    <li style={{ verticalAlign: "middle" }} className="inline-block p-3 laptop:px-4">
                        <a href="/">
                            <img className="w-[130px] h-[50px] laptop:w-[148px] laptop:h-[42px]" style={{ display: "inline-block", verticalAlign: "middle" }} src="/images/logos/logo.png" />
                        </a>
                    </li>

                    <MenuTop items={items} />

                    <li style={{ float: "right" }} class={`hidden phone:hidden tablet:inline-block`}>
                        <Hamburger />
                    </li>
                </ul>

                <ul id="mobile-menu" className="text-slate-50 block hidden min-h-[100vh] pt-[15vh]">
                    <MenuMobile items={items} />
                </ul>
            </nav>

        </header>
    );
}
