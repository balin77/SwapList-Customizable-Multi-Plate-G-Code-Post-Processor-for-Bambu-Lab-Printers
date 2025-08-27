import JSZip from "jszip";
import { state } from "../config/state.js";
import { update_progress } from "../ui/progressbar.js";
import { validatePlateXCoords } from "../ui/plates.js";
import { download } from "./ioUtils.js";
import { collectAndTransform } from "./ioUtils.js";
import { model_settings_xml } from "../config/xmlConfig.js";
import { buildProjectSettingsForUsedSlots } from "../config/materialConfig.js";

export async function export_gcode_txt() {
  if (!validatePlateXCoords()) return;
  try {
    update_progress(5);

    const { empty, platesOnce, originalCombined, modifiedCombined } =
      await collectAndTransform({ applyRules: true, applyOptimization: true, amsOverride: true });

    if (empty) {
      alert("Keine aktiven Platten (Repeats=0).");
      update_progress(-1);
      return;
    }

    update_progress(25);

    const file_name_field = document.getElementById("file_name");
    const base = (file_name_field.value || file_name_field.placeholder || "output_file_name").trim();
    const modeTag = (state.CURRENT_MODE || "A1M");
    const purgeTag = (state.CURRENT_MODE === 'X1' || state.CURRENT_MODE === 'P1')
      ? (state.USE_PURGE_START ? "_purge" : "_standard")
      : "";
    const stamp = new Date().toISOString().replace(/[:.]/g, "-");

    const zip = new JSZip();
    const root = zip.folder(`${base}_gcode_exports_${modeTag}${purgeTag}_${stamp}`);

    root.file(`${base}_${modeTag}${purgeTag}_original_combined.txt`, originalCombined);
    root.file(`${base}_${modeTag}${purgeTag}_modified_combined.txt`, modifiedCombined);

    const platesFolder = root.folder("per_plate_preloop");
    for (let i = 0; i < platesOnce.length; i++) {
      const idx = String(i + 1).padStart(2, "0");
      platesFolder.file(`plate_${idx}_original.txt`, platesOnce[i]);
      // modifiedPerPlate könntest du auf Wunsch zusätzlich aus collectAndTransform zurückgeben und hier ablegen
    }

    update_progress(60);
    const zipBlob = await zip.generateAsync(
      { type: "blob", compression: "DEFLATE", compressionOptions: { level: 3 } },
      (meta) => { update_progress(60 + Math.floor(35 * (meta.percent || 0) / 100)); }
    );

    const zipUrl = URL.createObjectURL(zipBlob);
    download(`${base}_${modeTag}${purgeTag}_gcode_exports.zip`, zipUrl);

    update_progress(100);
    setTimeout(() => update_progress(-1), 500);
  } catch (err) {
    console.error("GCODE txt export failed:", err);
    alert("TXT-Export fehlgeschlagen: " + (err.message || err));
    update_progress(-1);
  }
}
