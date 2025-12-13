// UI Visibility Configuration
// Central place to manage which UI elements are visible based on mode and device

import type { PrinterModel } from "../types/index.js";

/**
 * UI element IDs used throughout the application
 */
export const UI_ELEMENTS = {
  // Settings Panel Elements
  TEST_FILE_EXPORT: 'test_file_export_container',
  PURGE_PLATE: 'opt_purge_plate',
  FILAMENT_PURGE_OFF: 'opt_filament_purge_off_plate',
  SECURE_PUSHOFF: 'opt_secure_pushoff',
  EXTRA_PUSHOFF_CONTAINER: 'extra_pushoff_container',
  BEDLEVEL_COOLING: 'bedlevel_cooling_container',
  AMS_OPTIMIZATION: 'ams-optimization-settings',
  PRINTER_SOUNDS: 'printer-sounds-settings',
  OVERRIDE_METADATA: 'opt_override_metadata',
  STARTSEQUENCE_SETTINGS: 'startsequence-settings',
  MECH_MODE_FAST_CHECK: 'opt_disable_mech_mode_fast_check_container',

  // Logo Elements
  SWAP_LOGO: 'logo',
  PUSHOFF_LOGO: 'logo_pushoff',
  SWAP_MODE_LOGOS: 'swap_mode_logos',
  APP_LOGO_CONTAINER: 'app_logo',

  // Button Elements
  EXPORT_BUTTON: 'export',
  EXPORT_GCODE_BUTTON: 'export_gcode',

  // Statistics
  STATISTICS: 'statistics',

  // Mode Toggle
  APP_MODE_TOGGLE: 'app_mode_toggle',

  // Printer Info
  PRINTER_MODEL_INFO: 'printer_model_info'
} as const;

/**
 * Device-specific visibility rules
 */
interface DeviceRules {
  visible: string[];
  hidden: string[];
}

/**
 * Mode-specific visibility configuration
 */
interface ModeVisibilityRules {
  visible: string[];
  hidden: string[];
  deviceRules: Record<PrinterModel, DeviceRules>;
}

/**
 * App mode type for visibility rules
 */
type AppModeKey = 'PUSHOFF' | 'SWAP';

/**
 * Visibility rules based on APP_MODE and PRINTER_MODEL
 */
export const VISIBILITY_RULES: Record<AppModeKey, ModeVisibilityRules> = {
  // Push Off Mode Rules
  PUSHOFF: {
    // Always visible in Push Off Mode
    visible: [
      UI_ELEMENTS.PUSHOFF_LOGO,
      UI_ELEMENTS.EXPORT_BUTTON,        // SWAP file export always available
      UI_ELEMENTS.EXPORT_GCODE_BUTTON,  // GCODE export always available
      UI_ELEMENTS.SECURE_PUSHOFF,
      UI_ELEMENTS.EXTRA_PUSHOFF_CONTAINER
      // Note: OVERRIDE_METADATA is controlled by developer mode in settings.ts
    ],
    // Always hidden in Push Off Mode
    hidden: [
      UI_ELEMENTS.TEST_FILE_EXPORT,
      UI_ELEMENTS.SWAP_LOGO,
      UI_ELEMENTS.SWAP_MODE_LOGOS,
      UI_ELEMENTS.AMS_OPTIMIZATION
    ],
    // Device-specific rules for Push Off Mode
    deviceRules: {
      A1M: {
        visible: [UI_ELEMENTS.PRINTER_SOUNDS],
        hidden: [
          UI_ELEMENTS.BEDLEVEL_COOLING,  // A1M doesn't support bed level cooling
          UI_ELEMENTS.MECH_MODE_FAST_CHECK  // A1M doesn't support mech mode fast check option
        ]
      },
      A1: {
        visible: [
          UI_ELEMENTS.PRINTER_SOUNDS,
          UI_ELEMENTS.MECH_MODE_FAST_CHECK  // A1 supports mech mode fast check option
        ],
        hidden: [UI_ELEMENTS.BEDLEVEL_COOLING]  // A1 doesn't support bed level cooling
      },
      X1: {
        visible: [
          UI_ELEMENTS.BEDLEVEL_COOLING,  // Only X1/P1 support bed level cooling
          UI_ELEMENTS.MECH_MODE_FAST_CHECK  // X1 supports mech mode fast check option
        ],
        hidden: [UI_ELEMENTS.PRINTER_SOUNDS]
      },
      P1: {
        visible: [
          UI_ELEMENTS.BEDLEVEL_COOLING,  // Only X1/P1 support bed level cooling
          UI_ELEMENTS.MECH_MODE_FAST_CHECK  // P1 supports mech mode fast check option
        ],
        hidden: [UI_ELEMENTS.PRINTER_SOUNDS]
      }
    }
  },

  // Swap Mode Rules
  SWAP: {
    // Always visible in Swap Mode
    visible: [
      UI_ELEMENTS.EXPORT_BUTTON
      // Note: TEST_FILE_EXPORT and OVERRIDE_METADATA are controlled by developer mode in settings.ts
    ],
    // Always hidden in Swap Mode
    hidden: [
      UI_ELEMENTS.PUSHOFF_LOGO,
      UI_ELEMENTS.EXPORT_GCODE_BUTTON,
      UI_ELEMENTS.BEDLEVEL_COOLING,
      UI_ELEMENTS.SECURE_PUSHOFF,
      UI_ELEMENTS.EXTRA_PUSHOFF_CONTAINER
    ],
    // Device-specific rules for Swap Mode
    deviceRules: {
      A1M: {
        visible: [
          UI_ELEMENTS.SWAP_LOGO,
          UI_ELEMENTS.AMS_OPTIMIZATION,
          UI_ELEMENTS.PRINTER_SOUNDS
        ],
        hidden: [
          UI_ELEMENTS.SWAP_MODE_LOGOS,
          UI_ELEMENTS.MECH_MODE_FAST_CHECK  // A1M doesn't support mech mode fast check option in swap mode
        ]
      },
      A1: {
        visible: [
          UI_ELEMENTS.SWAP_MODE_LOGOS,
          UI_ELEMENTS.AMS_OPTIMIZATION,
          UI_ELEMENTS.PRINTER_SOUNDS,
          UI_ELEMENTS.MECH_MODE_FAST_CHECK  // A1 supports mech mode fast check option in swap mode
        ],
        hidden: [
          UI_ELEMENTS.SWAP_LOGO
        ]
      },
      X1: {
        visible: [
          UI_ELEMENTS.SWAP_LOGO,
          UI_ELEMENTS.PURGE_PLATE,
          UI_ELEMENTS.FILAMENT_PURGE_OFF
        ],
        hidden: [
          UI_ELEMENTS.SWAP_MODE_LOGOS,
          UI_ELEMENTS.AMS_OPTIMIZATION,
          UI_ELEMENTS.PRINTER_SOUNDS
        ]
      },
      P1: {
        visible: [
          UI_ELEMENTS.SWAP_LOGO,
          UI_ELEMENTS.PURGE_PLATE,
          UI_ELEMENTS.FILAMENT_PURGE_OFF
        ],
        hidden: [
          UI_ELEMENTS.SWAP_MODE_LOGOS,
          UI_ELEMENTS.AMS_OPTIMIZATION,
          UI_ELEMENTS.PRINTER_SOUNDS
        ]
      }
    }
  }
};

/**
 * Global visibility configuration
 */
interface GlobalVisibilityRules {
  alwaysVisible: string[];
  alwaysHidden: string[];
}

/**
 * Global visibility rules (always apply regardless of mode)
 */
export const GLOBAL_RULES: GlobalVisibilityRules = {
  // Elements that are always visible (logos should always be visible)
  alwaysVisible: [
    UI_ELEMENTS.APP_LOGO_CONTAINER
  ],
  // Elements that are never visible (for future use)
  alwaysHidden: []
};

/**
 * Initial state visibility configuration
 */
interface InitialStateRules {
  hiddenOnStart: string[];
}

/**
 * Initial state - hide everything until a file is loaded
 */
export const INITIAL_STATE_RULES: InitialStateRules = {
  // Elements hidden on app start (before any files are loaded)
  hiddenOnStart: [
    UI_ELEMENTS.APP_MODE_TOGGLE,
    UI_ELEMENTS.PRINTER_MODEL_INFO,
    UI_ELEMENTS.STATISTICS,
    UI_ELEMENTS.EXPORT_BUTTON,
    UI_ELEMENTS.EXPORT_GCODE_BUTTON,
    UI_ELEMENTS.TEST_FILE_EXPORT,
    UI_ELEMENTS.AMS_OPTIMIZATION,
    UI_ELEMENTS.PRINTER_SOUNDS,
    UI_ELEMENTS.BEDLEVEL_COOLING,
    UI_ELEMENTS.SECURE_PUSHOFF,
    UI_ELEMENTS.EXTRA_PUSHOFF_CONTAINER,
    UI_ELEMENTS.OVERRIDE_METADATA,
    UI_ELEMENTS.MECH_MODE_FAST_CHECK
  ]
};

/**
 * Apply visibility rules based on current app mode and device
 * @param appMode - 'PUSHOFF' or 'SWAP'
 * @param currentMode - 'A1M', 'A1', 'X1', 'P1', etc.
 */
export function applyVisibilityRules(appMode: AppModeKey, currentMode: PrinterModel | null): void {
  const rules = VISIBILITY_RULES[appMode];
  if (!rules) {
    console.warn(`No visibility rules found for app mode: ${appMode}`);
    return;
  }

  // Apply global always visible rules
  GLOBAL_RULES.alwaysVisible.forEach(elementId => {
    const element = document.getElementById(elementId);
    if (element) {
      element.classList.remove('hidden');
      element.style.display = '';
    }
  });

  // Apply global always hidden rules
  GLOBAL_RULES.alwaysHidden.forEach(elementId => {
    const element = document.getElementById(elementId);
    if (element) {
      element.classList.add('hidden');
      element.style.display = 'none';
    }
  });

  // Apply mode-specific visible rules
  rules.visible.forEach(elementId => {
    const element = document.getElementById(elementId);
    if (element) {
      element.classList.remove('hidden');
      element.style.display = '';
    }
  });

  // Apply mode-specific hidden rules
  rules.hidden.forEach(elementId => {
    const element = document.getElementById(elementId);
    if (element) {
      element.classList.add('hidden');
      element.style.display = 'none';
    }
  });

  // Apply device-specific rules
  if (currentMode && rules.deviceRules && rules.deviceRules[currentMode]) {
    const deviceRules = rules.deviceRules[currentMode];

    // Device-specific visible rules
    deviceRules.visible.forEach(elementId => {
      const element = document.getElementById(elementId);
      if (element) {
        element.classList.remove('hidden');
        element.style.display = '';
      }
    });

    // Device-specific hidden rules
    deviceRules.hidden.forEach(elementId => {
      const element = document.getElementById(elementId);
      if (element) {
        element.classList.add('hidden');
        element.style.display = 'none';
      }
    });
  }

  console.log(`Applied visibility rules for ${appMode} mode on ${currentMode || 'unknown'} device`);
}

/**
 * Show a specific UI element
 * @param elementId - The ID of the element to show
 */
export function showElement(elementId: string): void {
  const element = document.getElementById(elementId);
  if (element) {
    element.classList.remove('hidden');
    element.style.display = '';
  }
}

/**
 * Hide a specific UI element
 * @param elementId - The ID of the element to hide
 */
export function hideElement(elementId: string): void {
  const element = document.getElementById(elementId);
  if (element) {
    element.classList.add('hidden');
    element.style.display = 'none';
  }
}

/**
 * Toggle visibility of a specific UI element
 * @param elementId - The ID of the element to toggle
 * @param visible - True to show, false to hide
 */
export function toggleElement(elementId: string, visible: boolean): void {
  if (visible) {
    showElement(elementId);
  } else {
    hideElement(elementId);
  }
}

/**
 * Apply initial state - hide UI elements until files are loaded
 */
export function applyInitialState(): void {
  INITIAL_STATE_RULES.hiddenOnStart.forEach(elementId => {
    const element = document.getElementById(elementId);
    if (element) {
      element.classList.add('hidden');
      element.style.display = 'none';
    }
  });

  console.log('Applied initial UI state - elements hidden until files are loaded');
}

/**
 * Show UI elements after files are loaded and printer is detected
 * @param appMode - 'PUSHOFF' or 'SWAP'
 * @param currentMode - 'A1M', 'A1', 'X1', 'P1', etc.
 */
export function showUIAfterFileLoad(appMode: AppModeKey, currentMode: PrinterModel | null): void {
  // First apply the standard visibility rules
  applyVisibilityRules(appMode, currentMode);

  // Always show these elements after file load regardless of mode
  const alwaysShowAfterLoad = [
    UI_ELEMENTS.APP_MODE_TOGGLE,
    UI_ELEMENTS.PRINTER_MODEL_INFO,
    UI_ELEMENTS.STATISTICS,
    UI_ELEMENTS.EXPORT_BUTTON,        // SWAP file export always available when plates loaded
    UI_ELEMENTS.EXPORT_GCODE_BUTTON   // GCODE export always available when plates loaded
  ];

  alwaysShowAfterLoad.forEach(elementId => {
    const element = document.getElementById(elementId);
    if (element) {
      element.classList.remove('hidden');
      element.style.display = '';
    }
  });

  console.log('UI elements shown after file load');
}
