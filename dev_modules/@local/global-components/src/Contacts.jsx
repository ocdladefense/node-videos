
/* eslint-disable no-unused-vars */
import { vNode } from "@ocdla/view";
import Contact from "./Defaults";
/* eslint-enable */

export default function Contacts(props) {
    const className = props.className || "text-neutral-300";
    delete props.className;
    delete props.children;
    return (
        <ul class={className}>
            {Object.entries(props).map(([label, href]) => (
                <li>
                    <Contact href={href}>{label.replaceAll("_", " ")}</Contact>
                </li>
            ))}
        </ul>
    );
}
