// /src/gcode/readGcode.js

import { state } from "../config/state.js";
import JSZip from "jszip";

// ===== Section Split/Join =====

const RE_EXEC_START = /^[ \t]*;[ \t]*EXECUTABLE_BLOCK_START[^\n]*\n?/m;
const RE_START_END = /^[ \t]*;[ \t]*MACHINE_START_GCODE_END[^\n]*\n?/m;
const RE_END_START = /^[ \t]*;[ \t]*MACHINE_END_GCODE_START[^\n]*\n?/m;

function _lineEnd(src, idx) {
  if (idx < 0) return -1;
  const nl = src.indexOf("\n", idx);
  return (nl === -1) ? src.length : nl + 1;
}

/**
 * Schneidet gcode in: header, startseq, body, endseq.
 * - header:   [0 .. execIdx)                   (Marker nicht enthalten)
 * - startseq: [execIdx .. startEndLineEnd)     (EXEC.. inkl.; START_END inkl.)
 * - body:     [startEndLineEnd .. endStartIdx) (Zeilen nach START_END bis vor END_START)
 * - endseq:   [endStartIdx .. EOF]             (END_START inkl.)
 */
export function splitIntoSections(gcode) {
  const mExec = RE_EXEC_START.exec(gcode);
  const execIdx = mExec ? mExec.index : -1;
  const execLineEnd = mExec ? _lineEnd(gcode, execIdx) : -1;

  const mStartEnd = RE_START_END.exec(gcode);
  const startEndIdx = mStartEnd ? mStartEnd.index : -1;
  const startEndLineEnd = mStartEnd ? _lineEnd(gcode, startEndIdx) : -1;

  const mEndStart = RE_END_START.exec(gcode);
  const endStartIdx = mEndStart ? mEndStart.index : -1;

  // Vollständiger, idealer Fall
  if (execIdx >= 0 && startEndLineEnd >= 0 && endStartIdx >= 0) {
    return {
      header: gcode.slice(0, execIdx),
      startseq: gcode.slice(execIdx, startEndLineEnd),
      body: gcode.slice(startEndLineEnd, endStartIdx),
      endseq: gcode.slice(endStartIdx)
    };
  }

  // Fallbacks – robust bleiben
  // 1) Wenn nur EXEC vorhanden → header + (Rest als start/body/end heuristisch)
  if (execIdx >= 0 && startEndLineEnd < 0 && endStartIdx < 0) {
    return {
      header: gcode.slice(0, execIdx),
      startseq: gcode.slice(execIdx),
      body: "",
      endseq: ""
    };
  }
  // 2) EXEC & START_END vorhanden
  if (execIdx >= 0 && startEndLineEnd >= 0 && endStartIdx < 0) {
    return {
      header: gcode.slice(0, execIdx),
      startseq: gcode.slice(execIdx, startEndLineEnd),
      body: gcode.slice(startEndLineEnd),
      endseq: ""
    };
  }
  // 3) Nur END_START gefunden → alles davor als body, ab Marker endseq
  if (execIdx < 0 && startEndLineEnd < 0 && endStartIdx >= 0) {
    return {
      header: "",
      startseq: "",
      body: gcode.slice(0, endStartIdx),
      endseq: gcode.slice(endStartIdx)
    };
  }
  // 4) Nichts erkannt → alles als body
  return { header: "", startseq: "", body: gcode, endseq: "" };
}

export function parsePrinterModelFromGcode(gtext) {
  const m = gtext.match(/^[ \t]*;[ \t]*printer_model\s*=\s*(.+)$/mi);
  if (!m) return null;
  const raw = m[1].trim();

  if (/^Bambu Lab X1(?: Carbon|E)?$/i.test(raw)) return "X1";
  if (/^Bambu Lab A1 mini$/i.test(raw)) return "A1M";
  if (/^Bambu Lab P1(?:S|P)$/i.test(raw)) return "P1";
  return "UNSUPPORTED"; // alles andere
}

export function parseMaxZHeight(gcodeStr) {
  const m = gcodeStr.match(/^[ \t]*;[ \t]*max_z_height:\s*([0-9]+(?:\.[0-9]+)?)/m);
  return m ? parseFloat(m[1]) : null; // mm
}

export function joinSections(parts) {
  return (parts.header || "") + (parts.startseq || "") + (parts.body || "") + (parts.endseq || "");
}

export async function collectPlateGcodesOnce() {
  const my_plates = state.playlist_ol.getElementsByTagName("li");
  const list = [];

  for (let i = 0; i < my_plates.length; i++) {
    const c_f_id = my_plates[i].getElementsByClassName("f_id")[0].title;
    const c_file = state.my_files[c_f_id];
    const c_p_name = my_plates[i].getElementsByClassName("p_name")[0].title;
    const p_rep = my_plates[i].getElementsByClassName("p_rep")[0].value * 1;

    if (p_rep > 0) {
      const z = await JSZip.loadAsync(c_file);
      const plateText = await z.file(c_p_name).async("text");
      for (let r = 0; r < p_rep; r++) list.push(plateText);
    }
  }
  // list = [GCODE-Plate, GCODE-Plate, …] in Reihenfolge & mit Wiederholungen
  return list;
}

// Loops anwenden (1..N)
function applyLoops(arr, loops) {
  let out = [];
  for (let i = 0; i < loops; i++) out = out.concat(arr);
  return out;
}
