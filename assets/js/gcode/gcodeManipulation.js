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
  if (wrapWithMarkers && guardId) {
    payload = `;<<< INSERT:${guardId} START\n` + payload + `\n;>>> INSERT:${guardId} END\n`;
  }
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
  if (wrapWithMarkers && guardId) {
    if (_alreadyInserted(gcode, guardId)) return gcode;
    block = `;<<< INSERT:${guardId} START\n${block}\n;>>> INSERT:${guardId} END\n`;
  }
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
  if (wrapWithMarkers && guardId) {
    if (_alreadyInserted(gcode, guardId)) return gcode;
    block = `;<<< INSERT:${guardId} START\n${block}\n;>>> INSERT:${guardId} END\n`;
  }
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

  for (const raw of lines) {
    const lineRe = new RegExp(`(^|\\n)[ \\t]*${_escRe(raw)}[^\n]*(\\n|$)`, "m");
    middle = middle.replace(lineRe, ""); // Zeile komplett entfernen
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

function _alreadyInserted(gcode, guardId) {
  if (!guardId) return false;
  const re = new RegExp(`(^|\\n)[ \\t]*;<<< INSERT:${_escRe(guardId)} START[ \\t]*\\n`, "m");
  return re.test(gcode);
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
    if (!toKey) return `${cmd}${blob}`; // nichts zu tun

    const m = /^P(\d+)S(\d+)$/.exec(toKey);
    if (!m) return `${cmd}${blob}`;
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

    return `${cmd}${outRest}`;
  }


  // Nur M620/M621 ohne Suffix (.1/.11) anfassen
  let out = gcode.replace(
    /^\s*(M620)(?!\.)\b([^\n\r]*)$/gmi,
    (_, cmd, rest) => rewrite(cmd, rest)
  );
  out = out.replace(
    /^\s*(M621)(?!\.)\b([^\n\r]*)$/gmi,
    (_, cmd, rest) => rewrite(cmd, rest)
  );

  // T commands zwischen M620/M621 Paaren auch anpassen - nur im Body, nicht im Header
  console.log('Starting T-Command search and replace...');
  
  // Split GCode into header and body (header ends at CONFIG_BLOCK_END)
  const headerEndIndex = out.indexOf('; CONFIG_BLOCK_END');
  let headerPart = '';
  let bodyPart = out;
  
  if (headerEndIndex !== -1) {
    const headerEndPos = headerEndIndex + '; CONFIG_BLOCK_END'.length;
    headerPart = out.substring(0, headerEndPos);
    bodyPart = out.substring(headerEndPos);
    console.log('Found CONFIG_BLOCK_END, processing only body part for T-Commands');
    console.log('Header length:', headerPart.length);
    console.log('Body sample:', bodyPart.substring(0, 500));
  } else {
    console.log('No CONFIG_BLOCK_END found, processing entire GCode');
    console.log('GCode sample:', bodyPart.substring(0, 500));
  }
  
  // Apply T-Command remapping only to body part
  const modifiedBody = bodyPart.replace(
    /(M620\s+[^\n\r]*S(\d+)[\s\S]*?)(\bT)(\d+)\b([\s\S]*?M621\s+[^\n\r]*S\2)/gmi,
    (match, beforeT, originalSlot, tCmd, tSlot, afterT) => {
      console.log('T-Command RegEx Match found!');
      console.log('Full match:', match);
      console.log('beforeT:', beforeT);
      console.log('originalSlot:', originalSlot);
      console.log('tCmd:', tCmd);
      console.log('tSlot:', tSlot);
      console.log('afterT:', afterT);
      
      // Das T-Command sollte basierend auf dem M620 S-Parameter gemappt werden, nicht dem aktuellen T-Wert
      // Denn der Slicer generiert oft falsche T-Commands (immer T0)
      // M620 S0A sollte mit T0 verwendet werden
      // M620 S1A sollte mit T1 verwendet werden
      // etc.
      const correctTSlot = parseInt(originalSlot);  // S-Parameter von M620
      const uiSlot = correctTSlot + 1;  // Slot zu UI-Slot konvertieren (S0 -> Slot 1)
      const fromKey = `P0S${uiSlot}`;
      const map = state.GLOBAL_AMS.overridesPerPlate.get(plateOriginIndex) || {};
      const toKey = map[fromKey];
      
      console.log(`T-Command Debug: M620 S${originalSlot} should use T${correctTSlot}, plateOriginIndex=${plateOriginIndex}, fromKey=${fromKey}, map=`, map, `toKey=${toKey}`);
      
      if (!toKey) {
        // Auch wenn kein Mapping vorhanden ist, sollten wir den T-Command korrigieren
        if (correctTSlot !== parseInt(tSlot)) {
          console.log(`T-Command: Correcting ${tCmd}${tSlot} to ${tCmd}${correctTSlot} (no mapping, but fixing slicer error)`);
          return beforeT + tCmd + correctTSlot + afterT;
        }
        return match; // nichts zu tun
      }
      
      const m = /^P(\d+)S(\d+)$/.exec(toKey);
      if (!m) return match;
      const newUiSlot = +m[2];
      const newTCommand = newUiSlot - 1;  // UI-Slot zurück zu T-Command konvertieren
      
      console.log(`T-Command: Changing ${tCmd}${tSlot} to ${tCmd}${newTCommand} (M620 S${originalSlot} -> S${newTCommand}, UI-Slot ${uiSlot} -> ${newUiSlot})`);
      return beforeT + tCmd + newTCommand + afterT;
    }
  );

  // Combine header and modified body back together
  out = headerPart + modifiedBody;

  // Filament header line aktualisieren ("; filament: 1,2,3" -> neue Slots)
  out = out.replace(
    /^(;\s*filament:\s*)([\d,\s]+)$/mi,
    (match, prefix, slotList) => {
      // Parse original slots
      const originalSlots = slotList.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n));
      
      // Map each slot through the override system
      const newSlots = originalSlots.map(slot => {
        const fromKey = `P0S${slot}`;
        const toKey = map[fromKey];
        if (!toKey) return slot; // keine Änderung
        
        const m = /^P(\d+)S(\d+)$/.exec(toKey);
        return m ? +m[2] : slot; // neuer Slot oder original falls Parse-Fehler
      });
      
      // Remove duplicates and sort
      const uniqueSlots = [...new Set(newSlots)].sort((a, b) => a - b);
      
      return prefix + uniqueSlots.join(',');
    }
  );

  return out;
}
