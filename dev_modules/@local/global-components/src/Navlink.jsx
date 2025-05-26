
/* eslint-disable no-unused-vars */
import { vNode } from '@ocdla/view';
import Link from './Defaults';
/* eslint-enable */

export default function Navlink({ active, href, children }) {
    return (
        <li className='size-full'>
            <Link
                classes={`${active ? 'font-bold ' : ''}items-center lg:h-16 flex text-nowrap text-neutral-500 hover:opacity-[67.5%] hover:underline hover:underline-offset-2 p-4`}
                href={href}>
                {children}
            </Link>
        </li>
    );
}
