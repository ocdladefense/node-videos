



export default function Hamburger() {



    const toggleMenu = function(e) {
        let toggle = document.querySelector("#toggle-menu");
        let menu = document.querySelector("#mobile-menu");
        menu.classList.toggle("hidden");
        // menu.classList.toggle("flex");
    };

    const theStyles = {};//{ float: "right", marginRight: "15px" };

    return (
        <div
            style={theStyles} id="toggle-menu"
            className="grid place-content-center w-20 h-10 p-6 mx-auto"
            onClick={toggleMenu}
        >
            <div
                className="hamburgler inline-block w-3 h-1 bg-menu rounded-full transition-all duration-150 before:content-[''] before:absolute before:w-5 before:h-1 before:bg-menu before:rounded-full before:-translate-y-2 before:transition-all before:duration-150 after:content-[''] after:absolute after:w-4 after:h-1 after:bg-menu after:rounded-full after:translate-y-2 after:transition-all after:duration-150"
            ></div>
        </div>
    );
}
