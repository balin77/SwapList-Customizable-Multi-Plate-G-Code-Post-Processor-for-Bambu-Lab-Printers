import JSZip from "jszip";
import { state } from "../config/state.js";
import { update_progress } from "../ui/progressbar.js";
import { validatePlateXCoords } from "../ui/plates.js";
import { download, collectAndTransform, chunked_md5 } from "./ioUtils.js";
import { model_settings_xml } from "../config/xmlConfig.js";
import { colorToHex } from "../utils/colors.js";
import { buildProjectSettingsForUsedSlots } from "../config/materialConfig.js";


export async function export_3mf() {
  try {
    if (!validatePlateXCoords()) return;
    update_progress(5);


    // Collect and transform the data
    const result = await collectAndTransform({ applyRules: true, applyOptimization: true, amsOverride: true });
    if (result.empty) {
      alert("Keine aktiven Platten (Repeats=0).");
      update_progress(-1);
      return;
    }

    // final GCode payload
    const finalGcodeBlob = new Blob(result.modifiedLooped, { type: "text/x-gcode" });

    update_progress(25);

    // 3MF Basis
    const baseZip = await JSZip.loadAsync(state.my_files[0]);

    const oldPlates = baseZip.file(/plate_\d+\.gcode\b$/);
    oldPlates.forEach(f => baseZip.remove(f.name));

    if (baseZip.file("Metadata/custom_gcode_per_layer.xml")) {
      baseZip.remove("Metadata/custom_gcode_per_layer.xml");
    }

    // project_settings vom "größten AMS"-File lesen
    const projZip = await JSZip.loadAsync(state.my_files[state.ams_max_file_id]);
    let projSettingsText = await projZip.file("Metadata/project_settings.config").async("text");

    // NUR wenn Override aktiv: neues JSON erzeugen
    let finalProjSettingsText = projSettingsText;
    if (state.OVERRIDE_METADATA) {
      finalProjSettingsText = buildProjectSettingsForUsedSlots(projSettingsText);
    }

    // in die 3MF packen
    baseZip.file("Metadata/project_settings.config", finalProjSettingsText);

    // model_settings + slice_info
    baseZip.file("Metadata/model_settings.config", model_settings_xml);

    const sliceInfoStr = await baseZip.file("Metadata/slice_info.config").async("text");
    const parser = new DOMParser();
    const slicer_config_xml = parser.parseFromString(sliceInfoStr, "text/xml");

    // auf eine Plate reduzieren
    const platesXML = slicer_config_xml.getElementsByTagName("plate");
    while (platesXML.length > 1) platesXML[platesXML.length - 1].remove();

    const indexNode = platesXML[0].querySelector("[key='index']");
    if (indexNode) indexNode.setAttribute("value", "1");

    // --- Filament-Override nur, wenn aktiviert ---
    if (state.OVERRIDE_METADATA) {
      // Alte Filament-Knoten leeren
      let filamentNodes = platesXML[0].getElementsByTagName("filament");
      while (filamentNodes.length > 0) filamentNodes[filamentNodes.length - 1].remove();

      // Stats-Quelle
      const slotDivs = document
        .getElementById("filament_total")
        ?.querySelectorAll(":scope > div[title]") || [];

      for (let i = 0; i < slotDivs.length; i++) {
        const div = slotDivs[i];

        // Verbrauch lesen
        const usedM = parseFloat(div.dataset.used_m || "0") || 0;
        const usedG = parseFloat(div.dataset.used_g || "0") || 0;
        if (usedM <= 0 && usedG <= 0) continue;

        // Slot-ID (1..4)
        const slotId = parseInt(div.getAttribute("title") || `${i + 1}`, 10) || (i + 1);

        // Farbe vom Swatch
        const sw = div.querySelector(":scope > .f_color");
        const colorRaw = (sw?.dataset?.f_color) || (sw ? getComputedStyle(sw).backgroundColor : "#cccccc");
        const hex = colorToHex(colorRaw || "#cccccc");

        // Typ (aktuell hart: PLA – du passt das später an)
        const type = "PLA";

        // Filament-Node schreiben
        const filament_tag = slicer_config_xml.createElement("filament");
        filament_tag.id = String(slotId);
        filament_tag.setAttribute("type", type);
        filament_tag.setAttribute("color", hex);
        filament_tag.setAttribute("used_m", String(usedM));
        filament_tag.setAttribute("used_g", String(usedG));

        platesXML[0].appendChild(filament_tag);
      }
      // Wenn Override AUS ist, belassen wir die originalen Filament-Einträge unverändert.
    }

    const s = new XMLSerializer();
    const tmp_str = s.serializeToString(slicer_config_xml);
    baseZip.file("Metadata/slice_info.config", tmp_str.replace(/></g, ">\n<"));

    // neue Platte
    baseZip.file("Metadata/plate_1.gcode", finalGcodeBlob);

    // MD5 & packen
    let hash = "";
    await chunked_md5(state.enable_md5 ? finalGcodeBlob : new Blob([' ']), async (md5) => {
      hash = md5;
      baseZip.file("Metadata/plate_1.gcode.md5", hash);

      const zipBlob = await baseZip.generateAsync(
        { type: "blob", compression: "DEFLATE", compressionOptions: { level: 3 } },
        (meta) => update_progress(75 + Math.floor(20 * (meta.percent || 0) / 100))
      );

      const fnField = document.getElementById("file_name");
      const baseName = (fnField.value || fnField.placeholder || "output").trim();
      const url = URL.createObjectURL(zipBlob);
      download(`${baseName}.swap.3mf`, url);

      update_progress(100);
      setTimeout(() => update_progress(-1), 400);
    });
  } catch (err) {
    console.error("export_3mf failed:", err);
    alert("Export fehlgeschlagen: " + (err && err.message ? err.message : err));
    update_progress(-1);
  }
}
