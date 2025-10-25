import JSZip from "jszip";
import { state } from "../config/state.js";
import { update_progress } from "../ui/progressbar.js";
import { validatePlateXCoords } from "../ui/plates.js";
import { download, collectAndTransform, chunked_md5, generateFilenameFormat } from "./ioUtils.js";
import { generateModelSettingsXml } from "../config/xmlConfig.js";
import { colorToHex } from "../utils/colors.js";
import { buildProjectSettingsForUsedSlots } from "../config/materialConfig.js";
import { showError, showWarning } from "../ui/infobox.js";
import { _parseAmsParams } from "../utils/amsUtils.js";
import { createRecoloredPlateImage } from "../utils/imageColorMapping.js";
import { getSlotColor } from "../ui/filamentColors.js";
import { checkAllPlatesRestrictions } from "../commands/plateRestrictions.js";

/**
 * Helper function to convert a blob URL to an ArrayBuffer
 * @param {string} blobUrl - The blob URL to convert
 * @returns {Promise<ArrayBuffer>} The image data as ArrayBuffer
 */
async function blobUrlToArrayBuffer(blobUrl) {
  const response = await fetch(blobUrl);
  const blob = await response.blob();
  return await blob.arrayBuffer();
}

/**
 * Helper function to get recolored PNG data from the UI for a specific plate
 * @param {number} uiPlateIndex - The index of the plate in the UI (0-based)
 * @param {JSZip} baseZip - The base ZIP file containing original PNGs
 * @param {number} originalPlateNumber - The original plate number in the 3MF file
 * @returns {Promise<Object|null>} Object containing recolored PNG data or null
 */
async function getRecoloredPlateImages(uiPlateIndex, baseZip, originalPlateNumber) {
  try {
    // Get the plate element from the UI
    const my_plates = state.playlist_ol.getElementsByTagName("li");
    const plateElement = my_plates[uiPlateIndex];

    if (!plateElement) {
      console.log(`No plate element found at UI index ${uiPlateIndex}`);
      return null;
    }

    const plateIcon = plateElement.querySelector('.p_icon');

    // Check if we have a dynamically recolored image in the UI
    if (!plateIcon || !plateIcon.dataset.litImageUrl || !plateIcon.dataset.unlitImageUrl) {
      console.log(`No recolored image data found for plate at UI index ${uiPlateIndex}`);
      return null;
    }

    // Build color mapping from the plate's filament data
    const colorMapping = {};
    const filamentRows = plateElement.querySelectorAll('.p_filaments .p_filament');

    filamentRows.forEach(row => {
      const swatch = row.querySelector('.f_color');
      const slotSpan = row.querySelector('.f_slot');

      if (swatch && slotSpan) {
        // Get original color from dataset
        const originalColor = swatch.dataset.f_color;

        // Get current slot index
        const slotIndex = parseInt(swatch.dataset.slotIndex || '0', 10);
        const currentSlotColor = getSlotColor(slotIndex);

        if (originalColor && currentSlotColor && originalColor !== currentSlotColor) {
          colorMapping[originalColor] = currentSlotColor;
        }
      }
    });

    // If no color changes, return null to use original PNGs
    if (Object.keys(colorMapping).length === 0) {
      console.log(`No color changes detected for plate at UI index ${uiPlateIndex}`);
      return null;
    }

    console.log(`Creating recolored PNGs for plate ${originalPlateNumber} with color mapping:`, colorMapping);

    // Create the recolored image
    const recoloredBlobUrl = await createRecoloredPlateImage(
      plateIcon.dataset.litImageUrl,
      plateIcon.dataset.unlitImageUrl,
      colorMapping
    );

    // Convert the blob URL to ArrayBuffer
    const recoloredArrayBuffer = await blobUrlToArrayBuffer(recoloredBlobUrl);

    // Clean up the temporary blob URL
    URL.revokeObjectURL(recoloredBlobUrl);

    return {
      plateImage: recoloredArrayBuffer,
      // Note: We only recolor the main plate image (plate_X.png)
      // Other images (top, pick, small, no_light) are kept as original for now
    };

  } catch (error) {
    console.error(`Error creating recolored images for plate at UI index ${uiPlateIndex}:`, error);
    return null;
  }
}

/**
 * Collect all active plates data and check for restrictions
 * @returns {Object} Object containing plate data and warnings
 */
async function collectPlateDataForRestrictionCheck() {
  const allPlatesData = [];
  const my_plates = state.playlist_ol.getElementsByTagName("li");

  console.log('[plateRestrictions] Collecting plate data from', my_plates.length, 'UI plates');

  for (let i = 0; i < my_plates.length; i++) {
    const li = my_plates[i];
    const c_f_id = li.getElementsByClassName("f_id")[0].title;
    const c_pname = li.getElementsByClassName("p_name")[0].title;
    const p_rep = li.getElementsByClassName("p_rep")[0].value * 1;

    if (p_rep > 0) {
      try {
        const zip = await JSZip.loadAsync(state.my_files[c_f_id]);

        // Extract plate name and find corresponding JSON file
        const plateJsonName = c_pname.replace('.gcode', '.json');
        const plateJsonFile = zip.file(plateJsonName);

        if (plateJsonFile) {
          const plateJsonText = await plateJsonFile.async("text");
          const plateData = JSON.parse(plateJsonText);

          console.log(`[plateRestrictions] Loaded plate ${i + 1} (${c_pname}):`, {
            bbox_objects: plateData.bbox_objects?.length || 0,
            bed_type: plateData.bed_type
          });

          allPlatesData.push(plateData);
        } else {
          console.log(`[plateRestrictions] No JSON file found for plate ${c_pname}`);
          allPlatesData.push(null);
        }
      } catch (e) {
        console.warn(`[plateRestrictions] Failed to load plate ${c_pname}:`, e);
        allPlatesData.push(null);
      }
    }
  }

  return allPlatesData;
}

// Generate combined plate_1.json data from all plates
async function generatePlateJsonData() {
  const slotDivs = document
    .getElementById("filament_total")
    ?.querySelectorAll(":scope > div[title]") || [];

  // Build a list of USED slots only (compacted)
  const usedSlots = [];

  // Collect filament data from statistics
  for (let i = 0; i < slotDivs.length; i++) {
    const div = slotDivs[i];

    // Get slot ID (1..4) and convert to 0-based index
    const slotId = parseInt(div.getAttribute("title") || `${i + 1}`, 10) || (i + 1);
    const slotIndex = slotId - 1; // Convert to 0-based for filament_ids (0-3)

    if (slotIndex < 0 || slotIndex > 3) continue; // Skip invalid slots

    // Check if this slot is actually used
    const usedM = parseFloat(div.dataset.used_m || "0") || 0;
    const usedG = parseFloat(div.dataset.used_g || "0") || 0;

    // Only process slots with actual usage
    if (usedM > 0 || usedG > 0) {
      // Get color from swatch (use CURRENT slot color, not original)
      const sw = div.querySelector(":scope > .f_color");
      const colorRaw = sw ? (getComputedStyle(sw).backgroundColor || sw.style.backgroundColor) : "#cccccc";
      const hex = colorToHex(colorRaw || "#cccccc");

      usedSlots.push({
        originalSlotIndex: slotIndex,
        color: hex
      });
    }
  }

  // Sort by original slot index
  usedSlots.sort((a, b) => a.originalSlotIndex - b.originalSlotIndex);

  // Build compacted arrays (no gaps)
  const filament_colors = [];
  const filament_ids = [];

  usedSlots.forEach((slot, compactedIndex) => {
    filament_colors.push(slot.color);
    filament_ids.push(compactedIndex); // 0-based compacted index
  });

  console.log(`generatePlateJsonData: ${usedSlots.length} slots COMPACTED, filament_ids=`, filament_ids, 'filament_colors=', filament_colors);

  // Collect bbox objects from all active UI plates (considering repetitions)
  let allBboxObjects = [];
  let usedIds = new Set();
  let firstExtruder = 0;
  let bedType = "textured_plate";
  let isSeqPrint = false;
  let nozzleDiameter = state.NOZZLE_DIAMETER_MM || 0.4;
  let version = 2;

  // Helper function to find next available ID
  const getNextAvailableId = (startId = 1) => {
    let id = startId;
    while (usedIds.has(id)) {
      id++;
    }
    return id;
  };

  // Process UI plates similar to collectAndTransform, considering repetitions
  const my_plates = state.playlist_ol.getElementsByTagName("li");
  console.log('Processing', my_plates.length, 'UI plates for bbox objects');
  
  for (let i = 0; i < my_plates.length; i++) {
    const li = my_plates[i];
    const c_f_id = li.getElementsByClassName("f_id")[0].title;
    const c_pname = li.getElementsByClassName("p_name")[0].title;
    const p_rep = li.getElementsByClassName("p_rep")[0].value * 1;

    console.log(`Plate ${i}: file_id=${c_f_id}, plate_name=${c_pname}, repetitions=${p_rep}`);

    if (p_rep > 0) {
      try {
        const zip = await JSZip.loadAsync(state.my_files[c_f_id]);
        
        // Extract plate name and find corresponding JSON file
        const plateJsonName = c_pname.replace('.gcode', '.json');
        console.log(`Looking for JSON file: ${plateJsonName}`);
        const plateJsonFile = zip.file(plateJsonName);
        
        if (plateJsonFile) {
          console.log(`Found JSON file for plate ${c_pname}`);
          const plateJsonText = await plateJsonFile.async("text");
          const plateData = JSON.parse(plateJsonText);
          
          // Use values from first valid plate for metadata
          if (plateData.first_extruder !== undefined) firstExtruder = plateData.first_extruder;
          if (plateData.bed_type) bedType = plateData.bed_type;
          if (plateData.is_seq_print !== undefined) isSeqPrint = plateData.is_seq_print;
          if (plateData.nozzle_diameter) nozzleDiameter = plateData.nozzle_diameter;
          if (plateData.version) version = plateData.version;
          
          // Add bbox_objects for each repetition of this plate
          if (plateData.bbox_objects && Array.isArray(plateData.bbox_objects)) {
            console.log(`Found ${plateData.bbox_objects.length} bbox objects in plate ${c_pname}`);
            for (let rep = 0; rep < p_rep; rep++) {
              for (const originalBboxObj of plateData.bbox_objects) {
                // Create a copy of the bbox object
                const bboxObj = JSON.parse(JSON.stringify(originalBboxObj));
                
                // Check if ID already exists
                if (usedIds.has(bboxObj.id)) {
                  // Generate new unique ID
                  const newId = getNextAvailableId(bboxObj.id + 1);
                  console.log(`ID collision detected: object "${bboxObj.name}" ID ${bboxObj.id} changed to ${newId} (repetition ${rep + 1})`);
                  bboxObj.id = newId;
                }
                
                usedIds.add(bboxObj.id);
                allBboxObjects.push(bboxObj);
              }
            }
          } else {
            console.log(`No bbox_objects found in plate ${c_pname}:`, plateData.bbox_objects);
          }
        } else {
          console.log(`JSON file not found: ${plateJsonName}`);
          // List all files in Metadata to debug
          const metadataFiles = zip.file(/^Metadata\//);
          console.log('Available Metadata files:', metadataFiles.map(f => f.name));
        }
      } catch (e) {
        console.warn(`Failed to process plate ${c_pname} from file ${c_f_id}:`, e);
      }
    }
  }

  console.log('Total bbox objects collected:', allBboxObjects.length);

  // Calculate overall bounding box from all objects
  let bbox_all = null;
  if (allBboxObjects.length > 0) {
    let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
    
    for (const obj of allBboxObjects) {
      if (obj.bbox && Array.isArray(obj.bbox) && obj.bbox.length >= 4) {
        const [x1, y1, x2, y2] = obj.bbox;
        minX = Math.min(minX, x1);
        minY = Math.min(minY, y1);
        maxX = Math.max(maxX, x2);
        maxY = Math.max(maxY, y2);
      }
    }
    
    if (minX !== Infinity) {
      bbox_all = [minX, minY, maxX, maxY];
    }
  }

  return {
    bbox_all: bbox_all,
    bbox_objects: allBboxObjects,
    bed_type: bedType,
    filament_colors: filament_colors,
    filament_ids: filament_ids,
    first_extruder: firstExtruder,
    is_seq_print: isSeqPrint,
    nozzle_diameter: nozzleDiameter,
    version: version
  };
}


export async function export_3mf() {
  try {
    if (!(await validatePlateXCoords())) return;
    update_progress(5);

    // Check plate area restrictions
    console.log('[plateRestrictions] Starting plate restriction checks');
    const allPlatesData = await collectPlateDataForRestrictionCheck();

    // Determine current submode for A1 in swap mode
    let submode = null;
    if (state.PRINTER_MODEL === 'A1' && state.APP_MODE === 'swap') {
      // Use SWAP_MODE from state ('3print', 'jobox', 'printflow')
      // Default to '3print' if not specified
      submode = state.SWAP_MODE || '3print';
    }

    const warnings = checkAllPlatesRestrictions(
      allPlatesData,
      state.PRINTER_MODEL,
      state.APP_MODE,
      submode
    );

    // Display warnings if any
    if (warnings.length > 0) {
      console.log('[plateRestrictions] Found', warnings.length, 'restriction warnings');
      for (const warning of warnings) {
        if (warning.severity === 'high') {
          showWarning(warning.message);
        } else {
          showWarning(warning.message);
        }
      }
      // Note: We continue with export but show warnings
      // If you want to block export, you can add: return;
    } else {
      console.log('[plateRestrictions] No restriction warnings found');
    }

    // Collect and transform the data
    const result = await collectAndTransform({ applyRules: true, applyOptimization: true, amsOverride: true });
    if (result.empty) {
      showWarning("Keine aktiven Platten (Repeats=0).");
      update_progress(-1);
      return;
    }

    // final GCode payload
    const finalGcodeBlob = new Blob(result.modifiedLooped, { type: "text/x-gcode" });

    update_progress(25);

    // 3MF Basis (always from first file for structure consistency)
    const baseZip = await JSZip.loadAsync(state.my_files[0]);

    const oldPlates = baseZip.file(/plate_\d+\.gcode\b$/);
    oldPlates.forEach(f => baseZip.remove(f.name));

    if (baseZip.file("Metadata/custom_gcode_per_layer.xml")) {
      baseZip.remove("Metadata/custom_gcode_per_layer.xml");
    }

    // Find first active plate and copy its PNG files to plate_1 BEFORE removing files
    const my_plates = state.playlist_ol.getElementsByTagName("li");
    let firstActivePlateIndex = -1;
    
    console.log(`Finding first active plate from ${my_plates.length} plates`);
    for (let i = 0; i < my_plates.length; i++) {
      const li = my_plates[i];
      const p_rep = li.getElementsByClassName("p_rep")[0].value * 1;
      const c_pname = li.getElementsByClassName("p_name")[0].title;
      
      console.log(`UI Position ${i}: plate_name=${c_pname}, repetitions=${p_rep}`);
      
      if (p_rep > 0) {
        // Extract plate number from filename (e.g., "plate_3.gcode" -> 3)
        const plateMatch = c_pname.match(/plate_(\d+)\.gcode/);
        if (plateMatch) {
          firstActivePlateIndex = parseInt(plateMatch[1], 10);
          console.log(`First active plate found: plate_${firstActivePlateIndex} (from filename ${c_pname})`);
          break;
        } else {
          console.warn(`Could not extract plate number from filename: ${c_pname}`);
        }
      }
    }
    
    // Update plate_1 PNG files from first active plate (if it's not already plate_1)
    if (firstActivePlateIndex > 1) {
      try {
        // Remove existing plate_1 PNG files first
        const targetFiles = [
          "Metadata/plate_1.png",
          "Metadata/plate_1_small.png",
          "Metadata/plate_no_light_1.png",
          "Metadata/top_1.png",
          "Metadata/pick_1.png"
        ];

        targetFiles.forEach(targetFile => {
          if (baseZip.file(targetFile)) {
            baseZip.remove(targetFile);
            console.log(`Removed existing ${targetFile}`);
          }
        });

        // Try to get recolored images from the UI for the first active plate
        let firstActivePlateUIIndex = -1;
        for (let i = 0; i < my_plates.length; i++) {
          const li = my_plates[i];
          const p_rep = li.getElementsByClassName("p_rep")[0].value * 1;
          if (p_rep > 0) {
            firstActivePlateUIIndex = i;
            break;
          }
        }

        const recoloredImages = firstActivePlateUIIndex >= 0
          ? await getRecoloredPlateImages(firstActivePlateUIIndex, baseZip, firstActivePlateIndex)
          : null;

        // Copy plate PNG files from first active plate to plate_1 (within same baseZip)
        const pngFiles = [
          `Metadata/plate_${firstActivePlateIndex}.png`,
          `Metadata/plate_${firstActivePlateIndex}_small.png`,
          `Metadata/plate_no_light_${firstActivePlateIndex}.png`,
          `Metadata/top_${firstActivePlateIndex}.png`,
          `Metadata/pick_${firstActivePlateIndex}.png`
        ];

        for (const sourceFile of pngFiles) {
          const targetFile = sourceFile.replace(`_${firstActivePlateIndex}`, "_1");

          // Check if this is the main plate image and we have a recolored version
          if (sourceFile.endsWith(`plate_${firstActivePlateIndex}.png`) && recoloredImages?.plateImage) {
            // Use recolored image
            baseZip.file(targetFile, recoloredImages.plateImage);
            console.log(`Exported recolored ${targetFile}`);
          } else {
            // Use original image
            const file = baseZip.file(sourceFile);
            if (file) {
              const content = await file.async("arraybuffer");
              baseZip.file(targetFile, content);
              console.log(`Copied ${sourceFile} to ${targetFile}`);
            } else {
              console.log(`Source file not found in baseZip: ${sourceFile}`);
            }
          }
        }
      } catch (e) {
        console.warn(`Failed to copy PNG files from plate ${firstActivePlateIndex}:`, e);
      }
    } else if (firstActivePlateIndex === 1) {
      console.log(`First active plate is already plate_1, checking for recolored images`);

      // Find the UI index of the first active plate
      let firstActivePlateUIIndex = -1;
      for (let i = 0; i < my_plates.length; i++) {
        const li = my_plates[i];
        const p_rep = li.getElementsByClassName("p_rep")[0].value * 1;
        if (p_rep > 0) {
          firstActivePlateUIIndex = i;
          break;
        }
      }

      // Try to get recolored images
      const recoloredImages = firstActivePlateUIIndex >= 0
        ? await getRecoloredPlateImages(firstActivePlateUIIndex, baseZip, 1)
        : null;

      // If we have recolored images, replace the plate_1.png
      if (recoloredImages?.plateImage) {
        try {
          baseZip.file("Metadata/plate_1.png", recoloredImages.plateImage);
          console.log(`Exported recolored Metadata/plate_1.png`);
        } catch (e) {
          console.warn(`Failed to update plate_1.png with recolored version:`, e);
        }
      }
    } else {
      console.log(`No active plates found`);
    }

    // Remove unnecessary files (keep only plate_1.* and filament_settings_1.config)
    const filesToRemove = [
      /filament_settings_(?:[2-9]|\d{2,})\.config$/,
      /pick_(?:[2-9]|\d{2,})\.png$/,
      /plate_(?:[2-9]|\d{2,})\.gcode\.md5$/,
      /plate_(?:[2-9]|\d{2,})\.json$/,
      /plate_(?:[2-9]|\d{2,})\.png$/,
      /plate_(?:[2-9]|\d{2,})_small\.png$/,
      /plate_no_light_(?:[2-9]|\d{2,})\.png$/,
      /top_(?:[2-9]|\d{2,})\.png$/
    ];

    filesToRemove.forEach(pattern => {
      const files = baseZip.file(pattern);
      files.forEach(f => baseZip.remove(f.name));
    });

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
    baseZip.file("Metadata/model_settings.config", generateModelSettingsXml());

    const sliceInfoStr = await baseZip.file("Metadata/slice_info.config").async("text");
    const parser = new DOMParser();
    const slicer_config_xml = parser.parseFromString(sliceInfoStr, "text/xml");

    // Add custom header to mark this as a processed SWAP file
    const configElement = slicer_config_xml.querySelector("config");
    if (configElement) {
      const headerElement = configElement.querySelector("header") || slicer_config_xml.createElement("header");
      if (!configElement.querySelector("header")) {
        configElement.insertBefore(headerElement, configElement.firstChild);
      }

      // Add custom header item to mark this as processed
      const customHeaderItem = slicer_config_xml.createElement("header_item");
      customHeaderItem.setAttribute("key", "X-BBL-Clearbed-Processed");
      customHeaderItem.setAttribute("value", new Date().toISOString());
      headerElement.appendChild(customHeaderItem);

      console.log("Added X-BBL-Clearbed-Processed header to slice_info.config");
    }

    // auf eine Plate reduzieren
    const platesXML = slicer_config_xml.getElementsByTagName("plate");
    while (platesXML.length > 1) platesXML[platesXML.length - 1].remove();

    const indexNode = platesXML[0].querySelector("[key='index']");
    if (indexNode) indexNode.setAttribute("value", "1");

    // Stats-Quelle für Verbrauchsdaten
    const slotDivs = document
      .getElementById("filament_total")
      ?.querySelectorAll(":scope > div[title]") || [];

    // Map für Verbrauchsdaten erstellen (Slot-ID -> {usedM, usedG}) und Gesamtgewicht berechnen
    const usageMap = new Map();
    let totalWeight = 0;
    for (let i = 0; i < slotDivs.length; i++) {
      const div = slotDivs[i];
      const usedM = parseFloat(div.dataset.used_m || "0") || 0;
      const usedG = parseFloat(div.dataset.used_g || "0") || 0;
      const slotId = parseInt(div.getAttribute("title") || `${i + 1}`, 10) || (i + 1);
      usageMap.set(slotId, { usedM, usedG });
      totalWeight += usedG;
    }

    if (state.OVERRIDE_METADATA) {
      // Alte Filament-Knoten leeren
      let filamentNodes = platesXML[0].getElementsByTagName("filament");
      while (filamentNodes.length > 0) filamentNodes[filamentNodes.length - 1].remove();

      // Build a list of USED slots only (compacted)
      const usedSlots = [];

      for (let i = 0; i < slotDivs.length; i++) {
        const div = slotDivs[i];
        const slotId = parseInt(div.getAttribute("title") || `${i + 1}`, 10) || (i + 1);

        if (slotId < 1 || slotId > 4) continue; // Skip invalid slots

        // Verbrauch lesen
        const usedM = parseFloat(div.dataset.used_m || "0") || 0;
        const usedG = parseFloat(div.dataset.used_g || "0") || 0;

        // Only process slots with actual usage
        if (usedM > 0 || usedG > 0) {
          // Farbe vom Swatch (use CURRENT slot color, not original)
          const sw = div.querySelector(":scope > .f_color");
          const colorRaw = sw ? (getComputedStyle(sw).backgroundColor || sw.style.backgroundColor) : "#cccccc";
          const hex = colorToHex(colorRaw || "#cccccc");

          // Typ aus dataset lesen oder default PLA
          const type = div.dataset.f_type || "PLA";

          usedSlots.push({
            originalSlotId: slotId,
            usedM,
            usedG,
            hex,
            type
          });
        }
      }

      // Sort by original slot ID
      usedSlots.sort((a, b) => a.originalSlotId - b.originalSlotId);

      console.log(`slice_info.config: Creating ${usedSlots.length} COMPACTED filament nodes (no gaps)`);

      // Create filament nodes with compacted IDs (1, 2, 3, ... no gaps)
      usedSlots.forEach((slotData, compactedIndex) => {
        const compactedSlotId = compactedIndex + 1; // 1-based

        console.log(`  Slot ${slotData.originalSlotId} → ${compactedSlotId} (${slotData.hex})`);

        // Filament-Node schreiben (NUR für benutzte Slots!)
        const filament_tag = slicer_config_xml.createElement("filament");
        filament_tag.id = String(compactedSlotId);
        filament_tag.setAttribute("type", slotData.type);
        filament_tag.setAttribute("color", slotData.hex);
        filament_tag.setAttribute("used_m", String(slotData.usedM));
        filament_tag.setAttribute("used_g", String(slotData.usedG));

        platesXML[0].appendChild(filament_tag);
      });
    } else {
      // Override AUS: alle Filamente von allen aktiven Platten sammeln

      // Sammle alle Filamente von allen aktiven Platten
      const allFilaments = new Map(); // id -> {type, color, used_m, used_g, plateIndex}

      const my_plates = state.playlist_ol.getElementsByTagName("li");
      for (let i = 0; i < my_plates.length; i++) {
        const li = my_plates[i];
        const c_f_id = li.getElementsByClassName("f_id")[0].title;
        const p_rep = li.getElementsByClassName("p_rep")[0].value * 1;

        if (p_rep > 0) {
          try {
            const zip = await JSZip.loadAsync(state.my_files[c_f_id]);
            const plateSliceInfo = await zip.file("Metadata/slice_info.config").async("text");
            const plateParser = new DOMParser();
            const plateXML = plateParser.parseFromString(plateSliceInfo, "text/xml");
            const plateFilaments = plateXML.getElementsByTagName("filament");

            console.log(`Collecting filaments from plate ${i + 1} (${plateFilaments.length} filaments)`);

            for (let j = 0; j < plateFilaments.length; j++) {
              const filament = plateFilaments[j];
              const id = filament.id || filament.getAttribute("id");
              const type = filament.getAttribute("type");
              const color = filament.getAttribute("color");
              const used_m = parseFloat(filament.getAttribute("used_m") || "0");
              const used_g = parseFloat(filament.getAttribute("used_g") || "0");

              if (allFilaments.has(id)) {
                // Konflikt: Filament-ID bereits vorhanden
                const existing = allFilaments.get(id);
                console.log(`Filament ID ${id} conflict: plate ${existing.plateIndex + 1} vs plate ${i + 1}`);

                // Verbrauch addieren, aber Farbe/Typ von niedrigerer Platte behalten
                if (i < existing.plateIndex) {
                  // Aktuelle Platte hat niedrigere Nummer - ihre Werte übernehmen
                  allFilaments.set(id, {
                    type: type,
                    color: color,
                    used_m: existing.used_m + used_m,
                    used_g: existing.used_g + used_g,
                    plateIndex: i
                  });
                  console.log(`Using color/type from plate ${i + 1}, combined usage`);
                } else {
                  // Bestehende Platte hat niedrigere Nummer - nur Verbrauch addieren
                  existing.used_m += used_m;
                  existing.used_g += used_g;
                  console.log(`Keeping color/type from plate ${existing.plateIndex + 1}, combined usage`);
                }
              } else {
                // Neues Filament
                allFilaments.set(id, {
                  type: type,
                  color: color,
                  used_m: used_m,
                  used_g: used_g,
                  plateIndex: i
                });
              }
            }
          } catch (e) {
            console.warn(`Failed to read filaments from plate ${i + 1}:`, e);
          }
        }
      }

      // Alle alten Filament-Knoten entfernen
      const oldFilamentNodes = platesXML[0].getElementsByTagName("filament");
      while (oldFilamentNodes.length > 0) {
        oldFilamentNodes[0].remove();
      }

      // Neue Filament-Knoten aus gesammelten Daten erstellen
      console.log(`Creating ${allFilaments.size} merged filament nodes`);
      for (const [id, data] of allFilaments) {
        // Verbrauchsdaten aus UI überschreiben falls vorhanden
        let finalUsedM = data.used_m;
        let finalUsedG = data.used_g;

        const numericId = parseInt(id, 10);
        if (usageMap.has(numericId)) {
          const uiData = usageMap.get(numericId);
          finalUsedM = uiData.usedM;
          finalUsedG = uiData.usedG;
          console.log(`Override usage for filament ${id} with UI data: ${finalUsedM}m, ${finalUsedG}g`);
        }

        const filament_tag = slicer_config_xml.createElement("filament");
        filament_tag.id = String(id);
        filament_tag.setAttribute("type", data.type || "PLA");
        filament_tag.setAttribute("color", data.color || "#cccccc");
        filament_tag.setAttribute("used_m", String(finalUsedM));
        filament_tag.setAttribute("used_g", String(finalUsedG));

        platesXML[0].appendChild(filament_tag);
      }
    }

    // Weight-Metadaten in allen Fällen aktualisieren
    const weightNode = platesXML[0].querySelector("[key='weight']");
    if (weightNode) {
      weightNode.setAttribute("value", totalWeight.toFixed(2));
    } else {
      // Weight-Node erstellen falls nicht vorhanden
      const weightElement = slicer_config_xml.createElement("metadata");
      weightElement.setAttribute("key", "weight");
      weightElement.setAttribute("value", totalWeight.toFixed(2));
      platesXML[0].appendChild(weightElement);
    }

    const s = new XMLSerializer();
    const tmp_str = s.serializeToString(slicer_config_xml);
    baseZip.file("Metadata/slice_info.config", tmp_str.replace(/></g, ">\n<"));

    // neue Platte
    baseZip.file("Metadata/plate_1.gcode", finalGcodeBlob);

    // Generate plate_1.json with filament data
    if (state.OVERRIDE_METADATA) {
      console.log('=== OVERRIDE_METADATA is enabled, generating plate_1.json ===');
      const plateJsonData = await generatePlateJsonData();
      console.log('Original plateJsonData.first_extruder:', plateJsonData.first_extruder);

      // Update first_extruder based on the first M620 command in the final GCODE
      const finalGcodeText = await finalGcodeBlob.text();
      console.log('Final GCODE preview (first 1000 chars):');
      console.log(finalGcodeText.substring(0, 1000));

      const correctFirstExtruder = extractFirstExtruderFromGcode(finalGcodeText);
      plateJsonData.first_extruder = correctFirstExtruder;

      console.log(`Updated first_extruder from ${plateJsonData.first_extruder} to ${correctFirstExtruder} based on first M620 command`);

      baseZip.file("Metadata/plate_1.json", JSON.stringify(plateJsonData, null, 2));
    } else {
      console.log('=== OVERRIDE_METADATA is disabled, skipping plate_1.json generation ===');
    }

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

      // Generate filename with new format including loop count
      const fileName = generateFilenameFormat(baseName, true);

      const url = URL.createObjectURL(zipBlob);
      download(fileName, url);

      update_progress(100);
      setTimeout(() => update_progress(-1), 400);
    });
  } catch (err) {
    console.error("export_3mf failed:", err);
    showError("Export fehlgeschlagen: " + (err && err.message ? err.message : err));
    update_progress(-1);
  }
}

// Function to extract first_extruder from the first M620 command in GCODE
export function extractFirstExtruderFromGcode(gcodeText) {

  // Split into header and body to avoid processing header commands
  const headerEndIndex = gcodeText.indexOf('; CONFIG_BLOCK_END');
  let bodyPart = gcodeText;

  if (headerEndIndex !== -1) {
    const headerEndPos = headerEndIndex + '; CONFIG_BLOCK_END'.length;
    bodyPart = gcodeText.substring(headerEndPos);
  }

  // Find first M620 command with S parameter (not M620.1 or M620.3 or M620 M)
  const m620Match = bodyPart.match(/^\s*M620(?!\.)\s+([^M\n\r]*S[^\n\r]*)/m);

  if (m620Match) {
    const params = m620Match[1];
    const { s } = _parseAmsParams(params);

    console.log(`Found first M620 command: M620${params}`);
    console.log(`Extracted S parameter: ${s}, returning first_extruder: ${s}`);

    // S parameter is 0-based, first_extruder is also 0-based
    return s !== 255 ? s : 0; // 255 means auto/unspecified, default to 0
  }

  console.log('No M620 command found in GCODE body, defaulting first_extruder to 0');
  return 0; // Default to extruder 0 if no M620 found
}
