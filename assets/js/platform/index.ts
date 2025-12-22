/**
 * Platform Abstraction Layer
 *
 * Exports platform detection and adapters for file operations.
 * Use these instead of direct browser or Tauri APIs for cross-platform compatibility.
 */

export * from './detection.js';
export * from './adapters.js';
