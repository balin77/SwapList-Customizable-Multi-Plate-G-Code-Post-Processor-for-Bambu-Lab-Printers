/**
 * Dropzone module for handling file drag-and-drop operations
 */

import { state } from "../config/state.js";
import { handleFile } from "../io/read3mf.js";

/**
 * Handle file drop event on the dropzone
 * @param ev - The drag event
 * @param instant - Whether to process files instantly
 */
export function dropHandler(ev: DragEvent, instant: boolean): void {
  ev.preventDefault();

  // Remove active state from all drop zones
  Array.from(document.getElementsByClassName("drop_zone_active")).forEach(
    (element: Element) => {
      element.classList.remove("drop_zone_active");
    }
  );

  state.instant_processing = instant;

  if (ev.dataTransfer?.items) {
    // Use DataTransferItemList interface
    Array.from(ev.dataTransfer.items).forEach((item: DataTransferItem, i: number) => {
      if (item.kind === "file") {
        const file = item.getAsFile();
        if (file) {
          if ((i + 1) === ev.dataTransfer!.items.length) {
            state.last_file = true;
          } else {
            state.last_file = false;
          }
          handleFile(file);
        }
      }
    });
  } else if (ev.dataTransfer?.files) {
    // Use DataTransferFileList interface (fallback)
    Array.from(ev.dataTransfer.files).forEach((file: File, i: number) => {
      if ((i + 1) === ev.dataTransfer!.files.length) {
        state.last_file = true;
      } else {
        state.last_file = false;
      }
      handleFile(file);
    });
  }
}

/**
 * Focus the dropzone (add visual focus state)
 */
export function focusDropzone(): void {
  const wrapper = document.getElementById("drop_zones_wrapper");
  if (wrapper) {
    wrapper.classList.add("focused");
  }
}

/**
 * Defocus the dropzone (remove visual focus state)
 */
export function defocusDropzone(): void {
  const wrapper = document.getElementById("drop_zones_wrapper");
  if (wrapper) {
    wrapper.classList.remove("focused");
  }
}

/**
 * Handle drag over event to show drop zone as active
 * @param ev - The drag event
 * @param tar - The target element being dragged over
 */
export function dragOverHandler(ev: DragEvent, tar: HTMLElement): void {
  console.log("File(s) in drop zone");
  tar.classList.add("drop_zone_active");
  ev.preventDefault();
}

/**
 * Handle drag out event to remove active state from drop zone
 * @param ev - The drag event
 */
export function dragOutHandler(ev: DragEvent): void {
  const target = ev.target as HTMLElement;
  if (target) {
    target.classList.remove("drop_zone_active");
  }
  ev.preventDefault();
}
