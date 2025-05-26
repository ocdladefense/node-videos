
/* eslint-disable-next-line no-unused-vars */
import { vNode } from '@ocdla/view';
import logo_ocdla from './images/logo_ocdla.png';

export default function Logo({ typeNavbar }) {
    // Default = 'footer'
    const li = typeNavbar ? 'size-full' : '';
    const a = typeNavbar ? 'flex px-4' : '';

    return (
        <li class={li}>
            <a
                class={a}
                href='/'>
                <img
                    className='h-16'
                    src={logo_ocdla}
                />
            </a>
        </li>
    );
}
