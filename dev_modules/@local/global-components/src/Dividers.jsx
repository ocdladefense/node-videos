
/* eslint-disable-next-line no-unused-vars */
import { vNode } from '@ocdla/view';

export const DividerDesktop = () => (
    <li className='hidden text-neutral-300 lg:block'>|</li>
);

export const DividerMobile = () => {
    return (
        <li className='block size-full lg:hidden'>
            <hr />
        </li>
    );
};
