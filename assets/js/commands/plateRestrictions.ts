/**
 * Plate Area Restrictions Module
 *
 * This module defines declarative rules for validating plate usage restrictions.
 * Similar to swapRules.ts, each restriction can have conditions based on:
 * - Printer model (modes)
 * - App mode (appModes)
 * - Submodes (e.g., "3print", "jobox", etc.)
 * - Object dimensions and positions
 */

import type { PlateRestriction, PlateRestrictionWarning, PlateData, PrinterModel, AppMode } from '../types/index.js';

/**
 * Plate area restrictions
 *
 * Each restriction defines validation logic that checks if plate objects meet
 * specific positioning or dimensional requirements for the selected printer and mode.
 */
export const PLATE_RESTRICTIONS: PlateRestriction[] = [
  {
    id: "a1_3print_front_rear_clearance",
    description: "A1 3Print mode requires 30mm clearance at front or rear for objects taller than 15mm",
    enabled: true,
    when: {
      modes: ["A1"],
      appModes: ["swap"],
      submodes: ["3print"]
    },
    /**
     * Validates the restriction for a given plate
     * @param plateData - Plate data from JSON containing bounding box objects
     * @param plateIndex - Index of the plate (0-based)
     * @returns Warning object or null if validation passes
     */
    validate: (plateData: PlateData, plateIndex: number): PlateRestrictionWarning | null => {
      const PLATE_DEPTH = 256;  // mm
      const MIN_CLEARANCE = 30; // mm
      const HEIGHT_THRESHOLD = 15; // mm

      if (!plateData || !plateData.bbox_objects || !Array.isArray(plateData.bbox_objects)) {
        console.log(`[plateRestrictions] Plate ${plateIndex + 1}: No bbox_objects found`);
        return null;
      }

      // Check if any object exceeds height threshold
      let maxHeight = 0;
      let minY = Infinity;
      let maxY = -Infinity;

      for (const obj of plateData.bbox_objects) {
        if (!obj.bbox || !Array.isArray(obj.bbox) || obj.bbox.length < 6) {
          continue;
        }

        // bbox format: [x_min, y_min, z_min, x_max, y_max, z_max]
        const [_x_min, y_min, z_min, _x_max, y_max, z_max] = obj.bbox;
        const objectHeight = z_max - z_min;

        if (objectHeight > maxHeight) {
          maxHeight = objectHeight;
        }

        // Track Y bounds (front-to-back position)
        if (y_min < minY) minY = y_min;
        if (y_max > maxY) maxY = y_max;
      }

      // Only check clearance if there are objects taller than threshold
      if (maxHeight <= HEIGHT_THRESHOLD) {
        console.log(`[plateRestrictions] Plate ${plateIndex + 1}: Max height ${maxHeight.toFixed(1)}mm <= ${HEIGHT_THRESHOLD}mm threshold, no clearance check needed`);
        return null;
      }

      // Calculate clearances (Y-axis is front-to-back)
      const rearClearance = minY; // Distance from rear edge (Y=0)
      const frontClearance = PLATE_DEPTH - maxY; // Distance from front edge (Y=256)

      console.log(`[plateRestrictions] Plate ${plateIndex + 1}: Height ${maxHeight.toFixed(1)}mm, Rear clearance ${rearClearance.toFixed(1)}mm, Front clearance ${frontClearance.toFixed(1)}mm`);

      // Check if either front or rear has sufficient clearance
      const hasSufficientClearance = (rearClearance >= MIN_CLEARANCE) || (frontClearance >= MIN_CLEARANCE);

      if (!hasSufficientClearance) {
        return {
          restrictionId: "a1_3print_front_rear_clearance",
          type: "warning",
          plateIndex: plateIndex,
          message: `Plate ${plateIndex + 1}: Collision risk detected!\n\n` +
                   `Objects on this plate exceed ${HEIGHT_THRESHOLD}mm height (max: ${maxHeight.toFixed(1)}mm) ` +
                   `but do not have ${MIN_CLEARANCE}mm clearance at either the front or rear edge.\n\n` +
                   `Current clearances:\n` +
                   `- Rear (Y=0): ${rearClearance.toFixed(1)}mm\n` +
                   `- Front (Y=${PLATE_DEPTH}): ${frontClearance.toFixed(1)}mm\n\n` +
                   `Please ensure at least ${MIN_CLEARANCE}mm clearance at EITHER the front OR rear edge to avoid collisions during plate swapping.`,
          severity: "high"
        };
      }

      return null;
    }
  },

  // Additional restrictions can be added here following the same pattern
  // Example template:
  /*
  {
    id: "example_restriction",
    description: "Example restriction description",
    enabled: true,
    when: {
      modes: ["A1"],
      appModes: ["swap"],
      submodes: ["jobox"]
    },
    validate: (plateData: PlateData, plateIndex: number): PlateRestrictionWarning | null => {
      // Validation logic here
      // Return null if validation passes
      // Return warning object if validation fails
      return null;
    }
  }
  */
];

/**
 * Check all applicable restrictions for a given plate
 *
 * @param plateData - Plate data from JSON containing bounding box information
 * @param plateIndex - Index of the plate (0-based)
 * @param printerMode - Current printer mode (e.g., "A1", "X1")
 * @param appMode - Current app mode (e.g., "swap", "pushoff")
 * @param submode - Optional submode (e.g., "3print", "jobox")
 * @returns Array of warning objects
 */
export function checkPlateRestrictions(
  plateData: PlateData,
  plateIndex: number,
  printerMode: PrinterModel,
  appMode: AppMode,
  submode: string | null = null
): PlateRestrictionWarning[] {
  const warnings: PlateRestrictionWarning[] = [];

  for (const restriction of PLATE_RESTRICTIONS) {
    if (!restriction.enabled) {
      continue;
    }

    // Check if restriction applies to current configuration
    const { when } = restriction;

    // Check modes
    if (when.modes && !when.modes.includes(printerMode)) {
      continue;
    }

    // Check appModes
    if (when.appModes && !when.appModes.includes(appMode)) {
      continue;
    }

    // Check submodes (if specified in restriction and provided)
    if (when.submodes && submode && !when.submodes.includes(submode)) {
      continue;
    }

    // Run validation
    try {
      const warning = restriction.validate(plateData, plateIndex);
      if (warning) {
        warnings.push(warning);
      }
    } catch (error) {
      console.error(`[plateRestrictions] Error validating restriction ${restriction.id}:`, error);
    }
  }

  return warnings;
}

/**
 * Check all plates for restrictions
 *
 * @param allPlatesData - Array of plate data objects
 * @param printerMode - Current printer mode
 * @param appMode - Current app mode
 * @param submode - Optional submode
 * @returns Array of all warnings from all plates
 */
export function checkAllPlatesRestrictions(
  allPlatesData: PlateData[],
  printerMode: PrinterModel,
  appMode: AppMode,
  submode: string | null = null
): PlateRestrictionWarning[] {
  const allWarnings: PlateRestrictionWarning[] = [];

  for (let i = 0; i < allPlatesData.length; i++) {
    const plateData = allPlatesData[i];
    if (plateData) {
      const plateWarnings = checkPlateRestrictions(plateData, i, printerMode, appMode, submode);
      allWarnings.push(...plateWarnings);
    }
  }

  return allWarnings;
}
