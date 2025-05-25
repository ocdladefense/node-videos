
/* eslint-disable-next-line no-unused-vars */
import { vNode } from "@ocdla/view";

export default function Legal({ classNames, year, association, children }) {
    return (
        <ul
            className={
                classNames ||
                "text-neutral-500 text-[0.625rem] font-thin leading-[0.75rem]"
            }>
            <li>
                ©{year} {association}
            </li>
            <li className="size-full text-wrap">{children || ""}</li>
        </ul>
    );
}
