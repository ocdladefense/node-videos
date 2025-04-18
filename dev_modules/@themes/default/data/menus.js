const menus = {};

menus["main"] = getMainMenu();

export default menus;

function getMainMenu() {
    return [
        {
            url: "/",
            label: "home"
        },
        {
            url: "/eat",
            label: "eat"
        },
        {
            url: "/drink",
            label: "drink",
            hidden: true
        },
        {
            url: "/drink",
            label: "drink",
            hidden: false
        },
        {
            url: "/events",
            label: "events",
            hidden: true
        },
        {
            url: "/about",
            label: "about",
            hidden: true
        },
        {
            url: "/contact",
            label: "contact us",
            hidden: true
        }
    ];
}
