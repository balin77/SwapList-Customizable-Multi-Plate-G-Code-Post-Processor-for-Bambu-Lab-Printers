// /src/config/initialize.ts

import { state } from "./state.js";
import { setMode } from "./mode.js";
import { applyTheme, initializeCSSVariables } from "./colors.js";
import { applyInitialState } from "./uiVisibility.js";
import { getSecurePushOffEnabled } from "../ui/settings.js";
import { removePlate, duplicatePlate } from "../ui/plates.js";
import { update_progress } from "../ui/progressbar.js";
import { generateFilenameFormat } from "../io/ioUtils.js";
import { update_statistics } from "../ui/statistics.js";
import { dragOutHandler, dragOverHandler, dropHandler } from "../ui/dropzone.js";
import { handleFile } from "../io/read3mf.js";
import { export_3mf } from "../io/export3mf.js";
import { export_gcode_txt } from "../io/exportGcode.js";
import { custom_file_name, adj_field_length, show_settings_when_plates_loaded, setupDeveloperModeListeners } from "../ui/settings.js";
import { initInfobox, showWarning } from "../ui/infobox.js";
import { i18n } from "../i18n/i18n.js";

import {
  wirePlateSwatches,
  updateAllPlateSwatchColors,
  openSlotDropdown,
  renderTotalsColors,
  installFilamentTotalsAutoFix,
  deriveGlobalSlotColorsFromPlates,
  openStatsSlotDialog
} from "../ui/filamentColors.js";

import type { SwapMode } from "../types/index.js";

/**
 * Main page initialization function
 * Sets up all event listeners, UI components, and application state
 */
export async function initialize_page(): Promise<void> {

  // Initialize i18n (detect and load user's preferred language)
  const preferredLocale = i18n.detectPreferredLocale();
  await i18n.loadLocale(preferredLocale);
  i18n.translatePage();

  // Initialize CSS variables from JavaScript config
  initializeCSSVariables();

  // Apply initial UI state (hide everything until files are loaded)
  applyInitialState();

  // Initialize infobox
  initInfobox();

  // Language selector
  const languageSelect = document.getElementById("language_select") as HTMLSelectElement | null;
  if (languageSelect) {
    // Populate language options dynamically
    languageSelect.innerHTML = '';
    const supportedLocales = i18n.getSupportedLocales();
    supportedLocales.forEach(locale => {
      const option = document.createElement('option');
      option.value = locale;
      option.textContent = i18n.t(`languages.${locale}`);
      languageSelect.appendChild(option);
    });

    // Set initial value
    languageSelect.value = i18n.getCurrentLocale();

    languageSelect.addEventListener("change", async (e) => {
      const target = e.target as HTMLSelectElement;
      const newLocale = target.value as any; // Cast to any to avoid strict locale type checking
      await i18n.setLocale(newLocale);
      i18n.translatePage();
      // Update dynamic content that was generated with JavaScript
      update_statistics();
      updateFilenamePreview();
      console.log("Language changed to:", newLocale);
    });
  }

  // Export i18n globally so other modules can use it
  window.i18nInstance = i18n;

  //buttons
  document.getElementById("export")?.addEventListener("click", export_3mf);
  document.getElementById("export_gcode")?.addEventListener("click", export_gcode_txt);
  document.getElementById("reset")?.addEventListener("click", () => location.reload());



  // Printer model info is now displayed automatically via setMode() function
  // Purge-Checkbox
  const chkPurge = document.getElementById('opt_purge') as HTMLInputElement | null;
  if (chkPurge) {
    chkPurge.addEventListener('change', () => {
      state.USE_PURGE_START = chkPurge.checked;
      console.log("USE_PURGE_START:", state.USE_PURGE_START);
    });
    state.USE_PURGE_START = chkPurge.checked;
  }

  // Cooling-Bedlevel Checkbox
  const chkCool = document.getElementById('opt_bedlevel_cooling') as HTMLInputElement | null;
  if (chkCool) {
    chkCool.addEventListener('change', () => {
      state.USE_BEDLEVEL_COOLING = chkCool.checked;
      console.log("USE_BEDLEVEL_COOLING:", state.USE_BEDLEVEL_COOLING);
    });
    state.USE_BEDLEVEL_COOLING = chkCool.checked; // initial übernehmen (default false)
  }

  // Custom file name
  const fileNameInput = document.getElementById("file_name") as HTMLInputElement | null;
  if (fileNameInput) {
    fileNameInput.addEventListener("click", () => custom_file_name(fileNameInput));

    const resizeHandler = () => adj_field_length(fileNameInput, 5, 26);
    ["keyup", "keypress", "input"].forEach(evt =>
      fileNameInput.addEventListener(evt, resizeHandler)
    );

    // initial
    resizeHandler();
  }

  // Override-Checkbox
  const chkOverride = document.getElementById("opt_override_metadata") as HTMLInputElement | null;
  if (chkOverride) {
    state.OVERRIDE_METADATA = !!chkOverride.checked;
    chkOverride.addEventListener("change", () => {
      state.OVERRIDE_METADATA = !!chkOverride.checked;
      console.log("OVERRIDE_METADATA:", state.OVERRIDE_METADATA);
    });
  }

  // Test file export checkbox - show/hide wait time input
  const chkTestFile = document.getElementById("opt_test_file_export") as HTMLInputElement | null;
  const waitTimeContainer = document.getElementById("test_wait_time_container");
  if (chkTestFile && waitTimeContainer) {
    function toggleWaitTimeVisibility() {
      if (waitTimeContainer && chkTestFile) {
        waitTimeContainer.style.display = chkTestFile.checked ? "block" : "none";
      }
    }
    chkTestFile.addEventListener("change", toggleWaitTimeVisibility);
    toggleWaitTimeVisibility(); // Set initial state
  }

  // Developer mode - setup listeners and initial visibility
  setupDeveloperModeListeners();

  // App Mode Toggle (Swap Mode / Push Off Mode)
  const modeToggleCheckbox = document.getElementById("mode_toggle_checkbox") as HTMLInputElement | null;
  const logoJobox = document.getElementById("logo_jobox");
  const logo3print = document.getElementById("logo_3print");
  const logoPrintflow = document.getElementById("logo_printflow");

  // State to track which logo is selected in swap mode
  let selectedSwapLogo: SwapMode = 'jobox'; // 'jobox' | '3print' | 'printflow'

  function updateSwapModeLogos() {
    if (logoJobox && logo3print && logoPrintflow) {
      // Reset all logos to inactive
      [logoJobox, logo3print, logoPrintflow].forEach(logo => {
        logo.classList.remove('active');
        logo.classList.add('inactive');
      });

      // Activate selected logo
      if (selectedSwapLogo === 'jobox') {
        logoJobox.classList.remove('inactive');
        logoJobox.classList.add('active');
      } else if (selectedSwapLogo === '3print') {
        logo3print.classList.remove('inactive');
        logo3print.classList.add('active');
      } else if (selectedSwapLogo === 'printflow') {
        logoPrintflow.classList.remove('inactive');
        logoPrintflow.classList.add('active');
      }
    }
  }

  // Logo click handlers for swap mode
  if (logoJobox) {
    logoJobox.addEventListener('click', () => {
      if (selectedSwapLogo !== 'jobox') {
        selectedSwapLogo = 'jobox';
        state.SWAP_MODE = 'jobox';
        updateSwapModeLogos();
        updateFilenamePreview();
        // Apply Jobox blue theme
        applyTheme('JOBOX');
        console.log('Selected Jobox logo and applied blue theme');
      }
    });
  }

  if (logo3print) {
    logo3print.addEventListener('click', () => {
      if (selectedSwapLogo !== '3print') {
        selectedSwapLogo = '3print';
        state.SWAP_MODE = '3print';
        updateSwapModeLogos();
        updateFilenamePreview();
        // Apply appropriate theme based on current device mode
        if (state.PRINTER_MODEL === 'A1') {
          applyTheme('A1_SWAP'); // Gray theme for A1
        } else {
          applyTheme('A1M_SWAP'); // Yellow theme for A1M
        }
        console.log('Selected 3Print logo and applied appropriate theme for', state.PRINTER_MODEL);
      }
    });
  }

  if (logoPrintflow) {
    logoPrintflow.addEventListener('click', () => {
      if (selectedSwapLogo !== 'printflow') {
        selectedSwapLogo = 'printflow';
        state.SWAP_MODE = 'printflow';
        updateSwapModeLogos();
        updateFilenamePreview();
        // Apply Printflow blue theme
        applyTheme('PRINTFLOW');
        console.log('Selected PrintFlow logo and applied blue theme');
      }
    });
  }

  async function updateAppModeDisplay(isPushOffMode: boolean): Promise<void> {
    const appMode = isPushOffMode ? 'PUSHOFF' : 'SWAP';

    // Apply centralized visibility rules
    const applyVisibilityRulesImport = await import("./uiVisibility.js");
    applyVisibilityRulesImport.applyVisibilityRules(appMode, state.PRINTER_MODEL);

    // Apply themes - the theme system handles body classes automatically
    if (isPushOffMode) {
      applyTheme('PUSHOFF');
    } else {
      // Swap Mode: Apply appropriate theme based on device and selected logo
      if (state.PRINTER_MODEL === 'A1') {
        updateSwapModeLogos(); // Update Jobox/3Print/Printflow logo states
        if (state.SWAP_MODE === 'printflow') {
          applyTheme('PRINTFLOW');
        } else if (state.SWAP_MODE === 'jobox') {
          applyTheme('JOBOX');
        } else {
          applyTheme('A1_SWAP'); // For 3Print
        }
      } else {
        applyTheme('A1M_SWAP');
      }
    }

    // Note: Body classes are now managed by the theme system in applyTheme()
  }

  // Function to update filename extension preview
  function updateFilenamePreview(): void {
    const extensionElement = document.getElementById("filename_extension_preview");
    if (!extensionElement) return;

    // Generate filename format (without basename) and add space prefix
    const extension = " ." + generateFilenameFormat("", false).substring(1); // Remove leading dot, add space

    extensionElement.textContent = extension;
  }

  // Make functions globally available
  window.updateAppModeDisplay = updateAppModeDisplay;
  window.updateFilenamePreview = updateFilenamePreview;

  if (modeToggleCheckbox) {
    // Initial state - default to push off mode (but don't update UI yet)
    state.APP_MODE = "pushoff";
    modeToggleCheckbox.checked = true; // Push Off Mode aktivieren
    // Don't call updateAppModeDisplay yet - wait for files to be loaded

    modeToggleCheckbox.addEventListener("change", () => {
      const isPushOffMode = modeToggleCheckbox.checked;

      // Prüfen ob SWAP Mode für aktuellen Drucker erlaubt ist
      if (!isPushOffMode && state.PRINTER_MODEL && state.PRINTER_MODEL !== 'A1M' && state.PRINTER_MODEL !== 'A1') {
        // SWAP Mode nur für A1M und A1 erlaubt - Toggle zurücksetzen und Fehlermeldung
        modeToggleCheckbox.checked = true; // Zurück zu Push Off Mode
        showWarning("SWAP Mode is only available for A1 Mini and A1 printers. For other printers, please use Push Off Mode.");
        return;
      }

      state.APP_MODE = isPushOffMode ? "pushoff" : "swap";
      updateAppModeDisplay(isPushOffMode);
      updateFilenamePreview();
      // Update printer mode UI to refresh settings visibility
      setMode(state.PRINTER_MODEL);
      console.log("APP_MODE changed to:", state.APP_MODE);
      console.log("Body classes:", document.body.className);
      console.log("Push off mode active:", isPushOffMode);
    });
  }

  // Farben im „Filament usage statistics"-Block initial rendern
  renderTotalsColors();
  installFilamentTotalsAutoFix();
  deriveGlobalSlotColorsFromPlates();

  // Klick auf die Swatches im Statistik-Block => globalen Slot-Farbpicker öffnen
  document.getElementById("filament_total")?.addEventListener("click", (e) => {
    const target = e.target as HTMLElement;
    const sw = target.closest(".f_color") as HTMLElement | null;
    if (!sw) return;

    const idx = +(sw.dataset['slotIndex'] || 0); // 0..3
    openStatsSlotDialog(idx);
  });


  // Delegation: Klick auf Plate-Swatch → Slot zyklisch durchschalten (1..4)
  document.body.addEventListener("click", e => {
    const target = e.target as HTMLElement;
    const sw = target.closest(".p_filaments .f_color") as HTMLElement | null;
    if (!sw) return;
    openSlotDropdown(sw);
  });

  // Neue Platten im Playlist-DOM erkennen und deren Swatches synchronisieren
  const playlistEl = document.getElementById("playlist_ol");
  if (playlistEl) {
    const obs = new MutationObserver(muts => {
      for (const m of muts) {
        m.addedNodes?.forEach(n => {
          if (n.nodeType === 1 && (n as Element).matches?.("li.list_item")) {
            wirePlateSwatches(n as HTMLElement);
            deriveGlobalSlotColorsFromPlates(); // Stats-Farben aktualisieren
            updateAllPlateSwatchColors();             // dann Plate-Swatches aus Statistikfarbe malen
            show_settings_when_plates_loaded(); // Settings anzeigen wenn Plates geladen sind
          }
        });
      }
    });
    obs.observe(playlistEl, { childList: true, subtree: true });
  }

  // Loop repeats
  const loopsInput = document.getElementById("loops") as HTMLInputElement | null;
  if (loopsInput) {
    loopsInput.addEventListener("change", () => {
      update_statistics();
      updateFilenamePreview();
    });
  }

  // Plate removal
  document.body.addEventListener("click", e => {
    const target = e.target as HTMLElement;
    if (target.classList.contains("plate-remove")) {
      removePlate(target);
      deriveGlobalSlotColorsFromPlates();
      show_settings_when_plates_loaded(); // Settings verstecken wenn keine Plates mehr da sind
    }
  });

  // Plate repeat change
  document.body.addEventListener("change", e => {
    const target = e.target as HTMLElement;
    if (target.classList.contains("p_rep")) {
      update_statistics();
      deriveGlobalSlotColorsFromPlates();
    }
  });

  // Delegation: funktioniert auch in duplizierten Plates
  document.body.addEventListener("click", (e) => {
    const target = e.target as HTMLElement;
    const btn = target.closest(".plate-duplicate");
    if (!btn) return;
    e.preventDefault();
    const li = btn.closest("li.list_item") as HTMLElement | null;
    if (li) duplicatePlate(li);
  });

  // Secure push-off UI wiring
  const chkSec = document.getElementById("opt_secure_pushoff") as HTMLInputElement | null;
  const extraPushoffContainer = document.getElementById("extra_pushoff_container");

  function reflectSecureUI() {
    const on = getSecurePushOffEnabled();
    if (extraPushoffContainer) {
      extraPushoffContainer.style.display = on ? "block" : "none";
    }
  }
  if (chkSec) {
    chkSec.addEventListener("change", reflectSecureUI);
    reflectSecureUI(); // initial
  }

  const tpl = document.getElementById("list_item_prototype") as HTMLTemplateElement | null;
  state.li_prototype = (tpl?.content?.firstElementChild as HTMLElement) || null;
  state.fileInput = document.getElementById("file") as HTMLInputElement | null;
  state.playlist_ol = document.getElementById("playlist_ol") as HTMLElement | null;
  state.p_scale = document.getElementById("progress_scale") as HTMLElement | null;

  update_progress(-1);

  const drop_zone = document.getElementById("drop_zone")!;

  ['dragend', 'dragleave', 'drop'].forEach(evt => {
    drop_zone.addEventListener(evt, (e) => dragOutHandler(e as DragEvent));
  });

  drop_zone.addEventListener("dragover", (e) => {
    dragOverHandler(e as DragEvent, e.target as HTMLElement);
  });
  Array.from(drop_zone.children).forEach(child => {
    child.addEventListener("dragover", (e) => {
      dragOverHandler(e as DragEvent, (e.target as HTMLElement).parentElement!);
    });
  });

  drop_zone.addEventListener("drop", (e) => dropHandler(e as DragEvent, false));

  drop_zone.addEventListener("click", () => {
    state.fileInput?.click();
  });

  state.fileInput?.addEventListener("change", function (evt) {
    const target = evt.target as HTMLInputElement;
    const files = target.files;
    console.log("FILES:");
    console.log(files);

    if (files) {
      for (let i = 0; i < files.length; i++) {
        if ((i + 1) == files.length) state.last_file = true;
        else state.last_file = false;
        const file = files[i];
        if (file) {
          handleFile(file);
        }
      }
    }
    console.log("FILES processing done...");
  });
}
