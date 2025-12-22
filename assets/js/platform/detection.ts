/**
 * Platform Detection
 *
 * Detects which platform the app is running on (Web vs Tauri Desktop).
 */

/**
 * Check if running in Tauri desktop app
 * Checks for both Tauri v1 (__TAURI__) and v2 (__TAURI_INTERNALS__)
 * Note: This is a function to ensure runtime evaluation
 */
export function isTauri(): boolean {
  return typeof window !== 'undefined' &&
    ('__TAURI__' in window || '__TAURI_INTERNALS__' in window);
}

/**
 * Get platform name
 */
export function getPlatform(): 'web' | 'desktop' {
  return isTauri() ? 'desktop' : 'web';
}

/**
 * Log platform information on startup
 */
export function logPlatformInfo(): void {
  const platform = getPlatform();
  console.log(`[SwapMod] Running on ${platform === 'desktop' ? 'Tauri Desktop' : 'Web'}`);

  if (isTauri()) {
    console.log('[SwapMod] Tauri features enabled: Native file dialogs, filesystem access');
  } else {
    console.log('[SwapMod] Web features enabled: Browser file API, blob downloads');
  }
}
