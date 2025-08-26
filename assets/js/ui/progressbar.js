// /src/ui/progressbar.js
import { state } from "../config/state.js";

export function update_progress(i) {
  // Element sicherstellen (einmalig lazy-resolve)
  let el = state.p_scale || document.getElementById("progress_scale");
  if (!el) return; // UI noch nicht bereit
  // im State cachen, damit nächste Aufrufe schneller sind
  state.p_scale = el;

  const bar = el;
  const container = bar.parentElement;
  if (!container) return;

  if (i < 0) {
    // Reset / ausblenden
    bar.style.width = "0%";
    container.style.opacity = "0";
    return;
  }

  // einblenden + Breite clampen
  const pct = Math.max(0, Math.min(100, i | 0));
  container.style.opacity = "1";
  bar.style.width = pct + "%";
}
