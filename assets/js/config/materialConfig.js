// /src/config/materialConfig.js
import { buildFlushVolumesMatrixFromColors, buildFlushVolumesVector } from "../utils/flush.js";
import { colorToHex } from "../utils/colors.js";

/** Lese verwendete Slots & Farben aus #filament_total (nur Slots mit m/g > 0) */
function readUsedSlotsAndColors() {
  const root = document.getElementById("filament_total");
  const divs = root?.querySelectorAll(":scope > div[title]") || [];
  const used = [];
  divs.forEach(div => {
    const m = parseFloat(div.dataset.used_m || "0") || 0;
    const g = parseFloat(div.dataset.used_g || "0") || 0;
    if (m <= 0 && g <= 0) return;

    const sw = div.querySelector(":scope > .f_color");
    const raw = (sw?.dataset?.f_color) || (sw ? getComputedStyle(sw).backgroundColor : "#cccccc");
    const hex = (colorToHex(raw) || "#cccccc").toUpperCase();
    used.push(hex);
  });
  return used;
}

/** repliziere Template-Arrays auf Länge n (nimmt jeweils das erste Element als Basis) */
function replicateTemplateArrays(template, n) {
  const out = {};
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
 * basierend auf originalText + PLAPolyTerra + den verwendeten Slots/Farben.
 */
export function buildProjectSettingsForUsedSlots(originalText, templates = [PLAPolyTerra]) {
  let original;
  try { original = JSON.parse(originalText); }
  catch (e) { console.warn("project_settings original parse failed, fallback to {}:", e); original = {}; }

  const colors = readUsedSlotsAndColors();
  const n = colors.length;
  if (n === 0) {
    // nichts benutzt → gib Original zurück
    return JSON.stringify(original, null, 2);
  }

  // 1) Basis: Original klonen
  const out = structuredClone ? structuredClone(original) : JSON.parse(JSON.stringify(original));

  // NEU: Für jedes Feld, das ein Array ist, die Werte aus dem jeweiligen Template übernehmen
  for (const key of Object.keys(templates[0] || {})) {
    // Array-Feld: pro Slot aus dem jeweiligen Template übernehmen
    if (Array.isArray(templates[0][key])) {
      out[key] = Array(n).fill("").map((_, i) => {
        const tpl = templates[i] || templates[0];
        return tpl[key]?.[0] ?? "";
      });
    } else {
      // Skalar: Wert aus erstem Template übernehmen
      out[key] = templates[0][key];
    }
  }

  // Farben und Spezialfelder wie gehabt
  out["filament_colour"]       = colors.slice();
  out["filament_multi_colour"] = colors.slice();
  out["filament_self_index"]   = Array.from({length: n}, (_, i) => String(i+1));
  out["flush_volumes_matrix"]  = buildFlushVolumesMatrixFromColors(colors, { maxFlush: 850, minFlush: 0 }).map(v => String(v));
  out["flush_volumes_vector"]  = buildFlushVolumesVector(n, 140); // 2× pro Filament

  return JSON.stringify(out, null, 2);
}


export const PLAPolyTerra = {
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
}
