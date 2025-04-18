// import { vNode, View } from "@ocdla/view";
import "../css/input.css";
import "@themes/active/css/theme.css";
import React from 'react';
import { createRoot } from 'react-dom/client';
// import App from "../App.jsx";


if (MODULE_PATH)
    await import(MODULE_PATH + "/src/index.js");


else {



    if (USE_MOCK) { }

    const $root = document.getElementById("root");
    const root = createRoot($root);
    root.render(<App />);


    /*
    let toggle = document.querySelector("#toggle-menu");
    let menu = document.querySelector("#mobile-menu");

    toggle.addEventListener("click", function() {
        menu.classList.toggle("hidden");
        // menu.classList.toggle("flex");
    });
*/

}


function App() {
    return (
        <div id="the-app">
            <h1 class="font-bold">An OCDLA Project</h1>
            <p>This repository was cloned from the OCDLA project skeleton for React / Tailwind CSS.</p>
        </div>
    );
}
