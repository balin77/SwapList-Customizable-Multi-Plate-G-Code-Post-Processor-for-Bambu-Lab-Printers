// /src/gcode/readGcode.ts

import { state } from "../config/state.js";
import JSZip from "jszip";
import type { PrinterModel } from "../types/index.js";

/**
 * GCODE sections after splitting
 */
export interface GCodeSections {
  /** Header section (before EXECUTABLE_BLOCK_START) */
  header: string;
  /** Start sequence (from EXECUTABLE_BLOCK_START to MACHINE_START_GCODE_END) */
  startseq: string;
  /** Body section (main printing code) */
  body: string;
  /** End sequence (from MACHINE_END_GCODE_START to EOF) */
  endseq: string;
}

// ===== Section Split/Join =====

const RE_EXEC_START = /^[ \t]*;[ \t]*EXECUTABLE_BLOCK_START[^\n]*\n?/m;
const RE_START_END = /^[ \t]*;[ \t]*MACHINE_START_GCODE_END[^\n]*\n?/m;
const RE_END_START = /^[ \t]*;[ \t]*MACHINE_END_GCODE_START[^\n]*\n?/m;

/**
 * Finds the end of the line containing the given index
 *
 * @param src - Source string
 * @param idx - Index to start from
 * @returns Index of line end (after newline) or string length
 */
function _lineEnd(src: string, idx: number): number {
  if (idx < 0) return -1;
  const nl = src.indexOf("\n", idx);
  return (nl === -1) ? src.length : nl + 1;
}

/**
 * Splits GCODE into sections: header, startseq, body, endseq.
 *
 * - header:   [0 .. execIdx)                   (marker not included)
 * - startseq: [execIdx .. startEndLineEnd)     (EXEC.. incl.; START_END incl.)
 * - body:     [startEndLineEnd .. endStartIdx) (lines after START_END until END_START)
 * - endseq:   [endStartIdx .. EOF]             (END_START incl.)
 *
 * @param gcode - GCODE string to split
 * @returns Object with header, startseq, body, and endseq sections
 */
export function splitIntoSections(gcode: string): GCodeSections {
  const mExec = RE_EXEC_START.exec(gcode);
  const execIdx = mExec ? mExec.index : -1;
  // const execLineEnd = mExec ? _lineEnd(gcode, execIdx) : -1; // Unused variable

  const mStartEnd = RE_START_END.exec(gcode);
  const startEndIdx = mStartEnd ? mStartEnd.index : -1;
  const startEndLineEnd = mStartEnd ? _lineEnd(gcode, startEndIdx) : -1;

  const mEndStart = RE_END_START.exec(gcode);
  const endStartIdx = mEndStart ? mEndStart.index : -1;

  // Complete, ideal case
  if (execIdx >= 0 && startEndLineEnd >= 0 && endStartIdx >= 0) {
    return {
      header: gcode.slice(0, execIdx),
      startseq: gcode.slice(execIdx, startEndLineEnd),
      body: gcode.slice(startEndLineEnd, endStartIdx),
      endseq: gcode.slice(endStartIdx)
    };
  }

  // Fallbacks – stay robust
  // 1) Only EXEC present → header + (rest as start/body/end heuristically)
  if (execIdx >= 0 && startEndLineEnd < 0 && endStartIdx < 0) {
    return {
      header: gcode.slice(0, execIdx),
      startseq: gcode.slice(execIdx),
      body: "",
      endseq: ""
    };
  }
  // 2) EXEC & START_END present
  if (execIdx >= 0 && startEndLineEnd >= 0 && endStartIdx < 0) {
    return {
      header: gcode.slice(0, execIdx),
      startseq: gcode.slice(execIdx, startEndLineEnd),
      body: gcode.slice(startEndLineEnd),
      endseq: ""
    };
  }
  // 3) Only END_START found → everything before as body, from marker endseq
  if (execIdx < 0 && startEndLineEnd < 0 && endStartIdx >= 0) {
    return {
      header: "",
      startseq: "",
      body: gcode.slice(0, endStartIdx),
      endseq: gcode.slice(endStartIdx)
    };
  }
  // 4) Nothing recognized → everything as body
  return { header: "", startseq: "", body: gcode, endseq: "" };
}

/**
 * Parses the printer model from GCODE header comments
 *
 * @param gtext - GCODE text to parse
 * @returns Printer model string or "UNSUPPORTED" if not recognized, null if not found
 */
export function parsePrinterModelFromGcode(gtext: string): PrinterModel | "UNSUPPORTED" | null {
  const m = gtext.match(/^[ \t]*;[ \t]*printer_model\s*=\s*(.+)$/mi);
  if (!m || !m[1]) return null;
  const raw = m[1].trim();

  if (/^Bambu Lab X1(?: Carbon|E)?$/i.test(raw)) return "X1";
  if (/^Bambu Lab A1 mini$/i.test(raw)) return "A1M";
  if (/^Bambu Lab A1$/i.test(raw)) return "A1";
  if (/^Bambu Lab P1(?:S|P)$/i.test(raw)) return "P1";
  return "UNSUPPORTED"; // everything else
}

/**
 * Parses the maximum Z height from GCODE header comments
 *
 * @param gcodeStr - GCODE string to parse
 * @returns Maximum Z height in millimeters, or null if not found
 */
export function parseMaxZHeight(gcodeStr: string): number | null {
  const m = gcodeStr.match(/^[ \t]*;[ \t]*max_z_height:\s*([0-9]+(?:\.[0-9]+)?)/m);
  return (m && m[1]) ? parseFloat(m[1]) : null; // mm
}

/**
 * Joins GCODE sections back into a single string
 *
 * @param parts - GCODE sections to join
 * @returns Complete GCODE string
 */
export function joinSections(parts: Partial<GCodeSections>): string {
  return (parts.header || "") + (parts.startseq || "") + (parts.body || "") + (parts.endseq || "");
}

/**
 * Joins GCODE sections for test mode (body section removed)
 *
 * @param parts - GCODE sections to join
 * @returns GCODE string with test comment instead of body
 */
export function joinSectionsTestMode(parts: Partial<GCodeSections>): string {
  // For test files: only header, startseq, and endseq - no body (printing code)
  const testComment = "\n; BODY SECTION REMOVED FOR TEST FILE\n; (Original printing code would be here)\n\n";
  return (parts.header || "") + (parts.startseq || "") + testComment + (parts.endseq || "");
}

/**
 * Collects GCODE from all plates in the playlist
 *
 * @returns Array of GCODE strings (one per plate, with repetitions)
 */
export async function collectPlateGcodesOnce(): Promise<string[]> {
  const my_plates = state.playlist_ol!.getElementsByTagName("li");
  const list: string[] = [];

  for (let i = 0; i < my_plates.length; i++) {
    const f_id_el = my_plates[i]?.getElementsByClassName("f_id")[0];
    const c_f_id = f_id_el?.getAttribute("title") || "0";
    const c_file = state.my_files[parseInt(c_f_id)];
    const p_name_el = my_plates[i]?.getElementsByClassName("p_name")[0];
    const c_p_name = p_name_el?.getAttribute("title") || "";
    const p_rep_el = my_plates[i]?.getElementsByClassName("p_rep")[0] as HTMLInputElement | undefined;
    const p_rep = parseInt(p_rep_el?.value || "0") || 0;

    if (p_rep > 0) {
      const z = await JSZip.loadAsync(c_file);
      const plateFile = z.file(c_p_name);
      if (plateFile) {
        const plateText = await plateFile.async("text");
        for (let r = 0; r < p_rep; r++) list.push(plateText);
      }
    }
  }
  // list = [GCODE-Plate, GCODE-Plate, …] in order & with repetitions
  return list;
}

/**
 * Applies loops (repetitions) to an array
 *
 * @param arr - Array to repeat
 * @param loops - Number of times to repeat (1..N)
 * @returns New array with all elements repeated
 */
// eslint-disable-next-line @typescript-eslint/no-unused-vars
// @ts-ignore - Unused function kept for potential future use
// eslint-disable-next-line @typescript-eslint/no-unused-vars
function applyLoops<T>(arr: T[], loops: number): T[] {
  let out: T[] = [];
  for (let i = 0; i < loops; i++) out = out.concat(arr);
  return out;
}
