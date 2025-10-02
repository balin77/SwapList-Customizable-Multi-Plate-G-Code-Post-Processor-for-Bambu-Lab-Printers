// /src/config/initialize.js

import { DEV_MODE } from "../index.js";
import { state } from "./state.js";
import { setMode } from "./mode.js";
import { applyTheme, THEMES, initializeCSSVariables } from "./colors.js";
import { applyVisibilityRules, UI_ELEMENTS, applyInitialState } from "./uiVisibility.js";
import { getSecurePushOffEnabled } from "../ui/settings.js";
import { removePlate, duplicatePlate } from "../ui/plates.js";
import { update_progress } from "../ui/progressbar.js";
import { generateFilenameFormat } from "../io/ioUtils.js";
import { update_statistics } from "../ui/statistics.js";
import { dragOutHandler, dragOverHandler, dropHandler } from "../ui/dropzone.js";
import { handleFile } from "../io/read3mf.js";
import { export_3mf } from "../io/export3mf.js";
import { export_gcode_txt } from "../io/exportGcode.js";
import { toggle_settings, custom_file_name, adj_field_length, show_settings_when_plates_loaded } from "../ui/settings.js";
import { compareProjectSettingsFiles, compareTemplateModifiedFiles } from "../utils/utils.js";
import { initInfobox, showError, showWarning, showInfo, showSuccess } from "../ui/infobox.js";

import {
  wirePlateSwatches,
  updateAllPlateSwatchColors,
  openSlotDropdown,
  renderTotalsColors,
  installFilamentTotalsAutoFix,
  deriveGlobalSlotColorsFromPlates,
  openStatsSlotDialog
} from "../ui/filamentColors.js";

export function initialize_page() {

  // Initialize CSS variables from JavaScript config
  initializeCSSVariables();

  // Apply initial UI state (hide everything until files are loaded)
  applyInitialState();

  // Initialize infobox
  initInfobox();

  //buttons
  document.getElementById("export")?.addEventListener("click", export_3mf);
  document.getElementById("export_gcode")?.addEventListener("click", export_gcode_txt);
  document.getElementById("reset")?.addEventListener("click", () => location.reload());

  // Dev Mode: Show/Hide dev controls container based on DEV_MODE
  const devControlsContainer = document.getElementById("dev_controls_container");
  const btnCmp = document.getElementById("btn_compare_settings");
  const btnCmpTemplateModified = document.getElementById("btn_compare_template_modified");
  const btnCmpGcode = document.getElementById("btn_compare_gcode");

  if (devControlsContainer) {
    if (DEV_MODE) {
      devControlsContainer.style.display = "block";
      devControlsContainer.classList.remove("hidden");
    } else {
      devControlsContainer.style.display = "none";
      devControlsContainer.classList.add("hidden");
    }
  }

  if (btnCmp && DEV_MODE) {
    btnCmp.addEventListener("click", async () => {
      const origLabel = btnCmp.textContent;
      btnCmp.disabled = true;
      btnCmp.textContent = "Comparing…";
      try {
        const result = await compareProjectSettingsFiles(); // loggt selbst in die Konsole
        console.log("[compareProjectSettingsFiles] finished", result);
        showInfo("Vergleich abgeschlossen. Details stehen in der Konsole.");
      } catch (err) {
        console.error("Fehler beim Vergleich:", err);
        showError("Vergleich fehlgeschlagen: " + (err?.message || err));
      } finally {
        btnCmp.disabled = false;
        btnCmp.textContent = origLabel;
      }
    });

    // Optional: für manuelles Triggern über die DevTools
    window.compareProjectSettingsFiles = compareProjectSettingsFiles;
  }

  if (btnCmpTemplateModified && DEV_MODE) {
    btnCmpTemplateModified.addEventListener("click", async () => {
      const origLabel = btnCmpTemplateModified.textContent;
      btnCmpTemplateModified.disabled = true;
      btnCmpTemplateModified.textContent = "Comparing…";
      try {
        const result = await compareTemplateModifiedFiles(); // loggt selbst in die Konsole
        console.log("[compareTemplateModifiedFiles] finished", result);
        showInfo("Template vs Modified Vergleich abgeschlossen. Details stehen in der Konsole.");
      } catch (err) {
        console.error("Fehler beim Template vs Modified Vergleich:", err);
        showError("Template vs Modified Vergleich fehlgeschlagen: " + (err?.message || err));
      } finally {
        btnCmpTemplateModified.disabled = false;
        btnCmpTemplateModified.textContent = origLabel;
      }
    });

    // Optional: für manuelles Triggern über die DevTools
    window.compareTemplateModifiedFiles = compareTemplateModifiedFiles;
  }

  if (btnCmpGcode && DEV_MODE) {
    btnCmpGcode.addEventListener("click", async () => {
      const origLabel = btnCmpGcode.textContent;
      btnCmpGcode.disabled = true;
      btnCmpGcode.textContent = "Comparing…";
      try {
        // Import GCODE test files directly as modules
        const gcode1Module = await import('../testfiles/gcode1.gcode');
        const gcode2Module = await import('../testfiles/gcode2.gcode');

        const file1Content = gcode1Module.default;
        const file2Content = gcode2Module.default;

        console.log("[GCODE Compare] File 1 size:", file1Content.length, "chars");
        console.log("[GCODE Compare] File 2 size:", file2Content.length, "chars");

        // Simple line-by-line comparison
        const lines1 = file1Content.split('\n');
        const lines2 = file2Content.split('\n');

        let differences = 0;
        const maxLines = Math.max(lines1.length, lines2.length);

        console.log("[GCODE Compare] Lines in file 1:", lines1.length);
        console.log("[GCODE Compare] Lines in file 2:", lines2.length);

        for (let i = 0; i < maxLines; i++) {
          const line1 = lines1[i] || '';
          const line2 = lines2[i] || '';

          if (line1 !== line2) {
            differences++;
            if (differences <= 300) { // Only log first 300 differences
              console.log(`[GCODE Compare] Diff at line ${i+1}:`);
              console.log(`  File 1: "${line1}"`);
              console.log(`  File 2: "${line2}"`);
            }
          }
        }

        console.log(`[GCODE Compare] Total differences: ${differences}`);
        showInfo(`GCODE comparison complete. Found ${differences} differences. Check console for details.`);
      } catch (err) {
        console.error("Error comparing GCODE files:", err);
        showError("GCODE comparison failed: " + (err?.message || err));
      } finally {
        btnCmpGcode.disabled = false;
        btnCmpGcode.textContent = origLabel;
      }
    });
  }


  // Printer model info is now displayed automatically via setMode() function
  // Purge-Checkbox
  var chkPurge = document.getElementById('opt_purge');
  if (chkPurge) {
    chkPurge.addEventListener('change', () => {
      state.USE_PURGE_START = chkPurge.checked;
      console.log("USE_PURGE_START:", state.USE_PURGE_START);
    });
    state.USE_PURGE_START = chkPurge.checked;
  }

  // Cooling-Bedlevel Checkbox
  var chkCool = document.getElementById('opt_bedlevel_cooling');
  if (chkCool) {
    chkCool.addEventListener('change', () => {
      state.USE_BEDLEVEL_COOLING = chkCool.checked;
      console.log("USE_BEDLEVEL_COOLING:", state.USE_BEDLEVEL_COOLING);
    });
    state.USE_BEDLEVEL_COOLING = chkCool.checked; // initial übernehmen (default false)
  }

  // Custom file name
  const fileNameInput = document.getElementById("file_name");
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
  const chkOverride = document.getElementById("opt_override_metadata");
  if (chkOverride) {
    state.OVERRIDE_METADATA = !!chkOverride.checked;
    chkOverride.addEventListener("change", () => {
      state.OVERRIDE_METADATA = !!chkOverride.checked;
      console.log("OVERRIDE_METADATA:", state.OVERRIDE_METADATA);
    });
  }

  // Test file export checkbox - show/hide wait time input
  const chkTestFile = document.getElementById("opt_test_file_export");
  const waitTimeContainer = document.getElementById("test_wait_time_container");
  if (chkTestFile && waitTimeContainer) {
    function toggleWaitTimeVisibility() {
      waitTimeContainer.style.display = chkTestFile.checked ? "block" : "none";
    }
    chkTestFile.addEventListener("change", toggleWaitTimeVisibility);
    toggleWaitTimeVisibility(); // Set initial state
  }

  // App Mode Toggle (Swap Mode / Push Off Mode)
  const modeToggleCheckbox = document.getElementById("mode_toggle_checkbox");
  const swapLogo = document.getElementById("logo");
  const pushOffLogo = document.getElementById("logo_pushoff");
  const swapModeLogos = document.getElementById("swap_mode_logos");
  const logo3print = document.getElementById("logo_3print");
  const logoPrintflow = document.getElementById("logo_printflow");

  // State to track which logo is selected in swap mode
  let selectedSwapLogo = '3print'; // '3print' or 'printflow'

  function updateSwapModeLogos() {
    if (logo3print && logoPrintflow) {
      if (selectedSwapLogo === '3print') {
        logo3print.classList.remove('inactive');
        logo3print.classList.add('active');
        logoPrintflow.classList.remove('active');
        logoPrintflow.classList.add('inactive');
      } else {
        logoPrintflow.classList.remove('inactive');
        logoPrintflow.classList.add('active');
        logo3print.classList.remove('active');
        logo3print.classList.add('inactive');
      }
    }
  }

  // Logo click handlers for swap mode
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

  function updateAppModeDisplay(isPushOffMode) {
    const appMode = isPushOffMode ? 'PUSHOFF' : 'SWAP';

    // Apply centralized visibility rules
    applyVisibilityRules(appMode, state.PRINTER_MODEL);

    // Apply themes - the theme system handles body classes automatically
    if (isPushOffMode) {
      applyTheme('PUSHOFF');
    } else {
      // Swap Mode: Apply appropriate theme based on device and selected logo
      if (state.PRINTER_MODEL === 'A1') {
        updateSwapModeLogos(); // Update 3Print/Printflow logo states
        if (state.SWAP_MODE === 'printflow') {
          applyTheme('PRINTFLOW');
        } else {
          applyTheme('A1_SWAP');
        }
      } else {
        applyTheme('A1M_SWAP');
      }
    }

    // Note: Body classes are now managed by the theme system in applyTheme()
  }

  // Function to update filename extension preview
  function updateFilenamePreview() {
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

  // Farben im „Filament usage statistics“-Block initial rendern
  renderTotalsColors();
  installFilamentTotalsAutoFix();
  deriveGlobalSlotColorsFromPlates();

  // Klick auf die Swatches im Statistik-Block => globalen Slot-Farbpicker öffnen
  document.getElementById("filament_total")?.addEventListener("click", (e) => {
    const sw = e.target.closest(".f_color");
    if (!sw) return;

    const idx = +(sw.dataset.slotIndex || 0); // 0..3
    openStatsSlotDialog(idx);
  });


  // Delegation: Klick auf Plate-Swatch → Slot zyklisch durchschalten (1..4)
  document.body.addEventListener("click", e => {
    const sw = e.target.closest(".p_filaments .f_color");
    if (!sw) return;
    openSlotDropdown(sw);
  });

  // Neue Platten im Playlist-DOM erkennen und deren Swatches synchronisieren
  const playlistEl = document.getElementById("playlist_ol");
  if (playlistEl) {
    const obs = new MutationObserver(muts => {
      for (const m of muts) {
        m.addedNodes?.forEach(n => {
          if (n.nodeType === 1 && n.matches?.("li.list_item")) {
            wirePlateSwatches(n);
            deriveGlobalSlotColorsFromPlates(); // Stats-Farben aktualisieren
            updateAllPlateSwatchColors(n);             // dann Plate-Swatches aus Statistikfarbe malen
            show_settings_when_plates_loaded(); // Settings anzeigen wenn Plates geladen sind
          }
        });
      }
    });
    obs.observe(playlistEl, { childList: true, subtree: true });
  }

  // Loop repeats
  const loopsInput = document.getElementById("loops");
  if (loopsInput) {
    loopsInput.addEventListener("change", () => {
      update_statistics();
      updateFilenamePreview();
    });
  }

  // Plate removal
  document.body.addEventListener("click", e => {
    if (e.target.classList.contains("plate-remove")) {
      removePlate(e.target);
      deriveGlobalSlotColorsFromPlates();
      show_settings_when_plates_loaded(); // Settings verstecken wenn keine Plates mehr da sind
    }
  });

  // Plate repeat change
  document.body.addEventListener("change", e => {
    if (e.target.classList.contains("p_rep")) {
      update_statistics();
      deriveGlobalSlotColorsFromPlates();
    }
  });

  // Delegation: funktioniert auch in duplizierten Plates
  document.body.addEventListener("click", (e) => {
    const btn = e.target.closest(".plate-duplicate");
    if (!btn) return;
    e.preventDefault();
    const li = btn.closest("li.list_item");
    if (li) duplicatePlate(li);
  });

  // Secure push-off UI wiring
  const chkSec = document.getElementById("opt_secure_pushoff");
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

  const tpl = document.getElementById("list_item_prototype");
  state.li_prototype = tpl?.content?.firstElementChild || null;
  state.fileInput = document.getElementById("file");
  state.playlist_ol = document.getElementById("playlist_ol");
  state.p_scale = document.getElementById("progress_scale");

  update_progress(-1);

  const app_body = document.body;

  const drop_zone = document.getElementById("drop_zone");

  ['dragend', 'dragleave', 'drop'].forEach(evt => {
    drop_zone.addEventListener(evt, dragOutHandler);
  });

  drop_zone.addEventListener("dragover", (e) => dragOverHandler(e, e.target));
  [...drop_zone.children].forEach(child => {
    child.addEventListener("dragover", (e) => dragOverHandler(e, e.target.parentElement));
  });

  drop_zone.addEventListener("drop", (e) => dropHandler(e, false));

  drop_zone.addEventListener("click", () => {
    state.fileInput.click();
  });

  state.fileInput.addEventListener("change", function (evt) {
    var files = evt.target.files;
    console.log("FILES:");
    console.log(files);

    for (var i = 0; i < files.length; i++) {
      if ((i + 1) == files.length) state.last_file = true;
      else state.last_file = false;
      handleFile(files[i]);
    }
    console.log("FILES processing done...");
  });
}