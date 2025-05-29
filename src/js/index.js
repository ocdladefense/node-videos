import "../css/input.css";
import { createRoot } from 'react-dom/client';
import App from '../components/App';



const regeneratorRuntime = require("regenerator-runtime");
const dataUrl = "https://ocdla.my.site.com/VideoData";
const API_KEY = process.env.API_KEY;
const SF_INSTANCE_URL = process.env.SF_INSTANCE_URL;
const SF_ACCESS_TOKEN = process.env.SF_ACCESS_TOKEN;


if (process.env.NODE_ENV === 'debug') {
    setDebugLevel(1)
}




const $root = document.getElementById("app");
const root = createRoot($root);
root.render(<App />);


