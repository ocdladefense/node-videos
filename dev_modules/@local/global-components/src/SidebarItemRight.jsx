/** @jsx vNode */
/* eslint-disable no-unused-vars */
import { vNode } from '@ocdla/view';
import Link from './Defaults';
/* eslint-enable */

export default function SidebarItemRight({ href, label }) {
    return (
        <li>
            <Link
                extraClasses='flex border-b px-4 py-2'
                href={href}>
                {label}
            </Link>
        </li>
    );
}
