/**
 * Central type definitions for the SwapMod application
 */

// ============================================================================
// Printer & Mode Types
// ============================================================================

export type PrinterModel = 'A1M' | 'A1' | 'X1' | 'P1';
export type AppMode = 'swap' | 'pushoff';
export type SwapMode = 'jobox' | '3print' | 'printflow';

export const PRINTER_MODEL_MAP: Record<string, PrinterModel> = {
  "Bambu Lab X1 Carbon": "X1",
  "Bambu Lab X1": "X1",
  "Bambu Lab X1E": "X1",
  "Bambu Lab A1 mini": "A1M",
  "Bambu Lab A1": "A1",
  "Bambu Lab P1S": "P1",
  "Bambu Lab P1P": "P1",
};

// ============================================================================
// AMS (Automatic Material System) Types
// ============================================================================

export interface AMSSlot {
  id: number;
  color?: string;
  material?: string;
  [key: string]: unknown;
}

export interface AMSDevice {
  id: string | number;
  slots: AMSSlot[];
}

export interface AMSSlotMapping {
  [key: string]: string | number; // mapping key -> slot number or slot key
}

export interface GlobalAMS {
  devices: AMSDevice[];
  overridesPerPlate: Map<number, AMSSlotMapping>;
  seenKeys: Set<string>;
  slotCompactionMap: Map<number, number>;
}

// ============================================================================
// File & Plate Types
// ============================================================================

export interface PlateMetadata {
  index: number;
  name?: string;
  gcode?: string;
  thumbnail?: string;
  filaments?: FilamentInfo[];
  [key: string]: unknown;
}

export interface FilamentInfo {
  id: string | number;
  color?: string;
  type?: string;
  used_g?: number;
  used_m?: number;
  [key: string]: unknown;
}

export interface FileData {
  name: string;
  plates: PlateMetadata[];
  printerModel?: string;
  [key: string]: unknown;
}

// ============================================================================
// Application State Type
// ============================================================================

export interface AppState {
  // Global flags
  USE_PURGE_START: boolean;
  USE_BEDLEVEL_COOLING: boolean;
  PRINTER_MODEL: PrinterModel | null;
  APP_MODE: AppMode;
  SWAP_MODE: SwapMode;

  // File handling
  my_files: FileData[];
  fileInput: HTMLInputElement | null;
  li_prototype: HTMLElement | null;
  playlist_ol: HTMLElement | null;
  err: Error | null;
  p_scale: HTMLElement | null;
  last_file: boolean;
  ams_max_file_id: number;

  // Nozzle configuration
  NOZZLE_DIAMETER_MM: number | null;
  NOZZLE_IS_02: boolean;

  // Features / Options
  enable_md5: boolean;
  open_in_bbs: boolean;

  // Controls project_settings + slice_info Filament-Override
  OVERRIDE_METADATA: boolean;

  // Developer mode flag
  DEVELOPER_MODE: boolean;

  // Don't swap last plate (push-off mode only)
  DONT_SWAP_LAST_PLATE: boolean;

  // AMS global state
  GLOBAL_AMS: GlobalAMS;

  // UI state for filament slot management
  forcedSlotCount?: number;

  // Additional properties used in the codebase
  P0?: unknown;
  instant_processing?: boolean;
}

// ============================================================================
// GCODE Types
// ============================================================================

export interface GCodeLine {
  raw: string;
  command?: string;
  parameters?: Record<string, string | number>;
  comment?: string;
}

export interface GCodeSection {
  start: number;
  end: number;
  type: 'header' | 'start_sequence' | 'body' | 'end_sequence';
  lines: string[];
}

// ============================================================================
// Rule Engine Types
// ============================================================================

export type RuleScope = 'startseq' | 'start' | 'start_sequence' | 'endseq' | 'end' | 'end_sequence' | 'body' | 'all' | 'header';

export type RuleAction =
  | 'disable_between'
  | 'disable_lines'
  | 'disable_inner_between'
  | 'disable_next_line_after_pattern'
  | 'disable_next_line_after_pattern_in_range'
  | 'insert_after'
  | 'insert_before'
  | 'prepend'
  | 'remove_lines_matching'
  | 'keep_only_last_matching'
  | 'remove_header_block'
  | 'bump_first_extrusion_to_e3'
  | 'bump_first_three_extrusions_x1_p1'
  | 'bump_first_three_extrusions_a1_pushoff';

/**
 * Conditions for when a rule should be applied
 */
export interface RuleWhen {
  modes: PrinterModel[];
  appModes: AppMode[];
  requireTrue: string[];  // Option keys that must be true
  requireFalse: string[]; // Option keys that must be false
}

/**
 * Context-specific conditions for rule application
 */
export interface RuleOnlyIf {
  plateIndexGreaterThan?: number;
  plateIndexEquals?: number;
  plateIndexLessThan?: number | string; // can be number or "lastPlate"
  isLastPlate?: boolean;
  soundRemovalMode?: string;
}

/**
 * Rule context passed during rule application
 */
export interface RuleContext {
  plateIndex?: number;
  mode: PrinterModel | null;
  appMode: AppMode;
  submode?: string;
  isLastPlate?: boolean;
  totalPlates?: number;
  maxZHeight?: number;
  [key: string]: unknown;
}

/**
 * Complete swap rule definition
 */
export interface SwapRule {
  // Identification
  id: string;
  description: string;
  enabled: boolean;
  order?: number;

  // Scope and action
  scope: RuleScope;
  action: RuleAction;

  // Conditions
  when: RuleWhen;
  onlyIf?: RuleOnlyIf;

  // Pattern matching (for disable_between, disable_lines, etc.)
  start?: string;
  end?: string;
  useRegex?: boolean;

  // Inner pattern matching (for disable_inner_between)
  innerStart?: string;
  innerEnd?: string;
  innerUseRegex?: boolean;

  // Anchors (for insert_after, insert_before)
  anchor?: string;
  occurrence?: 'first' | 'last';

  // Payload content
  payload?: string;
  payloadFnId?: string;
  payloadVar?: string;
  wrapWithMarkers?: boolean;

  // Pattern operations (for remove_lines_matching, etc.)
  pattern?: string;
  patternFlags?: string;
  patternUseRegex?: boolean;
  appendIfMissing?: string;

  // Line operations (for disable_lines)
  lines?: string[];
}

/**
 * Plate restriction validation result
 */
export interface PlateRestrictionWarning {
  restrictionId: string;
  type: 'warning' | 'error';
  plateIndex: number;
  message: string;
  severity: 'low' | 'medium' | 'high';
}

/**
 * Plate restriction rule
 */
export interface PlateRestriction {
  id: string;
  description: string;
  enabled: boolean;
  when: {
    modes: PrinterModel[];
    appModes: AppMode[];
    submodes?: string[];
  };
  validate: (plateData: PlateData, plateIndex: number) => PlateRestrictionWarning | null;
}

/**
 * Plate data with bounding box information
 */
export interface PlateData {
  bbox_objects?: Array<{
    bbox: [number, number, number, number, number, number]; // [x_min, y_min, z_min, x_max, y_max, z_max]
    [key: string]: unknown;
  }>;
  [key: string]: unknown;
}

// ============================================================================
// Internationalization (i18n) Types
// ============================================================================

export type SupportedLocale = 'en' | 'de' | 'fr' | 'es' | 'it' | 'pt' | 'ru' | 'zh';

/**
 * Translation dictionary structure
 */
export interface TranslationDictionary {
  [key: string]: string | TranslationDictionary;
}

/**
 * Variable substitution map for translations
 */
export interface TranslationVariables {
  [key: string]: string | number;
}

/**
 * I18n instance interface for global access
 */
export interface I18nInstance {
  t: (key: string, variables?: TranslationVariables) => string;
  translatePage: () => void;
  loadLocale: (locale: SupportedLocale) => Promise<void>;
  getCurrentLocale: () => SupportedLocale;
  detectPreferredLocale: () => SupportedLocale;
  setLocale: (locale: SupportedLocale) => Promise<void>;
}

// ============================================================================
// Global Window Extensions
// ============================================================================

declare global {
  interface Window {
    i18nInstance?: I18nInstance;
    updateAppModeDisplay?: (isPushOffMode: boolean) => void;
    updateFilenamePreview?: () => void;
    getSettingForPlate?: (plateIndex: number, settingId: string) => boolean;
    getDisablePrinterSounds?: () => boolean;
    getSoundRemovalMode?: () => string;
    getDisableBedLeveling?: () => boolean;
    getDisableFirstLayerScan?: () => boolean;
    getDisableMechModeFastCheck?: () => boolean;
    repaintAllPlateSwatchesFromStats?: () => void;
  }
}

// ============================================================================
// UI Types
// ============================================================================

export interface ColorRGB {
  r: number;
  g: number;
  b: number;
}

export interface ColorHSL {
  h: number;
  s: number;
  l: number;
}

// ============================================================================
// Export Types
// ============================================================================

export interface ExportOptions {
  mode: AppMode;
  printerModel: PrinterModel;
  enableMD5?: boolean;
  openInBBS?: boolean;
  overrideMetadata?: boolean;
  [key: string]: unknown;
}

// ============================================================================
// Utility Types
// ============================================================================

export type Nullable<T> = T | null;
export type Optional<T> = T | undefined;
export type RecursivePartial<T> = {
  [P in keyof T]?: T[P] extends (infer U)[]
    ? RecursivePartial<U>[]
    : T[P] extends object
    ? RecursivePartial<T[P]>
    : T[P];
};
