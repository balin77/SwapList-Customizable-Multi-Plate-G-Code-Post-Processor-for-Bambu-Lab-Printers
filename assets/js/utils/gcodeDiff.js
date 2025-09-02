// src/utils/gcodeDiff.js
// Vergleicht zwei GCODE-Texte zeilenweise und loggt die Unterschiede in der Console.

import gcodeLeft from "../testfiles/gcode1.gcode";
import gcodeRight from "../testfiles/gcode2.gcode";

/** Hilfsfunktion: nimmt String (direkt) ODER ESM-Import (string, evtl. unter .default) */
function resolveTextInput(input) {
  if (input == null) throw new Error("No input provided");
  if (typeof input === "string") return input;
  if (typeof input === "object") {
    // esbuild loader:text liefert den reinen String als default
    if ("default" in input && typeof input.default === "string") return input.default;
  }
  throw new Error("Unsupported input for text: " + (typeof input));
}

/** Normalisierung einer GCODE-Zeile (CR raus, optional trim) */
function normLine(s, { trim = false } = {}) {
  if (s == null) return "";
  let x = String(s).replace(/\r$/, "");
  return trim ? x.trim() : x;
}

/** Vergleich von zwei GCODE-Strings, Ergebnis ins Console-Log */
export function compareGcodeStrings(leftText, rightText, {
  ignoreCase = false,
  ignoreTrailingSpaces = false,
  showContext = 0,        // >0: zusätzliche Kontextzeilen um Änderungen herum loggen
} = {}) {
  const L = leftText.split(/\n/);
  const R = rightText.split(/\n/);
  const n = Math.max(L.length, R.length);

  const diffs = [];
  const changedLineIdx = [];

  console.groupCollapsed("%ccompareGcodeStrings", "color:#0aa");

  for (let i = 0; i < n; i++) {
    let a = normLine(L[i] ?? "", { trim: ignoreTrailingSpaces });
    let b = normLine(R[i] ?? "", { trim: ignoreTrailingSpaces });

    if (ignoreCase) { a = a.toLowerCase(); b = b.toLowerCase(); }

    if (a !== b) {
      changedLineIdx.push(i);
      diffs.push({ line: i + 1, left: L[i] ?? "", right: R[i] ?? "" });
    }
  }

  if (diffs.length === 0) {
    console.info("✅ Keine Unterschiede gefunden.");
    console.groupEnd();
    return { ok: true, differences: 0, diffs: [] };
  }

  console.warn(`⚠️ Unterschiede: ${diffs.length}`);
  // kompaktes Listing
  diffs.forEach(d => {
    console.groupCollapsed(`Line ${d.line}`);
    console.log("%c< left","color:#b00", d.left ?? "");
    console.log("%c> right","color:#070", d.right ?? "");
    console.groupEnd();
  });

  // optionaler Kontextblock
  if (showContext > 0) {
    console.groupCollapsed("Context view");
    const marks = new Set();
    changedLineIdx.forEach(i => {
      for (let k = Math.max(0, i - showContext); k <= Math.min(n - 1, i + showContext); k++) marks.add(k);
    });
    const sorted = Array.from(marks).sort((a,b) => a-b);
    let last = -3;
    sorted.forEach(i => {
      if (i > last + 1) console.log("…");
      const a = L[i] ?? "";
      const b = R[i] ?? "";
      const aN = normLine(a, { trim: ignoreTrailingSpaces });
      const bN = normLine(b, { trim: ignoreTrailingSpaces });
      const changed = (ignoreCase ? aN.toLowerCase() !== bN.toLowerCase() : aN !== bN);
      const tag = changed ? "*" : " ";
      console.log(`${String(i+1).padStart(5," ")}${tag} | < ${a}`);
      console.log(`${String(i+1).padStart(5," ")}${tag} | > ${b}`);
      last = i;
    });
    console.groupEnd();
  }

  console.groupEnd();
  return { ok: true, differences: diffs.length, diffs };
}

/** “Wie bei project_settings”: Wrapper, der zwei Dateien lädt und vergleicht */
export async function compareGcodeFiles({
  left = gcodeLeft,
  right = gcodeRight,
  options = { ignoreCase: false, ignoreTrailingSpaces: false, showContext: 2 }
} = {}) {
  try {
    const leftText  = resolveTextInput(left);
    const rightText = resolveTextInput(right);
    return compareGcodeStrings(leftText, rightText, options);
  } catch (err) {
    console.error("❌ compareGcodeFiles failed:", err);
    return { ok: false, error: err?.message || String(err) };
  }
}
