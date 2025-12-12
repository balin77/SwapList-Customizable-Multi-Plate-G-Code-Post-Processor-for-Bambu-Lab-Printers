// /src/config/state.ts

import type { AppState } from "../types/index.js";

/**
 * Global application state
 * Manages printer settings, files, and UI state
 */
export const state: AppState = {
  // Global flags
  USE_PURGE_START: false,
  USE_BEDLEVEL_COOLING: false,
  PRINTER_MODEL: null,            // "A1M" | "X1" | "P1" | "A1" | null
  APP_MODE: "pushoff",           // "swap" | "pushoff"
  SWAP_MODE: "jobox",  // "jobox" | "3print" | "printflow"

  // File Handling
  my_files: [],
  fileInput: null,
  li_prototype: null,
  playlist_ol: null,
  err: null,
  p_scale: null,
  last_file: false,
  ams_max_file_id: -1,

  // Nozzle configuration
  NOZZLE_DIAMETER_MM: null,
  NOZZLE_IS_02: false,

  // Features / Options
  enable_md5: true,
  open_in_bbs: false,

  // Controls project_settings + slice_info Filament-Override
  OVERRIDE_METADATA: false,

  // Developer mode flag
  DEVELOPER_MODE: false,

  // Don't swap last plate (push-off mode only)
  DONT_SWAP_LAST_PLATE: false,

  // AMS global state
  GLOBAL_AMS: {
    devices: [],                 // [{id, slots:[...]}]
    overridesPerPlate: new Map(),// plateIndex -> mapping
    seenKeys: new Set(),         // alle in allen Platten gefundenen Keys
    slotCompactionMap: new Map(),// original slot (1-4) -> compacted slot (1-4)
  },
};
