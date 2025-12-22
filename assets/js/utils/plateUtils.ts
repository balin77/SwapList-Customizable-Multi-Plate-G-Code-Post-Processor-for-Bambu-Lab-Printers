// /src/utils/plateUtils.ts

import JSZip from "jszip";
import { state } from "../config/state.js";
import { getAllPlateSettings } from "../ui/settings.js";
// @ts-expect-error - Import for future use
import { getPlateSettings } from "../ui/settings.js";
// @ts-expect-error - Type import for documentation
import type { AppState } from "../types/index.js";

/**
 * Object information from bbox data
 */
export interface PlateObject {
  /** Object name */
  name: string;
  /** Center X coordinate */
  centerX: number;
  /** Whether this is a wipe tower */
  isWipeTower: boolean;
}

/**
 * Object coordinate calculation result
 */
export interface ObjectCoordinatesResult {
  /** Total number of objects (including wipe tower) */
  objectCount: number;
  /** Array of X coordinates for all objects */
  xCoordinates: number[];
  /** Array of object details */
  objects: PlateObject[];
}

/**
 * Plate JSON data structure from 3MF
 */
interface PlateJsonData {
  /** Array of bounding box objects */
  bbox_objects?: Array<{
    /** Object name */
    name?: string;
    /** Bounding box [minX, minY, maxX, maxY] */
    bbox?: number[];
  }>;
}


/**
 * Calculates object count and X coordinates from bbox_objects in plate JSON data.
 *
 * Reads the plate's JSON file from the 3MF ZIP to extract bounding box information
 * for all objects and calculates their center X coordinates.
 *
 * @param li - The plate list item element
 * @returns Object with count, coordinates, and object details
 *
 * @example
 * ```ts
 * const result = await calculateObjectCoordinatesFromBbox(plateElement);
 * console.log(`Found ${result.objectCount} objects`);
 * console.log(`X coordinates: ${result.xCoordinates.join(', ')}`);
 * ```
 */
export async function calculateObjectCoordinatesFromBbox(
  li: HTMLElement
): Promise<ObjectCoordinatesResult> {
  try {
    const fileIdElement = li.getElementsByClassName("f_id")[0] as HTMLElement | undefined;
    const plateNameElement = li.getElementsByClassName("p_name")[0] as HTMLElement | undefined;

    if (!fileIdElement || !plateNameElement) {
      throw new Error("Could not find file ID or plate name elements");
    }

    const fileId = parseInt(fileIdElement.title, 10);
    const plateName = plateNameElement.title;

    if (!Number.isFinite(fileId) || fileId < 0 || fileId >= state.my_files.length) {
      throw new Error(`Invalid file ID: ${fileId}`);
    }

    // Load the ZIP file
    const fileData = state.my_files[fileId];
    if (!fileData) {
      throw new Error(`File data not found for file ID: ${fileId}`);
    }
    const zip = await JSZip.loadAsync(fileData as unknown as ArrayBuffer | Blob);

    // Generate JSON filename from plate name
    const plateJsonName = plateName.replace('.gcode', '.json');

    // Try to find the JSON file
    const plateJsonFile = zip.file(plateJsonName);

    if (!plateJsonFile) {
      console.warn(`JSON file not found: ${plateJsonName}`);
      return { objectCount: 1, xCoordinates: [128], objects: [] }; // Default values
    }

    // Parse JSON data
    const jsonContent = await plateJsonFile.async("text");
    const plateData: PlateJsonData = JSON.parse(jsonContent);

    if (!plateData.bbox_objects || !Array.isArray(plateData.bbox_objects)) {
      console.warn(`No bbox_objects found in ${plateJsonName}`);
      return { objectCount: 1, xCoordinates: [128], objects: [] }; // Default values
    }

    // Process all objects including wipe tower
    const objects: PlateObject[] = [];
    const xCoordinates: number[] = [];

    plateData.bbox_objects.forEach(obj => {
      if (!obj.bbox || !Array.isArray(obj.bbox) || obj.bbox.length < 4) {
        console.warn(`Invalid bbox for object ${obj.name || 'unknown'}:`, obj.bbox);
        return;
      }

      const [minX, _minY, maxX, _maxY] = obj.bbox;
      if (minX === undefined || maxX === undefined) {
        console.warn(`Missing X coordinates for object ${obj.name || 'unknown'}`);
        return;
      }
      const centerX = Math.round((minX + maxX) / 2);
      const isWipeTower = obj.name ? obj.name.toLowerCase().includes('wipe_tower') : false;

      objects.push({
        name: obj.name || 'unknown',
        centerX: centerX,
        isWipeTower: isWipeTower
      });

      xCoordinates.push(centerX);

      console.log(
        `Object "${obj.name || 'unknown'}" (${isWipeTower ? 'wipe tower' : 'object'}): ` +
        `bbox=[${obj.bbox.join(', ')}], centerX=${centerX}`
      );
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

    console.log(
      `Calculated ${objects.length} objects ` +
      `(${objects.filter(o => !o.isWipeTower).length} objects + ` +
      `${objects.filter(o => o.isWipeTower).length} wipe towers)`
    );

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
 * Auto-populates plate X1/P1 UI with calculated values from bbox_objects.
 *
 * Only operates in X1/P1 modes where X-coordinates are relevant.
 * Reads the plate's JSON file and calculates object positions automatically.
 *
 * @param li - The plate list item element
 *
 * @example
 * ```ts
 * await autoPopulatePlateCoordinates(plateElement);
 * // Settings are now populated with object counts and coordinates
 * ```
 */
export async function autoPopulatePlateCoordinates(li: HTMLElement): Promise<void> {
  console.log('autoPopulatePlateCoordinates called, mode:', state.PRINTER_MODEL);

  // Only for X1/P1 modes (X-coordinates are irrelevant for A1/A1M in push-off mode)
  if (!(state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1')) {
    console.log('Skipping auto-populate - X-coordinates not needed for', state.PRINTER_MODEL, 'mode');
    return;
  }

  // Get the plate name for debugging
  const plateNameElement = li.getElementsByClassName("p_name")[0] as HTMLElement | undefined;
  const plateName = plateNameElement ? plateNameElement.textContent : 'unknown';
  console.log(`Auto-populating coordinates for plate: ${plateName}`);

  try {
    const { objectCount, objects } = await calculateObjectCoordinatesFromBbox(li);
    console.log('Calculated:', objectCount, 'objects:', objects);

    // Find the plate index in the current list
    const allPlates = document.querySelectorAll<HTMLElement>('#playlist_ol li.list_item:not(.hidden)');
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
      // Convert PlateObject[] to the settings format
      const settingsObjects = objects.map(obj => ({
        name: obj.name,
        centerX: obj.centerX,
        isWipeTower: obj.isWipeTower
      }));

      // Make sure settings exist for this plate
      if (!allSettings.has(plateIndex)) {
        allSettings.set(plateIndex, {
          objectCount: objectCount, // Use the calculated count, not default 1
          objectCoords: objects.map(obj => obj.centerX), // Use calculated coords
          objects: settingsObjects, // Store full object info including isWipeTower
          hidePurgeLoad: true,
          turnOffPurge: false,
          bedRaiseOffset: 30,
          securePushoff: true,
          extraPushoffLevels: 2,
          waitMinutesBeforeSwap: 0
        });
      } else {
        // Update existing settings
        const settings = allSettings.get(plateIndex);
        if (settings) {
          settings.objectCount = objectCount;
          settings.objectCoords = objects.map(obj => obj.centerX);
          settings.objects = settingsObjects;
        }
      }

      const plateNameEl = li.getElementsByClassName("p_name")[0] as HTMLElement | undefined;
      const name = plateNameEl?.textContent || 'unknown';
      console.log(
        `✅ Auto-populated plate ${plateIndex} "${name}" with ${objectCount} objects, ` +
        `coords:`, allSettings.get(plateIndex)?.objectCoords
      );
    }

  } catch (error) {
    console.error("Error auto-populating plate coordinates:", error);
  }
}
