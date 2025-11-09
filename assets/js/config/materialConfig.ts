// /src/config/materialConfig.ts
import { buildFlushVolumesMatrixFromColors, buildFlushVolumesVector } from "../utils/flush.js";
import { colorToHex } from "../utils/colors.js";
import { printerTemplates } from "./printerTemplates.js";
import { state } from "./state.js";

/**
 * Result of reading used slots and colors
 */
interface UsedSlotsResult {
  colors: string[];
  originalSlots: number[];
}

/**
 * Lese verwendete Slots & Farben aus #filament_total.
 * WICHTIG: Slots werden kompaktiert - Lücken werden eliminiert!
 *
 * Beispiel: Slot 1 + 3 belegt → Slot 3 wird zu Slot 2
 * Beispiel: Slot 2 + 4 belegt → Slots werden zu 1 + 2
 *
 * Erstellt auch state.GLOBAL_AMS.slotCompactionMap für Mapping original → kompaktiert
 *
 * @returns Object with colors array and originalSlots array
 */
function readUsedSlotsAndColors(): UsedSlotsResult {
  const root = document.getElementById("filament_total");
  const divs = root?.querySelectorAll<HTMLDivElement>(":scope > div[title]") || [];

  // Build a map: slotIndex (0-3) -> color for USED slots only
  const usedSlots: Array<{ originalSlot: number; color: string }> = [];

  divs.forEach(div => {
    const slotTitle = div.getAttribute("title");
    const slotIndex = parseInt(slotTitle || "0", 10) - 1; // Convert to 0-based (0-31)

    if (slotIndex < 0 || slotIndex > 31) return; // Skip invalid slots (up to 32 slots)

    const m = parseFloat(div.dataset['used_m'] || "0") || 0;
    const g = parseFloat(div.dataset['used_g'] || "0") || 0;

    // Only process slots that have actual usage
    if (m > 0 || g > 0) {
      const sw = div.querySelector<HTMLElement>(":scope > .f_color");
      // Read the CURRENT slot color from style.background
      const raw = sw ? (getComputedStyle(sw).backgroundColor || sw.style.backgroundColor) : "#cccccc";
      const hex = (colorToHex(raw) || "#cccccc").toUpperCase();

      usedSlots.push({ originalSlot: slotIndex, color: hex });
    }
  });

  // If no slots used, return empty arrays
  if (usedSlots.length === 0) {
    state.GLOBAL_AMS.slotCompactionMap.clear();
    return { colors: [], originalSlots: [] };
  }

  // Sort by original slot index
  usedSlots.sort((a, b) => a.originalSlot - b.originalSlot);

  // Build compaction map: original slot (1-based) -> compacted slot (1-based)
  state.GLOBAL_AMS.slotCompactionMap.clear();
  const colors: string[] = [];
  const originalSlots: number[] = [];

  usedSlots.forEach((slot, compactedIndex) => {
    const originalSlot1Based = slot.originalSlot + 1; // 1-4
    const compactedSlot1Based = compactedIndex + 1;   // 1-4

    state.GLOBAL_AMS.slotCompactionMap.set(originalSlot1Based, compactedSlot1Based);
    colors.push(slot.color);
    originalSlots.push(slot.originalSlot); // Store 0-based original slot index

    console.log(`Slot compaction: ${originalSlot1Based} → ${compactedSlot1Based} (${slot.color})`);
  });

  console.log(`readUsedSlotsAndColors: ${usedSlots.length} slots compacted, colors=`, colors, 'originalSlots=', originalSlots);

  return { colors, originalSlots };
}

/**
 * Replicate template arrays to length n (takes first element as base)
 * NOTE: Currently unused but kept for potential future use
 */
// @ts-ignore - Unused function kept for future use
// eslint-disable-next-line @typescript-eslint/no-unused-vars
function _replicateTemplateArrays(template: Record<string, unknown> | null, n: number): Record<string, unknown> {
  const out: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(template || {})) {
    if (Array.isArray(v)) {
      const base = String(v[0] ?? "");
      out[k] = Array(n).fill(base);
    } else {
      // skalare/sonstige Werte 1:1 übernehmen
      out[k] = v;
    }
  }
  return out;
}

/**
 * Baut ein neues project_settings.config JSON (String),
 * basierend auf originalText und den verwendeten Slots/Farben.
 * Verwendet printer-spezifische Templates für präzise Feld-Duplikation.
 *
 * WICHTIG: Bei Kompaktierung werden die Werte der ursprünglichen Slots übernommen!
 * Beispiel: Slots 3+4 verwendet → Werte von Index [2] und [3] werden zu [0] und [1]
 */
export function buildProjectSettingsForUsedSlots(originalText: string): string {
  let original: Record<string, unknown>;
  try {
    original = JSON.parse(originalText) as Record<string, unknown>;
  }
  catch (e) {
    console.warn("project_settings original parse failed, fallback to {}:", e);
    original = {};
  }

  const { colors, originalSlots } = readUsedSlotsAndColors();
  const n = colors.length;
  if (n === 0) {
    // nichts benutzt → gib Original zurück
    return JSON.stringify(original, null, 2);
  }

  // 1) Basis: Original klonen
  const out: Record<string, unknown> = structuredClone ? structuredClone(original) : JSON.parse(JSON.stringify(original));

  // 2) Printer-spezifische Template-Behandlung
  const printerMode = state.PRINTER_MODEL;
  const template = printerMode && (printerMode === 'A1' || printerMode === 'A1M')
    ? printerTemplates[printerMode]
    : null;

  if (template) {
    // Nur spezifische Felder kompaktieren (Werte von ursprünglichen Slots übernehmen)
    for (const fieldName of template.duplicateFields) {
      const value = original[fieldName];
      if (Array.isArray(value) && value.length > 0) {
        // Map original slot values to compacted positions
        out[fieldName] = originalSlots.map(origSlotIndex => {
          // origSlotIndex ist 0-based (0-3)
          const val = value[origSlotIndex];
          return val !== undefined ? String(val) : String(value[0] ?? "");
        });
      }
    }

    // Spezielle Behandlung für Felder mit besonderen Regeln
    if (template.specialFields) {
      for (const [fieldName, rule] of Object.entries(template.specialFields)) {
        if (original[fieldName] && Array.isArray(original[fieldName])) {
          if (rule === "sequential") {
            // Aufsteigend nummeriert: 0, 1, 2, 3, ...
            out[fieldName] = Array.from({length: n}, (_, i) => String(i));
          }
        }
      }
    }
  } else {
    // Fallback: alle Array-Felder kompaktieren (Werte von ursprünglichen Slots übernehmen)
    for (const [key, value] of Object.entries(original)) {
      if (Array.isArray(value) && value.length > 0) {
        // Map original slot values to compacted positions
        out[key] = originalSlots.map(origSlotIndex => {
          const val = value[origSlotIndex];
          return val !== undefined ? String(val) : String(value[0] ?? "");
        });
      }
    }
  }

  // 3) User-spezifische Overrides anwenden (immer erforderlich)
  out["filament_colour"]       = colors.slice();
  out["filament_multi_colour"] = colors.slice();
  out["filament_self_index"]   = Array.from({length: n}, (_, i) => String(i+1));
  out["flush_volumes_matrix"]  = buildFlushVolumesMatrixFromColors(colors, { maxFlush: 850, minFlush: 0 }).map(v => String(v));
  out["flush_volumes_vector"]  = buildFlushVolumesVector(n, 140); // 2× pro Filament

  return JSON.stringify(out, null, 2);
}

/**
 * PLA PolyTerra material preset configuration
 */
export const PLAPolyTerra: Record<string, string | string[]> = {
    "activate_air_filtration": [
        "0",
    ], "filament_diameter": [
        "1.75",
    ],
    "additional_cooling_fan_speed": [
        "20",
    ],
    "auxiliary_fan": "1",

    "chamber_temperatures": [
        "0",
    ],
    "filament_adaptive_volumetric_speed": [
        "0",
    ],
    "filament_extruder_variant": [
        "Direct Drive Standard",
    ],
    "circle_compensation_speed": [
        "200",
    ],
    "close_fan_the_first_x_layers": [
        "1",
    ],
    "complete_print_exhaust_fan_speed": [
        "70",
    ],
    "cool_plate_temp": [
        "35",
    ],
    "cool_plate_temp_initial_layer": [
        "35",
    ],
    "counter_coef_1": [
        "0",
    ],
    "counter_coef_2": [
        "0.008",
    ],
    "counter_coef_3": [
        "-0.041",
    ],
    "counter_limit_max": [
        "0.033",
    ],
    "counter_limit_min": [
        "-0.035",
    ],
    "default_filament_colour": [
        ""
    ],
    "diameter_limit": [
        "50",
    ],
    "during_print_exhaust_fan_speed": [
        "70",
    ],
    "enable_overhang_bridge_fan": [
        "1",
    ],
    "enable_pressure_advance": [
        "0",
    ],
    "eng_plate_temp": [
        "0",
    ],
    "eng_plate_temp_initial_layer": [
        "0",
    ],
    "fan_cooling_layer_time": [
        "100",
    ],
    "fan_max_speed": [
        "100",
    ],
    "fan_min_speed": [
        "100",
    ],
    "filament_adhesiveness_category": [
        "100",
    ],
    "filament_change_length": [
        "10",
    ],
    "filament_colour": [
        "#FFFFFF",
    ],
    "filament_colour_type": [
        "1",
    ],
    "filament_cost": [
        "25.4",
    ],
    "filament_density": [
        "1.31",
    ],
    "filament_deretraction_speed": [
        "nil",
    ],
    "filament_end_gcode": [
        "; filament end gcode \n\n",
    ],
    "filament_flow_ratio": [
        "0.98",
    ],
    "filament_flush_temp": [
        "0",
    ],
    "filament_flush_volumetric_speed": [
        "0",
    ],
    "filament_ids": [
        "GFL01",
    ],
    "filament_is_support": [
        "0",
    ],
    "filament_long_retractions_when_cut": [
        "nil",
    ],
    "filament_map": [
        "1",
    ],
    "filament_max_volumetric_speed": [
        "22",
    ],
    "filament_minimal_purge_on_wipe_tower": [
        "15",
    ],
    "filament_multi_colour": [
        "#FFFFFF",
    ],
    "filament_notes": "",
    "filament_pre_cooling_temperature": [
        "0",
    ],
    "filament_prime_volume": [
        "45",
    ],
    "filament_printable": [
        "3",
    ],
    "filament_ramming_travel_time": [
        "0",
    ],
    "filament_ramming_volumetric_speed": [
        "-1",
    ],
    "filament_retract_before_wipe": [
        "nil",
    ],
    "filament_retract_restart_extra": [
        "nil",
    ],
    "filament_retract_when_changing_layer": [
        "nil",
    ],
    "filament_retraction_distances_when_cut": [
        "nil",
    ],
    "filament_retraction_length": [
        "nil",
    ],
    "filament_retraction_minimum_travel": [
        "nil",
    ],
    "filament_retraction_speed": [
        "nil",
    ],
    "filament_scarf_gap": [
        "15%",
    ],
    "filament_scarf_height": [
        "10%",
    ],
    "filament_scarf_length": [
        "10",
    ],
    "filament_scarf_seam_type": [
        "none",
    ],
    "filament_self_index": [
        "1",
        "2",
        "3",
        "4",
    ],
    "filament_settings_id": [
        "PolyTerra PLA @BBL X1C",
    ],
    "filament_shrink": [
        "100%",
    ],
    "filament_soluble": [
        "0",
    ],
    "filament_start_gcode": [
        "; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}",
    ],
    "filament_type": [
        "PLA",
    ],
    "filament_vendor": [
        "Polymaker",
    ],
    "filament_wipe": [
        "nil",
    ],
    "filament_wipe_distance": [
        "nil",
    ],
    "filament_z_hop": [
        "nil",
    ],
    "filament_z_hop_types": [
        "nil",
    ],
    "hole_coef_1": [
        "0",
    ],
    "hole_coef_2": [
        "-0.008",
    ],
    "hole_coef_3": [
        "0.23415",
    ],
    "hole_limit_max": [
        "0.22",
    ],
    "hole_limit_min": [
        "0.088",
    ],
    "host_type": "octoprint",
    "hot_plate_temp": [
        "55",
    ],
    "hot_plate_temp_initial_layer": [
        "55",
    ],
    "impact_strength_z": [
        "10",
    ],
    "long_retractions_when_ec": [
        "0",
    ],
    "nozzle_temperature": [
        "220",
    ],
    "nozzle_temperature_initial_layer": [
        "220",
    ],
    "nozzle_temperature_range_high": [
        "240",
    ],
    "nozzle_temperature_range_low": [
        "190",
    ],
    "overhang_fan_speed": [
        "100",
    ],
    "overhang_fan_threshold": [
        "50%",
    ],
    "overhang_threshold_participating_cooling": [
        "95%",
    ],
    "pre_start_fan_time": [
        "0",
    ],
    "pressure_advance": [
        "0.02",
    ],
    "reduce_fan_stop_start_freq": [
        "1",
    ],
    "required_nozzle_HRC": [
        "3",
    ],
    "retraction_distances_when_ec": [
        "0",
    ],
    "slow_down_for_layer_cooling": [
        "1",
    ],
    "slow_down_layer_time": [
        "4",
    ],
    "slow_down_min_speed": [
        "20",
    ],
    "supertack_plate_temp": [
        "45",
    ],
    "supertack_plate_temp_initial_layer": [
        "45",
    ],
    "temperature_vitrification": [
        "45",
    ],
    "textured_plate_temp": [
        "55",
    ],
    "textured_plate_temp_initial_layer": [
        "55",
    ], "volumetric_speed_coefficients": [
        "0 0 0 0 0 0",
    ], "filament_velocity_adaptation_factor": [
        "1",
    ],     "full_fan_speed_layer": [
        "0",
    ],
};
