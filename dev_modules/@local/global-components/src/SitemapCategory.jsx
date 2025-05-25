
// <li class="size-full"> This was wrapping the entire return. We may need to keep size-full when using this.
// [{title: "SERVICES", links: [{href="/", label: "Membership Directory"}, {} ]}, {}]
export default function SitemapCategory(props) {
    const title = props.title;
    const className = props.className || null;
    let path = props.path;


    /*
    delete props.title;
    delete props.className;
    delete props.path;
    delete props.children;
*/


    // Remove trailing '/' if there is one.
    path = path.at(-1) == "/" ? path.slice(0, -1) : path;
    return (
        <ul class="flex flex-col gap-8 text-nowrap text-[#516490] lg:flex-row lg:gap-16">
            <li>
                <ul class="flex flex-col gap-1">
                    {/* Category title */}
                    <li>
                        <p class={`text-base font-bold ${className}`}>
                            <a href="{path}">{title}</a>
                        </p>
                    </li>
                    {/* Links in each category */}
                    {Object.entries(props).map(([label, href]) => (
                        <li>
                            <a href={href[0] == "/" ? path + href : href} class={className}>
                                {label.replaceAll("_", " ")}
                            </a>
                        </li>
                    ))}
                </ul>
            </li>
        </ul>
    );
}
