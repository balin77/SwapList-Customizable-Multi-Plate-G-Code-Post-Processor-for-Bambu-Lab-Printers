// "use strict";

import { initialize_page } from "./config/initialize.js";

// Dev Mode Toggle - set to true to show development/debug features
export const DEV_MODE = true;

// run initialisation after the page was loaded
window.addEventListener("DOMContentLoaded", () => {
  initialize_page();
});



