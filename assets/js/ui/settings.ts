/**
 * Settings module for managing UI settings and per-plate configurations
 */

import { state } from '../config/state.js';
import { autoPopulatePlateCoordinates } from '../utils/plateUtils.js';

// Extend Window interface for global functions
declare global {
  interface Window {
    getSettingForPlate?: (plateIndex: number, settingId: string) => boolean;
    getDisablePrinterSounds?: () => boolean;
    getSoundRemovalMode?: () => string;
    getDisableBedLeveling?: () => boolean;
    getDisableFirstLayerScan?: () => boolean;
    i18nInstance?: {
      t: (key: string, params?: Record<string, unknown>) => string;
      translatePage: () => void;
    };
  }
}

/**
 * Per-plate settings interface
 */
interface PlateSettings {
  objectCount: number;
  objectCoords: number[];
  objects: Array<{ isWipeTower?: boolean; [key: string]: unknown }>;
  hidePurgeLoad: boolean;
  turnOffPurge: boolean;
  bedRaiseOffset: number;
  securePushoff: boolean;
  extraPushoffLevels: number;
}

const currentPlateSettings = new Map<number, PlateSettings>();
let selectedPlateIndex = 0;

/**
 * Toggle settings panel visibility
 */
export function toggle_settings(settingsState: boolean): void {
  const settingsPanel = document.getElementById("settings_panel");
  if (settingsPanel) {
    settingsPanel.classList.toggle("hidden", !settingsState);
  }

  // Legacy support - remove old settings wrapper if it exists
  const settingsWrapper = document.getElementById("settings_wrapper");
  if (settingsWrapper) {
    settingsWrapper.style.display = "none";
  }
}

/**
 * Show settings panel when plates are loaded
 */
export function show_settings_when_plates_loaded(): void {
  const plates = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)");
  const hasPlates = plates.length > 0;
  toggle_settings(hasPlates);

  if (hasPlates) {
    updatePlateSelector();
    updateSettingsVisibilityForMode();
  }
}

/**
 * Custom file name handler
 */
export function custom_file_name(trg: HTMLInputElement): void {
  if (trg.value === "") {
    trg.value = trg.placeholder;
    trg.select();
  }
}

/**
 * Adjust field length dynamically
 */
export function adj_field_length(trg: HTMLInputElement, min: number, max: number): void {
  let trg_val: string;
  if (trg.value === "") {
    trg_val = trg.placeholder;
  } else {
    trg_val = trg.value;
  }

  trg.style.width = Math.min(max, (Math.max(min, trg_val.length + 2))) + 'ch';
}

/**
 * Get user bed raise offset setting
 */
export function getUserBedRaiseOffset(): number {
  const el = document.getElementById("raisebed_offset_mm") as HTMLInputElement | null;
  const v = el ? parseFloat(el.value) : 30;
  return Number.isFinite(v) ? Math.max(0, Math.min(200, v)) : 30;
}

/**
 * Get cooldown target bed temperature
 */
export function getCooldownTargetBedTemp(): number {
  const el = document.getElementById("cooldown_target_bed_temp") as HTMLInputElement | null;
  const v = el ? parseFloat(el.value) : 23;
  // Allow 0..120°C
  return Number.isFinite(v) ? Math.max(0, Math.min(120, v)) : 23;
}

/**
 * Get secure push-off enabled setting
 */
export function getSecurePushOffEnabled(): boolean {
  const el = document.getElementById("opt_secure_pushoff") as HTMLInputElement | null;
  return !!(el && el.checked);
}

/**
 * Get extra push-off levels setting
 */
export function getExtraPushOffLevels(): number {
  const el = document.getElementById("extra_pushoff_levels") as HTMLInputElement | null;
  const n = el ? parseInt(el.value, 10) : 1;
  return Number.isFinite(n) ? Math.max(1, Math.min(10, n)) : 1;
}

/**
 * Get disable printer sounds setting
 */
export function getDisablePrinterSounds(): boolean {
  const el = document.getElementById("opt_disable_printer_sounds") as HTMLInputElement | null;
  return !!(el && el.checked);
}

/**
 * Get sound removal mode
 */
export function getSoundRemovalMode(): string {
  const allSounds = document.getElementById("sound_removal_all") as HTMLInputElement | null;
  const betweenPlates = document.getElementById("sound_removal_between_plates") as HTMLInputElement | null;

  if (allSounds && allSounds.checked) {
    return "all";
  } else if (betweenPlates && betweenPlates.checked) {
    return "between_plates";
  }
  return "all"; // default
}

/**
 * Get layer progress mode (always returns "global")
 */
export function getLayerProgressMode(): string {
  // Layer Progress UI removed - always return "global" as default behavior
  return "global";
}

/**
 * Get percentage progress mode
 */
export function getPercentageProgressMode(): string {
  const perPlate = document.getElementById("percentage_progress_per_plate") as HTMLInputElement | null;
  const global = document.getElementById("percentage_progress_global") as HTMLInputElement | null;

  if (global && global.checked) {
    return "global";
  } else if (perPlate && perPlate.checked) {
    return "per_plate";
  }
  return "per_plate"; // default
}

/**
 * Get cooldown max time
 */
export function getCooldownMaxTime(): number {
  const el = document.getElementById("cooldown_max_time") as HTMLInputElement | null;
  const n = el ? parseInt(el.value, 10) : 40;
  return Number.isFinite(n) ? Math.max(5, Math.min(120, n)) : 40;
}

/**
 * Get disable bed leveling setting
 */
export function getDisableBedLeveling(): boolean {
  const el = document.getElementById("opt_disable_bed_leveling") as HTMLInputElement | null;
  return !!(el && el.checked);
}

/**
 * Get disable first layer scan setting
 */
export function getDisableFirstLayerScan(): boolean {
  const el = document.getElementById("opt_disable_first_layer_scan") as HTMLInputElement | null;
  return !!(el && el.checked);
}

/**
 * Update plate selector with click handlers
 */
export function updatePlateSelector(): void {
  const plates = document.querySelectorAll<HTMLElement>("#playlist_ol li.list_item:not(.hidden)");
  const plateSpecificSettings = document.getElementById("plate_specific_settings");

  if (!plateSpecificSettings) return;

  // Add click listeners to plates for selection
  plates.forEach((li, index) => {
    // Remove any existing click listeners
    const existingHandler = (li as any)._plateClickHandler;
    if (existingHandler) {
      li.removeEventListener("click", existingHandler);
    }

    // Create new click handler
    const clickHandler = (event: MouseEvent) => {
      // Ignore clicks on buttons, inputs, etc.
      if ((event.target as HTMLElement).closest('button, input, select, .plate-remove, .plate-duplicate')) {
        return;
      }

      // Update selected plate
      selectPlate(index);
    };

    // Store handler reference for cleanup
    (li as any)._plateClickHandler = clickHandler;
    li.addEventListener("click", clickHandler);

    // Make plate visually interactive
    li.style.cursor = "pointer";
  });

  // Show/hide settings based on plate count
  if (plates.length > 0) {
    plateSpecificSettings.classList.remove("hidden");

    // Select first plate by default
    selectPlate(0);
  } else {
    plateSpecificSettings.classList.add("hidden");
  }
}

/**
 * Select a plate and display its settings
 */
export function selectPlate(plateIndex: number): void {
  const plates = document.querySelectorAll<HTMLElement>("#playlist_ol li.list_item:not(.hidden)");

  // Update visual selection
  plates.forEach((li, index) => {
    if (index === plateIndex) {
      li.classList.add("plate-selected");
    } else {
      li.classList.remove("plate-selected");
    }
  });

  // Update settings display
  selectedPlateIndex = plateIndex;
  displayPlateSettings(plateIndex);
}

/**
 * Display settings for a specific plate
 */
export function displayPlateSettings(plateIndex: number): void {
  const plateSpecificSettings = document.getElementById("plate_specific_settings");
  const template = document.getElementById("plate_settings_template") as HTMLTemplateElement | null;
  const plates = document.querySelectorAll<HTMLElement>("#playlist_ol li.list_item:not(.hidden)");

  if (!plateSpecificSettings || !template || plateIndex >= plates.length) return;

  // Clear current settings
  plateSpecificSettings.innerHTML = "";

  // Clone template
  const clone = template.content.cloneNode(true);
  plateSpecificSettings.appendChild(clone);

  // Translate the newly inserted template content
  if (window.i18nInstance) {
    window.i18nInstance.translatePage();
  }

  // Get the selected plate element
  const plateEl = plates[plateIndex];

  // Initialize settings for this plate if not exists
  if (!currentPlateSettings.has(plateIndex)) {
    initializePlateSettings(plateIndex);
  }

  console.log(`Displaying settings for plate ${plateIndex}, objectCount:`, currentPlateSettings.get(plateIndex)?.objectCount);

  // Load settings from plate element and our stored settings
  loadPlateSettingsToUI(plateIndex, plateEl);

  // Hide/show sections based on current app mode
  updateSettingsVisibilityForMode();

  // Hide/show purge off option based on plate index
  updatePurgeOffVisibility(plateIndex);

  // Add event listeners for the new settings
  addPlateSettingsEventListeners(plateIndex);
}

/**
 * Initialize default settings for a plate
 */
function initializePlateSettings(plateIndex: number): void {
  currentPlateSettings.set(plateIndex, {
    objectCount: 1,
    objectCoords: [],
    objects: [], // Store full object info including isWipeTower
    hidePurgeLoad: true,
    turnOffPurge: false,
    bedRaiseOffset: 30,
    securePushoff: true,
    extraPushoffLevels: 2
  });
}

/**
 * Load plate settings to UI
 */
function loadPlateSettingsToUI(plateIndex: number, plateEl: HTMLElement): void {
  const settings = currentPlateSettings.get(plateIndex);
  const plateSpecificSettings = document.getElementById("plate_specific_settings");
  if (!settings || !plateSpecificSettings) return;

  // Object count
  const objCountSelect = plateSpecificSettings.querySelector<HTMLSelectElement>(".obj-count");
  if (objCountSelect) {
    objCountSelect.value = String(settings.objectCount);
    objCountSelect.addEventListener("change", (e) => {
      settings.objectCount = parseInt((e.target as HTMLSelectElement).value, 10);
      renderPlateCoordinatesInSettings(plateIndex);
    });
    renderPlateCoordinatesInSettings(plateIndex);
  }

  // Hide purge load
  const hidePurgeCheck = plateSpecificSettings.querySelector<HTMLInputElement>(".opt_purge_plate");
  if (hidePurgeCheck) {
    hidePurgeCheck.checked = settings.hidePurgeLoad;
    hidePurgeCheck.addEventListener("change", (e) => {
      settings.hidePurgeLoad = (e.target as HTMLInputElement).checked;
    });
  }

  // Turn off purge (only for plates > 0)
  const turnOffPurgeCheck = plateSpecificSettings.querySelector<HTMLInputElement>(".opt_filament_purge_off_plate");
  if (turnOffPurgeCheck) {
    turnOffPurgeCheck.checked = settings.turnOffPurge;
    turnOffPurgeCheck.addEventListener("change", (e) => {
      settings.turnOffPurge = (e.target as HTMLInputElement).checked;
    });
  }

  // Bed raise offset
  const bedRaiseInput = plateSpecificSettings.querySelector<HTMLInputElement>(".raisebed_offset_mm_plate");
  if (bedRaiseInput) {
    bedRaiseInput.value = String(settings.bedRaiseOffset);
    bedRaiseInput.addEventListener("change", (e) => {
      settings.bedRaiseOffset = Math.max(5, Math.min(200, parseInt((e.target as HTMLInputElement).value, 10) || 30));
    });
  }

  // Secure pushoff
  const securePushoffCheck = plateSpecificSettings.querySelector<HTMLInputElement>(".opt_secure_pushoff_plate");
  if (securePushoffCheck) {
    securePushoffCheck.checked = settings.securePushoff;
    securePushoffCheck.addEventListener("change", (e) => {
      settings.securePushoff = (e.target as HTMLInputElement).checked;
    });
  }

  // Extra pushoff levels
  const extraLevelsInput = plateSpecificSettings.querySelector<HTMLInputElement>(".extra_pushoff_levels_plate");
  if (extraLevelsInput) {
    extraLevelsInput.value = String(settings.extraPushoffLevels);
    extraLevelsInput.addEventListener("change", (e) => {
      settings.extraPushoffLevels = Math.max(1, Math.min(10, parseInt((e.target as HTMLInputElement).value, 10) || 2));
    });
  }
}

/**
 * Render plate coordinate inputs in settings
 */
function renderPlateCoordinatesInSettings(plateIndex: number): void {
  const plateSpecificSettings = document.getElementById("plate_specific_settings");
  const coordsContainer = plateSpecificSettings?.querySelector<HTMLElement>(".obj-coords");
  const settings = currentPlateSettings.get(plateIndex);

  if (!coordsContainer || !settings) return;

  coordsContainer.innerHTML = "";
  const count = settings.objectCount;

  console.log(`Rendering ${count} coordinates for plate ${plateIndex}:`, settings.objectCoords);

  // Create grid container
  const gridContainer = document.createElement('div');
  gridContainer.className = 'obj-coords-grid';

  for (let i = 1; i <= count; i++) {
    const coordItem = document.createElement('div');
    coordItem.className = 'obj-coord-item';

    // Determine the label based on object info
    let objectLabel = `Objekt ${i}`;
    if (settings.objects && settings.objects[i - 1]) {
      const obj = settings.objects[i - 1];
      if (obj.isWipeTower) {
        objectLabel = 'Wipe Tower';
      } else {
        // Count non-wipe-tower objects up to current index
        const objectNumber = settings.objects.slice(0, i).filter(o => !o.isWipeTower).length;
        objectLabel = `Objekt ${objectNumber}`;
      }
    }

    coordItem.innerHTML = `
      <b>${objectLabel}</b>
      <label>X <input type="number" class="obj-x" step="1" value="${settings.objectCoords[i - 1] || 0}" min="0" max="255" data-obj="${i}"></label>
    `;

    const input = coordItem.querySelector<HTMLInputElement>('input');
    if (input) {
      input.addEventListener("change", (e) => {
        const objIndex = i - 1;
        if (!settings.objectCoords[objIndex]) settings.objectCoords[objIndex] = 0;
        settings.objectCoords[objIndex] = parseInt((e.target as HTMLInputElement).value, 10) || 0;
      });
    }

    gridContainer.appendChild(coordItem);
  }

  coordsContainer.appendChild(gridContainer);

  // Add auto-populate button for X1/P1 modes only (X-coordinates irrelevant for A1/A1M)
  if (state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1') {
    const autoBtn = document.createElement('button');
    autoBtn.type = 'button';
    autoBtn.className = 'btn-auto-coords';
    autoBtn.textContent = '📐 Auto-calculate from objects';
    autoBtn.title = 'Automatically calculate object count and X coordinates from plate data';
    autoBtn.style.marginTop = '8px';
    autoBtn.onclick = async () => {
      try {
        // Get the plate element from the list
        const plates = document.querySelectorAll<HTMLElement>("#playlist_ol li.list_item:not(.hidden)");
        if (plateIndex < plates.length) {
          const li = plates[plateIndex];
          await autoPopulatePlateCoordinates(li);
          // Refresh the settings UI to show updated coordinates
          setTimeout(() => renderPlateCoordinatesInSettings(plateIndex), 100);
        }
      } catch (error) {
        console.error("Failed to auto-populate plate coordinates:", error);
      }
    };
    coordsContainer.appendChild(autoBtn);
  }
}

/**
 * Update purge off option visibility based on plate index
 */
function updatePurgeOffVisibility(plateIndex: number): void {
  const plateSpecificSettings = document.getElementById("plate_specific_settings");
  const purgeOffWrapper = plateSpecificSettings?.querySelector<HTMLElement>(".purge-off-wrapper");
  if (purgeOffWrapper) {
    // Only show for plates after the first one (index > 0)
    purgeOffWrapper.style.display = plateIndex > 0 ? "block" : "none";
  }
}

/**
 * Add event listeners for plate settings
 */
function addPlateSettingsEventListeners(plateIndex: number): void {
  // Event listeners are already added in loadPlateSettingsToUI
  // This function can be used for additional listeners if needed
}

/**
 * Get settings for a specific plate
 */
export function getPlateSettings(plateIndex: number): PlateSettings | null {
  return currentPlateSettings.get(plateIndex) || null;
}

/**
 * Get all plate settings
 */
export function getAllPlateSettings(): Map<number, PlateSettings> {
  return currentPlateSettings;
}

/**
 * Duplicate settings from one plate to another
 */
export function duplicatePlateSettings(sourcePlateIndex: number, targetPlateIndex: number): void {
  const sourceSettings = currentPlateSettings.get(sourcePlateIndex);

  if (sourceSettings) {
    // Deep clone the settings object
    const clonedSettings: PlateSettings = {
      objectCount: sourceSettings.objectCount,
      objectCoords: [...(sourceSettings.objectCoords || [])],
      objects: sourceSettings.objects ? JSON.parse(JSON.stringify(sourceSettings.objects)) : [],
      hidePurgeLoad: sourceSettings.hidePurgeLoad,
      turnOffPurge: sourceSettings.turnOffPurge,
      bedRaiseOffset: sourceSettings.bedRaiseOffset,
      securePushoff: sourceSettings.securePushoff,
      extraPushoffLevels: sourceSettings.extraPushoffLevels
    };

    currentPlateSettings.set(targetPlateIndex, clonedSettings);
    console.log(`Duplicated settings from plate ${sourcePlateIndex} to plate ${targetPlateIndex}`, clonedSettings);
  } else {
    // If source doesn't have settings, initialize default settings for target
    initializePlateSettings(targetPlateIndex);
    console.log(`Source plate ${sourcePlateIndex} had no settings, initialized defaults for plate ${targetPlateIndex}`);
  }
}

/**
 * Get user bed raise offset for a specific plate
 */
export function getUserBedRaiseOffsetForPlate(plateIndex: number): number {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.bedRaiseOffset !== undefined) {
    return settings.bedRaiseOffset;
  }
  // Fallback to global setting
  return getUserBedRaiseOffset();
}

/**
 * Get secure push-off enabled for a specific plate
 */
export function getSecurePushOffEnabledForPlate(plateIndex: number): boolean {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.securePushoff !== undefined) {
    return settings.securePushoff;
  }
  // Fallback to global setting
  return getSecurePushOffEnabled();
}

/**
 * Get extra push-off levels for a specific plate
 */
export function getExtraPushOffLevelsForPlate(plateIndex: number): number {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.extraPushoffLevels !== undefined) {
    return settings.extraPushoffLevels;
  }
  // Fallback to global setting
  return getExtraPushOffLevels();
}

/**
 * Get hide purge load for a specific plate
 */
export function getHidePurgeLoadForPlate(plateIndex: number): boolean {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.hidePurgeLoad !== undefined) {
    return settings.hidePurgeLoad;
  }
  // Default for backwards compatibility
  return true;
}

/**
 * Get turn off purge for a specific plate
 */
export function getTurnOffPurgeForPlate(plateIndex: number): boolean {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.turnOffPurge !== undefined) {
    return settings.turnOffPurge;
  }
  // Default for backwards compatibility
  return false;
}

/**
 * Get object count for a specific plate
 */
export function getObjectCountForPlate(plateIndex: number): number {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.objectCount !== undefined) {
    return settings.objectCount;
  }
  // Default
  return 1;
}

/**
 * Get object coordinates for a specific plate
 */
export function getObjectCoordsForPlate(plateIndex: number): number[] {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.objectCoords !== undefined) {
    return settings.objectCoords;
  }
  // Default
  return [];
}

/**
 * Helper function for swap rules to get plate-specific settings
 */
export function getSettingForPlate(plateIndex: number, settingId: string): boolean {
  const settings = getPlateSettings(plateIndex);
  if (!settings) {
    // Fallback to global DOM element if no plate settings
    const el = document.getElementById(settingId) as HTMLInputElement | null;
    return !!(el && el.checked);
  }

  switch (settingId) {
    case 'opt_purge':
      return settings.hidePurgeLoad !== undefined ? settings.hidePurgeLoad : true;
    case 'opt_filament_purge_off':
      return settings.turnOffPurge !== undefined ? settings.turnOffPurge : false;
    default:
      // For unknown settings, fallback to DOM
      const el = document.getElementById(settingId) as HTMLInputElement | null;
      return !!(el && el.checked);
  }
}

// Make these functions available globally for gcodeUtils
window.getSettingForPlate = getSettingForPlate;
window.getDisablePrinterSounds = getDisablePrinterSounds;
window.getSoundRemovalMode = getSoundRemovalMode;
window.getDisableBedLeveling = getDisableBedLeveling;
window.getDisableFirstLayerScan = getDisableFirstLayerScan;

/**
 * Function to hide/show settings sections based on current app mode
 */
function updateSettingsVisibilityForMode(): void {
  const isSwapMode = state.APP_MODE === 'swap';
  const isA1Mode = state.PRINTER_MODEL === 'A1' || state.PRINTER_MODEL === 'A1M';
  const isPushoffMode = state.APP_MODE === 'pushoff';
  const isX1 = state.PRINTER_MODEL === 'X1';
  const isP1 = state.PRINTER_MODEL === 'P1';

  // Global settings sections - find cooling section by looking for all h4 elements
  const globalSection = document.getElementById('global_settings_section');
  if (globalSection) {
    const settingsGroups = globalSection.querySelectorAll<HTMLElement>('.settings-group');
    settingsGroups.forEach(group => {
      const h4 = group.querySelector('h4');
      if (h4 && h4.textContent?.includes('Cooling')) {
        group.classList.toggle('hidden', isSwapMode);
      }
      // Hide AMS Optimization section for non-A1/A1M printers
      if (h4 && h4.textContent?.includes('AMS Optimization')) {
        group.classList.toggle('hidden', !isA1Mode);
      }
      // Hide Printer Sounds section for non-A1/A1M printers
      if (h4 && h4.textContent?.includes('Printer Sounds')) {
        group.classList.toggle('hidden', !isA1Mode);
      }
      // Hide Startsequence section unless in pushoff mode with X1 or P1
      if (h4 && h4.textContent?.includes('Startsequence')) {
        const shouldShow = isPushoffMode && (isX1 || isP1);
        group.classList.toggle('hidden', !shouldShow);

        // Within Startsequence, handle individual checkbox visibility
        if (shouldShow) {
          const bedLevelingLabel = group.querySelector<HTMLElement>('label:has(#opt_disable_bed_leveling)');
          const firstLayerScanLabel = group.querySelector<HTMLElement>('label:has(#opt_disable_first_layer_scan)');

          // Bed leveling: X1 and P1 in pushoff mode
          if (bedLevelingLabel) {
            bedLevelingLabel.style.display = (isX1 || isP1) ? 'block' : 'none';
          }

          // First layer scan: X1 only in pushoff mode
          if (firstLayerScanLabel) {
            firstLayerScanLabel.style.display = isX1 ? 'block' : 'none';
          }
        }
      }
    });
  }

  // Setup sound settings event listeners if in A1/A1M mode
  setupSoundSettingsListeners();

  // Per-plate settings sections in template
  const plateSettings = document.getElementById('plate_specific_settings');
  if (plateSettings) {
    let hasVisibleGroups = false;

    // Objects section - find by h5 text content
    const settingsGroups = plateSettings.querySelectorAll<HTMLElement>('.settings-group');
    settingsGroups.forEach(group => {
      const h5 = group.querySelector('h5');
      if (h5) {
        const text = h5.textContent || "";
        if (text.includes('Objects')) {
          // Hide Objects section for SWAP mode OR for A1/A1M modes
          const shouldHide = isSwapMode || isA1Mode;
          group.classList.toggle('hidden', shouldHide);
          if (!shouldHide) {
            hasVisibleGroups = true;
          }
        } else if (text.includes('Nozzle') || text.includes('Push-off')) {
          group.classList.toggle('hidden', isSwapMode);
          if (!isSwapMode) {
            hasVisibleGroups = true;
          }
        } else {
          // Count other visible groups (like future custom sections)
          if (!group.classList.contains('hidden')) {
            hasVisibleGroups = true;
          }
        }
      }
    });

    // Hide/show the entire plate settings section based on whether it has visible content
    const plateSettingsSection = document.getElementById('plate_settings_section');
    if (plateSettingsSection) {
      plateSettingsSection.classList.toggle('hidden', isSwapMode && !hasVisibleGroups);
    }
  }

  console.log(`Settings visibility updated - SWAP: ${isSwapMode}, A1: ${isA1Mode}, Mode: ${state.PRINTER_MODEL}`);
}

/**
 * Function to setup sound settings event listeners
 */
function setupSoundSettingsListeners(): void {
  const disableSoundsCheckbox = document.getElementById("opt_disable_printer_sounds") as HTMLInputElement | null;
  const soundOptions = document.getElementById("sound_removal_options");

  if (disableSoundsCheckbox && soundOptions) {
    // Remove existing listeners first
    disableSoundsCheckbox.removeEventListener("change", toggleSoundOptions);

    // Add new listener
    disableSoundsCheckbox.addEventListener("change", toggleSoundOptions);

    // Set initial state
    toggleSoundOptions();
  }
}

/**
 * Toggle sound options visibility
 */
function toggleSoundOptions(): void {
  const disableSoundsCheckbox = document.getElementById("opt_disable_printer_sounds") as HTMLInputElement | null;
  const soundOptions = document.getElementById("sound_removal_options");

  if (disableSoundsCheckbox && soundOptions) {
    soundOptions.style.display = disableSoundsCheckbox.checked ? "block" : "none";
  }
}

/**
 * Function to reorder plate settings when plates are moved via drag and drop
 */
export function reorderPlateSettings(fromIndex: number, toIndex: number): void {
  console.log(`Reordering plate settings from index ${fromIndex} to ${toIndex}`);

  // Create a new Map to store the reordered settings
  const newSettings = new Map<number, PlateSettings>();
  const settingsArray: (PlateSettings | null)[] = [];

  // Convert current settings to an array, preserving order
  const plates = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)");
  for (let i = 0; i < plates.length; i++) {
    settingsArray.push(currentPlateSettings.get(i) || null);
  }

  // Perform the move operation on the array
  if (fromIndex >= 0 && fromIndex < settingsArray.length &&
    toIndex >= 0 && toIndex < settingsArray.length &&
    fromIndex !== toIndex) {

    const [movedSettings] = settingsArray.splice(fromIndex, 1);
    settingsArray.splice(toIndex, 0, movedSettings);

    // Rebuild the settings map with new indices
    for (let i = 0; i < settingsArray.length; i++) {
      if (settingsArray[i] !== null) {
        newSettings.set(i, settingsArray[i]!);
      }
    }

    // Replace the old settings map
    currentPlateSettings.clear();
    for (const [index, settings] of newSettings) {
      currentPlateSettings.set(index, settings);
    }

    console.log(`Plate settings reordered successfully. Settings now available for ${currentPlateSettings.size} plates`);
  }
}

// Export the function for external use
export { updateSettingsVisibilityForMode };
