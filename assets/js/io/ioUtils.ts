// /src/io/ioUtils.ts

import JSZip from "jszip";
import SparkMD5 from "spark-md5";
import { update_progress } from "../ui/progressbar.js";
import { state } from "../config/state.js";
import { readPlateXCoordsSorted } from "../ui/plates.js";
import { applySwapRulesToGcode } from "../commands/applySwapRules.js";
import { applyAmsOverridesToPlate } from "../gcode/gcodeManipulation.js";
import { optimizeAMSBlocks } from "../gcode/gcodeManipulation.js";
import { SWAP_RULES } from "../commands/swapRules.js";
import { showWarning } from "../ui/infobox.js";
import { splitIntoSections, joinSectionsTestMode } from "../gcode/readGcode.js";
import { collectSettingsForPlate } from "../ui/settingsCollector.js";
import {
  SWAP_START_A1M,
  SWAP_END_A1M,
  A1_3Print_START,
  A1_3Print_END,
  A1_PRINTFLOW_START,
  A1_PRINTFLOW_END,
  A1_JOBOX_START,
  A1_JOBOX_END,
  HOMING_All_AXES,
  generateWaitCommand,
  START_SOUND_A1M,
  END_SOUND_A1M,
  HEATERS_OFF
} from "../commands/swapRules.js";
import { transformM73LayerProgressGlobal, transformM73PercentageProgressGlobal, insertM73ResetCommands, calculateTotalGlobalLayers, updateTotalLayerNumberHeader } from "../gcode/m73ProgressTransform.js";
import { getLayerProgressMode, getPercentageProgressMode } from "../ui/settings.js";
import type { SwapMode, AMSSlotMapping, RuleContext } from "../types/index.js";
// @ts-expect-error - Type import for documentation
import type { PrinterModel } from "../types/index.js";

/**
 * Options for collectAndTransform function
 */
export interface CollectAndTransformOptions {
  /** Whether to apply swap rules to the GCODE */
  applyRules?: boolean;
  /** Whether to apply AMS block optimization */
  applyOptimization?: boolean;
  /** Loop count value */
  loopsValue?: number;
  /** Whether to apply AMS slot overrides */
  amsOverride?: boolean;
}

/**
 * Result from collectAndTransform function
 */
export interface CollectAndTransformResult {
  /** Whether the result is empty (no active plates) */
  empty: boolean;
  /** Original plates processed once */
  platesOnce?: string[];
  /** Modified plates processed once (with rules applied) */
  modifiedPerPlate?: string[];
  /** Modified plates looped with all transformations applied */
  modifiedLooped?: string[];
  /** Original combined GCODE (lazy getter) */
  readonly originalCombined?: string;
  /** Modified combined GCODE (lazy getter) */
  readonly modifiedCombined?: string;
}

/**
 * Helper function to get correct submode based on printer model
 */
export function getSubmodeForExport(): SwapMode | null {
  const mode = state.APP_MODE || "swap";
  if (mode !== "swap") return null;

  // A1M always uses "swaplist" submode
  if (state.PRINTER_MODEL === "A1M") {
    return "swaplist" as SwapMode;
  }

  // For other printers, use the selected SWAP_MODE or default to "3print"
  return (state.SWAP_MODE || "3print") as SwapMode;
}

/**
 * Helper function to generate complete filename format with loop count
 */
export function generateFilenameFormat(baseName: string = "output", includeExtension: boolean = true): string {
  const loopsInput = document.getElementById("loops") as HTMLInputElement | null;
  const loops = loopsInput?.value || "1";
  const printerType = state.PRINTER_MODEL || "unknown";
  const mode = state.APP_MODE || "swap";
  const submode = getSubmodeForExport();

  // Build filename: basename.loopsx.printer.mode.submode.3mf
  let filename = `${baseName}.${loops}x.${printerType}.${mode}`;

  if (submode) {
    filename += `.${submode}`;
  }

  if (includeExtension) {
    filename += ".3mf";
  }

  return filename;
}

/**
 * Function to add autoeject processing comment at the beginning of GCODE
 */
function addAutoEjectComment(gcode: string, _plateIndex: number = 0, totalPlates: number = 1): string {
  const currentDate = new Date().toISOString();
  const printerModel = state.PRINTER_MODEL || "unknown";
  const appMode = state.APP_MODE || "swap";

  // Get active settings info
  const settingsInfo: string[] = [];

  // Check common settings that might be active
  if (state.OVERRIDE_METADATA) {
    settingsInfo.push("metadata_override");
  }

  // Get settings from UI elements if available
  const securePushOffEl = document.getElementById("opt_secure_pushoff") as HTMLInputElement | null;
  const securePushOff = securePushOffEl?.checked;
  if (securePushOff) {
    const levelsInput = document.getElementById("extra_pushoff_levels") as HTMLInputElement | null;
    const levels = levelsInput?.value || "1";
    settingsInfo.push(`secure_pushoff_${levels}x`);
  }

  const cooldownEnabledEl = document.getElementById("opt_cooldown_fans_wait") as HTMLInputElement | null;
  const cooldownEnabled = cooldownEnabledEl?.checked;
  if (cooldownEnabled) {
    const tempInput = document.getElementById("cooldown_target_bed_temp") as HTMLInputElement | null;
    const timeInput = document.getElementById("cooldown_max_time") as HTMLInputElement | null;
    const temp = tempInput?.value || "40";
    const time = timeInput?.value || "5";
    settingsInfo.push(`cooldown_${temp}C_${time}min`);
  }

  const raiseBedEl = document.getElementById("opt_raise_bed_after_cooldown") as HTMLInputElement | null;
  const raiseBed = raiseBedEl?.checked;
  if (raiseBed) {
    const offsetInput = document.getElementById("user_bed_raise_offset") as HTMLInputElement | null;
    const offset = offsetInput?.value || "30";
    settingsInfo.push(`bed_raise_${offset}mm`);
  }

  const testFileExportEl = document.getElementById("opt_test_file_export") as HTMLInputElement | null;
  const testFileExport = testFileExportEl?.checked;
  if (testFileExport) {
    settingsInfo.push("test_file_mode");
  }

  const loopsInput = document.getElementById("loops") as HTMLInputElement | null;
  const loops = loopsInput?.value || "1";
  if (parseInt(loops) > 1) {
    settingsInfo.push(`loops_${loops}x`);
  }

  const settingsStr = settingsInfo.length > 0 ? ` settings:[${settingsInfo.join(",")}]` : "";

  // Only include submode for swap mode
  let modeStr = `mode:${appMode}`;
  if (appMode === "swap") {
    const subMode = getSubmodeForExport();
    modeStr += ` submode:${subMode}`;
  }

  const comment = `; autoeject printer:${printerModel} ${modeStr} plates:${totalPlates}${settingsStr} date:${currentDate}`;

  // Add comment at the very beginning
  return comment + '\n' + gcode;
}

/**
 * Build rule context for GCODE processing
 */
function buildRuleContext(plateIndex: number, extra: Partial<RuleContext> = {}): RuleContext {
  // Collect settings from UI for this plate
  const settings = collectSettingsForPlate(plateIndex);

  return {
    mode: state.PRINTER_MODEL,
    appMode: state.APP_MODE,
    plateIndex,
    totalPlates: extra.totalPlates ?? 0,
    isLastPlate: (extra.totalPlates ? plateIndex === extra.totalPlates - 1 : false),
    settings, // Add settings to context
    ...extra
  };
}

/**
 * Download a file by creating a temporary anchor element
 */
export function download(filename: string, datafileurl: string): void {
  const element = document.createElement('a');
  console.log("datafileurl", datafileurl);
  element.setAttribute('href', datafileurl);
  element.setAttribute('download', filename);
  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
  console.log("download_started");
}

/**
 * Calculate MD5 hash of a file in chunks to avoid memory issues
 */
export function chunked_md5(my_content: Blob, callback: (hash: string) => void): void {
  const blobSlice = File.prototype.slice || (File.prototype as unknown as { mozSlice?: typeof File.prototype.slice }).mozSlice || (File.prototype as unknown as { webkitSlice?: typeof File.prototype.slice }).webkitSlice;
  const chunkSize = 2097152;
  const chunks = Math.ceil(my_content.size / chunkSize);
  let currentChunk = 0;
  const spark = new SparkMD5.ArrayBuffer();
  const fileReader = new FileReader();

  fileReader.onload = function (e: ProgressEvent<FileReader>) {
    console.log('read chunk nr', currentChunk + 1, 'of', chunks);
    const result = e.target?.result;
    if (result && result instanceof ArrayBuffer) {
      spark.append(result);
    }
    currentChunk++;
    update_progress(25 + 50 / chunks * currentChunk);

    if (currentChunk < chunks) {
      loadNext();
    } else {
      const my_hash = spark.end();
      console.log('finished loading');
      console.info('computed hash', my_hash);
      callback(my_hash);
    }
  };

  fileReader.onerror = function () {
    console.warn('oops, something went wrong.');
  };

  function loadNext(): void {
    const start = currentChunk * chunkSize;
    const end = ((start + chunkSize) >= my_content.size) ? my_content.size : start + chunkSize;

    if (blobSlice) {
      fileReader.readAsArrayBuffer(blobSlice.call(my_content, start, end));
    }
  }

  loadNext();
}

/**
 * Collect and transform all active plates with various processing options
 */
export async function collectAndTransform(
  { applyRules = true, applyOptimization = true, amsOverride = true }: CollectAndTransformOptions = {}
): Promise<CollectAndTransformResult> {
  const my_plates = state.playlist_ol?.getElementsByTagName("li");
  if (!my_plates) {
    return { empty: true };
  }

  const platesOnce: string[] = [];
  const coordsOnce: number[][] = [];
  const originIdxOnce: number[] = [];
  const uiIdxOnce: number[] = [];  // Track which UI plate index this processed plate corresponds to

  for (let i = 0; i < my_plates.length; i++) {
    const li = my_plates[i];
    if (!li) continue;
    const c_f_id_el = li.getElementsByClassName("f_id")[0] as HTMLElement | undefined;
    const c_f_id = c_f_id_el?.title || "";
    const c_file = state.my_files[parseInt(c_f_id)];
    const c_pname_el = li.getElementsByClassName("p_name")[0] as HTMLElement | undefined;
    const c_pname = c_pname_el?.title || "";
    const p_rep_el = li.getElementsByClassName("p_rep")[0] as HTMLInputElement | undefined;
    const p_rep = (p_rep_el?.value ? parseFloat(p_rep_el.value) : 0) || 0;

    if (p_rep > 0 && li) {
      const z = await JSZip.loadAsync(c_file);
      const plateFile = z.file(c_pname);
      if (!plateFile) continue;
      const plateText = await plateFile.async("text");
      const xsDesc = readPlateXCoordsSorted(li); // absteigend
      for (let r = 0; r < p_rep; r++) {
        platesOnce.push(plateText);
        coordsOnce.push(xsDesc);
        originIdxOnce.push(i);
        uiIdxOnce.push(i);  // Each repetition uses the same UI plate index
      }
    }
  }

  if (platesOnce.length === 0) {
    showWarning("No active plates (Repeats=0).");
    update_progress(-1);
    return { empty: true };
  }

  const lis = state.playlist_ol?.getElementsByTagName("li");
  if (!lis) {
    return { empty: true };
  }

  // Map leeren und neu füllen
  state.GLOBAL_AMS.overridesPerPlate.clear();
  console.log(`Processing ${lis.length} UI plates for AMS overrides`);

  for (let i = 0; i < lis.length; i++) {
    const currentLi = lis[i];
    if (!currentLi) continue;
    const repEl = currentLi.getElementsByClassName("p_rep")[0] as HTMLInputElement | undefined;
    const p_rep = parseFloat(repEl?.value || "0") || 0;
    console.log(`Plate ${i}: repetitions=${p_rep}`);
    if (p_rep <= 0) continue; // inaktiv -> ignorieren

    const ov = _computeOverridesForLi(currentLi);
    console.log(`Plate ${i}: computed overrides =`, ov);
    if (Object.keys(ov).length) {
      state.GLOBAL_AMS.overridesPerPlate.set(i, ov);
      console.log(`Plate ${i}: overrides stored in map`);
    } else {
      console.log(`Plate ${i}: no overrides to store`);
    }
  }

  // Get loops value early so we can calculate total plates correctly
  const loopsInput = document.getElementById("loops") as HTMLInputElement | null;
  const loops = Math.max(1, (loopsInput ? parseFloat(loopsInput.value) : 1) || 1);

  // Total plates AFTER loop repeats are applied
  const totalPlatesAfterLoops = platesOnce.length * loops;

  const modifiedPerPlate = applyRules
    ? platesOnce.map((src, i) => {
      const ctx = buildRuleContext(i, {
        totalPlates: totalPlatesAfterLoops,
        coords: coordsOnce[i] || [],
        sourcePlateText: src,
      });

      console.log(`\n===== RULE PASS for plate ${i + 1}/${platesOnce.length} (total after loops: ${totalPlatesAfterLoops}, mode=${state.PRINTER_MODEL}) =====`);
      let out = applySwapRulesToGcode(src, (SWAP_RULES || []), ctx);

      // Plate marker is now added by swap rules

      if (amsOverride) {
        const uiIdx = uiIdxOnce[i];
        if (uiIdx !== undefined) {
          out = applyAmsOverridesToPlate(out, uiIdx);  // Use UI index instead of origin index
        }
      }
      return out;
    })
    : platesOnce.slice();

  // Use streaming approach for large arrays to avoid RangeError
  function safeJoinArray(arr: string[], separator: string = "\n", chunkSize: number = 1000): string {
    if (arr.length <= chunkSize) {
      try {
        return arr.join(separator);
      } catch (e) {
        // Fallback to manual concatenation if even small chunks fail
        return manualJoin(arr, separator);
      }
    }

    return manualJoin(arr, separator);
  }

  function manualJoin(arr: string[], separator: string): string {
    if (arr.length === 0) return "";
    if (arr.length === 1) return arr[0] || "";

    let result = arr[0] || "";
    for (let i = 1; i < arr.length; i++) {
      result += separator + (arr[i] || "");
    }
    return result;
  }

  const originalFlat = Array(loops).fill(platesOnce).flat();
  // Create independent copies for each loop iteration to avoid reference issues
  let modifiedLooped: string[] = [];
  for (let loop = 0; loop < loops; loop++) {
    // Clone each plate's gcode string (strings are immutable, but we need a new array)
    modifiedLooped.push(...modifiedPerPlate);
  }
  if (applyOptimization) modifiedLooped = optimizeAMSBlocks(modifiedLooped);

  // Apply M73 progress transformations based on user settings
  const layerProgressMode = getLayerProgressMode();
  const percentageProgressMode = getPercentageProgressMode();

  if (layerProgressMode === 'global') {
    console.log('[M73 Transform] Applying global layer progress transformation');
    modifiedLooped = transformM73LayerProgressGlobal(modifiedLooped);
  } else if (layerProgressMode === 'per_plate') {
    console.log('[M73 Transform] Applying per-plate layer progress (inserting M73.2 R1.0 commands)');
    modifiedLooped = insertM73ResetCommands(modifiedLooped);
  }

  if (percentageProgressMode === 'global') {
    console.log('[M73 Transform] Applying global percentage progress transformation');
    modifiedLooped = transformM73PercentageProgressGlobal(modifiedLooped);
  }

  // Update GCODE header "total layer number" if global layer progress is enabled
  if (layerProgressMode === 'global' && modifiedLooped.length > 0) {
    const globalMaxLayerIndex = calculateTotalGlobalLayers(modifiedLooped);
    const totalLayerCount = globalMaxLayerIndex + 1; // Convert 0-based index to 1-based count

    console.log(`[Header Update] Updating first plate header with total layer count: ${totalLayerCount}`);

    // Update the header in the first plate only (where the header is located)
    const firstPlate = modifiedLooped[0];
    if (firstPlate) {
      modifiedLooped[0] = updateTotalLayerNumberHeader(firstPlate, totalLayerCount);
    }
  }

  // Apply "Don't swap last plate" post-processing if enabled
  const dontSwapLastPlateCheckbox = document.getElementById("opt_dont_swap_last_plate") as HTMLInputElement | null;
  const dontSwapLastPlateEnabled = dontSwapLastPlateCheckbox && dontSwapLastPlateCheckbox.checked;

  if (dontSwapLastPlateEnabled && modifiedLooped.length > 0 && state.APP_MODE === 'swap') {
    console.log('[Don\'t Swap Last Plate] Removing end sequence from last plate (index:', modifiedLooped.length - 1, ')');
    const lastPlateIndex = modifiedLooped.length - 1;
    let lastPlateGcode = modifiedLooped[lastPlateIndex] || "";

    // Find and remove the end sequence block using standardized GCODE markers
    // Pattern matches the plate swap sequences with unified format:
    // - A1M: ; ==== A1M PLATE_SWAP_FULL ==== ... ; ==== A1M PLATE_SWAP_FULL END ====
    // - A1 (all variants): ; ==== A1 PLATE_SWAP_FULL ==== ... ; ==== A1 PLATE_SWAP_FULL END ====
    // Each variant also includes a subtype comment like ; === swapmod: JOBOX
    // Uses capture group to ensure same prefix (A1 or A1M) at start and end
    const endSegPattern = /; ==== (A1M?) PLATE_SWAP_FULL ====[\s\S]*?; ==== \1 PLATE_SWAP_FULL END ====\n?/;
    const before = lastPlateGcode;
    lastPlateGcode = lastPlateGcode.replace(endSegPattern, '');

    if (before !== lastPlateGcode) {
      const removed = before.length - lastPlateGcode.length;
      console.log('[Don\'t Swap Last Plate] Successfully removed end sequence (removed', removed, 'chars)');
      modifiedLooped[lastPlateIndex] = lastPlateGcode;
    } else {
      console.warn('[Don\'t Swap Last Plate] No end sequence markers found in last plate');
    }
  }

  // Check if test file export is enabled - if so, convert each plate to test file
  const testFileCheckbox = document.getElementById("opt_test_file_export") as HTMLInputElement | null;
  const isTestFileExport = testFileCheckbox && testFileCheckbox.checked;
  if (isTestFileExport) {
    // IMPORTANT: Test file mode is ONLY for SWAP mode, never for push-off mode
    if (state.APP_MODE === 'pushoff') {
      console.warn('Test file export is not supported in Push-off mode. Ignoring checkbox.');
    } else {
      // Check if we're in SWAP mode for special handling
      const isSwapMode = state.APP_MODE === 'swap' && (state.PRINTER_MODEL === 'A1M' || state.PRINTER_MODEL === 'A1');

      if (isSwapMode) {
        modifiedLooped = createSwapTestFile(modifiedLooped.length);
      } else {
        modifiedLooped = modifiedLooped.map(gcode => convertToTestFile(gcode));
      }
    }
  }

  // Lazy evaluation for combined strings to avoid memory issues
  const result: CollectAndTransformResult = {
    empty: false,
    platesOnce,
    modifiedPerPlate,
    modifiedLooped: modifiedLooped.map((gcode, index) => addAutoEjectComment(gcode, index, totalPlatesAfterLoops)), // Add autoeject comment to each plate
    get originalCombined(): string {
      // Only create the string when accessed
      return safeJoinArray(originalFlat);
    },
    get modifiedCombined(): string {
      // Only create the string when accessed
      return safeJoinArray(this.modifiedLooped || []); // Use this.modifiedLooped which already has comments
    }
  };

  return result;
}

/**
 * Helper function to convert GCODE to test file (remove body section)
 */
function convertToTestFile(gcode: string): string {
  const sections = splitIntoSections(gcode);
  return joinSectionsTestMode(sections);
}

/**
 * Helper function to create SWAP test file: 1x START + Nx END sequences
 */
function createSwapTestFile(plateCount: number): string[] {
  const isA1M = state.PRINTER_MODEL === 'A1M';
  const isA1 = state.PRINTER_MODEL === 'A1';

  if (!isA1M && !isA1) {
    console.warn('createSwapTestFile called for unsupported mode:', state.PRINTER_MODEL);
    return [];
  }

  // Get the appropriate start and end sequences based on logo selection
  let startSequence: string;
  let endSequence: string;

  if (isA1M) {
    startSequence = SWAP_START_A1M;
    endSequence = SWAP_END_A1M;
  } else {
    // A1 mode - check logo selection
    if (state.SWAP_MODE === 'printflow') {
      startSequence = A1_PRINTFLOW_START;
      endSequence = A1_PRINTFLOW_END;
    } else if (state.SWAP_MODE === 'jobox') {
      startSequence = A1_JOBOX_START;
      endSequence = A1_JOBOX_END;
    } else {
      startSequence = A1_3Print_START;
      endSequence = A1_3Print_END;
    }
  }

  // Get wait time from UI input
  const waitTimeInput = document.getElementById("test_wait_time") as HTMLInputElement | null;
  const waitSeconds = waitTimeInput ? parseInt(waitTimeInput.value) || 30 : 30;

  // Create test file content with new extended sequence
  const testFileContent = [
    '; SWAP TEST FILE - Start and End Sequences Only',
    '; Generated by AutoEject - SWAP Test File Mode',
    `; Mode: ${state.PRINTER_MODEL} - ${plateCount} plate changes`,
    `; Submode: ${state.SWAP_MODE || '3print'}`,
    '; PRINT BODIES REMOVED FOR TEST FILE',
    `; (${plateCount} plates of actual printing code would be here)`,
    '',
    '; Turn off heaters for safety during test',
    HEATERS_OFF,
    '',
    `; Wait ${waitSeconds} seconds`,
    generateWaitCommand(waitSeconds).trim(),
    '',
    '; Start sound',
    START_SOUND_A1M,
    '',
    '; Start sequence',
    startSequence,
    '',
    '; Home all axes',
    HOMING_All_AXES,
    '',
    '; End sound after start',
    END_SOUND_A1M,
    '',
  ];

  // Add end sequences + sound for each plate
  for (let i = 0; i < plateCount; i++) {
    testFileContent.push(`; End sequence ${i + 1}`);
    testFileContent.push(endSequence);
    testFileContent.push('');
    testFileContent.push(`; End sound ${i + 1}`);
    testFileContent.push(END_SOUND_A1M);
    if (i < plateCount - 1) {
      testFileContent.push(''); // Empty line between plates
    }
  }

  const finalContent = testFileContent.join('\n');

  // Return as array with single element (like normal GCODE processing)
  return [finalContent];
}

/**
 * Compute AMS slot overrides for a specific plate element
 */
function _computeOverridesForLi(li: HTMLElement): AMSSlotMapping {
  const map: AMSSlotMapping = {};
  li.querySelectorAll(".p_filament .f_slot").forEach(fslot => {
    const slotEl = fslot as HTMLElement;
    const old1 = parseInt(slotEl?.dataset?.['origSlot'] || "0", 10); // 1..4
    const now1Text = (slotEl?.textContent || "").trim() || "0";
    const now1 = parseInt(now1Text, 10); // 1..4
    if (Number.isFinite(old1) && Number.isFinite(now1) && old1 >= 1 && now1 >= 1 && old1 !== now1) {
      // A1M: P ist 0 → key "P0S<idx>"
      const fromKey = `P0S${old1 - 1}`;
      const toKey = `P0S${now1 - 1}`;
      map[fromKey] = toKey;
    }
  });
  return map;
}
