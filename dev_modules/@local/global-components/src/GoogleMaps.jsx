
/* eslint-disable-next-line no-unused-vars */
import { vNode } from '@ocdla/view';

export default function GoogleMaps({ src }) {
    return (
        <li>
            <ul>
                <iframe
                    className='aspect-square w-full border-0 lg:w-64'
                    src={src}
                    allowfullscreen
                    referrerpolicy='no-referrer-when-downgrade'></iframe>
            </ul>
        </li>
    );
}
