// /src/gcode/gcodeUtils.js

import { _escRe } from "../utils/regex.js";

export function _countPattern(src, pattern, flags = "gm") {
  try { return [...src.matchAll(new RegExp(pattern, flags))].length; }
  catch (_) { return 0; }
}

export function _hasAnchor(src, anchor, useRegex = false) {
  const re = useRegex
    ? new RegExp(anchor, "gm")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(anchor)}[^\\n]*(\\n|$)`, "gm"); // ← (\n|$)
  return re.test(src);
}

export function _logRule(rule, ctx, scope, before, after, extra = {}) {
  const applied = (after !== before);
  const delta = after.length - before.length;
  const payload = {
    id: rule.id, action: rule.action, scope,
    plate: ctx.plateIndex, totalPlates: ctx.totalPlates,
    mode: ctx.mode, isLastPlate: !!ctx.isLastPlate,
    applied, deltaBytes: delta,
    ...extra
  };
  // Erfolg -> info, sonst warn (noch sichtbar)
  (applied ? console.info : console.warn)("[SWAP_RULE]", payload);
}

export function _findRange(src, start, end, useRegex = false) {
  const esc = s => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
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

export function _ruleActiveWhy(rule, ctx) {
  // Nur fürs Loggen: warum inaktiv?
  const w = rule.when || {};
  if (w.modes && w.modes.length && !w.modes.includes(ctx.mode)) return "mode_mismatch";
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
      checked = el && el.checked;
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
      checked = el && el.checked;
    }

    if (checked) return `requireFalse_blocked:${id}`;
  }

  const onlyIf = rule.onlyIf || {};
  if (Number.isFinite(onlyIf.plateIndexGreaterThan) && !(ctx.plateIndex > onlyIf.plateIndexGreaterThan)) return "plateIndexGreaterThan_false";
  if (Number.isFinite(onlyIf.plateIndexEquals) && !(ctx.plateIndex === onlyIf.plateIndexEquals)) return "plateIndexEquals_false";
  if (typeof onlyIf.isLastPlate === "boolean" && !(!!ctx.isLastPlate === onlyIf.isLastPlate)) return "isLastPlate_mismatch";

  // Handle plateIndexLessThan with special case for "lastPlate"
  if (onlyIf.plateIndexLessThan !== undefined) {
    let maxIndex;
    if (onlyIf.plateIndexLessThan === "lastPlate") {
      maxIndex = (ctx.totalPlates || 1) - 1;
    } else if (Number.isFinite(onlyIf.plateIndexLessThan)) {
      maxIndex = onlyIf.plateIndexLessThan;
    } else {
      return "plateIndexLessThan_invalid";
    }
    if (!(ctx.plateIndex < maxIndex)) return "plateIndexLessThan_false";
  }

  // Check sound removal mode
  if (onlyIf.soundRemovalMode) {
    let currentMode = "all"; // default
    try {
      // Import and use the sound settings functions
      if (typeof getSoundRemovalMode === 'function') {
        currentMode = getSoundRemovalMode();
      } else if (typeof window !== 'undefined' && window.getSoundRemovalMode) {
        currentMode = window.getSoundRemovalMode();
      }
    } catch (e) {
      console.warn("Failed to get sound removal mode:", e);
    }
    if (currentMode !== onlyIf.soundRemovalMode) return `soundRemovalMode_mismatch:${onlyIf.soundRemovalMode}`;
  }

  return "active";
}

export function resolvePayloadVar(varName) {
  const v = (window && window[varName]) || (globalThis && globalThis[varName]);
  return (typeof v === "string") ? v : "";
}
