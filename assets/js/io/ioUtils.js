// /src/io/ioUtils.js

// /src/io/buildPipeline.js
import JSZip from "jszip";
import SparkMD5 from "spark-md5";
import { update_progress } from "../ui/progressbar.js";
import { state } from "../config/state.js";
import { readPlateXCoordsSorted } from "../ui/plates.js";
import { applySwapRulesToGcode } from "../commands/applySwapRules.js";
import { applyAmsOverridesToPlate } from "../gcode/gcodeManipulation.js";
import { optimizeAMSBlocks } from "../gcode/gcodeManipulation.js";
import { SWAP_RULES } from "../commands/swapRules.js";
import { showError, showWarning } from "../ui/infobox.js";
import { splitIntoSections, joinSectionsTestMode } from "../gcode/readGcode.js";
import { SWAP_START_A1M, SWAP_END_A1M, A1_3Print_START, A1_3Print_END } from "../commands/swapRules.js";


function buildRuleContext(plateIndex, extra = {}) {
  return {
    mode: state.CURRENT_MODE,
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

      console.log(`\n===== RULE PASS for plate ${i + 1}/${totalPlates} (mode=${state.CURRENT_MODE}) =====`);
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
    // Check if we're in SWAP mode for special handling
    const isSwapMode = state.APP_MODE === 'swap' && (state.CURRENT_MODE === 'A1M' || state.CURRENT_MODE === 'A1');

    if (isSwapMode) {
      modifiedLooped = createSwapTestFile(modifiedLooped.length);
    } else {
      modifiedLooped = modifiedLooped.map(gcode => convertToTestFile(gcode));
    }
  }

  // Lazy evaluation for combined strings to avoid memory issues
  const result = {
    empty: false,
    platesOnce,
    modifiedPerPlate,
    modifiedLooped,
    get originalCombined() {
      // Only create the string when accessed
      return safeJoinArray(originalFlat);
    },
    get modifiedCombined() {
      // Only create the string when accessed  
      return safeJoinArray(modifiedLooped);
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
  const isA1M = state.CURRENT_MODE === 'A1M';
  const isA1 = state.CURRENT_MODE === 'A1';

  if (!isA1M && !isA1) {
    console.warn('createSwapTestFile called for unsupported mode:', state.CURRENT_MODE);
    return [];
  }

  // Get the appropriate start and end sequences
  const startSequence = isA1M ? SWAP_START_A1M : A1_3Print_START;
  const endSequence = isA1M ? SWAP_END_A1M : A1_3Print_END;

  // Create test file content
  const testFileContent = [
    '; SWAP TEST FILE - Start and End Sequences Only',
    '; Generated by SwapList.app - SWAP Test File Mode',
    `; Mode: ${state.CURRENT_MODE} - ${plateCount} plate changes`,
    '',
    startSequence,
    '',
    '; PRINT BODIES REMOVED FOR TEST FILE',
    `; (${plateCount} plates of actual printing code would be here)`,
    ''
  ];

  // Add one end sequence for each plate
  for (let i = 0; i < plateCount; i++) {
    testFileContent.push(`; ==== PLATE ${i + 1} END SEQUENCE ====`);
    testFileContent.push(endSequence);
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

