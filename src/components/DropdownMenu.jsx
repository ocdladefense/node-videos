import React from 'react';
import { useState } from "react";


/*
    @param buttonLabel
    @param items: {
        title: title,
        action: function,
    }

*/


export default function DropdownMenu({ buttonLabel, items }) {
    const [open, setOpen] = useState(false);

    const handleToggle = () => {
        setOpen((prev) => !prev);
    };

    return (
        <div className="relative">
            <button
                type="button"
                className="inline-flex items-center justify-center text-xl border-2 bg-zinc-50 border-zinc-50 rounded-lg px-4 py-2 relative mr-5"
                onClick={handleToggle}
            >
                {buttonLabel}

            </button>
            {open && (
                <div>
                    <ul className="h-auto shadow-md rounded-md p-1 border bg-white">
                        {items.map((item, index) => (
                            <li
                                key={index}
                                className={` flex items-center gap-2 px-4 py-2 text-sm hover:bg-gray-100 rounded-md`}
                            >
                                <button type="button" onClick={() => { item.action(); handleToggle(); }} className='w-full text-left'>{item.title}</button>
                            </li>
                        ))}
                    </ul>
                </div>
            )}
        </div>
    );

}
