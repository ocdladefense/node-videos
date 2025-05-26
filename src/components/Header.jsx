
import { vNode, View } from "@ocdla/view";
import Navigation from "./navigation/Navigation";



export default function Header() {
    return (
        <header class="w-full mb-0 pb-1 p-[10px] sticky top-0 bg-wb-black z-50">
            <Navigation />
        </header>
    );
}
