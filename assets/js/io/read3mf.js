// /src/io/read3mf.js

// /src/io/read3mf.js
import JSZip from "jszip";
import { state } from "../config/state.js";
import { parsePrinterModelFromGcode } from "../gcode/readGcode.js";
import { ensureModeOrReject } from "../config/mode.js";
import { initPlateX1P1UI, makeListSortable, installPlateButtons } from "../ui/plates.js";
import {
  syncPlateFilamentSwatches,
  deriveGlobalSlotColorsFromPlates,
  repaintPlateFromStats
} from "../ui/filamentColors.js";
import { update_statistics } from "../ui/statistics.js";
import { export_3mf } from "./export3mf.js";
import { err00, err01 } from "../constants/errorMessages.js";

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

      var model_config_file = zip.file("Metadata/model_settings.config").async("text");
      var model_config_xml = parser.parseFromString(await model_config_file, "text/xml");
      const plateNode = model_config_xml.querySelector("[key='gcode_file']");

      if (!plateNode) { reject_file(err01); return; }

      const firstPlatePath = plateNode.getAttribute("value");
      if (!firstPlatePath) { reject_file(err01); return; }

      // Eine GCODE-Datei öffnen (reicht für Modelldetektion)
      const firstPlateText = await zip.file(firstPlatePath).async("text");
      const detectedMode = parsePrinterModelFromGcode(firstPlateText);

      if (!ensureModeOrReject(detectedMode, f.name)) {
        // Frühe Rückkehr: nichts wurde in Arrays/UI eingefügt
        return;
      }

      var model_plates = model_config_xml.getElementsByTagName("plate");

      if (model_plates.length == 0) {
        reject_file(err01);
        return;
      }

      if (model_plates[0].querySelectorAll("[key='gcode_file']").length == 0) {
        reject_file(err01);
        return;
      }

      //change UI layout
      document.getElementById("drop_zones_wrapper").classList.add("mini_drop_zone");
      document.getElementById("action_buttons").classList.remove("hidden");
      document.getElementById("mode_switch").classList.remove("hidden");  // ← NEU
      document.getElementById("statistics").classList.remove("hidden");

      var slice_config_file = zip.file("Metadata/slice_info.config").async("text");
      var slicer_config_xml = parser.parseFromString(await slice_config_file, "text/xml");

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

          var img_file = zip.file(icon_name);
          console.log("img_file", img_file);

          img_file.async("blob").then(function (u8) {
            p_icon.src = URL.createObjectURL(u8);
          });

          var queryBuf = "[key='index'][value='" + (i + 1) + "']";
          var buf = slicer_config_xml.querySelectorAll(queryBuf);

          if (buf.length > 0)
            var config_filaments = buf[0].parentElement.getElementsByTagName("filament");
          else
            var config_filaments = slicer_config_xml.getElementsByTagName("plate")[0].getElementsByTagName("filament");

          var my_fl;

          for (var filament_id = 0; filament_id < config_filaments.length; filament_id++) {
            my_fl = p_filament_prototype.cloneNode(true);
            p_filaments.appendChild(my_fl);

            // Filamentfarbe und Slot-Text setzen
            my_fl.getElementsByClassName("f_color")[0].style.backgroundColor = config_filaments[filament_id].getAttribute("color");
            my_fl.getElementsByClassName("f_color")[0].dataset.f_color = config_filaments[filament_id].getAttribute("color");

            //  Slot 1..4 aus dem Attribut "id" holen (Fallback = Index+1)
            const slotAttr = config_filaments[filament_id].getAttribute("id");
            let slotNum = parseInt(slotAttr, 10);
            if (!Number.isFinite(slotNum)) slotNum = filament_id + 1;       // Fallback
            slotNum = Math.max(1, Math.min(4, slotNum));                    // clamp 1..4

            // Slot anzeigen …
            my_fl.getElementsByClassName("f_slot")[0].innerText = slotNum;
            // … und **Original**-Slot für späteres Mapping speichern
            my_fl.getElementsByClassName("f_slot")[0].dataset.origSlot = String(slotNum);

            // Filamenttyp und Verbrauchswerte setzen
            my_fl.getElementsByClassName("f_type")[0].innerText = config_filaments[filament_id].getAttribute("type");
            my_fl.getElementsByClassName("f_used_m")[0].innerText = config_filaments[filament_id].getAttribute("used_m");
            my_fl.getElementsByClassName("f_used_g")[0].innerText = config_filaments[filament_id].getAttribute("used_g");
            my_fl.className = "p_filament";
          }

          // Plate-Swatches (Filamentfarben) mit Slot-Texten verknüpfen
          syncPlateFilamentSwatches(li);
          // Globale Slotfarben aus allen Platten ableiten → Statistik einfärben
          deriveGlobalSlotColorsFromPlates();
          // Danach die Plate mit den aktuellen Statistikfarben bemalen
          repaintPlateFromStats(li);

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
        if (state.instant_processing)
          export_3mf();
      }
    }, function (e) {
      var errorDiv = document.createElement("div");
      errorDiv.className = "alert alert-danger";
      errorDiv.textContent = "Error reading " + f.name + ": " + e.message;
      state.err.appendChild(errorDiv);
      reject_file(err00);
    });
}
