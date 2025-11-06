// "use strict";

import { initialize_page } from "./config/initialize.js";


// run initialisation after the page was loaded
window.addEventListener("DOMContentLoaded", async () => {
  await initialize_page();
});



