
import { useState } from "react";


/*
    @param buttonLabel
    @param items: {
        title: title,
        action: function,
    }

*/


export default function DropdownMenu({ label, items = [], action }) {
    const [open, setOpen] = useState(false);

    const handleToggle = () => {
        setOpen((prev) => !prev);
    };

    return (
        <div className="relative">
            <button
                type="button"
                className="inline-flex items-center justify-center text-xl border-2 bg-zinc-100 border-zinc-50 rounded-lg px-4 py-2 relative mr-5"
                onClick={handleToggle}
            >
                {label}
            </button>
            {open && (
                <div className="max-h-[400px] overflow-y-scroll">
                    <ul className="w-auto shadow-md rounded-md p-1 border bg-zinc-100 absolute max-h-[400px] overflow-y-scroll z-20">
                        {items.map((item, index) => (
                            <li
                                key={index}
                                className={` flex items-center gap-2 px-4 py-2 text-sm hover:bg-zinc-300 border-b`}
                            >
                                <button type="button" value={item.value} onClick={(e) => { action(e.target.value); handleToggle(); }} className='w-full text-left'>{item.title}</button>
                            </li>
                        ))}
                    </ul>
                </div>
            )}
        </div>
    );

}
