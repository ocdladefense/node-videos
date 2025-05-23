
import { vNode } from "@ocdla/view";




export default function TableOfContents({ onChapterChange, entries, currentChapter }) {
    return <aside className='lg:sticky lg:top-0 hidden h-[87.5vh] list-none overflow-y-scroll lg:block overflow-x-clip'>
        <ul id="toc-sidebar" class="list-none">
            {entries.map((entry) => {
                return (
                    <li class="py-4 border-b">
                        <h1 className='text-blue-400 group-hover:text-blue-500 font-bold'>
                            <a
                                id={entry.getId()}
                                class={["group", "flex", "flex-col", "gap-2", "px-4", "py-2", entry.getUnit() === currentChapter ? 'text-white border-black bg-black' : 'hover:bg-neutral-100'].join(" ")}
                                href='#'
                                onclick={(e) => { e.stopPropagation(); e.preventDefault(); onChapterChange(entry.getUnit()); }}>
                                {entry.isChapter() ? entry.getHeading() : ''}
                            </a>
                        </h1>
                        <p class="px-4">{entry.getName()}</p>
                    </li>
                );
            })}
        </ul>
    </aside>
}
