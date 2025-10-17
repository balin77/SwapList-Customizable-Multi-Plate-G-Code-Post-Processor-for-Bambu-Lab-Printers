// /src/io/ioUtils.js

// /src/io/buildPipeline.js
import JSZip from "jszip";
import SparkMD5 from "spark-md5";
import { update_progress } from "../ui/progressbar.js";
import { state } from "../config/state.js";
import { readPlateXCoordsSorted } from "../ui/plates.js";
import { applySwapRulesToGcode } from "../commands/applySwapRules.js";
import { applyAmsOverridesToPlate } from "../gcode/gcodeManipulation.js";

// Helper function to get correct submode based on printer model
export function getSubmodeForExport() {
  const mode = state.APP_MODE || "swap";
  if (mode !== "swap") return null;

  // A1M always uses "swaplist" submode
  if (state.PRINTER_MODEL === "A1M") {
    return "swaplist";
  }

  // For other printers, use the selected SWAP_MODE or default to "3print"
  return state.SWAP_MODE || "3print";
}

// Helper function to generate complete filename format with loop count
export function generateFilenameFormat(baseName = "output", includeExtension = true) {
  const loops = document.getElementById("loops")?.value || "1";
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
import { optimizeAMSBlocks } from "../gcode/gcodeManipulation.js";
import { SWAP_RULES } from "../commands/swapRules.js";
import { showError, showWarning } from "../ui/infobox.js";
import { splitIntoSections, joinSectionsTestMode } from "../gcode/readGcode.js";
import { SWAP_START_A1M, SWAP_END_A1M, A1_3Print_START, A1_3Print_END, A1_PRINTFLOW_START, A1_PRINTFLOW_END, A1_JOBOX_START, A1_JOBOX_END, HOMING_All_AXES, HOMING_XY_AXES, GCODE_WAIT_30SECONDS, generateWaitCommand, START_SOUND_A1M, END_SOUND_A1M } from "../commands/swapRules.js";

// Function to add clearbed processing comment at the beginning of GCODE
function addClearbedComment(gcode, plateIndex = 0, totalPlates = 1) {
  const currentDate = new Date().toISOString();
  const printerModel = state.PRINTER_MODEL || "unknown";
  const appMode = state.APP_MODE || "swap";

  // Get active settings info
  const settingsInfo = [];

  // Check common settings that might be active
  if (state.OVERRIDE_METADATA) {
    settingsInfo.push("metadata_override");
  }

  // Get settings from UI elements if available
  const securePushOff = document.getElementById("opt_secure_pushoff")?.checked;
  if (securePushOff) {
    const levels = document.getElementById("extra_pushoff_levels")?.value || "1";
    settingsInfo.push(`secure_pushoff_${levels}x`);
  }

  const cooldownEnabled = document.getElementById("opt_cooldown_fans_wait")?.checked;
  if (cooldownEnabled) {
    const temp = document.getElementById("cooldown_target_bed_temp")?.value || "40";
    const time = document.getElementById("cooldown_max_time")?.value || "5";
    settingsInfo.push(`cooldown_${temp}C_${time}min`);
  }

  const raiseBed = document.getElementById("opt_raise_bed_after_cooldown")?.checked;
  if (raiseBed) {
    const offset = document.getElementById("user_bed_raise_offset")?.value || "30";
    settingsInfo.push(`bed_raise_${offset}mm`);
  }

  const testFileExport = document.getElementById("opt_test_file_export")?.checked;
  if (testFileExport) {
    settingsInfo.push("test_file_mode");
  }

  const loops = document.getElementById("loops")?.value || "1";
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

  const comment = `; clearbed printer:${printerModel} ${modeStr} plates:${totalPlates}${settingsStr} date:${currentDate}`;

  // Add comment at the very beginning
  return comment + '\n' + gcode;
}


function buildRuleContext(plateIndex, extra = {}) {
  return {
    mode: state.PRINTER_MODEL,
    appMode: state.APP_MODE,
    plateIndex,
    totalPlates: extra.totalPlates ?? 0,
    isLastPlate: (extra.totalPlates ? plateIndex === extra.totalPlates - 1 : false),
    ...extra
  };
}

export function download(filename, datafileurl) {
  var element = document.createElement('a');
  console.log("datafileurl", datafileurl);
  element.setAttribute('href', datafileurl);
  element.setAttribute('download', filename);
  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
  console.log("download_started");
}

export function chunked_md5(my_content, callback) {
  var blobSlice = File.prototype.slice || File.prototype.mozSlice || File.prototype.webkitSlice,
    chunkSize = 2097152,
    chunks = Math.ceil(my_content.size / chunkSize),
    currentChunk = 0,
    spark = new SparkMD5.ArrayBuffer(),
    fileReader = new FileReader();

  fileReader.onload = function (e) {
    console.log('read chunk nr', currentChunk + 1, 'of', chunks);
    spark.append(e.target.result);
    currentChunk++;
    update_progress(25 + 50 / chunks * currentChunk);

    if (currentChunk < chunks) {
      loadNext();
    } else {
      var my_hash = spark.end();
      console.log('finished loading');
      console.info('computed hash', my_hash);
      callback(my_hash);
    }
  };

  fileReader.onerror = function () {
    console.warn('oops, something went wrong.');
  };

  function loadNext() {
    var start = currentChunk * chunkSize,
      end = ((start + chunkSize) >= my_content.size) ? my_content.size : start + chunkSize;

    fileReader.readAsArrayBuffer(blobSlice.call(my_content, start, end));
  }

  loadNext();
}

export async function collectAndTransform({ applyRules = true, applyOptimization = true, loopsValue, amsOverride = true } = {}) {
  const my_plates = state.playlist_ol.getElementsByTagName("li");
  const platesOnce = [];
  const coordsOnce = [];
  const originIdxOnce = [];
  const uiIdxOnce = [];  // Track which UI plate index this processed plate corresponds to

  for (let i = 0; i < my_plates.length; i++) {
    const li = my_plates[i];
    const c_f_id = li.getElementsByClassName("f_id")[0].title;
    const c_file = state.my_files[c_f_id];
    const c_pname = li.getElementsByClassName("p_name")[0].title;
    const p_rep = li.getElementsByClassName("p_rep")[0].value * 1;

    if (p_rep > 0) {
      const z = await JSZip.loadAsync(c_file);
      const plateText = await z.file(c_pname).async("text");
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

  const lis = state.playlist_ol.getElementsByTagName("li");
  // Map leeren und neu füllen
  state.GLOBAL_AMS.overridesPerPlate.clear();
  console.log(`Processing ${lis.length} UI plates for AMS overrides`);
  
  for (let i = 0; i < lis.length; i++) {
    const repEl = lis[i].getElementsByClassName("p_rep")[0];
    const p_rep = parseFloat(repEl?.value) || 0;
    console.log(`Plate ${i}: repetitions=${p_rep}`);
    if (p_rep <= 0) continue; // inaktiv -> ignorieren
    
    const ov = _computeOverridesForLi(lis[i]);
    console.log(`Plate ${i}: computed overrides =`, ov);
    if (Object.keys(ov).length) {
      state.GLOBAL_AMS.overridesPerPlate.set(i, ov);
      console.log(`Plate ${i}: overrides stored in map`);
    } else {
      console.log(`Plate ${i}: no overrides to store`);
    }
  }

  const totalPlates = platesOnce.length;

  const modifiedPerPlate = applyRules
    ? platesOnce.map((src, i) => {
      const ctx = buildRuleContext(i, {
        totalPlates,
        coords: coordsOnce[i] || [],
        sourcePlateText: src,
      });

      console.log(`\n===== RULE PASS for plate ${i + 1}/${totalPlates} (mode=${state.PRINTER_MODEL}) =====`);
      let out = applySwapRulesToGcode(src, (SWAP_RULES || []), ctx);
      
      // Plate marker is now added by swap rules
      
      if (amsOverride) {
        out = applyAmsOverridesToPlate(out, uiIdxOnce[i]);  // Use UI index instead of origin index
      }
      return out;
    })
    : platesOnce.slice();

  const loops = Math.max(1, (document.getElementById("loops").value * 1) || 1);
  
  // Use streaming approach for large arrays to avoid RangeError
  function safeJoinArray(arr, separator = "\n", chunkSize = 1000) {
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
  
  function manualJoin(arr, separator) {
    if (arr.length === 0) return "";
    if (arr.length === 1) return arr[0];
    
    let result = arr[0];
    for (let i = 1; i < arr.length; i++) {
      result += separator + arr[i];
    }
    return result;
  }
  
  const originalFlat = Array(loops).fill(platesOnce).flat();
  let modifiedLooped = Array(loops).fill(modifiedPerPlate).flat();
  if (applyOptimization) modifiedLooped = optimizeAMSBlocks(modifiedLooped);

  // Check if test file export is enabled - if so, convert each plate to test file
  const testFileCheckbox = document.getElementById("opt_test_file_export");
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
  const result = {
    empty: false,
    platesOnce,
    modifiedPerPlate,
    modifiedLooped: modifiedLooped.map((gcode, index) => addClearbedComment(gcode, index, totalPlates)), // Add clearbed comment to each plate
    get originalCombined() {
      // Only create the string when accessed
      return safeJoinArray(originalFlat);
    },
    get modifiedCombined() {
      // Only create the string when accessed
      return safeJoinArray(this.modifiedLooped); // Use this.modifiedLooped which already has comments
    }
  };
  
  return result;
}

// Helper function to convert GCODE to test file (remove body section)
function convertToTestFile(gcode) {
  const sections = splitIntoSections(gcode);
  return joinSectionsTestMode(sections);
}

// Helper function to create SWAP test file: 1x START + Nx END sequences
function createSwapTestFile(plateCount) {
  const isA1M = state.PRINTER_MODEL === 'A1M';
  const isA1 = state.PRINTER_MODEL === 'A1';

  if (!isA1M && !isA1) {
    console.warn('createSwapTestFile called for unsupported mode:', state.PRINTER_MODEL);
    return [];
  }

  // Get the appropriate start and end sequences based on logo selection
  let startSequence, endSequence;

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
  const waitTimeInput = document.getElementById("test_wait_time");
  const waitSeconds = waitTimeInput ? parseInt(waitTimeInput.value) || 30 : 30;

  // Create test file content with new extended sequence
  const testFileContent = [
    '; SWAP TEST FILE - Start and End Sequences Only',
    '; Generated by Clearbed - SWAP Test File Mode',
    `; Mode: ${state.PRINTER_MODEL} - ${plateCount} plate changes`,
    `; Submode: ${state.SWAP_MODE || '3print'}`,
    '; PRINT BODIES REMOVED FOR TEST FILE',
    `; (${plateCount} plates of actual printing code would be here)`,
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

function _computeOverridesForLi(li) {
  const map = {};
  li.querySelectorAll(".p_filament .f_slot").forEach(fslot => {
    const old1 = parseInt(fslot?.dataset?.origSlot || "0", 10); // 1..4
    const now1 = parseInt((fslot?.textContent || "").trim() || "0", 10); // 1..4
    if (Number.isFinite(old1) && Number.isFinite(now1) && old1 >= 1 && now1 >= 1 && old1 !== now1) {
      // A1M: P ist 0 → key "P0S<idx>"
      const fromKey = `P0S${old1 - 1}`;
      const toKey = `P0S${now1 - 1}`;
      map[fromKey] = toKey;
    }
  });
  return map;
}

