// src/utils/utils.js

// Import JSON data as JavaScript modules to avoid CORS issues
import { project_settings_original } from "../testfiles/project_settings_original_data.js";
import { project_settings_template } from "../testfiles/project_settings_template_data.js";
import { project_settings_modified } from "../testfiles/project_settings_modified_data.js";

// Provide access to the imported data
const getOriginalSettings = async () => project_settings_original;
const getTemplateSettings = async () => project_settings_template;
const getModifiedSettings = async () => project_settings_modified;

/** interner Helper: nimmt Objekt ODER Pfad/URL und liefert ein Objekt */
async function resolveSettingsInput(input) {
  if (!input) throw new Error("No input provided");

  // Falls bereits ein Objekt (z.B. via ESM import)
  if (typeof input === "object") {
    // ESM default-Wrapper abfangen
    if (input && typeof input === "object" && "default" in input && input.default) {
      return input.default;
    }
    return input;
  }

  // Falls String ⇒ versuchen zu laden
  if (typeof input === "string") {
    let url = input;
    // bei Bedarf Endung ergänzen (optional)
    if (!/\.(json|js)$/i.test(url)) url = url + ".json";

    const resp = await fetch(url);
    if (!resp.ok) {
      throw new Error(`Fetch failed (${resp.status} ${resp.statusText}) for ${url}`);
    }
    // .json() klappt für JSON. Für .js würdest du dynamic import nutzen – hier nur JSON.
    return await resp.json();
  }

  throw new Error(`Unsupported input type: ${typeof input}`);
}

/** hübsche Kurzform für primitive Werte im Log */
function repr(v) {
  if (typeof v === "string") return JSON.stringify(v);
  if (typeof v === "number" || typeof v === "boolean" || v == null) return String(v);
  if (Array.isArray(v)) return `[Array(${v.length})]`;
  if (typeof v === "object") return "{Object}";
  return String(v);
}

/** Deep-Diff: rekursiv vergleichen und Log-Einträge erzeugen */
function diffObjects(a, b, path = "", out = []) {
  const here = path || "(root)";

  // Typen abgleichen
  const ta = Object.prototype.toString.call(a);
  const tb = Object.prototype.toString.call(b);
  if (ta !== tb) {
    out.push(`Type mismatch at ${here}: ${ta} != ${tb}`);
    return out;
  }

  // Primitive
  if (typeof a !== "object" || a === null) {
    if (a !== b) out.push(`Value mismatch at ${here}: ${repr(a)} != ${repr(b)}`);
    return out;
  }

  // Array
  if (Array.isArray(a)) {
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

  // Objekt
  const keys = new Set([...Object.keys(a), ...Object.keys(b)]);
  for (const k of keys) {
    const hasA = Object.prototype.hasOwnProperty.call(a, k);
    const hasB = Object.prototype.hasOwnProperty.call(b, k);
    const p = path ? `${path}.${k}` : k;

    if (!hasA) out.push(`Missing key in original at ${p}`);
    else if (!hasB) out.push(`Missing key in modified at ${p}`);
    else diffObjects(a[k], b[k], p, out);
  }
  return out;
}

/**
 * Vergleicht original vs. modifiziert (Objekte ODER Pfade).
 * Logs landen gruppiert in der Konsole. Liefert eine Zusammenfassung zurück.
 */
export async function compareProjectSettingsFiles({
  original = null,
  modified = null,
} = {}) {
  // Use default JSON files if no parameters provided
  if (!original) original = await getOriginalSettings();
  if (!modified) modified = await getModifiedSettings();
  try {
    const origObj = await resolveSettingsInput(original);
    const modObj  = await resolveSettingsInput(modified);

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
    return { ok: false, error: err?.message || String(err) };
  }
}

/**
 * Vergleicht template vs. modifiziert (Objekte ODER Pfade).
 * Logs landen gruppiert in der Konsole. Liefert eine Zusammenfassung zurück.
 */
export async function compareTemplateModifiedFiles({
  template = null,
  modified = null,
} = {}) {
  // Use default JSON files if no parameters provided
  if (!template) template = await getTemplateSettings();
  if (!modified) modified = await getModifiedSettings();
  try {
    const templObj = await resolveSettingsInput(template);
    const modObj  = await resolveSettingsInput(modified);

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
    return { ok: false, error: err?.message || String(err) };
  }
}
