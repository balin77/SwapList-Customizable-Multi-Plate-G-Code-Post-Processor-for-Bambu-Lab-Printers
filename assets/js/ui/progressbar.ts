/**
 * Progress bar module for displaying file processing progress
 */

import { state } from "../config/state.js";

/**
 * Update the progress bar display
 * @param i - Progress percentage (0-100), or negative value to hide/reset
 */
export function update_progress(i: number): void {
  // Ensure element exists (lazy-resolve on first call)
  let el = state.p_scale || document.getElementById("progress_scale");
  if (!el) return; // UI not ready yet

  // Cache in state for faster subsequent calls (ensure it's an HTMLElement)
  if (el instanceof HTMLElement) {
    state.p_scale = el;
  }

  const bar = el as HTMLElement;
  const container = bar.parentElement;
  if (!container) return;

  if (i < 0) {
    // Reset / hide
    bar.style.width = "0%";
    container.style.opacity = "0";
    return;
  }

  // Show and clamp percentage to 0-100
  const pct = Math.max(0, Math.min(100, i | 0));
  container.style.opacity = "1";
  bar.style.width = pct + "%";
}
