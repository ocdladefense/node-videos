
/* eslint-disable no-unused-vars */
import { vNode } from '@ocdla/view';
/* eslint-enable */

export default function Breadcrumbs({ items = [] }) {
    return (
        <section className='flex items-center border border-t-0 p-4 capitalize text-black lg:h-16'>
            <ul className='flex flex-wrap items-center whitespace-pre'>
                {items.map((item, i) => {
                    const seperatorString = i !== items.length - 1 ? ' / ' : ' ';
                    return (
                        <li>
                            <a href={item.href}>{item.label}</a>
                            <span>{seperatorString}</span>
                        </li>
                    );
                })}
            </ul>
        </section>
    );
}
