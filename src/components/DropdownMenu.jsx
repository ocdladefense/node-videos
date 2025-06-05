
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
                className="inline-flex items-left justify-between text-xl bg-zinc-800 rounded-md text-zinc-100 px-4 py-2 relative mr-5 w-[200px]"
                onClick={handleToggle}
            >
                {label}<span>&#9660;</span>
            </button>
            {open && (
                <div className="max-h-[400px] overflow-y-scroll">
                    <ul className="w-auto shadow-md p-1  absolute max-h-[400px] bg-zinc-800 bg-opacity-80 text-zinc-100 overflow-y-scroll z-20 w-[200px]">
                        {items.map((item, index) => (
                            <li
                                key={index}
                                className={` flex items-center gap-2 px-4 py-2 text-sm hover:bg-slate-600 border-b`}
                            >
                                <button type="button" value={item.value} onClick={(e) => { action(e.target.value); handleToggle(); }} className='w-full text-left'>{item.label}</button>
                            </li>
                        ))}
                    </ul>
                </div>
            )}
        </div>
    );

}
