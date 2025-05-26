
/* eslint-disable no-unused-vars */
import { vNode } from '@ocdla/view';
import Dropdown from './Dropdown';
/* eslint-enable */

export default function Profile({ bg, label }) {
    return (
        <li className='relative'>
            <button
                className='group peer flex h-16 items-center p-4'
                type='button'>
                {/* prettier-ignore */}
                <div class={`${bg ? `${bg} ` : ''}h-[34px] w-[34px] flex items-center text-white justify-center rounded-full group-hover:opacity-[67.5%] focus-within:opacity-[67.5%]`}>{label}</div>
            </button>
            <ul className='absolute left-[-1rem] top-[calc(100%+0.5rem)] z-10 hidden -translate-x-1/2 flex-col text-nowrap shadow peer-focus-within:flex lg:left-1/2'>
                <Dropdown
                    href='https://oregon.public.law/users/sign_in'
                    label='Login'
                />
            </ul>
        </li>
    );
}
