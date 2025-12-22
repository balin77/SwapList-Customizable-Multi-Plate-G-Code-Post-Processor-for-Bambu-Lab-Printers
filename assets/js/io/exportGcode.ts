// /src/io/exportGcode.ts

import { state } from "../config/state.js";
import { update_progress } from "../ui/progressbar.js";
import { validatePlateXCoords } from "../ui/plates.js";
import { collectAndTransform, generateFilenameFormat } from "./ioUtils.js";
import { showError, showWarning } from "../ui/infobox.js";
import { exportGcodeWithUI } from "./exportGcodeAdapter.js";

/**
 * Export GCODE as text file
 */
export async function export_gcode_txt(): Promise<void> {
  if (!(await validatePlateXCoords())) return;
  try {
    update_progress(5);

    const result = await collectAndTransform({ applyRules: true, applyOptimization: true, amsOverride: true });

    if (result.empty) {
      showWarning("Keine aktiven Platten (Repeats=0).");
      update_progress(-1);
      return;
    }

    update_progress(25);

    const file_name_field = document.getElementById("file_name") as HTMLInputElement | null;
    const base = (file_name_field?.value || file_name_field?.placeholder || "output_file_name").trim();
    const modeTag = (state.PRINTER_MODEL || "A1M");
    // @ts-expect-error - Intentionally unused, kept for future use
    const _purgeTag = (state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1')
      ? (state.USE_PURGE_START ? "_purge" : "_standard")
      : "";

    // Check if test file export is enabled
    const testFileExportCheckbox = document.getElementById("opt_test_file_export") as HTMLInputElement | null;
    const isTestFileExport = testFileExportCheckbox && testFileExportCheckbox.checked;

    // Exportiere nur modifizierten kombinierten GCODE mit einfachem Namen
    const finalBase = isTestFileExport ? `${base}_test` : base;
    await exportNormalMode(finalBase, modeTag, result.modifiedCombined || "");

    update_progress(100);
    setTimeout(() => update_progress(-1), 500);
  } catch (err) {
    const error = err as Error;
    console.error("GCODE export failed:", err);
    showError("GCODE-Export fehlgeschlagen: " + (error.message || err));
    update_progress(-1);
  }
}

/**
 * Export GCODE in normal mode (not debug mode)
 * Now uses core exportGcode function via adapter
 */
async function exportNormalMode(base: string, modeTag: string, modifiedCombined: string): Promise<void> {
  update_progress(60);

  // Generate filename with new format including loop count
  const filenameWithoutExt = generateFilenameFormat(`${base}.${modeTag}`, false);
  const filename = `${filenameWithoutExt}.gcode`;

  // Use core exportGcode function via adapter
  await exportGcodeWithUI(modifiedCombined, filename);
}
