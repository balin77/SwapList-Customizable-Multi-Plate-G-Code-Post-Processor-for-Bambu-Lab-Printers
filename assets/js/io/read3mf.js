// /src/io/read3mf.js

// /src/io/read3mf.js
import JSZip from "jszip";
import { state } from "../config/state.js";
import { parsePrinterModelFromGcode } from "../gcode/readGcode.js";
import { ensureModeOrReject } from "../config/mode.js";
import { initPlateX1P1UI, makeListSortable, installPlateButtons } from "../ui/plates.js";
import { autoPopulatePlateCoordinates } from "../utils/plateUtils.js";
import {
  wirePlateSwatches,
  updateAllPlateSwatchColors,
  deriveGlobalSlotColorsFromPlates  // Add this import
} from "../ui/filamentColors.js";
import { calculateLightingMask } from "../utils/imageColorMapping.js";
import { update_statistics } from "../ui/statistics.js";
import { export_3mf } from "./export3mf.js";
import { err00, err01 } from "../constants/errorMessages.js";
import { showError, showWarning } from "../ui/infobox.js";

// Zeigt eine Fehlermeldung an, rollt den zuletzt gepushten File zurück
// und setzt die UI zurück, falls noch keine Plate geladen wurde.
function reject_file(message) {
  const msg =
    typeof message === "string"
      ? message
      : (message && (message.message || message.toString())) || "Unknown error";

  console.warn("[read3mf] reject_file:", msg);

  // Use the modern infobox system instead of legacy error container
  showError(msg);

  // den zuletzt hinzugefügten File entfernen (wir haben ihn oben gepusht)
  if (Array.isArray(state.my_files) && state.my_files.length) {
    state.my_files.pop();
  }

  // Datei-Nameingabe zurücksetzen (optional)
  const fileNameInput = document.getElementById("file_name");
  if (fileNameInput) {
    fileNameInput.value = "";
    fileNameInput.placeholder = fileNameInput.placeholder || "output";
    // falls die Helper-Funktion im Scope ist:
    if (typeof adj_field_length === "function") {
      adj_field_length(fileNameInput, 5, 26);
    }
  }

  // Wenn noch keine Plate in der Liste ist → UI auf „leer" zurücksetzen
  const anyItem = document.querySelector("#playlist_ol li.list_item:not(.hidden)");
  if (!anyItem) {
    document.getElementById("drop_zones_wrapper")?.classList.remove("mini_drop_zone");
    document.getElementById("action_buttons")?.classList.add("hidden");
    document.getElementById("printer_model_info")?.classList.add("hidden");
    document.getElementById("statistics")?.classList.add("hidden");
    document.getElementById("controls_box")?.classList.add("hidden");
    document.getElementById("app_header")?.classList.add("compact");
    document.body.classList.add("compact-mode");
  }
}

// Hilfsfunktion: Slot aus <filament id>, sonst aus model_settings 'filament_maps'
function resolveSlotForRow(model_plates, plateIndex, filIndex, filamentNode) {
  // 1) Versuche: <filament id="...">
  const slotAttr = filamentNode?.getAttribute?.("id");
  let slot = parseInt(slotAttr, 10);
  if (Number.isFinite(slot) && slot >= 1 && slot <= 32) return slot;

  // 2) Fallback: Plate-Metadaten 'filament_maps'
  try {
    const plate = model_plates[plateIndex];
    const meta = plate?.querySelector?.("[key='filament_maps']");
    const raw = meta?.getAttribute?.("value") || "";
    // "1 4 2" -> [1,4,2]
    const parts = raw.split(/\s+/).map(n => parseInt(n, 10)).filter(n => Number.isFinite(n));
    if (parts[filIndex] && parts[filIndex] >= 1 && parts[filIndex] <= 32) {
      return parts[filIndex];
    }
  } catch (e) {
    console.debug("[resolveSlotForRow] filament_maps parse failed:", e);
  }

  // 3) Letzter Fallback: Reihenindex + 1
  return filIndex + 1;
}

function adj_field_length(trg, min, max) {
  if (trg.value == "")
    trg_val = trg.placeholder;
  else
    trg_val = trg.value;

  trg.style.width = Math.min(max, (Math.max(min, trg_val.length + 2))) + 'ch';
}

// read the content of 3mf file
export function handleFile(f) {
  var current_file_id = state.my_files.length;
  const file_name_field = document.getElementById("file_name");
  if (current_file_id == 0) {
    file_name_field.placeholder = f.name.split(".gcode.").join(".").split(".3mf")[0];
  }
  else {
    file_name_field.placeholder = "mix"
  }
  adj_field_length(file_name_field, 5, 26);
  state.my_files.push(f);

  JSZip.loadAsync(f)
    .then(async function (zip) {
      const parser = new DOMParser();
      // model_settings laden
      const model_config_file = zip.file("Metadata/model_settings.config")?.async("text");
      if (!model_config_file) {
        console.warn("[read3mf] model_settings.config fehlt.");
        reject_file(err01);
        return;
      }
      const model_config_xml = parser.parseFromString(await model_config_file, "text/xml");

      // Platten finden
      const model_plates = model_config_xml.getElementsByTagName("plate");
      if (!model_plates || model_plates.length === 0) {
        console.log("[read3mf] Keine <plate>-Knoten gefunden.");
        reject_file(err01);
        return;
      }

      // gcode_file aus erster Plate holen – mit Varianten/Fallbacks
      const gTag =
        model_plates[0].querySelector("[key='gcode_file']") ||
        model_config_xml.querySelector("[key='gcode_file']") ||
        model_plates[0].querySelector("[key^='gcode_file']"); // manche Exporte nutzen gcode_file_0 etc.

      let firstPlatePath = gTag?.getAttribute("value") || "";

      // Fallback: nimm die erste .gcode-Datei im ZIP (bevorzugt unter Metadata/)
      if (!firstPlatePath) {
        const gFiles = zip.file(/\.gcode$/i) || [];
        if (gFiles.length) {
          const metaFirst = gFiles.find(f => /(^|\/)Metadata\//i.test(f.name));
          firstPlatePath = (metaFirst || gFiles[0]).name;
          console.warn("[read3mf] Kein gcode_file im model_settings gefunden. Fallback auf:", firstPlatePath);
        }
      }

      // Immer noch nichts? -> sauber abbrechen + Debug-Infos
      if (!firstPlatePath) {
        console.log("[read3mf] firstPlatePath leer. Liste .gcode im ZIP:", (zip.file(/\.gcode$/i) || []).map(f => f.name));
        reject_file(err01);
        return;
      }

      // Prüfen, ob die gefundene Datei tatsächlich im ZIP existiert
      const firstPlateEntry = zip.file(firstPlatePath);
      if (!firstPlateEntry) {
        console.log("[read3mf] gcode-Datei nicht im ZIP gefunden:", firstPlatePath,
          "Kandidaten:", (zip.file(/\.gcode$/i) || []).map(f => f.name));
        reject_file(err01);
        return;
      }

      // Eine GCODE-Datei öffnen (reicht für Modelldetektion)
      const firstPlateText = await firstPlateEntry.async("text");

      // Check for clearbed comment at the beginning of GCODE (fallback method)
      const clearbedCommentMatch = firstPlateText.match(/^\s*;\s*clearbed\s+printer:/mi);
      if (clearbedCommentMatch) {
        console.warn("[read3mf] File contains clearbed comment:", clearbedCommentMatch[0]);
        reject_file("This file has already been processed by Clearbed and cannot be imported again.");
        return;
      }

      // Printer-Modell erkennen
      const detectedMode = parsePrinterModelFromGcode(firstPlateText);

      // Nozzle-Durchmesser aus dem Header lesen, z.B. "; nozzle_diameter = 0.4"
      const nozMatch = firstPlateText.match(/^\s*;\s*nozzle_diameter\s*=\s*([\d.]+)/mi);
      const currentNozzleDiameter = nozMatch ? parseFloat(nozMatch[1]) : null;
      
      // Bei der ersten Datei: Nozzle-Durchmesser setzen
      if (current_file_id === 0) {
        state.NOZZLE_DIAMETER_MM = currentNozzleDiameter;
        state.NOZZLE_IS_02 = !!(state.NOZZLE_DIAMETER_MM && Math.abs(state.NOZZLE_DIAMETER_MM - 0.2) < 1e-6);
      } else {
        // Bei weiteren Dateien: Nozzle-Durchmesser validieren
        if (state.NOZZLE_DIAMETER_MM !== null && currentNozzleDiameter !== null) {
          // Toleranz von 0.001mm für Rundungsfehler
          if (Math.abs(state.NOZZLE_DIAMETER_MM - currentNozzleDiameter) > 0.001) {
            console.warn(`[read3mf] Nozzle diameter mismatch: ${state.NOZZLE_DIAMETER_MM}mm vs ${currentNozzleDiameter}mm`);
            reject_file(`Nozzle diameter mismatch: First plate uses ${state.NOZZLE_DIAMETER_MM}mm, but "${f.name}" uses ${currentNozzleDiameter}mm. All plates must use the same nozzle diameter.`);
            return;
          }
        } else if (state.NOZZLE_DIAMETER_MM === null && currentNozzleDiameter !== null) {
          // Falls erste Datei keine Nozzle-Info hatte, aber diese schon
          state.NOZZLE_DIAMETER_MM = currentNozzleDiameter;
          state.NOZZLE_IS_02 = !!(state.NOZZLE_DIAMETER_MM && Math.abs(state.NOZZLE_DIAMETER_MM - 0.2) < 1e-6);
        }
      }

      // Mode prüfen (bricht selbst ab, wenn falsch)
      if (!ensureModeOrReject(detectedMode, f.name)) {
        return;
      }


      if (model_plates[0].querySelectorAll("[key='gcode_file']").length == 0) {
        console.log("model_plates[0].querySelectorAll([key='gcode_file']).length == 0")
        reject_file(err01);
        return;
      }

      //change UI layout
      document.getElementById("drop_zones_wrapper").classList.add("mini_drop_zone");
      document.getElementById("action_buttons").classList.remove("hidden");
      document.getElementById("printer_model_info").classList.remove("hidden");   // Printer model info
      document.getElementById("app_mode_toggle").classList.remove("hidden");      // App mode toggle
      document.getElementById("statistics").classList.remove("hidden");
      document.getElementById("controls_box").classList.remove("hidden");
      document.getElementById("app_header")?.classList.remove("compact");
      document.body.classList.remove("compact-mode");

      var slice_config_file = zip.file("Metadata/slice_info.config").async("text");
      var slicer_config_xml = parser.parseFromString(await slice_config_file, "text/xml");

      // Check for custom header that marks this as already processed
      const clearbedProcessedHeader = slicer_config_xml.querySelector("header_item[key='X-BBL-Clearbed-Processed']");
      if (clearbedProcessedHeader) {
        console.warn("[read3mf] File already processed by Clearbed:", clearbedProcessedHeader.getAttribute("value"));
        reject_file("This file has already been processed by Clearbed and cannot be imported again.");
        return;
      }

      for (var i = 0; i < model_plates.length; i++) {
        (function () {
          const gcode_tag = model_plates[i].querySelectorAll("[key='gcode_file']");
          const plate_name = gcode_tag[0].getAttribute("value");
          if (plate_name == "") return;

          console.log("plate_name found", plate_name);

          var relativePath = zip.file(plate_name);
          if (!relativePath) return;

          var li = state.li_prototype.cloneNode(true);
          li.removeAttribute("id");
          state.playlist_ol.appendChild(li);
          initPlateX1P1UI(li);
          installPlateButtons(li);

          var f_name = li.getElementsByClassName("f_name")[0];
          var p_name = li.getElementsByClassName("p_name")[0];
          var p_icon = li.getElementsByClassName("p_icon")[0];
          var f_id = li.getElementsByClassName("f_id")[0];
          var p_time = li.getElementsByClassName("p_time")[0];
          var p_filaments = li.getElementsByClassName("p_filaments")[0];
          var p_filament_prototype = li.getElementsByClassName("p_filament_prototype")[0];

          li.classList.remove("hidden");

          f_name.textContent = f.name;
          f_name.title = f.name;

          p_name.textContent = plate_name.split("Metadata").join("").split(".gcode").join("");
          p_name.title = plate_name;

          f_id.title = current_file_id;
          f_id.innerText = "[" + current_file_id + "]";

          var icon_name = model_plates[i].querySelectorAll("[key='thumbnail_file']")[0].getAttribute("value");
          console.log("icon_name", icon_name);

          // Also get the no-light version
          var no_light_icon_name = null;
          const no_light_element = model_plates[i].querySelectorAll("[key='thumbnail_no_light_file']")[0];
          if (no_light_element) {
            no_light_icon_name = no_light_element.getAttribute("value");
            console.log("no_light_icon_name", no_light_icon_name);
          }

          var img_file = zip.file(icon_name);
          console.log("img_file", img_file);

          img_file.async("blob").then(function (u8) {
            const litImageUrl = URL.createObjectURL(u8);
            p_icon.src = litImageUrl;

            // Store URLs for later color mapping
            p_icon.dataset.litImageUrl = litImageUrl;

            // Load no-light image if available
            if (no_light_icon_name) {
              const no_light_img_file = zip.file(no_light_icon_name);
              if (no_light_img_file) {
                no_light_img_file.async("blob").then(async function (no_light_u8) {
                  const unlitImageUrl = URL.createObjectURL(no_light_u8);
                  p_icon.dataset.unlitImageUrl = unlitImageUrl;
                  console.log("Stored unlit image URL for plate", i);

                  // Calculate and cache the lighting mask (shadowmap) once during loading
                  try {
                    const lightingMask = await calculateLightingMask(litImageUrl, unlitImageUrl);
                    if (lightingMask) {
                      // Store the lighting mask directly on the DOM element
                      // Note: We can't store ImageData directly, so we store it as a non-enumerable property
                      Object.defineProperty(p_icon, '_cachedLightingMask', {
                        value: lightingMask,
                        writable: false,
                        enumerable: false,
                        configurable: true
                      });
                      console.log("Cached lighting mask for plate", i);
                    }
                  } catch (error) {
                    console.error("Failed to calculate lighting mask for plate", i, error);
                  }
                });
              }
            }
          });

          var queryBuf = "[key='index'][value='" + (i + 1) + "']";
          var buf = slicer_config_xml.querySelectorAll(queryBuf);

          if (buf.length > 0)
            var config_filaments = buf[0].parentElement.getElementsByTagName("filament");
          else
            var config_filaments = slicer_config_xml.getElementsByTagName("plate")[0].getElementsByTagName("filament");

          var my_fl;

          // Get total number of colors on this plate to determine display format
          const numColors = config_filaments.length;

          // Neue Filamentzeilen erstellen
          for (let filament_id = 0; filament_id < config_filaments.length; filament_id++) {
            const cfg = config_filaments[filament_id];

            const color = cfg.getAttribute("color") || "#cccccc";
            const type = cfg.getAttribute("type") || "PLA";
            const trayInfoIdx = cfg.getAttribute("tray_info_idx") || "";

            // Verbrauch robust parsen (keine "undefined" schreiben)
            const usedM = parseFloat(cfg.getAttribute("used_m") || "0") || 0;
            const usedG = parseFloat(cfg.getAttribute("used_g") || "0") || 0;

            // Slot 1..32 aus dem Attribut "id" holen (Fallback = Index+1)
            const slotNum = resolveSlotForRow(model_plates, i, filament_id, cfg);

            // Zeile klonen + anhängen
            const my_fl = p_filament_prototype.cloneNode(true);
            p_filaments.appendChild(my_fl);

            // Farbe setzen (sichtbar + als Datenquelle)
            const sw = my_fl.getElementsByClassName("f_color")[0];
            sw.style.backgroundColor = color;
            sw.dataset.f_color = color;

            // Slot-Text setzen (sichtbar) …
            const slotEl = my_fl.getElementsByClassName("f_slot")[0];
            slotEl.innerText = String(slotNum);
            // … und Original-Slot/Typ/TrayInfoIdx für spätere Exporte merken
            slotEl.dataset.origSlot = String(slotNum);
            slotEl.dataset.origType = type;
            slotEl.dataset.trayInfoIdx = trayInfoIdx;

            // Determine what to display based on number of colors on this plate
            // 1-5 colors: Full display (Slot #, type, g, m) - default template
            // 6-10 colors: No "Slot" label (type, g, m)
            // 11+ colors: Only g value

            const typeEl = my_fl.getElementsByClassName("f_type")[0];
            const mEl = my_fl.getElementsByClassName("f_used_m")[0];
            const gEl = my_fl.getElementsByClassName("f_used_g")[0];

            if (numColors <= 5) {
              // Full display (1-5 colors): Slot #, type, g, m
              typeEl.innerText = type;
              mEl.innerText = usedM.toString();
              gEl.innerText = usedG.toString();
            } else if (numColors <= 10) {
              // Reduced display (6-10 colors): Hide "Slot" label, keep type, g, m
              // Find and hide the "Slot" text span
              const slotLabel = Array.from(my_fl.querySelectorAll('span')).find(
                span => !span.className && span.textContent.trim() === 'Slot'
              );
              if (slotLabel) {
                slotLabel.style.display = 'none';
              }
              slotEl.style.display = 'none';

              typeEl.innerText = type;
              mEl.innerText = usedM.toString();
              gEl.innerText = usedG.toString();
            } else {
              // Minimal display (11+ colors): Only g value
              // Hide "Slot" label
              const slotLabel = Array.from(my_fl.querySelectorAll('span')).find(
                span => !span.className && span.textContent.trim() === 'Slot'
              );
              if (slotLabel) {
                slotLabel.style.display = 'none';
              }
              slotEl.style.display = 'none';

              // Hide type
              typeEl.style.display = 'none';

              // Hide m value and its label
              mEl.style.display = 'none';
              const mLabel = Array.from(my_fl.querySelectorAll('span')).find(
                span => !span.className && span.textContent.trim() === 'm'
              );
              if (mLabel) {
                mLabel.style.display = 'none';
              }

              // Keep only g value
              gEl.innerText = usedG.toString();
            }

            my_fl.className = "p_filament";
          }


          // Plate-Swatches (Filamentfarben) mit Slot-Texten verknüpfen
          wirePlateSwatches(li);
          // Globale Slotfarben aus allen Platten ableiten → Statistik einfärben
          deriveGlobalSlotColorsFromPlates();
          // Danach die Plate mit den aktuellen Statistikfarben bemalen
          updateAllPlateSwatchColors();

          relativePath.async("string").then(async function (content) {

            const time_flag = "total estimated time: ";
            const time_place = content.indexOf(time_flag) + time_flag.length;
            const time_sting = content.slice(time_place, content.indexOf("\n", time_place));
            p_time.innerText = time_sting;

            var time_int = 0;

            var t = time_sting.match(/\d+[s]/);
            time_int = t ? parseInt(t) : 0;

            t = time_sting.match(/\d+[m]/);
            time_int += (t ? parseInt(t) : 0) * 60;

            t = time_sting.match(/\d+[h]/);
            time_int += (t ? parseInt(t) : 0) * 60 * 60;

            t = time_sting.match(/\d+[d]/);
            time_int += (t ? parseInt(t) : 0) * 60 * 60 * 24;

            p_time.title = time_int;

            update_statistics();


            console.log("plate_name:" + relativePath.name + " time-string", time_sting);
          });
        })();
      }

      var filaments = slicer_config_xml.getElementsByTagName("filament");
      console.log("filaments.length", filaments.length);
      var max_id = 0;
      console.log("filaments:", filaments);

      for (var i = 0; i < filaments.length; i++) {
        if (filaments[i].id > max_id) max_id = filaments[i].id;
        console.log("filaments[i].id:", filaments[i].id);
        console.log("max_id:", max_id);
      }

      if (state.last_file) {
        makeListSortable(state.playlist_ol);

        // Auto-populate coordinates for X1/P1 modes after ALL plates are completely processed
        if (state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1') {
          setTimeout(async () => {
            const plates = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)");
            console.log(`Auto-populating coordinates for ${plates.length} plates in ${state.PRINTER_MODEL} mode`);

            // Auto-populate all plates
            const promises = Array.from(plates).map(async (li, index) => {
              try {
                await autoPopulatePlateCoordinates(li);
              } catch (error) {
                console.error(`Failed to auto-populate coordinates for plate ${index}:`, error);
              }
            });

            // Wait for all auto-populations to complete
            await Promise.all(promises);

            // Update UI after all calculations are done
            console.log('All coordinates calculated, updating UI...');
            // Trigger settings display update if a plate is currently selected
            setTimeout(() => {
              const selectedPlate = document.querySelector("#playlist_ol li.list_item.plate-selected");
              if (selectedPlate) {
                // Force refresh of the settings display by re-selecting the same plate
                const plateIndex = Array.from(plates).indexOf(selectedPlate);
                if (plateIndex >= 0) {
                  // Re-import and call the display function directly
                  import('../ui/settings.js').then(({ displayPlateSettings }) => {
                    displayPlateSettings(plateIndex);
                  });
                }
              }
            }, 100);
          }, 500); // Longer delay to ensure all async plate processing is complete
        }
      }
    }, function (e) {
      const errorMessage = `Error reading ${f.name}: ${e.message}`;
      console.error("[read3mf]", errorMessage);
      showError(errorMessage);
      reject_file(err00);
    });
}
