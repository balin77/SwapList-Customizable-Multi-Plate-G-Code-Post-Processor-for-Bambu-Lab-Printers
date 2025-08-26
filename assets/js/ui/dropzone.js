// /src/ui/dropzone.js

import { state } from "../config/state.js";
import { handleFile } from "../io/read3mf.js";

export function dropHandler(ev, instant) {
  ev.preventDefault();

  Array.from(document.getElementsByClassName("drop_zone_active")).forEach(
    function (element, index, array) {
      element.classList.remove("drop_zone_active");
    });

  state.instant_processing = instant;

  if (ev.dataTransfer.items) {
    [...ev.dataTransfer.items].forEach((item, i) => {

      if (item.kind === "file") {
        const file = item.getAsFile();

        if ((i + 1) == ev.dataTransfer.items.length) state.last_file = true;
        else state.last_file = false;
        handleFile(file);
      }
    });

  } else {
    [...ev.dataTransfer.files].forEach((file, i) => {
      if ((i + 1) == ev.dataTransfer.files.length) state.last_file = true;
      else state.last_file = false;
      handleFile(file);
    });
  }
}

export function focusDropzone() {
  document.getElementById("drop_zones_wrapper").classList.add("focused");
}

export function defocusDropzone() {
  document.getElementById("drop_zones_wrapper").classList.remove("focused");
}

export function dragOverHandler(ev, tar) {
  console.log("File(s) in drop zone");
  tar.classList.add("drop_zone_active");
  ev.preventDefault();
}

export function dragOutHandler(ev) {
  ev.target.classList.remove("drop_zone_active");
  ev.preventDefault();
}