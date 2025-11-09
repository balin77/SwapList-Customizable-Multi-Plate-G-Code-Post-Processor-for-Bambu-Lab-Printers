// /src/gcode/gcodeManipulation.ts

import { _escRe } from "../utils/regex.js";
import { state } from "../config/state.js";
import { _findRange } from "../gcode/gcodeUtils.js";
import { _parseAmsParams } from "../utils/amsUtils.js";

/**
 * Options for marker-based operations
 */
export interface MarkerOptions {
  /** Whether to use regex for pattern matching */
  useRegex?: boolean;
}

/**
 * Options for prepend/insert operations
 */
export interface InsertOptions {
  /** Guard ID to prevent duplicate insertions */
  guardId?: string;
  /** Whether to wrap with markers */
  wrapWithMarkers?: boolean;
  /** Whether to use regex for pattern matching */
  useRegex?: boolean;
  /** Which occurrence to target ("first" or "last") */
  occurrence?: "first" | "last";
}

/**
 * Options for inner marker operations
 */
export interface InnerMarkerOptions {
  /** Start marker for outer range */
  start: string;
  /** End marker for outer range */
  end: string;
  /** Start marker for inner range to disable */
  innerStart: string;
  /** End marker for inner range to disable */
  innerEnd: string;
  /** Whether to use regex for outer markers */
  useRegex?: boolean;
  /** Whether to use regex for inner markers */
  innerUseRegex?: boolean;
  /** Whether to process all pairs or just the first */
  allPairs?: boolean;
}

/**
 * Options for disabling next line after pattern
 */
export interface DisableNextLineInRangeOptions {
  /** Start marker for range */
  start: string;
  /** End marker for range */
  end: string;
  /** Pattern to search for */
  pattern: string;
  /** Whether to use regex for range markers */
  useRegex?: boolean;
  /** Whether to use regex for pattern */
  patternUseRegex?: boolean;
}

/**
 * Replaces content between start and end markers
 *
 * @param gcode - GCODE string
 * @param startMark - Start marker
 * @param endMark - End marker
 * @param content - New content to inject
 * @returns Modified GCODE string
 */
export function injectBetweenMarkers(gcode: string, startMark: string, endMark: string, content: string): string {
  const s = gcode.indexOf(startMark);
  if (s === -1) return gcode;
  const e = gcode.indexOf(endMark, s);
  if (e === -1 || e < s) return gcode;

  const insertPos = s + startMark.length;
  const before = gcode.slice(0, insertPos);
  const after = gcode.slice(e);

  const needsNLBefore = before.length && before[before.length - 1] !== '\n';
  const needsNLAfter = after.length && after[0] !== '\n';

  const middle = (needsNLBefore ? "\n" : "") + (content.endsWith("\n") ? content : content + "\n");
  const tail = (needsNLAfter ? "\n" : "") + after;

  return before + middle + tail;
}

/**
 * Disables (removes) content between start and end markers
 *
 * @param gcode - GCODE string
 * @param start - Start marker
 * @param end - End marker
 * @param options - Marker options
 * @returns Modified GCODE string
 */
export function disableBetweenMarkers(gcode: string, start: string, end: string, options: MarkerOptions = {}): string {
  const { useRegex = false } = options;
  const esc = (s: string) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const startRe = useRegex ? new RegExp(start, "m")
    : new RegExp(`(^|\\n)[ \\t]*${esc(start)}[^\\n]*\\n`, "m");
  const mStart = gcode.match(startRe);
  if (!mStart) return gcode;
  const sIdx = (mStart.index ?? 0) + mStart[0].length;

  const endRe = useRegex ? new RegExp(end, "m")
    : new RegExp(`(^|\\n)[ \\t]*${esc(end)}[^\\n]*\\n`, "m");
  const rest = gcode.slice(sIdx);
  const mEnd = rest.match(endRe);
  if (!mEnd) return gcode;
  const eIdx = sIdx + (mEnd.index ?? 0);

  // → Remove content completely
  return gcode.slice(0, sIdx) + gcode.slice(eIdx);
}

/**
 * Prepends a block to the beginning of GCODE (idempotent with optional guard markers)
 *
 * @param gcode - GCODE string
 * @param block - Block to prepend
 * @param options - Insert options
 * @returns Modified GCODE string
 */
export function prependBlock(gcode: string, block: string, options: InsertOptions = {}): string {
  const { guardId = "", wrapWithMarkers = true } = options;
  if (!block) return gcode;
  if (wrapWithMarkers && guardId && _alreadyInserted(gcode, guardId)) return gcode;

  let payload = block.replace(/\r\n/g, "\n");
  const needsNL = (gcode[0] && gcode[0] !== '\n') ? "\n" : "";
  return payload + needsNL + gcode;
}

/**
 * Inserts content before an anchor (first or last occurrence)
 *
 * @param gcode - GCODE string
 * @param anchor - Anchor pattern to search for
 * @param payload - Content to insert
 * @param options - Insert options
 * @returns Modified GCODE string
 */
export function insertBeforeAnchor(
  gcode: string,
  anchor: string,
  payload: string,
  options: InsertOptions = {}
): string {
  const { useRegex = false, occurrence = "last", guardId: _guardId = "", wrapWithMarkers: _wrapWithMarkers = true } = options;
  if (!payload) return gcode;

  const re = useRegex
    ? new RegExp(anchor, "gm")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(anchor)}[^\\n]*(\\n|$)`, "gm");

  let match: RegExpExecArray | null = null;
  if (occurrence === "first") {
    match = re.exec(gcode);
  } else {
    let m: RegExpExecArray | null;
    let last: RegExpExecArray | null = null;
    while ((m = re.exec(gcode)) !== null) {
      if (m[0].length === 0) break;
      last = m;
    }
    match = last;
  }
  if (!match) return gcode;

  const insertPos = match.index; // ← BEFORE the anchor
  let block = payload.replace(/\r\n/g, "\n");
  return gcode.slice(0, insertPos) + block + gcode.slice(insertPos);
}

/**
 * Inserts content after an anchor (first or last occurrence)
 *
 * @param gcode - GCODE string
 * @param anchor - Anchor pattern to search for
 * @param payload - Content to insert
 * @param options - Insert options
 * @returns Modified GCODE string
 */
export function insertAfterAnchor(
  gcode: string,
  anchor: string,
  payload: string,
  options: InsertOptions = {}
): string {
  const { useRegex = false, occurrence = "last", guardId: _guardId = "", wrapWithMarkers: _wrapWithMarkers = true } = options;
  if (!payload) return gcode;

  const re = useRegex
    ? new RegExp(anchor, "gm")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(anchor)}[^\\n]*(\\n|$)`, "gm");

  let match: RegExpExecArray | null = null;
  if (occurrence === "first") {
    match = re.exec(gcode);
  } else {
    let m: RegExpExecArray | null;
    let last: RegExpExecArray | null = null;
    while ((m = re.exec(gcode)) !== null) {
      if (m[0].length === 0) break;
      last = m;
    }
    match = last;
  }
  if (!match) return gcode;

  const insertPos = match.index + match[0].length;
  let block = payload.replace(/\r\n/g, "\n");
  return gcode.slice(0, insertPos) + block + gcode.slice(insertPos);
}

/**
 * Disables specific lines within a range
 *
 * @param gcode - GCODE string
 * @param start - Start marker
 * @param end - End marker
 * @param lines - Lines to disable
 * @param options - Marker options
 * @returns Modified GCODE string
 */
export function disableSpecificLinesInRange(
  gcode: string,
  start: string,
  end: string,
  lines: string[],
  options: MarkerOptions = {}
): string {
  const { useRegex = false } = options;
  if (!Array.isArray(lines) || lines.length === 0) return gcode;
  const sRe = useRegex ? new RegExp(start, "m")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(start)}[^\\n]*\\n`, "m");
  const mS = gcode.match(sRe);
  if (!mS) return gcode;
  const sIdx = (mS.index ?? 0) + mS[0].length;

  const eRe = useRegex ? new RegExp(end, "m")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(end)}[^\\n]*\\n`, "m");
  const rest = gcode.slice(sIdx);
  const mE = rest.match(eRe);
  if (!mE) return gcode;
  const eIdx = sIdx + (mE.index ?? 0);

  const before = gcode.slice(0, sIdx);
  let middle = gcode.slice(sIdx, eIdx);
  const after = gcode.slice(eIdx);

  const removedLines: string[] = [];
  for (const raw of lines) {
    const lineRe = new RegExp(`(^|\\n)[ \\t]*${_escRe(raw)}[^\\n]*(\\n|$)`, "m");
    const match = middle.match(lineRe);
    if (match) {
      removedLines.push(match[0].trim());
      middle = middle.replace(lineRe, ""); // Remove line completely
    }
  }

  return before + middle + after;
}

/**
 * Disables an inner range within an outer range
 *
 * @param gcode - GCODE string
 * @param opts - Inner marker options
 * @returns Modified GCODE string
 */
export function disableInnerBetweenMarkers(gcode: string, opts: InnerMarkerOptions): string {
  const { start, end, innerStart, innerEnd, useRegex = false, innerUseRegex = false } = opts;
  const outerRange = _findRange(gcode, start, end, useRegex);
  if (!outerRange.found) return gcode;

  const before = gcode.slice(0, outerRange.sIdx);
  let middle = gcode.slice(outerRange.sIdx, outerRange.eIdx);
  const after = gcode.slice(outerRange.eIdx);

  // Reuse disableBetweenMarkers on the middle part
  middle = disableBetweenMarkers(middle, innerStart, innerEnd, { useRegex: innerUseRegex });

  return before + middle + after;
}

/**
 * Optimizes AMS blocks by removing redundant swap sequences
 *
 * @param gcodeArray - Array of GCODE strings (one per plate)
 * @returns Modified GCODE array with optimized AMS blocks
 */
export function optimizeAMSBlocks(gcodeArray: string[]): string[] {
  // Defensive: wrong type -> do nothing
  if (!Array.isArray(gcodeArray)) return gcodeArray;

  // Check if AMS optimization is enabled via checkbox
  const amsOptimizationCheckbox = document.getElementById('opt_ams_optimization') as HTMLInputElement | null;
  const isAmsOptimizationEnabled = amsOptimizationCheckbox ? amsOptimizationCheckbox.checked : true;

  if (!isAmsOptimizationEnabled) {
    console.log('AMS optimization skipped - disabled by user setting');
    return gcodeArray;
  }

  // Only apply optimization for A1/A1M printers in swap mode
  const isA1Mode = state.PRINTER_MODEL === 'A1' || state.PRINTER_MODEL === 'A1M';
  if (!isA1Mode || state.APP_MODE !== 'swap') {
    console.log(`AMS optimization skipped - only applies to A1/A1M in swap mode (current: ${state.PRINTER_MODEL}, ${state.APP_MODE})`);
    return gcodeArray;
  }

  // We detect AMS swaps with "\nM620 S"
  const ams_flag = "\nM620 S";

  // Collect findings
  const ams_flag_index: number[] = [];   // Index in the respective string (position of character after \n)
  const ams_flag_plate: number[] = [];   // Index of the plate (element in array)
  const ams_flag_value: number[] = [];   // Numeric value after "M620 S" (e.g., 255, 0..3, ...)

  for (let plate = 0; plate < gcodeArray.length; plate++) {
    const g = gcodeArray[plate];
    if (!g) continue;
    let searchFrom = 0;
    while (true) {
      const idx = g.indexOf(ams_flag, searchFrom);
      if (idx === -1) break;

      // Store index (+1 like in original)
      ams_flag_index.push(idx + 1);
      ams_flag_plate.push(plate);

      // Extract value: substring from "M620 S" (idx+7) up to 2–3 digits or until space/newline
      let raw = g.substring(idx + 7, idx + 10); // 2–3 characters
      if (raw[2] === "\n" || raw[2] === " ") raw = raw.substring(0, 2);

      const val = parseInt(raw, 10);
      ams_flag_value.push(Number.isFinite(val) ? val : NaN);

      searchFrom = idx + 1;
    }
  }

  // Remove redundant AMS swaps:
  // As in original: if we detect a sequence ... X, 255, X ...
  // the 255-block and the following block are disabled.
  for (let i = 0; i < ams_flag_value.length - 1; i++) {
    // Protect against i-1 < 0 and i+1 >= length
    if (i === 0 || i + 1 >= ams_flag_value.length) continue;

    if (ams_flag_value[i] === 255 && ams_flag_value[i - 1] === ams_flag_value[i + 1]) {
      const plateA = ams_flag_plate[i];
      const plateB = ams_flag_plate[i + 1];
      const idxA = ams_flag_index[i];
      const idxB = ams_flag_index[i + 1];

      // Disable (replace the AMS block with commented placeholders, see disable_ams_block)
      if (plateA !== undefined && idxA !== undefined && gcodeArray[plateA]) {
        gcodeArray[plateA] = disable_ams_block(gcodeArray[plateA]!, idxA);
      }
      if (plateB !== undefined && idxB !== undefined && gcodeArray[plateB]) {
        gcodeArray[plateB] = disable_ams_block(gcodeArray[plateB]!, idxB);
      }

      // Debug (optional)
      try {
        console.log("AMS swap redundancy removed at pair:", i,
          "plateA:", plateA, "plateB:", plateB);
      } catch (e) { }
    }
  }

  return gcodeArray;
}

/**
 * Disables an AMS block by replacing it with comments
 *
 * @param str - GCODE string
 * @param index - Index of M620 command
 * @returns Modified GCODE string
 */
function disable_ams_block(str: string, index: number): string {
  if (index > str.length - 1) return str;
  const rel = str.substring(index);
  const p = rel.indexOf("M621 S");
  if (p === -1) {
    // No end found → do nothing
    return str;
  }
  const block_end = str.substring(index).search("M621 S");
  let replacement_string = ";SWAP - AMS block removed";
  while (replacement_string.length < block_end - 1) { replacement_string += "/"; }
  replacement_string += ";";
  if (replacement_string.length > 2000) return str;
  else return str.substring(0, index) + replacement_string + str.substring(index + block_end);
}

/**
 * Removes lines matching a pattern
 *
 * @param gcode - GCODE string
 * @param pattern - Pattern to match (as string for RegExp)
 * @param flags - RegExp flags (default: "gm")
 * @returns Modified GCODE string
 */
export function removeLinesMatching(gcode: string, pattern: string, flags: string = "gm"): string {
  const re = new RegExp(pattern, flags);
  return gcode.replace(re, "");
}

/**
 * Keeps only the last occurrence of lines matching a pattern, commenting out earlier ones
 *
 * @param gcode - GCODE string
 * @param pattern - Pattern to match (as string for RegExp)
 * @param flags - RegExp flags (default: "gm")
 * @param appendIfMissing - Text to append if no matches are found
 * @returns Modified GCODE string
 */
export function keepOnlyLastMatching(
  gcode: string,
  pattern: string,
  flags: string = "gm",
  appendIfMissing: string = ""
): string {
  const re = new RegExp(pattern, flags);
  const matches = [...gcode.matchAll(re)];
  if (matches.length === 0) {
    if (appendIfMissing) {
      const nl = gcode.endsWith("\n") ? "" : "\n";
      return gcode + nl + appendIfMissing + "\n";
    }
    return gcode;
  }
  if (matches.length === 1) return gcode;

  // Comment out all except the last one
  let out = "";
  let cursor = 0;
  for (let i = 0; i < matches.length - 1; i++) {
    const m = matches[i];
    if (!m) continue;
    out += gcode.slice(cursor, m.index);
    const original = m[0];
    const commented = original.replace(/^/m, "; ");
    out += commented;
    cursor = (m.index ?? 0) + original.length;
  }
  out += gcode.slice(cursor);
  return out;
}

/**
 * Disables the line immediately after each occurrence of a pattern
 *
 * @param gcode - GCODE string
 * @param pattern - Pattern to search for
 * @param options - Marker options
 * @returns Modified GCODE string
 */
export function disableNextLineAfterPattern(gcode: string, pattern: string, options: MarkerOptions = {}): string {
  const { useRegex = false } = options;
  const re = useRegex
    ? new RegExp(pattern, "gm")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(pattern)}[^\\n]*(\\n|$)`, "gm");

  let result = gcode;
  let match: RegExpExecArray | null;
  const processedPositions = new Set<number>(); // Avoid double processing

  // Reset regex lastIndex for multiple matches
  re.lastIndex = 0;

  while ((match = re.exec(gcode)) !== null) {
    const matchEnd = match.index + match[0].length;

    // Skip already processed positions
    if (processedPositions.has(match.index)) {
      continue;
    }
    processedPositions.add(match.index);

    // Find the next line after the match
    const nextLineStart = gcode.indexOf('\n', matchEnd);
    if (nextLineStart === -1) {
      // No more lines available
      continue;
    }

    const nextLineEnd = gcode.indexOf('\n', nextLineStart + 1);
    const actualEnd = nextLineEnd === -1 ? gcode.length : nextLineEnd;

    // Extract the next line
    const nextLine = gcode.slice(nextLineStart + 1, actualEnd);

    // Skip empty lines or already commented lines
    if (!nextLine.trim() || nextLine.trim().startsWith(';')) {
      continue;
    }

    // Remove the line completely
    result = result.slice(0, nextLineStart + 1) + result.slice(actualEnd + 1);

    // Prevent infinite loops with zero-length matches
    if (match[0].length === 0) {
      re.lastIndex++;
    }
  }

  return result;
}

/**
 * Disables the line after a pattern within a specific range
 *
 * @param gcode - GCODE string
 * @param opts - Options for range and pattern
 * @returns Modified GCODE string
 */
export function disableNextLineAfterPatternInRange(gcode: string, opts: DisableNextLineInRangeOptions): string {
  const { start, end, pattern, useRegex = false, patternUseRegex = false } = opts;
  const outerRange = _findRange(gcode, start, end, useRegex);
  if (!outerRange.found) return gcode;

  const before = gcode.slice(0, outerRange.sIdx);
  let middle = gcode.slice(outerRange.sIdx, outerRange.eIdx);
  const after = gcode.slice(outerRange.eIdx);

  // Apply disableNextLineAfterPattern only to the middle part
  middle = disableNextLineAfterPattern(middle, pattern, { useRegex: patternUseRegex });

  return before + middle + after;
}

/**
 * Checks if content has already been inserted (guard check)
 *
 * @param _gcode - GCODE string (unused)
 * @param _guardId - Guard ID to check for (unused)
 * @returns Always returns false (dev mode removed)
 */
export function _alreadyInserted(_gcode: string, _guardId: string): boolean {
  // Since dev mode is removed, markers are never inserted, so always return false
  return false;
}

/**
 * Applies AMS slot overrides to a plate's GCODE
 *
 * This function rewrites M620/M621 commands and T-commands based on user-defined
 * slot mappings and automatic slot compaction.
 *
 * @param gcode - GCODE string for the plate
 * @param plateOriginIndex - Original plate index (0-based)
 * @returns Modified GCODE with AMS overrides applied
 */
export function applyAmsOverridesToPlate(gcode: string, plateOriginIndex: number): string {
  console.log('=== applyAmsOverridesToPlate CALLED ===');
  console.log('plateOriginIndex:', plateOriginIndex);
  console.log('OVERRIDE_METADATA:', state.OVERRIDE_METADATA);

  // Only execute when "Override project & filament settings" is enabled
  if (!state.OVERRIDE_METADATA) {
    console.log('OVERRIDE_METADATA is false, returning original gcode');
    return gcode;
  }

  // Get slot compaction map
  const compactionMap = state.GLOBAL_AMS.slotCompactionMap;
  console.log('Slot compaction map:', compactionMap);

  // UI stores overrides here: Map<number, { fromKey: toKey }>
  const map = state.GLOBAL_AMS.overridesPerPlate.get(plateOriginIndex) || {};
  console.log('AMS overrides for plate:', plateOriginIndex, map);

  /**
   * Rewrites AMS command parameters
   *
   * @param cmd - Command name (M620 or M621)
   * @param blob - Parameter blob
   * @returns Rewritten command line
   */
  function rewrite(cmd: string, blob: string): string {
    // Capture original form (compact S…A? P present?)
    const hadP = /\bP\d+\b/i.test(blob);

    const { p: origP, s: origS } = _parseAmsParams(blob);
    const fromKey = `P${origP}S${origS}`;
    const map = state.GLOBAL_AMS.overridesPerPlate.get(plateOriginIndex) || {};
    let toKey = map[fromKey] as string | undefined;

    // If no user override, apply slot compaction mapping
    if (!toKey && compactionMap && compactionMap.size > 0) {
      // Convert 0-based S parameter to 1-based slot ID
      const originalSlot1Based = origS + 1;
      const compactedSlot1Based = compactionMap.get(originalSlot1Based);

      if (compactedSlot1Based !== undefined && compactedSlot1Based !== originalSlot1Based) {
        // Apply compaction: create synthetic toKey
        const compactedS = compactedSlot1Based - 1; // Convert back to 0-based
        toKey = `P${origP}S${compactedS}`;
        console.log(`Slot compaction applied: ${fromKey} → ${toKey} (slot ${originalSlot1Based} → ${compactedSlot1Based})`);
      }
    }

    if (!toKey) {
      // Preserve original spacing even when no changes are made
      const originalSpacing = /^(\s*)/.exec(blob)?.[1] || ' ';
      return `${cmd}${originalSpacing}${blob.trim()}`;
    }

    const m = /^P(\d+)S(\d+)$/.exec(toKey);
    if (!m || !m[1] || !m[2]) {
      // Preserve original spacing for invalid toKey format
      const originalSpacing = /^(\s*)/.exec(blob)?.[1] || ' ';
      return `${cmd}${originalSpacing}${blob.trim()}`;
    }
    const toP = +m[1];
    const toS = +m[2];

    let outRest = blob;

    // 1) Replace S…(A) – supports "S3A", "S3 A" or just "S3"
    outRest = outRest.replace(/(\bS)(\d{1,3})(\s*A\b|A\b)?/i, (_fullMatch, S, _num, aPart) => {
      // Preserve A, and if it was "compact" before, keep it compact
      if (aPart) {
        const compact = !/^\s/.test(aPart); // true for "A", false for " A"
        return compact ? `${S}${toS}A` : `${S}${toS} A`;
      }
      return `${S}${toS}`; // no A present -> don't add one
    });

    // 2) Replace/insert P: only show P if it was there before OR target P != 0
    if (/\bP\d+\b/i.test(outRest)) {
      outRest = outRest.replace(/(\bP)(\d+)\b/i, (_fullMatch, P, _num) => `${P}${toP}`);
    } else if (!hadP && toP !== 0) {
      // Target has real P>0 → insert P at the front (with space)
      outRest = ` P${toP}` + outRest;
    }
    // If neither P was present before nor toP != 0 → don't output P (A1M-style)

    // Preserve original spacing between command and parameters
    const originalSpacing = /^(\s*)/.exec(blob)?.[1] || ' ';
    return `${cmd}${originalSpacing}${outRest.trim()}`;
  }

  // Split GCode into header and body (header ends at CONFIG_BLOCK_END)
  const headerEndIndex = gcode.indexOf('; CONFIG_BLOCK_END');
  let headerPart = '';
  let bodyPart = gcode;

  if (headerEndIndex !== -1) {
    const headerEndPos = headerEndIndex + '; CONFIG_BLOCK_END'.length;
    headerPart = gcode.substring(0, headerEndPos);
    bodyPart = gcode.substring(headerEndPos);
    console.log('Found CONFIG_BLOCK_END, processing only body part');
  } else {
    console.log('No CONFIG_BLOCK_END found, processing entire GCode');
  }

  // Process M620...M621 blocks in body part (including T-commands)
  let modifiedBody = bodyPart;

  // Find all M620 commands and process complete blocks
  const m620Pattern = /^(\s*)(M620)(?!\.)\s+([^\n\r]*S(\d+)[^\n\r]*)(\r?\n|$)/gmi;
  let m620Match: RegExpExecArray | null;
  const processedRanges: Array<{ start: number; end: number }> = [];

  // Reset regex
  m620Pattern.lastIndex = 0;

  while ((m620Match = m620Pattern.exec(bodyPart)) !== null) {
    const m620Start = m620Match.index;
    const m620End = m620Start + m620Match[0].length;
    const originalSlot = parseInt(m620Match[4] ?? '0');
    const m620Indent = m620Match[1] ?? '';
    const m620Cmd = m620Match[2] ?? 'M620';
    const m620Rest = m620Match[3] ?? '';
    const m620LineEnd = m620Match[5] ?? '\n';

    console.log(`Processing M620 S${originalSlot} block starting at ${m620Start}`);

    // Find corresponding M621 with same S parameter
    const m621Pattern = new RegExp(`^(\\s*)(M621)(?!\\.\\d)\\s+([^\\n\\r]*S${originalSlot}[^\\n\\r]*)(\\r?\\n|$)`, 'mi');
    const remainingGcode = bodyPart.substring(m620End);
    const m621Match = remainingGcode.match(m621Pattern);

    if (!m621Match) {
      console.log(`No matching M621 S${originalSlot} found`);
      continue;
    }

    const m621Start = m620End + (m621Match.index ?? 0);
    const m621End = m621Start + m621Match[0].length;
    const m621Indent = m621Match[1] ?? '';
    const m621Cmd = m621Match[2] ?? 'M621';
    const m621Rest = m621Match[3] ?? '';
    const m621LineEnd = m621Match[4] ?? '\n';

    // Check if this range was already processed
    const rangeStart = m620Start;
    const rangeEnd = m621End;
    const alreadyProcessed = processedRanges.some(range =>
      (rangeStart >= range.start && rangeStart < range.end) ||
      (rangeEnd > range.start && rangeEnd <= range.end)
    );

    if (alreadyProcessed) {
      console.log(`Range ${rangeStart}-${rangeEnd} already processed, skipping`);
      continue;
    }

    processedRanges.push({ start: rangeStart, end: rangeEnd });

    // Extract the complete block content
    const blockContent = bodyPart.substring(rangeStart, rangeEnd);
    const middleContent = bodyPart.substring(m620End, m621Start);

    console.log(`Block content preview:`, blockContent.substring(0, 200).replace(/\n/g, '\\n'));

    // Apply rewrite function to M620 and M621 commands
    const newM620 = rewrite(m620Cmd, m620Rest);
    const newM621 = rewrite(m621Cmd, m621Rest);

    // Extract new slot from rewritten M620 command
    const newSlotMatch = newM620.match(/S(\d+)/);
    const newSlot = newSlotMatch && newSlotMatch[1] ? parseInt(newSlotMatch[1]) : originalSlot;

    // Process T commands in the middle content if slot changed
    let processedMiddle = middleContent;
    if (newSlot !== originalSlot) {
      console.log(`Slot changed from ${originalSlot} to ${newSlot}, updating T commands`);
      // Only match T commands that are standalone on their own line (not part of other commands like M620.1)
      processedMiddle = middleContent.replace(/^(\s*)(T)(\d+)\s*$/gmi, (_tMatch, indent, tCmd, _tSlot) => {
        console.log(`Found standalone T-Command ${tCmd}${_tSlot} in block, changing to ${tCmd}${newSlot}`);
        return indent + tCmd + newSlot;
      });
    } else {
      console.log(`No slot change (${originalSlot} -> ${newSlot}), T commands unchanged`);
    }

    // Reconstruct the complete block with proper spacing
    const processedBlock = m620Indent + newM620 + m620LineEnd + processedMiddle + m621Indent + newM621 + m621LineEnd;

    // Apply the change to modifiedBody
    modifiedBody = modifiedBody.substring(0, rangeStart) + processedBlock + modifiedBody.substring(rangeEnd);

    // Adjust the regex position due to potential content length changes
    const lengthDiff = processedBlock.length - (rangeEnd - rangeStart);
    m620Pattern.lastIndex = rangeEnd + lengthDiff;
  }

  // Also handle standalone M620/M621 commands that weren't part of blocks
  modifiedBody = modifiedBody.replace(
    /^(\s*)(M620)(?!\.)\b([^\n\r]*)(\r?\n|$)/gmi,
    (_match, indent, cmd, rest, lineEnd) => {
      // Only process if not already processed as part of a block
      const wasProcessed = processedRanges.some(range => {
        const matchStart = modifiedBody.indexOf(_match);
        return matchStart >= range.start && matchStart < range.end;
      });
      return wasProcessed ? _match : indent + rewrite(cmd, rest) + lineEnd;
    }
  );

  modifiedBody = modifiedBody.replace(
    /^(\s*)(M621)(?!\.)\b([^\n\r]*)(\r?\n|$)/gmi,
    (_match, indent, cmd, rest, lineEnd) => {
      // Only process if not already processed as part of a block
      const wasProcessed = processedRanges.some(range => {
        const matchStart = modifiedBody.indexOf(_match);
        return matchStart >= range.start && matchStart < range.end;
      });
      return wasProcessed ? _match : indent + rewrite(cmd, rest) + lineEnd;
    }
  );

  // Combine header and modified body back together
  let out = headerPart + modifiedBody;

  // Update filament header line ("; filament: 1,2,3" -> new slots)
  out = out.replace(
    /^(;\s*filament:\s*)([\d,\s]+)$/mi,
    (_match, prefix, slotList) => {
      // Parse original slots
      const originalSlots = slotList.split(',').map((s: string) => parseInt(s.trim())).filter((n: number) => !isNaN(n));

      // Map each slot through the override system + compaction
      const newSlots = originalSlots.map((slot: number) => {
        // Convert 1-based filament slot to 0-based AMS S-parameter
        const fromKey = `P0S${slot - 1}`;
        let toKey = map[fromKey] as string | undefined;

        // If no user override, apply slot compaction
        if (!toKey && compactionMap && compactionMap.size > 0) {
          const compactedSlot1Based = compactionMap.get(slot);
          if (compactedSlot1Based !== undefined && compactedSlot1Based !== slot) {
            toKey = `P0S${compactedSlot1Based - 1}`;
          }
        }

        if (!toKey) return slot; // no change

        const m = /^P(\d+)S(\d+)$/.exec(toKey);
        if (!m || !m[2]) return slot; // Return original if parse fails
        // Convert 0-based AMS S-parameter back to 1-based filament slot
        return +m[2] + 1;
      });

      // Remove duplicates and sort
      const uniqueSlots = [...new Set(newSlots)].sort((a, b) => (a as number) - (b as number));

      return prefix + uniqueSlots.join(',');
    }
  );

  return out;
}
