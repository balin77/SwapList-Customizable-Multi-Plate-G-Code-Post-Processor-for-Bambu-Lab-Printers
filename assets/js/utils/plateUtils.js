// /src/utils/plateUtils.js

import JSZip from "jszip";
import { state } from "../config/state.js";
import { getPlateSettings, getAllPlateSettings } from "../ui/settings.js";

/**
 * Calculates object count and X coordinates from bbox_objects in plate JSON data
 * @param {HTMLElement} li - The plate list item element
 * @returns {Promise<{objectCount: number, xCoordinates: number[], objects: Array<{name: string, centerX: number, isWipeTower: boolean}>}>}
 */
export async function calculateObjectCoordinatesFromBbox(li) {
  try {
    const fileIdElement = li.getElementsByClassName("f_id")[0];
    const plateNameElement = li.getElementsByClassName("p_name")[0];
    
    if (!fileIdElement || !plateNameElement) {
      throw new Error("Could not find file ID or plate name elements");
    }
    
    const fileId = parseInt(fileIdElement.title, 10);
    const plateName = plateNameElement.title;
    
    if (!Number.isFinite(fileId) || fileId < 0 || fileId >= state.my_files.length) {
      throw new Error(`Invalid file ID: ${fileId}`);
    }
    
    // Load the ZIP file
    const zip = await JSZip.loadAsync(state.my_files[fileId]);
    
    // Generate JSON filename from plate name
    const plateJsonName = plateName.replace('.gcode', '.json');
    
    // Try to find the JSON file
    const plateJsonFile = zip.file(plateJsonName);
    
    if (!plateJsonFile) {
      console.warn(`JSON file not found: ${plateJsonName}`);
      return { objectCount: 1, xCoordinates: [128] }; // Default values
    }
    
    // Parse JSON data
    const jsonContent = await plateJsonFile.async("text");
    const plateData = JSON.parse(jsonContent);
    
    if (!plateData.bbox_objects || !Array.isArray(plateData.bbox_objects)) {
      console.warn(`No bbox_objects found in ${plateJsonName}`);
      return { objectCount: 1, xCoordinates: [128], objects: [] }; // Default values
    }
    
    // Process all objects including wipe tower
    const objects = [];
    const xCoordinates = [];
    
    plateData.bbox_objects.forEach(obj => {
      if (!obj.bbox || !Array.isArray(obj.bbox) || obj.bbox.length < 4) {
        console.warn(`Invalid bbox for object ${obj.name || 'unknown'}:`, obj.bbox);
        return;
      }
      
      const [minX, minY, maxX, maxY] = obj.bbox;
      const centerX = Math.round((minX + maxX) / 2);
      const isWipeTower = obj.name && obj.name.toLowerCase().includes('wipe_tower');
      
      objects.push({
        name: obj.name || 'unknown',
        centerX: centerX,
        isWipeTower: isWipeTower
      });
      
      xCoordinates.push(centerX);
      
      console.log(`Object "${obj.name || 'unknown'}" (${isWipeTower ? 'wipe tower' : 'object'}): bbox=[${obj.bbox.join(', ')}], centerX=${centerX}`);
    });
    
    if (objects.length === 0) {
      console.warn(`No valid objects found in ${plateJsonName}`);
      return { objectCount: 1, xCoordinates: [128], objects: [] }; // Default values
    }
    
    // Sort objects: regular objects first, then wipe tower
    objects.sort((a, b) => {
      if (a.isWipeTower && !b.isWipeTower) return 1;
      if (!a.isWipeTower && b.isWipeTower) return -1;
      return a.centerX - b.centerX; // Sort by X coordinate within same type
    });
    
    console.log(`Calculated ${objects.length} objects (${objects.filter(o => !o.isWipeTower).length} objects + ${objects.filter(o => o.isWipeTower).length} wipe towers)`);
    
    return {
      objectCount: objects.length,
      xCoordinates: objects.map(obj => obj.centerX),
      objects: objects
    };
    
  } catch (error) {
    console.error("Error calculating object coordinates from bbox:", error);
    return { objectCount: 1, xCoordinates: [128], objects: [] }; // Default fallback
  }
}

/**
 * Auto-populates plate X1/P1 UI with calculated values from bbox_objects
 * @param {HTMLElement} li - The plate list item element
 */
export async function autoPopulatePlateCoordinates(li) {
  // Only for X1/P1 modes
  if (!(state.CURRENT_MODE === 'X1' || state.CURRENT_MODE === 'P1')) {
    return;
  }

  try {
    const { objectCount, objects } = await calculateObjectCoordinatesFromBbox(li);

    // Find the plate index in the current list
    const allPlates = document.querySelectorAll('#playlist_ol li.list_item:not(.hidden)');
    let plateIndex = -1;
    for (let i = 0; i < allPlates.length; i++) {
      if (allPlates[i] === li) {
        plateIndex = i;
        break;
      }
    }

    if (plateIndex === -1) {
      console.warn('Could not determine plate index for auto-population');
      return;
    }

    // Always update the internal settings data structure first
    const allSettings = getAllPlateSettings();
    if (allSettings) {
      // Make sure settings exist for this plate
      if (!allSettings.has(plateIndex)) {
        allSettings.set(plateIndex, {
          objectCount: 1,
          objectCoords: [],
          hidePurgeLoad: true,
          turnOffPurge: false,
          bedRaiseOffset: 30,
          securePushoff: true,
          extraPushoffLevels: 2
        });
      }

      const settings = allSettings.get(plateIndex);
      settings.objectCount = objectCount;
      settings.objectCoords = objects.map(obj => obj.centerX);

      // If this plate is currently selected in settings, also update the UI
      const plateSpecificSettings = document.getElementById("plate_specific_settings");
      const objCountSelector = plateSpecificSettings?.querySelector(".obj-count");

      if (objCountSelector && !plateSpecificSettings.classList.contains('hidden')) {
        // Update the UI if settings panel is visible
        objCountSelector.value = Math.min(20, Math.max(1, objectCount)).toString();
        objCountSelector.dispatchEvent(new Event('change'));

        // Wait for UI update then populate coordinates
        setTimeout(() => {
          const coordInputs = plateSpecificSettings.querySelectorAll('.obj-coords input.obj-x');
          const coordLabels = plateSpecificSettings.querySelectorAll('.obj-coords b');

          coordInputs.forEach((input, index) => {
            if (index < objects.length) {
              const obj = objects[index];
              input.value = obj.centerX.toString();
              input.style.backgroundColor = '#f8f9fa';

              if (coordLabels[index]) {
                if (obj.isWipeTower) {
                  coordLabels[index].textContent = 'Wipe Tower';
                } else {
                  const objectNumber = objects.slice(0, index + 1).filter(o => !o.isWipeTower).length;
                  coordLabels[index].textContent = `Objekt ${objectNumber}`;
                }
              }
            }
          });
        }, 100);
      }
    }

    console.log(`Auto-populated plate "${li.getElementsByClassName("p_name")[0]?.textContent || 'unknown'}" with ${objectCount} objects`);

  } catch (error) {
    console.error("Error auto-populating plate coordinates:", error);
  }
}