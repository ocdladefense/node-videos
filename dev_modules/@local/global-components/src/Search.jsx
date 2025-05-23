
/* eslint-disable no-unused-vars */
import { vNode } from '@ocdla/view';
import { defaultButtonStyle } from '@ocdla/global-components/src/Defaults';

export default function Search({ typeNavbar, placeholder }) {
    // prettier-ignore
    return (
        <li class={`${typeNavbar ? 'px-4 lg:p-4 ' : ''}flex size-full justify-center`}>
            <input
                className='size-full rounded-l-md border border-neutral-300 px-3 py-2 focus:border-neutral-200'
                type='search'
                placeholder={placeholder}
            />
            <button class={`${defaultButtonStyle} rounded-l-none`}>GO</button>
        </li>
    );
}
