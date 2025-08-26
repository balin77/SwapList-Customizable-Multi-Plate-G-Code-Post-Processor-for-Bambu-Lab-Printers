// /src/gcode/buildGcode.js

import { parseMaxZHeight, splitIntoSections } from "../gcode/readGcode.js";
import {
  getSecurePushOffEnabled,
  getExtraPushOffLevels,
  getUserBedRaiseOffset,
  getCooldownTargetBedTemp,
  getCooldownMaxTime,
} from "../ui/settings.js";


// Multi‑Z push‑off: only "levels" mode (no legacy staircase).
// - levels = 1  → only final push at Z=1
// - levels >= 2 → evenly spaced heights from maxZ down, then always final at Z=1
// Feed rates:
//   * feedZ:     Z moves
//   * feedDown:  approach to Y=5   (slower)
//   * feedBack:  moves to Y=254    (faster, "reverse" legs)
export function buildFixedPushOffMultiZ(maxZmm, levels) {
  if (!Number.isFinite(maxZmm) || maxZmm <= 1) return "";

  const XsDesc = [200, 150, 100, 50]; // descending
  const Z_FLOOR = 1;                   // final floor
  const feedZ = 600;
  const feedDown = 1000;                // towards Y=5 (approach)
  const feedBack = 2000;                // towards Y=254 (reverse – faster)

  const fmt = v => {
    const s = (Math.round(v * 1000) / 1000).toString();
    return s.replace(/(\.\d*?)0+$/, '$1').replace(/\.$/, '');
  };

  const lines = [];

  function emitPushAt(z) {
    const zt = Math.max(Z_FLOOR, z);
    lines.push(`;--- PUSH_OFF at Z=${fmt(zt)} mm ---`);
    lines.push(`G1 Z${fmt(zt)} F${feedZ}`);
    for (const X of XsDesc) {
      const xOff = fmt(X - 8);
      // reverse (fast) to back edge
      lines.push(`G1 X${xOff} Y254 F${feedBack}`);
      // approach (slower) down
      lines.push(`G1 X${xOff} Y5   F${feedDown}`);
      // reverse (fast) back up
      lines.push(`G1 X${xOff} Y254 F${feedBack}`);
    }
  }

  const n = Number.isInteger(levels) ? Math.max(1, Math.min(10, levels)) : 1;

  if (n === 1) {
    // Only final push at Z=1
    emitPushAt(Z_FLOOR);
    return lines.join("\n");
  }

  const step = maxZmm / n; // equal divisions
  // Intermediate levels: maxZ - i*step (i=1..n-1), skip any that are <= 1
  for (let i = 1; i < n; i++) {
    const z = maxZmm - i * step;
    if (z <= Z_FLOOR + 1e-6) break;
    emitPushAt(z);
  }
  // Always finish at floor
  emitPushAt(Z_FLOOR);

  return lines.join("\n");
}

// baut die 2-Zeilen-Sequenz für jede X-Koordinate
export function buildPushOffSequence(xs) {
  if (!xs || !xs.length) return "";

  return xs.map(x => {
    const xOff = (x - 8).toFixed(2); // 2 Nachkommastellen, wenn du magst
    return [
      `G1 X${xOff} Y254 F2000`, // rausfahren hoch
      `G1 X${xOff} Y5 F300`,    // langsam runter
      `G1 X${xOff} Y254 F2000`  // schnell zurück
    ].join("\n");
  }).join("\n");
}

export function buildPushOffPayload(gcode, ctx) {
  // Per-object sequence (unchanged)
  const perObjectSeq = buildPushOffSequence(ctx.coords || []);

  // Read max_z_height from the plate header/orig
  const maxZ = parseMaxZHeight(ctx.sourcePlateText || gcode);

  // Secure push-off staircase (only if enabled)
  let staircaseSeq = "";
  if (getSecurePushOffEnabled()) {
    const levels = getExtraPushOffLevels(); // 1..10
    staircaseSeq = buildFixedPushOffMultiZ(maxZ, levels);
  }

  return [perObjectSeq, staircaseSeq].filter(Boolean).join("\n");
}

export function buildRaiseBedAfterCooldownPayload(gcodeSection, ctx) {
  const src = ctx.sourcePlateText || gcodeSection || "";
  const header = (splitIntoSections(src).header || src);
  const maxZ = parseMaxZHeight(header);

  const offset = getUserBedRaiseOffset();         // ← Userwert (z.B. 30 mm)
  let targetZ = 1;
  if (Number.isFinite(maxZ)) {
    targetZ = Math.max(1, +(maxZ - offset).toFixed(1)); // eine Nachkommastelle
  }

  console.log("[raiseBedAfterCooldown] maxZ=", maxZ, "offset=", offset, "→ Z=", targetZ);

  return [
    ";=== Raise Bed Level (after cooldown) ===",
    "M400",
    `G1 Z${targetZ} F600`,
    "M400 P100"
  ].join("\n");
}

export function buildCooldownFansWaitPayload(gcode, ctx) {
  const targetTemp = getCooldownTargetBedTemp(); // dein bisheriger Getter für °C
  const waitTemp = Math.max(0, targetTemp - 5); // wie gehabt: -5 °C offset
  const maxTimeMin = getCooldownMaxTime();        // NEW

  const lines = [];

  lines.push("; ====== Cool Down =====");
  lines.push("M106 P2 S255        ;turn Aux fan on");
  lines.push("M106 P3 S200        ;turn on chamber cooling fan");
  lines.push("M400");

  // Anzahl Wiederholungen = Minuten
  for (let i = 0; i < maxTimeMin; i++) {
    lines.push(`M190 S${waitTemp} ; wait for bed temp`);
  }
  lines.push(`; total max wait time of all lines = ${maxTimeMin} min`);

  lines.push("M106 P2 S0         ;turn off Aux fan");
  lines.push("M106 P3 S0         ;turn off chamber cooling fan");
  lines.push("M400");
  lines.push(";>>> Cooldown_fans_wait END");

  return lines.join("\n");
}

export function bumpFirstExtrusionToE3(gcode, plateIndex = -1) {
  const lines = gcode.split(/\r?\n/);
  const reG1 = /^\s*G1\b/i;
  const reX = /\bX[-+]?\d*\.?\d+/i;
  const reY = /\bY[-+]?\d*\.?\d+/i;
  const reE = /\bE([-+]?\d*\.?\d+)/i;
  const reEsub = /\bE[-+]?\d*\.?\d+/i;

  let hit = -1;
  for (let i = 0; i < lines.length; i++) {
    const raw = lines[i];
    if (/^\s*;/.test(raw)) continue;
    const code = raw.split(';', 1)[0];
    if (!reG1.test(code)) continue;
    if (!reX.test(code) || !reY.test(code)) continue;
    const mE = code.match(reE);
    if (!mE) continue;
    const eVal = parseFloat(mE[1]);
    if (!Number.isFinite(eVal) || eVal <= 0) continue;
    hit = i; break;
  }
  if (hit === -1) return gcode;

  lines[hit] = lines[hit].replace(reEsub, 'E3');
  return lines.join('\n');
}

