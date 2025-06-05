import { useState } from "react";


export default function SearchBar() {
    const [searchInput, setSearchInput] = useState("");

    const handleChange = (e) => {
        e.preventDefault();
        setSearchInput(e.target.value);
    };

    if (searchInput.length > 0) {
        //filter
    }

    return (
        <div class="w-full max-w-sm min-w-[200px]">
            <input
                type="text"
                placeholder="Search here"
                onChange={handleChange}
                value={searchInput}
                className="w-full bg-transparent placeholder:text-slate-400 text-zinc-100 text-sm border border-slate-200 rounded-md px-3 py-2 transition duration-300 ease focus:outline-none focus:border-slate-400 hover:border-slate-300 shadow-sm focus:shadow"
            />
        </div>


    )
}
