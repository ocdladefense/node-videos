
/* eslint-disable no-unused-vars */
import { vNode } from '@ocdla/view';
import Link from './Defaults';
/* eslint-enable */

export default function Dropdown({ href, label }) {
    return (
        <li>
            <Link
                classes='border lg:border-t-0 hover:border-neutral-200 bg-neutral-50 px-12 py-2 text-neutral-500 hover:bg-neutral-100 hover:text-neutral-600'
                href={href}>
                {label}
            </Link>
        </li>
    );
}
