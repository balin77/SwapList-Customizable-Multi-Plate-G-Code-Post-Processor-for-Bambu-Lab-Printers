// src/utils/utils.ts

// Import JSON data as JavaScript modules to avoid CORS issues
// @ts-expect-error - Test data imports
import { project_settings_original } from "../testfiles/project_settings_original_data.js";
// @ts-expect-error - Test data imports
import { project_settings_template } from "../testfiles/project_settings_template_data.js";
// @ts-expect-error - Test data imports
import { project_settings_modified } from "../testfiles/project_settings_modified_data.js";

/**
 * Input type for settings - can be an object, path/URL, or ESM module import
 */
type SettingsInput = Record<string, unknown> | string | { default: Record<string, unknown> } | unknown;

/**
 * Comparison result type
 */
export interface ComparisonResult {
  /** Whether the comparison succeeded */
  ok: boolean;
  /** Number of differences found */
  differences: number;
  /** Array of difference descriptions */
  diffs: string[];
  /** Error message if ok is false */
  error?: string;
}

// Provide access to the imported data
const getOriginalSettings = async (): Promise<Record<string, unknown>> => project_settings_original;
const getTemplateSettings = async (): Promise<Record<string, unknown>> => project_settings_template;
const getModifiedSettings = async (): Promise<Record<string, unknown>> => project_settings_modified;

/**
 * Internal helper: Takes an object OR path/URL and returns an object.
 *
 * @param input - Object, URL string, or ESM module import
 * @returns Resolved settings object
 */
async function resolveSettingsInput(input: SettingsInput): Promise<Record<string, unknown>> {
  if (!input) throw new Error("No input provided");

  // If already an object (e.g. via ESM import)
  if (typeof input === "object") {
    // Catch ESM default wrapper
    if (input && typeof input === "object" && "default" in input && input.default) {
      return input.default as Record<string, unknown>;
    }
    return input as Record<string, unknown>;
  }

  // If string ⇒ try to load
  if (typeof input === "string") {
    let url = input;
    // Add extension if needed (optional)
    if (!/\.(json|js)$/i.test(url)) url = url + ".json";

    const resp = await fetch(url);
    if (!resp.ok) {
      throw new Error(`Fetch failed (${resp.status} ${resp.statusText}) for ${url}`);
    }
    // .json() works for JSON. For .js you'd use dynamic import – here only JSON.
    return await resp.json();
  }

  throw new Error(`Unsupported input type: ${typeof input}`);
}

/**
 * Pretty short form for primitive values in logs.
 *
 * @param v - Value to represent
 * @returns String representation
 */
function repr(v: unknown): string {
  if (typeof v === "string") return JSON.stringify(v);
  if (typeof v === "number" || typeof v === "boolean" || v == null) return String(v);
  if (Array.isArray(v)) return `[Array(${v.length})]`;
  if (typeof v === "object") return "{Object}";
  return String(v);
}

/**
 * Deep-Diff: Recursively compares objects and generates log entries.
 *
 * @param a - First object to compare
 * @param b - Second object to compare
 * @param path - Current path in object tree (for logging)
 * @param out - Output array for difference messages
 * @returns Array of difference descriptions
 */
function diffObjects(a: unknown, b: unknown, path: string = "", out: string[] = []): string[] {
  const here = path || "(root)";

  // Compare types
  const ta = Object.prototype.toString.call(a);
  const tb = Object.prototype.toString.call(b);
  if (ta !== tb) {
    out.push(`Type mismatch at ${here}: ${ta} != ${tb}`);
    return out;
  }

  // Primitives
  if (typeof a !== "object" || a === null) {
    if (a !== b) out.push(`Value mismatch at ${here}: ${repr(a)} != ${repr(b)}`);
    return out;
  }

  // Arrays
  if (Array.isArray(a) && Array.isArray(b)) {
    if (a.length !== b.length) {
      out.push(`Length mismatch at ${here}: ${a.length} != ${b.length}`);
    }
    const n = Math.max(a.length, b.length);
    for (let i = 0; i < n; i++) {
      if (!(i in a)) out.push(`Missing index in original at ${here}[${i}]`);
      else if (!(i in b)) out.push(`Missing index in modified at ${here}[${i}]`);
      else diffObjects(a[i], b[i], `${here}[${i}]`, out);
    }
    return out;
  }

  // Objects
  const aObj = a as Record<string, unknown>;
  const bObj = b as Record<string, unknown>;
  const keys = new Set([...Object.keys(aObj), ...Object.keys(bObj)]);
  for (const k of keys) {
    const hasA = Object.prototype.hasOwnProperty.call(aObj, k);
    const hasB = Object.prototype.hasOwnProperty.call(bObj, k);
    const p = path ? `${path}.${k}` : k;

    if (!hasA) out.push(`Missing key in original at ${p}`);
    else if (!hasB) out.push(`Missing key in modified at ${p}`);
    else diffObjects(aObj[k], bObj[k], p, out);
  }
  return out;
}

/**
 * Compares original vs. modified settings (objects OR paths).
 * Logs are grouped in the console. Returns a summary.
 *
 * @param params - Comparison parameters
 * @param params.original - Original settings (object, path, or import)
 * @param params.modified - Modified settings (object, path, or import)
 * @returns Comparison result
 *
 * @example
 * ```ts
 * const result = await compareProjectSettingsFiles({
 *   original: originalData,
 *   modified: modifiedData
 * });
 * console.log(`Found ${result.differences} differences`);
 * ```
 */
export async function compareProjectSettingsFiles({
  original = null as SettingsInput | null,
  modified = null as SettingsInput | null,
}: {
  original?: SettingsInput | null;
  modified?: SettingsInput | null;
} = {}): Promise<ComparisonResult> {
  // Use default JSON files if no parameters provided
  if (!original) original = await getOriginalSettings();
  if (!modified) modified = await getModifiedSettings();
  try {
    const origObj = await resolveSettingsInput(original);
    const modObj = await resolveSettingsInput(modified);

    console.groupCollapsed("%ccompareProjectSettingsFiles", "color:#0aa");
    console.log("Original:", origObj);
    console.log("Modified:", modObj);

    const diffs = diffObjects(origObj, modObj);

    if (diffs.length === 0) {
      console.info("✅ Keine Unterschiede gefunden.");
    } else {
      console.groupCollapsed(`⚠️ Unterschiede (${diffs.length})`);
      for (const line of diffs) console.log(line);
      console.groupEnd();
    }
    console.groupEnd();

    return { ok: true, differences: diffs.length, diffs };
  } catch (err) {
    console.error("❌ compareProjectSettingsFiles failed:", err);
    return {
      ok: false,
      differences: 0,
      diffs: [],
      error: err instanceof Error ? err.message : String(err)
    };
  }
}

/**
 * Compares template vs. modified settings (objects OR paths).
 * Logs are grouped in the console. Returns a summary.
 *
 * @param params - Comparison parameters
 * @param params.template - Template settings (object, path, or import)
 * @param params.modified - Modified settings (object, path, or import)
 * @returns Comparison result
 *
 * @example
 * ```ts
 * const result = await compareTemplateModifiedFiles({
 *   template: templateData,
 *   modified: modifiedData
 * });
 * console.log(`Found ${result.differences} differences`);
 * ```
 */
export async function compareTemplateModifiedFiles({
  template = null as SettingsInput | null,
  modified = null as SettingsInput | null,
}: {
  template?: SettingsInput | null;
  modified?: SettingsInput | null;
} = {}): Promise<ComparisonResult> {
  // Use default JSON files if no parameters provided
  if (!template) template = await getTemplateSettings();
  if (!modified) modified = await getModifiedSettings();
  try {
    const templObj = await resolveSettingsInput(template);
    const modObj = await resolveSettingsInput(modified);

    console.groupCollapsed("%ccompareTemplateModifiedFiles", "color:#0aa");
    console.log("Template:", templObj);
    console.log("Modified:", modObj);

    const diffs = diffObjects(templObj, modObj);

    if (diffs.length === 0) {
      console.info("✅ Keine Unterschiede gefunden - Template und Modified sind identisch!");
    } else {
      console.groupCollapsed(`⚠️ Unterschiede (${diffs.length})`);
      for (const line of diffs) console.log(line);
      console.groupEnd();
    }
    console.groupEnd();

    return { ok: true, differences: diffs.length, diffs };
  } catch (err) {
    console.error("❌ compareTemplateModifiedFiles failed:", err);
    return {
      ok: false,
      differences: 0,
      diffs: [],
      error: err instanceof Error ? err.message : String(err)
    };
  }
}
