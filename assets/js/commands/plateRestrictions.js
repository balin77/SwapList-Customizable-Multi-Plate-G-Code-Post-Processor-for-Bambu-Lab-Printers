// /src/commands/plateRestrictions.js

/**
 * Plate Area Restrictions
 *
 * This module defines declarative rules for validating plate usage restrictions.
 * Similar to swapRules.js, each restriction can have conditions based on:
 * - Printer model (modes)
 * - App mode (appModes)
 * - Submodes (e.g., "3print", "jobox", etc.)
 * - Object dimensions and positions
 */

/**
 * Plate area restriction rule structure:
 *
 * @typedef {Object} PlateRestriction
 * @property {string} id - Unique identifier for the restriction
 * @property {string} description - Human-readable description
 * @property {boolean} enabled - Whether this restriction is active
 * @property {Object} when - Conditions for when this restriction applies
 * @property {string[]} when.modes - Printer models (e.g., ["A1", "A1M", "X1", "P1"])
 * @property {string[]} when.appModes - App modes (e.g., ["swap", "pushoff"])
 * @property {string[]} [when.submodes] - Optional submodes (e.g., ["3print", "jobox"])
 * @property {Function} validate - Function that validates the plate and returns warnings
 */

/**
 * Plate area restrictions
 */
export const PLATE_RESTRICTIONS = [
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
     * @param {Object} plateData - Plate data from JSON
     * @param {Array} plateData.bbox_objects - Array of bounding box objects
     * @param {number} plateIndex - Index of the plate (0-based)
     * @returns {Object|null} Warning object or null if validation passes
     */
    validate: (plateData, plateIndex) => {
      const PLATE_WIDTH = 256;  // mm
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
        const [x_min, y_min, z_min, x_max, y_max, z_max] = obj.bbox;
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
    validate: (plateData, plateIndex) => {
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
 * @param {Object} plateData - Plate data from JSON
 * @param {number} plateIndex - Index of the plate (0-based)
 * @param {string} printerMode - Current printer mode (e.g., "A1", "X1")
 * @param {string} appMode - Current app mode (e.g., "swap", "pushoff")
 * @param {string} [submode] - Optional submode (e.g., "3print", "jobox")
 * @returns {Array} Array of warning objects
 */
export function checkPlateRestrictions(plateData, plateIndex, printerMode, appMode, submode = null) {
  const warnings = [];

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
        warnings.push({
          restrictionId: restriction.id,
          ...warning
        });
      }
    } catch (error) {
      console.error(`[plateRestrictions] Error validating restriction ${restriction.id}:`, error);
    }
  }

  return warnings;
}

/**
 * Check all plates for restrictions
 * @param {Array} allPlatesData - Array of plate data objects
 * @param {string} printerMode - Current printer mode
 * @param {string} appMode - Current app mode
 * @param {string} [submode] - Optional submode
 * @returns {Array} Array of all warnings from all plates
 */
export function checkAllPlatesRestrictions(allPlatesData, printerMode, appMode, submode = null) {
  const allWarnings = [];

  for (let i = 0; i < allPlatesData.length; i++) {
    const plateWarnings = checkPlateRestrictions(allPlatesData[i], i, printerMode, appMode, submode);
    allWarnings.push(...plateWarnings);
  }

  return allWarnings;
}
