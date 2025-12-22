// "use strict";

import { initialize_page } from "./config/initialize.js";
import { logPlatformInfo } from "./platform/index.js";


// run initialisation after the page was loaded
window.addEventListener("DOMContentLoaded", async () => {
  // Log platform information
  logPlatformInfo();

  await initialize_page();
});



