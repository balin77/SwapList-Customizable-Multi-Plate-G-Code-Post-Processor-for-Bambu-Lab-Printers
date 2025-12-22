/**
 * Settings Collector for Web UI
 *
 * Collects all settings from the DOM and converts them to GcodeSettings format
 * for use with @swapmod/core functions.
 */

import type { GcodeSettings, PlateSpecificSettings } from '../types/index.js';
import {
  getSecurePushOffEnabled,
  getExtraPushOffLevels,
  getUserBedRaiseOffset,
  getCooldownTargetBedTemp,
  getCooldownMaxTime,
  getDisablePrinterSounds,
  getSoundRemovalMode,
  getLayerProgressMode,
  getPercentageProgressMode,
  getDisableBedLeveling,
  getDisableFirstLayerScan,
  getDontSwapLastPlate,
  getDisableMechModeFastCheck,
  getSecurePushOffEnabledForPlate,
  getExtraPushOffLevelsForPlate,
  getUserBedRaiseOffsetForPlate,
  getWaitMinutesBeforeSwapForPlate,
} from './settings.js';

/**
 * Collects all global settings from the UI
 */
export function collectGlobalSettings(): GcodeSettings {
  return {
    securePushOffEnabled: getSecurePushOffEnabled(),
    extraPushOffLevels: getExtraPushOffLevels(),
    userBedRaiseOffset: getUserBedRaiseOffset(),
    cooldownTargetBedTemp: getCooldownTargetBedTemp(),
    cooldownMaxTime: getCooldownMaxTime(),
    disablePrinterSounds: getDisablePrinterSounds(),
    soundRemovalMode: getSoundRemovalMode(),
    layerProgressMode: getLayerProgressMode(),
    percentageProgressMode: getPercentageProgressMode(),
    disableBedLeveling: getDisableBedLeveling(),
    disableFirstLayerScan: getDisableFirstLayerScan(),
    dontSwapLastPlate: getDontSwapLastPlate(),
    disableMechModeFastCheck: getDisableMechModeFastCheck(),
  };
}

/**
 * Collects per-plate settings for a specific plate
 */
export function collectPlateSettings(plateIndex: number): PlateSpecificSettings {
  return {
    securePushoff: getSecurePushOffEnabledForPlate(plateIndex),
    extraPushoffLevels: getExtraPushOffLevelsForPlate(plateIndex),
    bedRaiseOffset: getUserBedRaiseOffsetForPlate(plateIndex),
    waitMinutesBeforeSwap: getWaitMinutesBeforeSwapForPlate(plateIndex),
  };
}

/**
 * Collects all settings (global + per-plate for all plates)
 */
export function collectAllSettings(plateCount: number): GcodeSettings {
  const settings: GcodeSettings = collectGlobalSettings();

  // Collect per-plate settings
  settings.perPlate = new Map<number, PlateSpecificSettings>();
  for (let i = 0; i < plateCount; i++) {
    settings.perPlate.set(i, collectPlateSettings(i));
  }

  return settings;
}

/**
 * Collects settings for a single plate context
 * Includes global settings + specific plate settings
 */
export function collectSettingsForPlate(plateIndex: number): GcodeSettings {
  const settings: GcodeSettings = collectGlobalSettings();

  // Add this plate's specific settings
  settings.perPlate = new Map<number, PlateSpecificSettings>();
  settings.perPlate.set(plateIndex, collectPlateSettings(plateIndex));

  return settings;
}
