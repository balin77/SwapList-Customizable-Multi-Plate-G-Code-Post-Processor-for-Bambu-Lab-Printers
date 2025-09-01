// /src/config/state.js

export const state = {
  // globale Flags
  USE_PURGE_START: false,
  USE_BEDLEVEL_COOLING: false,
  CURRENT_MODE: null,            // "A1M" | "X1" | "P1" | null

  // File Handling
  my_files: [],
  fileInput: null,
  li_prototype: null,
  playlist_ol: null,
  err: null,
  p_scale: null,
  instant_processing: false,
  last_file: false,
  ams_max_file_id: -1,

  // Features / Optionen
  enable_md5: true,
  open_in_bbs: false,

  // steuert project_settings + slice_info Filament-Override
  OVERRIDE_METADATA: true,

  // AMS global state
  GLOBAL_AMS: {
    devices: [],                 // [{id, slots:[...]}]
    overridesPerPlate: new Map(),// plateIndex -> mapping
    seenKeys: new Set(),         // alle in allen Platten gefundenen Keys
  },
};
