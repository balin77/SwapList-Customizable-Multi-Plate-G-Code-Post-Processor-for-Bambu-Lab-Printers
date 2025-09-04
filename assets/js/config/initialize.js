// /src/config/initialize.js

import { DEV_MODE } from "../index.js";
import { state } from "./state.js";
import { getSecurePushOffEnabled } from "../ui/settings.js";
import { removePlate, duplicatePlate } from "../ui/plates.js";
import { update_progress } from "../ui/progressbar.js";
import { update_statistics } from "../ui/statistics.js";
import { dragOutHandler, dragOverHandler, dropHandler } from "../ui/dropzone.js";
import { handleFile } from "../io/read3mf.js";
import { export_3mf } from "../io/export3mf.js";
import { export_gcode_txt } from "../io/exportGcode.js";
import { toggle_settings, custom_file_name, adj_field_length, show_settings_when_plates_loaded } from "../ui/settings.js";
import { compareProjectSettingsFiles } from "../utils/utils.js";

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

  //buttons
  document.getElementById("export")?.addEventListener("click", export_3mf);
  document.getElementById("export_gcode")?.addEventListener("click", export_gcode_txt);
  document.getElementById("reset")?.addEventListener("click", () => location.reload());

  // Dev Mode: Show/Hide compare buttons based on DEV_MODE
  const btnCmp = document.getElementById("btn_compare_settings");
  const btnCmpGcode = document.getElementById("btn_compare_gcode");
  const compareGcodeHelp = document.getElementById("compare_gcode_help");
  
  if (btnCmp) {
    if (DEV_MODE) {
      btnCmp.style.display = "block";
      btnCmp.classList.remove("hidden");
      
      btnCmp.addEventListener("click", async () => {
        const origLabel = btnCmp.textContent;
        btnCmp.disabled = true;
        btnCmp.textContent = "Comparing…";
        try {
          const result = await compareProjectSettingsFiles(); // loggt selbst in die Konsole
          console.log("[compareProjectSettingsFiles] finished", result);
          alert("Vergleich abgeschlossen. Details stehen in der Konsole.");
        } catch (err) {
          console.error("Fehler beim Vergleich:", err);
          alert("Vergleich fehlgeschlagen: " + (err?.message || err));
        } finally {
          btnCmp.disabled = false;
          btnCmp.textContent = origLabel;
        }
      });

      // Optional: für manuelles Triggern über die DevTools
      window.compareProjectSettingsFiles = compareProjectSettingsFiles;
    } else {
      btnCmp.style.display = "none";
      btnCmp.classList.add("hidden");
    }
  }
  
  if (btnCmpGcode) {
    if (DEV_MODE) {
      btnCmpGcode.style.display = "block";
      btnCmpGcode.classList.remove("hidden");
      
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
          alert(`GCODE comparison complete. Found ${differences} differences. Check console for details.`);
        } catch (err) {
          console.error("Error comparing GCODE files:", err);
          alert("GCODE comparison failed: " + (err?.message || err));
        } finally {
          btnCmpGcode.disabled = false;
          btnCmpGcode.textContent = origLabel;
        }
      });
    } else {
      btnCmpGcode.style.display = "none";
      btnCmpGcode.classList.add("hidden");
    }
  }
  
  if (compareGcodeHelp) {
    if (DEV_MODE) {
      compareGcodeHelp.style.display = "block";
      compareGcodeHelp.classList.remove("hidden");
    } else {
      compareGcodeHelp.style.display = "none";
      compareGcodeHelp.classList.add("hidden");
    }
  }


  // mode toggle listeners
  var mA1 = document.getElementById('mode_a1m');
  var mX1 = document.getElementById('mode_x1');
  var mP1 = document.getElementById('mode_p1');
  if (mA1 && mX1 && mP1) {
    // Deaktivieren: nur noch per detect → setMode()
    mA1.disabled = true;
    mX1.disabled = true;
    mP1.disabled = true;

    // Optional: Tooltip
    mA1.title = mX1.title = mP1.title = "Printer mode is set automatically from the loaded file(s).";

  }
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
    loopsInput.addEventListener("change", update_statistics);
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
  const lvlInp = document.getElementById("extra_pushoff_levels");
  const lvlLbl = document.getElementById("extra_pushoff_levels_label");
  const lvlHelp = document.getElementById("extra_pushoff_levels_help");

  function reflectSecureUI() {
    const on = getSecurePushOffEnabled();
    if (lvlInp) lvlInp.disabled = !on;
    if (lvlLbl) lvlLbl.style.opacity = on ? "1" : "0.5";
    if (lvlHelp) lvlHelp.style.display = on ? "" : "none";
  }
  if (chkSec) {
    chkSec.addEventListener("change", reflectSecureUI);
    reflectSecureUI(); // initial
  }

  const tpl = document.getElementById("list_item_prototype");
  state.li_prototype = tpl?.content?.firstElementChild || null;
  state.fileInput = document.getElementById("file");
  state.playlist_ol = document.getElementById("playlist_ol");
  state.err = document.getElementById("err");
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