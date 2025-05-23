
/* eslint-disable no-unused-vars */
import { vNode } from '@ocdla/view';

export default function Sidebar({ children, id, sticky = false }) {
    let classList = `hidden h-full lg:h-[87.5vh] overflow-y-scroll lg:block ${sticky ? 'sticky top-0' : ''}`;
    return (
        /* prettier-ignore */
        <aside
            id={id || null}
            class={`${sticky ? 'lg:sticky lg:top-0 ' : ''}hidden h-[87.5vh] list-none overflow-y-scroll lg:block overflow-x-clip`}>
            {children}
        </aside>
    );
}
