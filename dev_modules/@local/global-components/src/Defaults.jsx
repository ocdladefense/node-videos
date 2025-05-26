
/* eslint-disable-next-line no-unused-vars */
import { vNode } from '@ocdla/view';

export const defaultLinkStyle =
    'hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2';

export const defaultButtonStyle =
    'text-nowrap rounded-md border border-black bg-black px-3 py-2 font-bold text-white';

export default function Link({
    classes = defaultLinkStyle,
    extraClasses,
    href,
    children,
    id
}) {
    return (
        <a
            id={id || null}
            class={`${classes}${extraClasses ? ` ${extraClasses}` : ''}`}
            href={href || null}>
            {children}
        </a>
    );
}
