/** @jsx vNode */
import '../css/input.css';
import { vNode, View } from "@ocdla/view/view.js";
import { changeNames } from "./helper.js";
import Profile from "../components/Profile.jsx";

// Data
/* eslint-enable */

console.log("Loaded index.js"); 


let root = View.createRoot("#app");
root.render(<Profile firstName="José" lastName="Bernal" />);




const changer = changeNames();

const intId = window.setInterval(() => {
  
  let first = changer.next().value;

  if(!first) {
    window.clearInterval(intId);
    return;
  }

  root.update(<Profile firstName={first} lastName="Bernal" />);
}, 1000);

