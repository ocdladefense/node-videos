/* eslint-disable no-unused-vars */
import { vNode } from '@ocdla/view';
import Link from './Defaults';
/* eslint-enable */

export default function Folder({ href, label }) {
    return (
        <li>
            <Link
                classes='border border-blue-600 hover:opacity-[67.5%] text-blue-600 px-4 py-2 rounded-md contrast-[0] saturate-0'
                href={href}>
                {label}
            </Link>
        </li>
    );
}
