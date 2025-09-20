import JSZip from "jszip";
import { state } from "../config/state.js";
import { update_progress } from "../ui/progressbar.js";
import { validatePlateXCoords } from "../ui/plates.js";
import { download, collectAndTransform, chunked_md5 } from "./ioUtils.js";
import { model_settings_xml } from "../config/xmlConfig.js";
import { colorToHex } from "../utils/colors.js";
import { buildProjectSettingsForUsedSlots } from "../config/materialConfig.js";
import { showError, showWarning } from "../ui/infobox.js";

// Generate combined plate_1.json data from all plates
async function generatePlateJsonData() {
  const slotDivs = document
    .getElementById("filament_total")
    ?.querySelectorAll(":scope > div[title]") || [];

  const filament_colors = [];
  const filament_ids = [];

  // Collect filament data from statistics
  for (let i = 0; i < slotDivs.length; i++) {
    const div = slotDivs[i];

    // Check if this slot is actually used
    const usedM = parseFloat(div.dataset.used_m || "0") || 0;
    const usedG = parseFloat(div.dataset.used_g || "0") || 0;
    if (usedM <= 0 && usedG <= 0) continue;

    // Get slot ID (1..4) and convert to 0-based index
    const slotId = parseInt(div.getAttribute("title") || `${i + 1}`, 10) || (i + 1);
    const slotIndex = slotId - 1; // Convert to 0-based for filament_ids

    // Get color from swatch
    const sw = div.querySelector(":scope > .f_color");
    const colorRaw = (sw?.dataset?.f_color) || (sw ? getComputedStyle(sw).backgroundColor : "#cccccc");
    const hex = colorToHex(colorRaw || "#cccccc");

    filament_colors.push(hex);
    filament_ids.push(slotIndex);
  }

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
        
        // Copy plate PNG files from first active plate to plate_1 (within same baseZip)
        const pngFiles = [
          `Metadata/plate_${firstActivePlateIndex}.png`,
          `Metadata/plate_${firstActivePlateIndex}_small.png`, 
          `Metadata/plate_no_light_${firstActivePlateIndex}.png`,
          `Metadata/top_${firstActivePlateIndex}.png`,
          `Metadata/pick_${firstActivePlateIndex}.png`
        ];
        
        for (const sourceFile of pngFiles) {
          const file = baseZip.file(sourceFile);
          if (file) {
            const content = await file.async("arraybuffer");
            // Replace any occurrence of _X with _1 (works for plate_X, top_X, pick_X, etc.)
            const targetFile = sourceFile.replace(`_${firstActivePlateIndex}`, "_1");
            baseZip.file(targetFile, content);
            console.log(`Copied ${sourceFile} to ${targetFile}`);
          } else {
            console.log(`Source file not found in baseZip: ${sourceFile}`);
          }
        }
      } catch (e) {
        console.warn(`Failed to copy PNG files from plate ${firstActivePlateIndex}:`, e);
      }
    } else if (firstActivePlateIndex === 1) {
      console.log(`First active plate is already plate_1, no PNG copying needed`);
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
    baseZip.file("Metadata/model_settings.config", model_settings_xml);

    const sliceInfoStr = await baseZip.file("Metadata/slice_info.config").async("text");
    const parser = new DOMParser();
    const slicer_config_xml = parser.parseFromString(sliceInfoStr, "text/xml");

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
      const plateJsonData = await generatePlateJsonData();
      baseZip.file("Metadata/plate_1.json", JSON.stringify(plateJsonData, null, 2));
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

      // Build filename with printer type, mode, and submode (only for swap mode)
      const printerType = state.CURRENT_MODE || "unknown";
      const mode = state.APP_MODE || "swap";
      const submode = mode === "swap" ? (state.SELECTED_SWAP_LOGO || "3print") : null;
      const fileName = submode
        ? `${baseName}.${printerType}.${mode}.${submode}.3mf`
        : `${baseName}.${printerType}.${mode}.3mf`;

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
