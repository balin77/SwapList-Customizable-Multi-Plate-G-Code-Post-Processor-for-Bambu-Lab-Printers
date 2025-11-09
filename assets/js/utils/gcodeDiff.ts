// src/utils/gcodeDiff.ts
// Compares two GCODE texts line by line and logs the differences to the console.

// @ts-expect-error - Test data imports
import gcodeLeft from "../testfiles/gcode1.gcode";
// @ts-expect-error - Test data imports
import gcodeRight from "../testfiles/gcode2.gcode";

/**
 * Input type for GCODE comparison - can be a string or ESM module import
 */
type TextInput = string | { default: string } | unknown;

/**
 * Single line difference record
 */
export interface LineDiff {
  /** Line number (1-indexed) */
  line: number;
  /** Left side content */
  left: string;
  /** Right side content */
  right: string;
}

/**
 * Comparison result
 */
export interface ComparisonResult {
  /** Whether the comparison succeeded */
  ok: boolean;
  /** Number of differences found */
  differences: number;
  /** Array of line differences */
  diffs: LineDiff[];
  /** Error message if ok is false */
  error?: string;
}

/**
 * Comparison options
 */
export interface ComparisonOptions {
  /** Ignore case differences */
  ignoreCase?: boolean;
  /** Ignore trailing whitespace */
  ignoreTrailingSpaces?: boolean;
  /** Number of context lines to show around changes (0 = none) */
  showContext?: number;
}

/**
 * Internal helper: Takes an object OR path/URL and returns a string.
 * Handles ESM imports with default wrapper.
 *
 * @param input - String or ESM module import
 * @returns Resolved text content
 */
function resolveTextInput(input: TextInput): string {
  if (input == null) throw new Error("No input provided");
  if (typeof input === "string") return input;
  if (typeof input === "object") {
    // esbuild loader:text provides the raw string as default
    if ("default" in input && typeof input.default === "string") return input.default;
  }
  throw new Error("Unsupported input for text: " + (typeof input));
}

/**
 * Line normalization options
 */
interface NormOptions {
  /** Trim whitespace */
  trim?: boolean;
}

/**
 * Normalizes a GCODE line (removes CR, optionally trims).
 *
 * @param s - Line to normalize
 * @param options - Normalization options
 * @returns Normalized line
 */
function normLine(s: string | null | undefined, { trim = false }: NormOptions = {}): string {
  if (s == null) return "";
  let x = String(s).replace(/\r$/, "");
  return trim ? x.trim() : x;
}

/**
 * Compares two GCODE strings line by line and logs differences to console.
 *
 * @param leftText - First GCODE string
 * @param rightText - Second GCODE string
 * @param options - Comparison options
 * @returns Comparison result with differences
 *
 * @example
 * ```ts
 * const result = compareGcodeStrings(gcode1, gcode2, {
 *   ignoreCase: false,
 *   ignoreTrailingSpaces: true,
 *   showContext: 2
 * });
 * console.log(`Found ${result.differences} differences`);
 * ```
 */
export function compareGcodeStrings(
  leftText: string,
  rightText: string,
  {
    ignoreCase = false,
    ignoreTrailingSpaces = false,
    showContext = 0,
  }: ComparisonOptions = {}
): ComparisonResult {
  const L = leftText.split(/\n/);
  const R = rightText.split(/\n/);
  const n = Math.max(L.length, R.length);

  const diffs: LineDiff[] = [];
  const changedLineIdx: number[] = [];

  console.groupCollapsed("%ccompareGcodeStrings", "color:#0aa");

  for (let i = 0; i < n; i++) {
    let a = normLine(L[i] ?? "", { trim: ignoreTrailingSpaces });
    let b = normLine(R[i] ?? "", { trim: ignoreTrailingSpaces });

    if (ignoreCase) {
      a = a.toLowerCase();
      b = b.toLowerCase();
    }

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
  // Compact listing
  diffs.forEach(d => {
    console.groupCollapsed(`Line ${d.line}`);
    console.log("%c< left", "color:#b00", d.left ?? "");
    console.log("%c> right", "color:#070", d.right ?? "");
    console.groupEnd();
  });

  // Optional context block
  if (showContext > 0) {
    console.groupCollapsed("Context view");
    const marks = new Set<number>();
    changedLineIdx.forEach(i => {
      for (let k = Math.max(0, i - showContext); k <= Math.min(n - 1, i + showContext); k++) {
        marks.add(k);
      }
    });
    const sorted = Array.from(marks).sort((a, b) => a - b);
    let last = -3;
    sorted.forEach(i => {
      if (i > last + 1) console.log("…");
      const a = L[i] ?? "";
      const b = R[i] ?? "";
      const aN = normLine(a, { trim: ignoreTrailingSpaces });
      const bN = normLine(b, { trim: ignoreTrailingSpaces });
      const changed = (ignoreCase ? aN.toLowerCase() !== bN.toLowerCase() : aN !== bN);
      const tag = changed ? "*" : " ";
      console.log(`${String(i + 1).padStart(5, " ")}${tag} | < ${a}`);
      console.log(`${String(i + 1).padStart(5, " ")}${tag} | > ${b}`);
      last = i;
    });
    console.groupEnd();
  }

  console.groupEnd();
  return { ok: true, differences: diffs.length, diffs };
}

/**
 * Wrapper that loads and compares two GCODE files (similar to project_settings).
 *
 * @param params - Comparison parameters
 * @param params.left - Left GCODE file (string or import)
 * @param params.right - Right GCODE file (string or import)
 * @param params.options - Comparison options
 * @returns Comparison result
 *
 * @example
 * ```ts
 * const result = await compareGcodeFiles({
 *   left: gcodeImport1,
 *   right: gcodeImport2,
 *   options: { showContext: 2 }
 * });
 * ```
 */
export async function compareGcodeFiles({
  left = gcodeLeft,
  right = gcodeRight,
  options = { ignoreCase: false, ignoreTrailingSpaces: false, showContext: 2 }
}: {
  left?: TextInput;
  right?: TextInput;
  options?: ComparisonOptions;
} = {}): Promise<ComparisonResult> {
  try {
    const leftText = resolveTextInput(left);
    const rightText = resolveTextInput(right);
    return compareGcodeStrings(leftText, rightText, options);
  } catch (err) {
    console.error("❌ compareGcodeFiles failed:", err);
    return {
      ok: false,
      differences: 0,
      diffs: [],
      error: err instanceof Error ? err.message : String(err)
    };
  }
}
