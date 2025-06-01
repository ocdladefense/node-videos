import "../css/input.css";
import { createRoot } from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import { App2 as App } from '../components/App';
const regeneratorRuntime = require("regenerator-runtime");



if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1)
}




const $root = document.getElementById("app");
const root = createRoot($root);

root.render(
    <BrowserRouter>
        <App />
    </BrowserRouter>
);
