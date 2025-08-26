// /src/config/mode.js

import { state } from "./state.js";
import { renderCoordInputs } from "../ui/plates.js";

export const PRINTER_MODEL_MAP = {
  "Bambu Lab X1 Carbon": "X1",
  "Bambu Lab X1": "X1",
  "Bambu Lab X1E": "X1",
  "Bambu Lab A1 mini": "A1M",
  "Bambu Lab P1S": "P1",
  "Bambu Lab P1P": "P1",
};

export function modeFromPrinterModel(model) {
  return model ? PRINTER_MODEL_MAP[model] || null : null;
}

// Prüft den GCode-Text auf einen erkennbaren Druckermodus und setzt/validiert CURRENT_MODE
export function setMode(mode) {
  state.CURRENT_MODE = mode;
  document.body.setAttribute("data-mode", mode);

  const isX1P1 = (mode === 'X1' || mode === 'P1');

  const mo = document.getElementById('mode_options');
  const xset = document.getElementById('x1p1-settings');

  if (mo) mo.classList.toggle('hidden', !isX1P1);
  if (xset) xset.classList.toggle('hidden', !isX1P1);

  if (isX1P1) {
    const sel = document.getElementById('object-count');
    renderCoordInputs(parseInt((sel && sel.value) ? sel.value : "1", 10));
  }

  // Per-plate X1/P1-Sektionen zeigen/verstecken
  document.querySelectorAll('.plate-x1p1-settings').forEach(el => {
    el.classList.toggle('hidden', !isX1P1);
  });

  console.log("Mode switched to:", mode);
}

export function ensureModeOrReject(detectedMode, fileName) {
  if (detectedMode === "UNSUPPORTED" || !detectedMode) {
    alert(`This printer model is not supported yet in this app (file: ${fileName}).`);
    return false;
  }

  if (state.CURRENT_MODE == null) {
    setMode(detectedMode);
    // Radios visuell spiegeln (falls sichtbar)
    const map = { A1M: 'mode_a1m', X1: 'mode_x1', P1: 'mode_p1' };
    const rb = document.getElementById(map[detectedMode]);
    if (rb) rb.checked = true;
    return true;
  }

  if (state.CURRENT_MODE !== detectedMode) {
    alert(
      `Printer mismatch.\nLoaded queue is ${state.CURRENT_MODE}, new file is ${detectedMode}.\n` +
      `The new plate will not be added.`
    );
    return false;
  }
  return true;
}