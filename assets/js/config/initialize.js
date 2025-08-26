// /src/config/initialize.js

import { state } from "./state.js";
import { getSecurePushOffEnabled } from "../ui/settings.js";
import { removePlate, duplicatePlate } from "../ui/plates.js";
import { update_progress } from "../ui/progressbar.js";
import { update_statistics } from "../ui/statistics.js";
import { dragOutHandler, dragOverHandler, dropHandler } from "../ui/dropzone.js";
import { handleFile } from "../io/read3mf.js";
import { export_3mf } from "../io/export3mf.js";
import { export_gcode_txt } from "../io/exportGcode.js";
import { toggle_settings, custom_file_name, adj_field_length } from "../ui/settings.js";

import {
  deriveGlobalSlotColorsFromPlates,
  renderTotalsColors,
  installFilamentTotalsAutoFix,
  syncPlateFilamentSwatches,
  openSlotDropdown,
  getSlotColor,
  setGlobalSlotColor,
  repaintPlateFromStats
} from "../ui/filamentColors.js";

export function initialize_page() {

  //buttons
  document.getElementById("export")?.addEventListener("click", export_3mf);
  document.getElementById("export_gcode")?.addEventListener("click", export_gcode_txt);
  document.getElementById("reset")?.addEventListener("click", () => location.reload());
  document.getElementById("show_settings")?.addEventListener("change", e => toggle_settings(e.target.checked));

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

  // Farben im „Filament usage statistics“-Block initial rendern
  renderTotalsColors();
  installFilamentTotalsAutoFix();
  deriveGlobalSlotColorsFromPlates();

  // Klick auf die Swatches im Statistik-Block => globalen Slot-Farbpicker öffnen
  document.getElementById("filament_total")?.addEventListener("click", (e) => {
    const sw = e.target.closest(".f_color");
    if (!sw) return;
    const idx = +(sw.dataset.slotIndex || 0);
    const inp = document.createElement("input");
    inp.type = "color";
    inp.value = sw.dataset.f_color || getSlotColor(idx);
    inp.onchange = () => setGlobalSlotColor(idx, inp.value);  // setzt Override + rendert neu
    inp.click();
  });

  document.getElementById("show_settings")?.addEventListener("change", e => {
    toggle_settings(e.target.checked);
    // falls das Panel erst jetzt sichtbar wird → sicherheitshalber rendern
    renderTotalsColors();
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
            syncPlateFilamentSwatches(n);
            deriveGlobalSlotColorsFromPlates(); // Stats-Farben aktualisieren
            repaintPlateFromStats(n);             // dann Plate-Swatches aus Statistikfarbe malen
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
  const drop_zone_instant = document.getElementById("drop_zone_instant");

  ['dragend', 'dragleave', 'drop'].forEach(evt => {
    drop_zone.addEventListener(evt, dragOutHandler);
    drop_zone_instant.addEventListener(evt, dragOutHandler);
  });

  drop_zone.addEventListener("dragover", (e) => dragOverHandler(e, e.target));
  [...drop_zone.children].forEach(child => {
    child.addEventListener("dragover", (e) => dragOverHandler(e, e.target.parentElement));
  });

  drop_zone_instant.addEventListener("dragover", (e) => dragOverHandler(e, e.target));
  [...drop_zone_instant.children].forEach(child => {
    child.addEventListener("dragover", (e) => dragOverHandler(e, e.target.parentElement));
  });

  drop_zone_instant.addEventListener("drop", (e) => dropHandler(e, true));
  drop_zone.addEventListener("drop", (e) => dropHandler(e, false));

  drop_zone.addEventListener("click", () => {
    state.fileInput.click();
    state.instant_processing = false;
  });


  /*
  drop_zone_instant.addEventListener("click", () => {
    state.fileInput.click();
    instant_processing=true;});
  */

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