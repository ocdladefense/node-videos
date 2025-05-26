
/* eslint-disable-next-line no-unused-vars */
import { vNode } from '@ocdla/view';

export default function NotFound() {
    return (
        <div className='flex flex-col items-center gap-4 bg-black p-32 text-white'>
            <h1 className='text-center text-7xl font-black tracking-tighter'>
                404
            </h1>
            <h6 className='text-2xl font-thin'>Something Went Wrong</h6>
            <a
                className='rounded-md border border-black bg-white p-4 font-bold text-black'
                href='/'>
                RETURN HOME
            </a>
        </div>
    );
}
