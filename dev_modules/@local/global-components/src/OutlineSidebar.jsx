
/* eslint-disable no-unused-vars */
import { vNode } from '@ocdla/view';

export default function OutlineSidebar({ items }) {
    return (
        <ul className='ml-4 border-l'>
            {items.map(item => {
                return (
                    <li>
                        <a
                            className='flex px-4 py-2 hover:underline-blue-500 text-blue-400 hover:opacity-[67.5%] hover:underline hover:underline-offset-2'
                            href={'#' + item.href}
                            id={item.href + '-outline-item'}>
                            {item.content}
                        </a>
                        {item.children && item.children.length > 0
                            ? <OutlineSidebar items={item.children} />
                            : ''}
                    </li>
                );
            })}
        </ul>
    );
}
