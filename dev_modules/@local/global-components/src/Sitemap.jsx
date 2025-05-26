
import { vNode } from "@ocdla/view";

// <li class="size-full"> This was wrapping the entire return. We may need to keep size-full when using this.
// [{title: "SERVICES", links: [{href="/", label: "Membership Directory"}, {} ]}, {}]
export default function Sitemap({ className, children }) {
    return (
        <ul
            class={
                className ||
                "flex flex-col gap-8 text-nowrap text-[#516490] lg:flex-row lg:gap-16"
            }>
            {children}
        </ul>
    );
}
