import { Elm } from "./src/Main.elm";

import "normalize.css";
import "./src/main.styl";

Elm.Main.init({
  node: document.querySelector("main"),
});
