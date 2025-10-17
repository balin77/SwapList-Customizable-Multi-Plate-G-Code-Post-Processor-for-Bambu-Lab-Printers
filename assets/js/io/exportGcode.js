import JSZip from "jszip";
import { state } from "../config/state.js";
import { update_progress } from "../ui/progressbar.js";
import { validatePlateXCoords } from "../ui/plates.js";
import { download, collectAndTransform, generateFilenameFormat } from "./ioUtils.js";
import { PRESET_INDEX } from "../config/filamentConfig/registry-generated.js";
import { buildProjectSettingsForUsedSlots } from "../config/materialConfig.js";
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

    // Exportiere nur modifizierten kombinierten GCODE mit einfachem Namen
    const finalBase = isTestFileExport ? `${base}_test` : base;
    await exportNormalMode(finalBase, modeTag, modifiedCombined);

    update_progress(100);
    setTimeout(() => update_progress(-1), 500);
  } catch (err) {
    console.error("GCODE export failed:", err);
    showError("GCODE-Export fehlgeschlagen: " + (err.message || err));
    update_progress(-1);
  }
}



async function exportNormalMode(base, modeTag, modifiedCombined) {
  update_progress(60);

  // Generate filename with new format including loop count
  const filenameWithoutExt = generateFilenameFormat(`${base}.${modeTag}`, false);
  const filename = `${filenameWithoutExt}.gcode`;

  // Create GCODE file directly from string - avoids string length issues
  const gcodeBlob = new Blob([modifiedCombined], { type: "text/x-gcode" });
  const gcodeUrl = URL.createObjectURL(gcodeBlob);

  download(filename, gcodeUrl);
}
