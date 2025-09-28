


export function MenuTop({ items }) {



    let top = items.map(item => {
        let phoneDisplay = !!item.hidden ? "hidden phone:hidden tablet:inline-block" : "phone:inline-block";
        return (
            <li className={`hidden ${phoneDisplay} p-2 laptop:p-6`}>
                {/*<NavLink to={item.url}>{item.label}</NavLink> */}
                <a href={item.url}>
                    <button className={`font-marketing text-white subpixel-antialiased hover:text-wb-cordovan`}>{item.label}</button>
                </a>
            </li>
        );
    });


    return top;
}




export function MenuMobile({ items }) {


    let all = items.map(item => {
        // let phoneDisplay = !!item.hidden ? "hidden phone:hidden tablet:inline-block" : "phone:inline-block";
        return (
            <li className="p-3 text-center laptop:px-4">
                <a href={item.url}>
                    <button className="text-center font-marketing text-white subpixel-antialiased hover:text-wb-cordovan">{item.label}</button>
                </a>
            </li>
        );
    });

    return (


        <ul id="mobile-menu" className="text-slate-50 block hidden min-h-[100vh] pt-[15vh]">
            {all}
        </ul>

    );
}
