import JSZip from "jszip";
import { state } from "../config/state.js";
import { update_progress } from "../ui/progressbar.js";
import { validatePlateXCoords } from "../ui/plates.js";
import { download , collectAndTransform, chunked_md5} from "./ioUtils.js";
import { model_settings_template } from "../libs/obfsc.js";

export async function export_3mf() {
  try {
    if (!validatePlateXCoords()) return;
    update_progress(5);

    const result = await collectAndTransform({ applyRules: true, applyOptimization: true });
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

    const oldPlates = await baseZip.file(/plate_\d+\.gcode\b$/);
    oldPlates.forEach(f => baseZip.remove(f.name));

    if (baseZip.file("Metadata/custom_gcode_per_layer.xml")) {
      await baseZip.remove("Metadata/custom_gcode_per_layer.xml");
    }

    // project_settings vom "größten AMS"-File
    const projZip = await JSZip.loadAsync(state.my_files[state.ams_max_file_id]);
    const projSettings = await projZip.file("Metadata/project_settings.config").async("text");
    baseZip.file("Metadata/project_settings.config", projSettings);

    // model_settings + slice_info
    baseZip.file("Metadata/model_settings.config", model_settings_template);

    const sliceInfoStr = await baseZip.file("Metadata/slice_info.config").async("text");
    const parser = new DOMParser();
    const slicer_config_xml = parser.parseFromString(sliceInfoStr, "text/xml");

    const platesXML = slicer_config_xml.getElementsByTagName("plate");
    while (platesXML.length > 1) platesXML[platesXML.length - 1].remove();

    const indexNode = platesXML[0].querySelector("[key='index']");
    if (indexNode) indexNode.setAttribute("value", "1");

    let filamentNodes = platesXML[0].getElementsByTagName("filament");
    while (filamentNodes.length > 0) filamentNodes[filamentNodes.length - 1].remove();

    const fil_stat_slots = document.getElementById("filament_total").childNodes;
    for (let i = 0; i < fil_stat_slots.length; i++) {
      const filament_tag = slicer_config_xml.createElement("filament");
      platesXML[0].appendChild(filament_tag);

      filament_tag.id = fil_stat_slots[i].title;
      filament_tag.setAttribute("type",  fil_stat_slots[i].dataset.f_type);
      filament_tag.setAttribute("color", fil_stat_slots[i].dataset.f_color);
      filament_tag.setAttribute("used_m", fil_stat_slots[i].dataset.used_m);
      filament_tag.setAttribute("used_g", fil_stat_slots[i].dataset.used_g);
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
