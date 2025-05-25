
import { vNode, View } from "@ocdla/view";


export default function Hamburger() {

    return (
        <div
            style={{ float: "right", marginRight: "15px" }} id="toggle-menu"
            class="tablet:hidden grid place-content-center w-20 h-10 p-6 mx-auto"
        >
            <div
                class="hamburgler inline-block w-3 h-1 bg-menu rounded-full transition-all duration-150 before:content-[''] before:absolute before:w-5 before:h-1 before:bg-menu before:rounded-full before:-translate-y-2 before:transition-all before:duration-150 after:content-[''] after:absolute after:w-4 after:h-1 after:bg-menu after:rounded-full after:translate-y-2 after:transition-all after:duration-150"
            ></div>
        </div>
    );
}
