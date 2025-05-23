
/* eslint-disable-next-line no-unused-vars */
import { vNode } from '@ocdla/view';
import { defaultButtonStyle } from '@ocdla/global-components/src/Defaults';

export default function Button({ href, label }) {
    return (
        <li className='size-full'>
            <a
                className='group flex items-center p-4'
                href={href}>
                <span class={defaultButtonStyle}>{label}</span>
            </a>
        </li>
    );
}
