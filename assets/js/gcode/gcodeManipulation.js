// /src/gcode/gcodeManipulation.js

import { _escRe } from "../utils/regex.js";
import { state } from "../config/state.js";
import { _findRange } from "../gcode/gcodeUtils.js";
import { _parseAmsParams } from "../utils/amsUtils.js";


// ersetzt den Inhalt zwischen Start/End-Markern
export function injectBetweenMarkers(gcode, startMark, endMark, content) {
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

export function disableBetweenMarkers(gcode, start, end, { useRegex = false } = {}) {
  const esc = s => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const startRe = useRegex ? new RegExp(start, "m")
    : new RegExp(`(^|\\n)[ \\t]*${esc(start)}[^\n]*\\n`, "m");
  const mStart = gcode.match(startRe);
  if (!mStart) return gcode;
  const sIdx = (mStart.index ?? 0) + mStart[0].length;

  const endRe = useRegex ? new RegExp(end, "m")
    : new RegExp(`(^|\\n)[ \\t]*${esc(end)}[^\n]*\\n`, "m");
  const rest = gcode.slice(sIdx);
  const mEnd = rest.match(endRe);
  if (!mEnd) return gcode;
  const eIdx = sIdx + (mEnd.index ?? 0);

  // → Inhalt komplett entfernen
  return gcode.slice(0, sIdx) + gcode.slice(eIdx);
}

// Prepend-Block (idempotent, mit optionalen Markerhüllen)
export function prependBlock(gcode, block, { guardId = "", wrapWithMarkers = true } = {}) {
  if (!block) return gcode;
  if (wrapWithMarkers && guardId && _alreadyInserted(gcode, guardId)) return gcode;

  let payload = block.replace(/\r\n/g, "\n");
  const needsNL = (gcode[0] && gcode[0] !== '\n') ? "\n" : "";
  return payload + needsNL + gcode;
}

// Anker-basiert VOR eine Zeile einfügen (first/last Vorkommen)
export function insertBeforeAnchor(gcode, anchor, payload, {
  useRegex = false, occurrence = "last", guardId = "", wrapWithMarkers = true
} = {}) {
  if (!payload) return gcode;

  const re = useRegex
    ? new RegExp(anchor, "gm")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(anchor)}[^\\n]*(\\n|$)`, "gm");

  let match = null;
  if (occurrence === "first") {
    match = re.exec(gcode);
  } else {
    let m, last = null;
    while ((m = re.exec(gcode)) !== null) {
      if (m[0].length === 0) break;
      last = m;
    }
    match = last;
  }
  if (!match) return gcode;

  const insertPos = match.index; // ← VOR dem Anchor
  let block = payload.replace(/\r\n/g, "\n");
  return gcode.slice(0, insertPos) + block + gcode.slice(insertPos);
}



// Anker-basiert hinter eine Zeile einfügen (first/last Vorkommen)
export function insertAfterAnchor(gcode, anchor, payload, {
  useRegex = false, occurrence = "last", guardId = "", wrapWithMarkers = true
} = {}) {
  if (!payload) return gcode;

  const re = useRegex
    ? new RegExp(anchor, "gm")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(anchor)}[^\\n]*(\\n|$)`, "gm"); // ← (\n|$)

  let match = null;
  if (occurrence === "first") {
    match = re.exec(gcode);
  } else {
    let m, last = null;
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


export function disableSpecificLinesInRange(gcode, start, end, lines, { useRegex = false } = {}) {
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
  const eIdx = sIdx + mE.index;

  const before = gcode.slice(0, sIdx);
  let middle = gcode.slice(sIdx, eIdx);
  const after = gcode.slice(eIdx);

  const removedLines = [];
  for (const raw of lines) {
    const lineRe = new RegExp(`(^|\\n)[ \\t]*${_escRe(raw)}[^\n]*(\\n|$)`, "m");
    const match = middle.match(lineRe);
    if (match) {
      removedLines.push(match[0].trim());
      middle = middle.replace(lineRe, ""); // Zeile komplett entfernen
    }
  }
  
  
  return before + middle + after;
}

export function disableInnerBetweenMarkers(gcode, opts) {
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

export function optimizeAMSBlocks(gcodeArray) {
  // Defensive: falscher Typ -> nichts tun
  if (!Array.isArray(gcodeArray)) return gcodeArray;

  // Check if AMS optimization is enabled via checkbox
  const amsOptimizationCheckbox = document.getElementById('opt_ams_optimization');
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

  // Wir erkennen AMS-Swaps an "\nM620 S"
  const ams_flag = "\nM620 S";

  // Sammeln der Fundstellen
  const ams_flag_index = [];   // Index im jeweiligen String (Position des Buchstabens nach dem \n)
  const ams_flag_plate = [];   // Index der Platte (Element im Array)
  const ams_flag_value = [];   // Zahlenwert nach "M620 S" (z.B. 255, 0..3, ...)

  for (let plate = 0; plate < gcodeArray.length; plate++) {
    const g = gcodeArray[plate];
    let searchFrom = 0;
    while (true) {
      const idx = g.indexOf(ams_flag, searchFrom);
      if (idx === -1) break;

      // Index speichern (+1 wie im Original)
      ams_flag_index.push(idx + 1);
      ams_flag_plate.push(plate);

      // Wert extrahieren: substring ab "M620 S" (idx+7) bis 2–3 Ziffern bzw. bis Leerzeichen/Zeilenumbruch
      let raw = g.substring(idx + 7, idx + 10); // 2–3 Zeichen
      if (raw[2] === "\n" || raw[2] === " ") raw = raw.substring(0, 2);

      const val = parseInt(raw, 10);
      ams_flag_value.push(Number.isFinite(val) ? val : NaN);

      searchFrom = idx + 1;
    }
  }

  // Redundante AMS-Swaps entfernen:
  // Wie im Original: wenn wir eine Folge ... X, 255, X ... erkennen,
  // wird der 255-Block und der darauffolgende Block deaktiviert.
  for (let i = 0; i < ams_flag_value.length - 1; i++) {
    // Schutz gegen i-1 < 0 und i+1 >= length
    if (i === 0 || i + 1 >= ams_flag_value.length) continue;

    if (ams_flag_value[i] === 255 && ams_flag_value[i - 1] === ams_flag_value[i + 1]) {
      const plateA = ams_flag_plate[i];
      const plateB = ams_flag_plate[i + 1];
      const idxA = ams_flag_index[i];
      const idxB = ams_flag_index[i + 1];

      // Deaktivieren (ersetzt den AMS-Block durch kommentierte Platzhalter, siehe deine disable_ams_block)
      gcodeArray[plateA] = disable_ams_block(gcodeArray[plateA], idxA);
      gcodeArray[plateB] = disable_ams_block(gcodeArray[plateB], idxB);

      // Debug (optional)
      try {
        console.log("AMS swap redundancy removed at pair:", i,
          "plateA:", plateA, "plateB:", plateB);
      } catch (e) { }
    }
  }

  return gcodeArray;
}

function disable_ams_block(str, index) {
  if (index > str.length - 1) return str;
  const rel = str.substring(index);
  const p = rel.indexOf("M621 S");
  if (p === -1) {
    // Kein Ende gefunden → nichts tun
    return str;
  }
  const block_end = str.substring(index).search("M621 S");
  var replacement_string = ";SWAP - AMS block removed";
  while (replacement_string.length < block_end - 1) { replacement_string += "/"; }
  replacement_string += ";";
  if (replacement_string.length > 2000) return str;
  else return str.substring(0, index) + replacement_string + str.substring(index + block_end);
}

export function removeLinesMatching(gcode, pattern, flags = "gm") {
  const re = new RegExp(pattern, flags);
  
  
  return gcode.replace(re, "");
}

export function keepOnlyLastMatching(gcode, pattern, flags = "gm", appendIfMissing = "") {
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

  // alle bis auf den letzten auskommentieren
  const last = matches[matches.length - 1];
  let out = "";
  let cursor = 0;
  for (let i = 0; i < matches.length - 1; i++) {
    const m = matches[i];
    out += gcode.slice(cursor, m.index);
    const original = m[0];
    const commented = original.replace(/^/m, "; ");
    out += commented;
    cursor = m.index + original.length;
  }
  out += gcode.slice(cursor);
  return out;
}

export function disableNextLineAfterPattern(gcode, pattern, { useRegex = false } = {}) {
  const re = useRegex
    ? new RegExp(pattern, "gm")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(pattern)}[^\\n]*(\\n|$)`, "gm");

  let result = gcode;
  let match;
  const processedPositions = new Set(); // Vermeide doppelte Bearbeitung

  // Reset regex lastIndex for multiple matches
  re.lastIndex = 0;

  while ((match = re.exec(gcode)) !== null) {
    const matchEnd = match.index + match[0].length;

    // Überspringe bereits bearbeitete Positionen
    if (processedPositions.has(match.index)) {
      continue;
    }
    processedPositions.add(match.index);

    // Finde die nächste Zeile nach dem Match
    const nextLineStart = gcode.indexOf('\n', matchEnd);
    if (nextLineStart === -1) {
      // Keine weitere Zeile vorhanden
      continue;
    }

    const nextLineEnd = gcode.indexOf('\n', nextLineStart + 1);
    const actualEnd = nextLineEnd === -1 ? gcode.length : nextLineEnd;

    // Extrahiere die nächste Zeile
    const nextLine = gcode.slice(nextLineStart + 1, actualEnd);

    // Überspringe leere Zeilen oder bereits auskommentierte Zeilen
    if (!nextLine.trim() || nextLine.trim().startsWith(';')) {
      continue;
    }

    // Remove the line completely
    result = result.slice(0, nextLineStart + 1) + result.slice(actualEnd + 1);

    // Verhindere infinite loops bei zero-length matches
    if (match[0].length === 0) {
      re.lastIndex++;
    }
  }

  return result;
}

export function disableNextLineAfterPatternInRange(gcode, opts) {
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

export function _alreadyInserted(gcode, guardId) {
  // Since dev mode is removed, markers are never inserted, so always return false
  return false;
}

// Ersetzung beim Export: pro Platte
export function applyAmsOverridesToPlate(gcode, plateOriginIndex) {
  console.log('=== applyAmsOverridesToPlate CALLED ===');
  console.log('plateOriginIndex:', plateOriginIndex);
  console.log('OVERRIDE_METADATA:', state.OVERRIDE_METADATA);
  
  // Nur ausführen, wenn "Override project & filament settings" aktiviert ist
  if (!state.OVERRIDE_METADATA) {
    console.log('OVERRIDE_METADATA is false, returning original gcode');
    return gcode;
  }
  
  // UI speichert Overrides hier: Map<number, { fromKey: toKey }>
  const map = state.GLOBAL_AMS.overridesPerPlate.get(plateOriginIndex) || {};
  console.log('AMS overrides for plate:', plateOriginIndex, map);
  if (!map || Object.keys(map).length === 0) {
    console.log('No overrides for this plate, returning original gcode');
    return gcode;
  }

  function rewrite(cmd, blob) {
    // Original-Form erfassen (kompaktes S…A? P vorhanden?)
    const hadP = /\bP\d+\b/i.test(blob);
    const hadSACompact = /(?:^|\s)S\d+A\b/i.test(blob);      // "S3A" ohne Leerzeichen
    const hadAToken = /(?:^|\s)A\b/i.test(blob);             // separates " A"

    const { p: origP, s: origS } = _parseAmsParams(blob);
    const fromKey = `P${origP}S${origS}`;
    const map = state.GLOBAL_AMS.overridesPerPlate.get(plateOriginIndex) || {};
    const toKey = map[fromKey];
    if (!toKey) {
      // Preserve original spacing even when no changes are made
      const originalSpacing = /^(\s*)/.exec(blob)?.[1] || ' ';
      return `${cmd}${originalSpacing}${blob.trim()}`;
    }

    const m = /^P(\d+)S(\d+)$/.exec(toKey);
    if (!m) {
      // Preserve original spacing for invalid toKey format
      const originalSpacing = /^(\s*)/.exec(blob)?.[1] || ' ';
      return `${cmd}${originalSpacing}${blob.trim()}`;
    }
    const toP = +m[1];
    const toS = +m[2];

    let outRest = blob;

    // 1) S…(A) ersetzen – unterstützt "S3A", "S3 A" oder nur "S3"
    outRest = outRest.replace(/(\bS)(\d{1,3})(\s*A\b|A\b)?/i, (_, S, num, aPart) => {
      // A erhalten, und wenn es vorher "kompakt" war, bleibt es kompakt
      if (aPart) {
        const compact = !/^\s/.test(aPart); // true bei "A", false bei " A"
        return compact ? `${S}${toS}A` : `${S}${toS} A`;
      }
      return `${S}${toS}`; // kein A vorhanden -> auch keins hinzufügen
    });

    // 2) P ersetzen/einfügen: P nur zeigen, wenn es vorher schon da war ODER Ziel-P != 0
    if (/\bP\d+\b/i.test(outRest)) {
      outRest = outRest.replace(/(\bP)(\d+)\b/i, (_, P, num) => `${P}${toP}`);
    } else if (!hadP && toP !== 0) {
      // Ziel hat echtes P>0 → füge P vorne ein (mit Leerzeichen)
      outRest = ` P${toP}` + outRest;
    }
    // Falls weder vorher P vorhanden noch toP != 0 → kein P ausgeben (A1M-Style)

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
  let m620Match;
  const processedRanges = [];

  // Reset regex
  m620Pattern.lastIndex = 0;

  while ((m620Match = m620Pattern.exec(bodyPart)) !== null) {
    const m620Start = m620Match.index;
    const m620End = m620Start + m620Match[0].length;
    const originalSlot = parseInt(m620Match[4]);
    const m620Indent = m620Match[1];
    const m620Cmd = m620Match[2];
    const m620Rest = m620Match[3];
    const m620LineEnd = m620Match[5];

    console.log(`Processing M620 S${originalSlot} block starting at ${m620Start}`);

    // Find corresponding M621 with same S parameter
    const m621Pattern = new RegExp(`^(\\s*)(M621)(?!\\.\\d)\\s+([^\\n\\r]*S${originalSlot}[^\\n\\r]*)(\\r?\\n|$)`, 'mi');
    const remainingGcode = bodyPart.substring(m620End);
    const m621Match = remainingGcode.match(m621Pattern);

    if (!m621Match) {
      console.log(`No matching M621 S${originalSlot} found`);
      continue;
    }

    const m621Start = m620End + m621Match.index;
    const m621End = m621Start + m621Match[0].length;
    const m621Indent = m621Match[1];
    const m621Cmd = m621Match[2];
    const m621Rest = m621Match[3];
    const m621LineEnd = m621Match[4];

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
    const newSlot = newSlotMatch ? parseInt(newSlotMatch[1]) : originalSlot;

    // Process T commands in the middle content if slot changed
    let processedMiddle = middleContent;
    if (newSlot !== originalSlot) {
      console.log(`Slot changed from ${originalSlot} to ${newSlot}, updating T commands`);
      // Only match T commands that are standalone on their own line (not part of other commands like M620.1)
      processedMiddle = middleContent.replace(/^(\s*)(T)(\d+)\s*$/gmi, (tMatch, indent, tCmd, tSlot) => {
        console.log(`Found standalone T-Command ${tCmd}${tSlot} in block, changing to ${tCmd}${newSlot}`);
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
    (match, indent, cmd, rest, lineEnd) => {
      // Only process if not already processed as part of a block
      const wasProcessed = processedRanges.some(range => {
        const matchStart = modifiedBody.indexOf(match);
        return matchStart >= range.start && matchStart < range.end;
      });
      return wasProcessed ? match : indent + rewrite(cmd, rest) + lineEnd;
    }
  );

  modifiedBody = modifiedBody.replace(
    /^(\s*)(M621)(?!\.)\b([^\n\r]*)(\r?\n|$)/gmi,
    (match, indent, cmd, rest, lineEnd) => {
      // Only process if not already processed as part of a block
      const wasProcessed = processedRanges.some(range => {
        const matchStart = modifiedBody.indexOf(match);
        return matchStart >= range.start && matchStart < range.end;
      });
      return wasProcessed ? match : indent + rewrite(cmd, rest) + lineEnd;
    }
  );

  // Combine header and modified body back together
  let out = headerPart + modifiedBody;

  // Filament header line aktualisieren ("; filament: 1,2,3" -> neue Slots)
  out = out.replace(
    /^(;\s*filament:\s*)([\d,\s]+)$/mi,
    (match, prefix, slotList) => {
      // Parse original slots
      const originalSlots = slotList.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n));
      
      // Map each slot through the override system
      const newSlots = originalSlots.map(slot => {
        // Convert 1-based filament slot to 0-based AMS S-parameter
        const fromKey = `P0S${slot - 1}`;
        const toKey = map[fromKey];
        if (!toKey) return slot; // keine Änderung

        const m = /^P(\d+)S(\d+)$/.exec(toKey);
        // Convert 0-based AMS S-parameter back to 1-based filament slot
        return m ? +m[2] + 1 : slot; // neuer Slot oder original falls Parse-Fehler
      });
      
      // Remove duplicates and sort
      const uniqueSlots = [...new Set(newSlots)].sort((a, b) => a - b);
      
      return prefix + uniqueSlots.join(',');
    }
  );

  return out;
}
