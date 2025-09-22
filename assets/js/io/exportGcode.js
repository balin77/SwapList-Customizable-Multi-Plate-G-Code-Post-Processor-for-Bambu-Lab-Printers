import JSZip from "jszip";
import { state } from "../config/state.js";
import { update_progress } from "../ui/progressbar.js";
import { validatePlateXCoords } from "../ui/plates.js";
import { download } from "./ioUtils.js";
import { collectAndTransform } from "./ioUtils.js";
import { PRESET_INDEX } from "../config/filamentConfig/registry-generated.js";
import { buildProjectSettingsForUsedSlots } from "../config/materialConfig.js";
import { DEV_MODE } from "../index.js";
import { showError, showWarning } from "../ui/infobox.js";

// Hilfsfunktion: Finde das Filament-Objekt anhand setting_id
function findFilamentBySettingId(settingId) {
  return PRESET_INDEX.find(f => f.settings?.setting_id === settingId);
}

export async function export_gcode_txt() {
  if (!(await validatePlateXCoords())) return;
  try {
    update_progress(5);

    const { empty, platesOnce, modifiedPerPlate, originalCombined, modifiedCombined } =
      await collectAndTransform({ applyRules: true, applyOptimization: true, amsOverride: true });

    if (empty) {
      showWarning("Keine aktiven Platten (Repeats=0).");
      update_progress(-1);
      return;
    }

    update_progress(25);

    const file_name_field = document.getElementById("file_name");
    const base = (file_name_field.value || file_name_field.placeholder || "output_file_name").trim();
    const modeTag = (state.PRINTER_MODEL || "A1M");
    const purgeTag = (state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1')
      ? (state.USE_PURGE_START ? "_purge" : "_standard")
      : "";

    // Check if test file export is enabled
    const testFileExportCheckbox = document.getElementById("opt_test_file_export");
    const isTestFileExport = testFileExportCheckbox && testFileExportCheckbox.checked;

    if (DEV_MODE) {
      // DEV MODE: Exportiere vollständige ZIP-Struktur mit detaillierten Namen
      await exportDevMode(base, modeTag, purgeTag, {
        platesOnce,
        modifiedPerPlate,
        originalCombined,
        modifiedCombined
      });
    } else {
      // NORMAL MODE: Exportiere nur modifizierten kombinierten GCODE mit einfachem Namen
      const finalBase = isTestFileExport ? `${base}_test` : base;
      await exportNormalMode(finalBase, modeTag, modifiedCombined);
    }

    update_progress(100);
    setTimeout(() => update_progress(-1), 500);
  } catch (err) {
    console.error("GCODE export failed:", err);
    showError("GCODE-Export fehlgeschlagen: " + (err.message || err));
    update_progress(-1);
  }
}

async function exportDevMode(base, modeTag, purgeTag, data) {
  const stamp = new Date().toISOString().replace(/[:.]/g, "-");
  // Build filename with printer type, mode, and submode (only for swap mode)
  const mode = state.APP_MODE || "swap";
  const submode = mode === "swap" ? (state.SWAP_MODE || "3print") : null;
  const filenamePart = submode ? `${modeTag}.${mode}.${submode}` : `${modeTag}.${mode}`;

  const zip = new JSZip();
  const root = zip.folder(`${base}_gcode_exports_${filenamePart}${purgeTag}_${stamp}`);

  // Combined files - use lazy evaluation to avoid memory issues
  try {
    root.file(`${base}_${filenamePart}${purgeTag}_original_combined.txt`, data.originalCombined);
  } catch (err) {
    console.warn("Skipping original_combined.txt due to size limitations:", err.message);
  }
  try {
    root.file(`${base}_${filenamePart}${purgeTag}_modified_combined.txt`, data.modifiedCombined);
  } catch (err) {
    console.warn("Skipping modified_combined.txt due to size limitations:", err.message);
  }

  // Per-plate original files
  const originalFolder = root.folder("per_plate_original");
  for (let i = 0; i < data.platesOnce.length; i++) {
    const idx = String(i + 1).padStart(2, "0");
    originalFolder.file(`plate_${idx}_original.txt`, data.platesOnce[i]);
  }

  // Per-plate modified files
  const modifiedFolder = root.folder("per_plate_modified");
  for (let i = 0; i < data.modifiedPerPlate.length; i++) {
    const idx = String(i + 1).padStart(2, "0");
    modifiedFolder.file(`plate_${idx}_modified.txt`, data.modifiedPerPlate[i]);
  }

  // Project settings
  const slotMetas = (state.P0?.slots || []).map(slot => slot.meta || {});
  const templates = slotMetas.map(meta => {
    const filament = findFilamentBySettingId(meta.setting_id);
    return filament ? filament.settings : null;
  });
  const projectSettings = buildProjectSettingsForUsedSlots(data.originalCombined, templates);
  root.file(`${base}_${filenamePart}${purgeTag}_project_settings.txt`, projectSettings);

  update_progress(60);
  const zipBlob = await zip.generateAsync(
    { type: "blob", compression: "DEFLATE", compressionOptions: { level: 3 } },
    (meta) => { update_progress(60 + Math.floor(35 * (meta.percent || 0) / 100)); }
  );

  const zipUrl = URL.createObjectURL(zipBlob);
  download(`${base}_${filenamePart}${purgeTag}_gcode_exports.zip`, zipUrl);
}


async function exportNormalMode(base, modeTag, modifiedCombined) {
  update_progress(60);

  // Build filename with printer type, mode, and submode (only for swap mode)
  const mode = state.APP_MODE || "swap";
  const submode = mode === "swap" ? (state.SWAP_MODE || "3print") : null;
  const filename = submode
    ? `${base}.${modeTag}.${mode}.${submode}.gcode`
    : `${base}.${modeTag}.${mode}.gcode`;

  // Create GCODE file directly from array - avoids string length issues
  const gcodeBlob = new Blob(modifiedCombined.map(line => line + '\n'), { type: "text/x-gcode" });
  const gcodeUrl = URL.createObjectURL(gcodeBlob);

  download(filename, gcodeUrl);
}
