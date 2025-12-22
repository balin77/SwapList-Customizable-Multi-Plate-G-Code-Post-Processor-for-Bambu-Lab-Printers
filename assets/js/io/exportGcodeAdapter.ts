// Platform-agnostic adapter for exportGcode
// Uses @swapmod/core for GCODE export logic with UI-specific callbacks
// Automatically uses Tauri or Web download based on environment

import { exportGcode as coreExportGcode, type ExportGcodeCallbacks } from '@swapmod/core';
import { update_progress } from '../ui/progressbar.js';
import { showError } from '../ui/infobox.js';
import { downloadFile } from '../platform/index.js';

/**
 * Web adapter for exportGcode that integrates with UI
 * Uses core exportGcode function with progress callbacks
 *
 * @param gcode - GCODE string to export
 * @param filename - Target filename
 * @returns Promise that resolves when export is complete
 */
export async function exportGcodeWithUI(gcode: string, filename: string): Promise<void> {
  const callbacks: ExportGcodeCallbacks = {
    onProgress: (progress: number, message: string) => {
      update_progress(progress);
      console.log(`[Export GCODE] ${progress}% - ${message}`);
    },
    onError: (message: string) => {
      showError(message);
      update_progress(-1);
    }
  };

  try {
    const { blob, filename: exportFilename } = await coreExportGcode(gcode, filename, callbacks);

    // Use platform-agnostic download (Tauri native dialog or browser download)
    const success = await downloadFile(exportFilename, blob);

    if (success) {
      update_progress(100);
      setTimeout(() => update_progress(-1), 500);
    } else {
      showError('Download wurde abgebrochen');
      update_progress(-1);
    }
  } catch (err) {
    const error = err as Error;
    console.error('GCODE export failed:', err);
    showError('GCODE-Export fehlgeschlagen: ' + (error.message || err));
    update_progress(-1);
    throw err;
  }
}

/**
 * Calculate GCODE file size for display
 *
 * @param gcode - GCODE string
 * @returns Human-readable file size string
 */
export function formatGcodeFileSize(gcode: string): string {
  const bytes = new Blob([gcode]).size;

  if (bytes < 1024) {
    return `${bytes} B`;
  } else if (bytes < 1024 * 1024) {
    return `${(bytes / 1024).toFixed(2)} KB`;
  } else {
    return `${(bytes / (1024 * 1024)).toFixed(2)} MB`;
  }
}
