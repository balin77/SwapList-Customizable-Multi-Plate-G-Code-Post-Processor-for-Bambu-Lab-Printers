// /src/gcode/gcodeUtils.ts

import { _escRe } from "../utils/regex.js";
import type { SwapRule, RuleContext } from "../types/index.js";

/**
 * Sound removal mode settings
 */
export type SoundRemovalMode = "all" | "between_plates" | "none";

/**
 * Result of a range find operation
 */
export interface RangeResult {
  /** Whether a valid range was found */
  found: boolean;
  /** Start index (after start pattern) */
  sIdx?: number;
  /** End index (before end pattern) */
  eIdx?: number;
}

// Type alias for GCodeContext (using RuleContext from types/index.ts)
export type GCodeContext = RuleContext;

/**
 * Counts occurrences of a pattern in the source string
 *
 * @param src - Source string to search
 * @param pattern - Pattern to search for
 * @param flags - RegExp flags (default: "gm")
 * @returns Number of matches found, 0 if error
 */
export function _countPattern(src: string, pattern: string, flags: string = "gm"): number {
  try {
    return [...src.matchAll(new RegExp(pattern, flags))].length;
  } catch (_) {
    return 0;
  }
}

/**
 * Checks if a source string contains a specific anchor pattern
 *
 * @param src - Source string to search
 * @param anchor - Anchor pattern to find
 * @param useRegex - Whether to treat anchor as regex (default: false)
 * @returns True if anchor is found
 */
export function _hasAnchor(src: string, anchor: string, useRegex: boolean = false): boolean {
  const re = useRegex
    ? new RegExp(anchor, "gm")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(anchor)}[^\\n]*(\\n|$)`, "gm");
  return re.test(src);
}

/**
 * Logs rule application results for debugging
 *
 * @param rule - The rule being applied
 * @param ctx - GCODE processing context
 * @param scope - Scope where rule was applied
 * @param before - GCODE before rule application
 * @param after - GCODE after rule application
 * @param extra - Additional log data
 */
export function _logRule(
  rule: SwapRule,
  ctx: GCodeContext,
  scope: string,
  before: string,
  after: string,
  extra: Record<string, unknown> = {}
): void {
  const applied = (after !== before);
  const delta = after.length - before.length;
  const payload = {
    id: rule.id,
    action: rule.action,
    scope,
    plate: ctx.plateIndex,
    totalPlates: ctx.totalPlates,
    mode: ctx.mode,
    isLastPlate: !!ctx.isLastPlate,
    applied,
    deltaBytes: delta,
    ...extra
  };
  // Success → info, otherwise warn (still visible)
  (applied ? console.info : console.warn)("[SWAP_RULE]", payload);
}

/**
 * Finds a range between start and end patterns in the source string
 *
 * @param src - Source string to search
 * @param start - Start pattern
 * @param end - End pattern
 * @param useRegex - Whether to treat patterns as regex (default: false)
 * @returns Range result with found flag and indices
 */
export function _findRange(
  src: string,
  start: string,
  end: string,
  useRegex: boolean = false
): RangeResult {
  const esc = (s: string) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const sRe = useRegex ? new RegExp(start, "m")
    : new RegExp(`(^|\\n)[ \\t]*${esc(start)}[^\\n]*\\n`, "m");
  const mS = src.match(sRe);
  if (!mS) return { found: false };
  const sIdx = (mS.index ?? 0) + mS[0].length;

  const eRe = useRegex ? new RegExp(end, "m")
    : new RegExp(`(^|\\n)[ \\t]*${esc(end)}[^\\n]*\\n`, "m");
  const rest = src.slice(sIdx);
  const mE = rest.match(eRe);
  if (!mE) return { found: false };
  return { found: true, sIdx, eIdx: sIdx + (mE.index ?? 0) };
}

/**
 * Determines why a rule is active or inactive based on conditions
 *
 * @param rule - The rule to check
 * @param ctx - GCODE processing context
 * @returns Status string: "active" or reason for being inactive
 */
export function _ruleActiveWhy(rule: SwapRule, ctx: GCodeContext): string {
  // Only for logging: why is it inactive?
  const w = rule.when || {};
  if (w.modes && w.modes.length && ctx.mode && !w.modes.includes(ctx.mode)) return "mode_mismatch";
  if (w.appModes && w.appModes.length && !w.appModes.includes(ctx.appMode)) return "appMode_mismatch";

  // Check per-plate settings if available, otherwise fallback to DOM elements
  for (const id of (w.requireTrue || [])) {
    let checked = false;

    // Try to get from per-plate settings first
    if (ctx.plateIndex !== undefined && typeof getSettingForPlate === 'function') {
      checked = getSettingForPlate(ctx.plateIndex, id);
    } else {
      // Fallback to DOM element check
      const el = document.getElementById(id);
      checked = !!(el && (el as HTMLInputElement).checked);
    }

    if (!checked) return `requireTrue_missing:${id}`;
  }

  for (const id of (w.requireFalse || [])) {
    let checked = false;

    // Try to get from per-plate settings first
    if (ctx.plateIndex !== undefined && typeof getSettingForPlate === 'function') {
      checked = getSettingForPlate(ctx.plateIndex, id);
    } else {
      // Fallback to DOM element check
      const el = document.getElementById(id);
      checked = !!(el && (el as HTMLInputElement).checked);
    }

    if (checked) return `requireFalse_blocked:${id}`;
  }

  const onlyIf = rule.onlyIf || {};
  if (Number.isFinite(onlyIf.plateIndexGreaterThan) && ctx.plateIndex !== undefined && !(ctx.plateIndex > onlyIf.plateIndexGreaterThan!)) return "plateIndexGreaterThan_false";
  if (Number.isFinite(onlyIf.plateIndexEquals) && ctx.plateIndex !== undefined && !(ctx.plateIndex === onlyIf.plateIndexEquals)) return "plateIndexEquals_false";
  if (typeof onlyIf.isLastPlate === "boolean" && !(!!ctx.isLastPlate === onlyIf.isLastPlate)) return "isLastPlate_mismatch";

  // Handle plateIndexLessThan with special case for "lastPlate"
  if (onlyIf.plateIndexLessThan !== undefined && ctx.plateIndex !== undefined) {
    let maxIndex: number;
    if (onlyIf.plateIndexLessThan === "lastPlate") {
      maxIndex = (ctx.totalPlates || 1) - 1;
    } else if (Number.isFinite(onlyIf.plateIndexLessThan)) {
      maxIndex = onlyIf.plateIndexLessThan as number;
    } else {
      return "plateIndexLessThan_invalid";
    }
    if (!(ctx.plateIndex < maxIndex)) return "plateIndexLessThan_false";
  }

  // Check sound removal mode
  if (onlyIf.soundRemovalMode) {
    let currentMode: SoundRemovalMode = "all"; // default
    try {
      // Import and use the sound settings functions
      if (typeof getSoundRemovalMode === 'function') {
        currentMode = getSoundRemovalMode();
      } else if (typeof window !== 'undefined' && (window as any).getSoundRemovalMode) {
        currentMode = (window as any).getSoundRemovalMode();
      }
    } catch (e) {
      console.warn("Failed to get sound removal mode:", e);
    }
    if (currentMode !== onlyIf.soundRemovalMode) return `soundRemovalMode_mismatch:${onlyIf.soundRemovalMode}`;
  }

  return "active";
}

/**
 * Resolves a variable name to its global value
 *
 * @param varName - Variable name to resolve
 * @returns String value of the variable, or empty string if not found
 */
export function resolvePayloadVar(varName: string): string {
  const v = (window && (window as any)[varName]) || (globalThis && (globalThis as any)[varName]);
  return (typeof v === "string") ? v : "";
}

// Declare global functions that may be available at runtime
declare global {
  function getSettingForPlate(plateIndex: number, settingId: string): boolean;
  function getSoundRemovalMode(): SoundRemovalMode;
}
