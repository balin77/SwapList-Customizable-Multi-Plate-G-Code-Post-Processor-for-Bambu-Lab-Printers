// /src/config/mode.js

import { state } from "./state.js";
import { renderCoordInputs } from "../ui/plates.js";
import { showError, showWarning } from "../ui/infobox.js";
import { updateSettingsVisibilityForMode } from "../ui/settings.js";
import { applyVisibilityRules, showUIAfterFileLoad } from "./uiVisibility.js";

export const PRINTER_MODEL_MAP = {
  "Bambu Lab X1 Carbon": "X1",
  "Bambu Lab X1": "X1",
  "Bambu Lab X1E": "X1",
  "Bambu Lab A1 mini": "A1M",
  "Bambu Lab A1": "A1",
  "Bambu Lab P1S": "P1",
  "Bambu Lab P1P": "P1",
};

export function modeFromPrinterModel(model) {
  return model ? PRINTER_MODEL_MAP[model] || null : null;
}

export function getDisplayNameForMode(mode) {
  const displayMap = {
    "A1M": "A1 Mini",
    "A1": "A1",
    "X1": "X1",
    "P1": "P1"
  };
  return displayMap[mode] || "Unknown";
}

// Prüft den GCode-Text auf einen erkennbaren Druckermodus und setzt/validiert CURRENT_MODE
export function setMode(mode) {
  state.CURRENT_MODE = mode;
  document.body.setAttribute("data-mode", mode);

  // App-Mode automatisch basierend auf Drucker setzen
  const modeToggleCheckbox = document.getElementById("mode_toggle_checkbox");
  if (mode === 'A1M') {
    // A1M → SWAP Mode
    state.APP_MODE = "swap";
    if (modeToggleCheckbox) {
      modeToggleCheckbox.checked = false;
    }
  } else if (mode === 'A1') {
    // A1 → Default to Push Off Mode, but allow toggle. Don't force mode change if already set
    if (!state.APP_MODE) {
      state.APP_MODE = "pushoff";
    }
    if (modeToggleCheckbox) {
      modeToggleCheckbox.checked = (state.APP_MODE === "pushoff");
    }
  } else {
    // X1, P1 → Push Off Mode
    state.APP_MODE = "pushoff";
    if (modeToggleCheckbox) {
      modeToggleCheckbox.checked = true;
    }
  }

  // UI basierend auf App-Mode aktualisieren
  const updateAppModeDisplay = window.updateAppModeDisplay;
  if (updateAppModeDisplay) {
    updateAppModeDisplay(state.APP_MODE === "pushoff");
  }

  // Show UI elements after file load and apply visibility rules
  const appMode = state.APP_MODE === "pushoff" ? 'PUSHOFF' : 'SWAP';
  showUIAfterFileLoad(appMode, mode);

  const isX1P1 = (mode === 'X1' || mode === 'P1');
  const shouldShowSettings = isX1P1 || ((mode === 'A1' || mode === 'A1M') && state.APP_MODE === 'pushoff');

  const mo = document.getElementById('mode_options');
  const xset = document.getElementById('x1p1-settings');

  if (mo) mo.classList.toggle('hidden', !isX1P1);
  if (xset) xset.classList.toggle('hidden', !shouldShowSettings);

  if (isX1P1) {
    const sel = document.getElementById('object-count');
    renderCoordInputs(parseInt((sel && sel.value) ? sel.value : "1", 10));
  }

  // Per-plate X1/P1-Sektionen zeigen/verstecken
  document.querySelectorAll('.plate-x1p1-settings').forEach(el => {
    el.classList.toggle('hidden', !shouldShowSettings);
  });

  // Set default bed raise offset based on printer mode
  const bedRaiseInput = document.getElementById('raisebed_offset_mm');
  if (bedRaiseInput && shouldShowSettings) {
    const currentValue = parseInt(bedRaiseInput.value);
    const isA1Mode = (mode === 'A1' || mode === 'A1M');
    const expectedDefault = isA1Mode ? 40 : 30;
    
    // Only change if current value matches the opposite default (to avoid overriding user changes)
    const oppositeDefault = isA1Mode ? 30 : 40;
    if (currentValue === oppositeDefault || bedRaiseInput.value === '') {
      bedRaiseInput.value = expectedDefault;
      console.log(`[Mode Switch] Updated bed raise offset to ${expectedDefault}mm for ${mode}`);
    }
  }

  // Set default additional push off levels based on printer mode
  const pushOffLevelsInput = document.getElementById('extra_pushoff_levels');
  if (pushOffLevelsInput && shouldShowSettings) {
    const currentValue = parseInt(pushOffLevelsInput.value);
    const isA1Mode = (mode === 'A1' || mode === 'A1M');
    const expectedDefault = isA1Mode ? 6 : 2;
    
    // Only change if current value matches the opposite default (to avoid overriding user changes)
    const oppositeDefault = isA1Mode ? 2 : 6;
    if (currentValue === oppositeDefault || pushOffLevelsInput.value === '') {
      pushOffLevelsInput.value = expectedDefault;
      console.log(`[Mode Switch] Updated additional push off levels to ${expectedDefault} for ${mode}`);
    }
  }

  // Hide/show "Raise Bed Level for cooling" option based on printer mode
  const bedlevelCoolingContainer = document.getElementById('bedlevel_cooling_container');
  if (bedlevelCoolingContainer) {
    // Only show for X1/P1 printers
    const shouldShowBedlevelCooling = isX1P1;
    bedlevelCoolingContainer.classList.toggle('hidden', !shouldShowBedlevelCooling);
    console.log(`[Mode Switch] Bedlevel cooling option ${shouldShowBedlevelCooling ? 'shown' : 'hidden'} for ${mode}`);
  }

  // Update printer model info display
  updatePrinterModelDisplay(mode);

  // Update settings visibility based on new mode
  updateSettingsVisibilityForMode();

  // Update filename preview when mode changes
  if (window.updateFilenamePreview) {
    window.updateFilenamePreview();
  }

  console.log("Mode switched to:", mode, "App mode:", state.APP_MODE);
}

function updatePrinterModelDisplay(mode) {
  const printerModelElement = document.getElementById("current_printer_model");
  if (printerModelElement) {
    printerModelElement.textContent = getDisplayNameForMode(mode);
  }
}

export function ensureModeOrReject(detectedMode, fileName) {
  if (detectedMode === "UNSUPPORTED" || !detectedMode) {
    showError(`This printer model is not supported yet in this app (file: ${fileName}).`);
    return false;
  }

  if (state.CURRENT_MODE == null) {
    setMode(detectedMode);
    return true;
  }

  if (state.CURRENT_MODE !== detectedMode) {
    showWarning(
      `Printer mismatch. Loaded queue is ${state.CURRENT_MODE}, new file is ${detectedMode}. ` +
      `The new plate will not be added.`
    );
    return false;
  }
  return true;
}

export function applyPrinterMode(fileName) {
  // Extract from the filename, mapping to modes
  let printerType;
  let printerMode;
  let modelInfo = {
    printer: null,
    name: fileName
  };

  console.log("Analyzing filename for printer model:", fileName);

  // Define patterns to detect printer model
  const patterns = [
    { regex: /X1C/i, model: "Bambu Lab X1 Carbon" },
    { regex: /X1E/i, model: "Bambu Lab X1E" },
    { regex: /X1[^CE]/i, model: "Bambu Lab X1" },
    { regex: /A1M|A1_mini/i, model: "Bambu Lab A1 mini" },
    { regex: /A1(?!M|_mini)/i, model: "Bambu Lab A1" },
    { regex: /P1S/i, model: "Bambu Lab P1S" },
    { regex: /P1P/i, model: "Bambu Lab P1P" },
  ];

  // Try to detect model from filename
  for (const pattern of patterns) {
    if (pattern.regex.test(fileName)) {
      modelInfo.printer = pattern.model;
      break;
    }
  }

  if (!modelInfo.printer) {
    showError(`This printer model is not supported yet in this app (file: ${fileName}).`);
    return null;
  }

  // Convert model to internal mode
  printerMode = modeFromPrinterModel(modelInfo.printer);
  
  if (!printerMode) {
    showWarning(
      `This printer model (${modelInfo.printer}) is not yet fully supported. ` +
      `Supported models: Bambu Lab A1 Mini (SWAP mode), Bambu Lab X1 series (automated routines), ` +
      `Bambu Lab P1 series (automated routines). Your file: ${fileName}`
    );
    return null;
  }

  return {
    mode: printerMode,
    modelInfo
  };
}