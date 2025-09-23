// /src/gcode/buildGcode.js

import { parseMaxZHeight, splitIntoSections } from "../gcode/readGcode.js";
import {
  getSecurePushOffEnabled,
  getExtraPushOffLevels,
  getUserBedRaiseOffset,
  getCooldownTargetBedTemp,
  getCooldownMaxTime,
  getSecurePushOffEnabledForPlate,
  getExtraPushOffLevelsForPlate,
  getUserBedRaiseOffsetForPlate,
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
  const plateIndex = ctx.plateIndex;
  const securePushOffEnabled = plateIndex !== undefined
    ? getSecurePushOffEnabledForPlate(plateIndex)
    : getSecurePushOffEnabled();

  if (securePushOffEnabled) {
    const levels = plateIndex !== undefined
      ? getExtraPushOffLevelsForPlate(plateIndex)
      : getExtraPushOffLevels(); // 1..10
    staircaseSeq = buildFixedPushOffMultiZ(maxZ, levels);
  }

  return [
    "",
    perObjectSeq,
    staircaseSeq
  ].filter(Boolean).join("\n") + "\n";
}

export function buildRaiseBedAfterCooldownPayload(gcodeSection, ctx) {
  const src = ctx.sourcePlateText || gcodeSection || "";
  const header = (splitIntoSections(src).header || src);
  const maxZ = parseMaxZHeight(header);

  const plateIndex = ctx.plateIndex;
  const offset = plateIndex !== undefined
    ? getUserBedRaiseOffsetForPlate(plateIndex)
    : getUserBedRaiseOffset();         // ← Userwert (z.B. 30 mm)
  let targetZ = 1;
  if (Number.isFinite(maxZ)) {
    targetZ = Math.max(1, +(maxZ - offset).toFixed(1)); // eine Nachkommastelle
  }

  console.log("[raiseBedAfterCooldown] maxZ=", maxZ, "offset=", offset, "→ Z=", targetZ);

  return [
    "",
    ";=== Raise Bed Level (after cooldown) ===",
    "M400",
    `G1 Z${targetZ} F600`,
    "M400 P100",
    ";>>> Raise_bed_after_cooldown END",
    ""
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

export function buildA1NozzleCoolingSequence(gcode, ctx) {
  // Extract temperatures from GCODE comment
  const temperatureMatch = gcode.match(/;\s*nozzle_temperature\s*=\s*([\d,]+)/i);
  let temperatures = [];
  if (temperatureMatch) {
    temperatures = temperatureMatch[1].split(',').map(t => parseInt(t.trim())).filter(t => !isNaN(t));
  }
  
  // Extract first extruder from plate JSON if available in sourcePlateText
  let firstExtruder = 0;
  const plateJsonMatch = ctx.sourcePlateText?.match(/"first_extruder"\s*:\s*(\d+)/);
  if (plateJsonMatch) {
    firstExtruder = parseInt(plateJsonMatch[1]);
  }
  
  // Get the temperature for the first extruder
  let baseTemp = 220; // fallback temperature
  if (temperatures.length > firstExtruder) {
    baseTemp = temperatures[firstExtruder];
  }
  
  // Calculate cooling temperature (baseTemp - 20)
  const coolingTemp = Math.max(180, baseTemp - 20);
  
  console.log(`[A1 Cooling] First extruder: ${firstExtruder}, base temp: ${baseTemp}, cooling temp: ${coolingTemp}`);
  
  return `\n\nG1 Z3 F800 ; move nozzle up a little\nM106 P1 S255 ; turn on fan to cool tip of nozzle, prevents oozing\nM109 S${coolingTemp} ; wait for warm up but don't fully heat yet to prevent oozing\n`;
}

export function buildA1EndseqCooldown(gcode, ctx) {
  const targetTemp = getCooldownTargetBedTemp(); // UI Setting
  const waitTemp = Math.max(0, targetTemp - 5); // -5 °C offset
  const maxTimeMin = getCooldownMaxTime(); // UI Setting für Anzahl der M190 Zeilen

  // Z-Höhen Logik wie bei buildRaiseBedAfterCooldownPayload
  const src = ctx.sourcePlateText || gcode || "";
  const header = (splitIntoSections(src).header || src);
  const maxZ = parseMaxZHeight(header);
  
  const plateIndex = ctx.plateIndex;
  const offset = plateIndex !== undefined
    ? getUserBedRaiseOffsetForPlate(plateIndex)
    : getUserBedRaiseOffset(); // UI Setting (default 30mm für X1/P1, sollte 40mm für A1 sein)
  let targetZ = 1;
  if (Number.isFinite(maxZ)) {
    targetZ = Math.max(1, +(maxZ - offset).toFixed(1)); // eine Nachkommastelle
  }

  console.log("[A1 Endseq Cooldown] maxZ=", maxZ, "offset=", offset, "→ Z=", targetZ);

  const lines = [];
  
  lines.push("M400                ;wait for all print moves to be done");
  lines.push("");
  lines.push(";===== Cool Down =======");
  lines.push("G90");
  lines.push("G1 X-48 Y262 F3600 ; move to safe limit position on the left");
  
  // Füge die M190 Zeilen basierend auf maxTimeMin hinzu
  for (let i = 0; i < maxTimeMin; i++) {
    lines.push(`M190 S${waitTemp}    ;wait for bed temp, ${i + 1} to be done`);
  }
  
  // Bed ausschalten und Push-Off Marker
  lines.push("");
  lines.push("M140 S0 ; turn off bed");
  lines.push("");
  lines.push("");
  lines.push(";======= Cool Down Done, Start Push Off =============");
  
  // Z-Movement basierend auf Höhe und Offset
  lines.push(`G1 Z${targetZ} F600`);
  
  // Push-off Sequenz
  lines.push("M400 P100");
  lines.push("G1 Y-0.5 F300        ; very slow push off use x gantry");

  return lines.join("\n");
}

export function buildA1SafetyClear(gcode, ctx) {
  const plateIndex = ctx.plateIndex;
  const levels = plateIndex !== undefined
    ? getExtraPushOffLevelsForPlate(plateIndex)
    : getExtraPushOffLevels(); // UI Setting für additional push off levels
  
  const lines = [];
  
  // Header und initiale Bewegungen
  lines.push(";======== Push off complete, start safety clear / side push off ======");
  lines.push("G1 Y262 F800    ;move bed forward again");
  lines.push("G1 Z1 F600      ;move nozzle closer to the bed when using tall parts");
  
  // X-mal die Push-Off Sequenz
  for (let i = 0; i < levels; i++) {
    const yPos = Math.max(0, 262 - (i + 1) * 50); // Y niemals kleiner als 0
    lines.push("");
    lines.push(`G1 Y${yPos} F2000    ;move bed back a little`);
    lines.push("G1 X256 F800    ;move to the right");
    lines.push("G1 X-48 F2000    ;move back to the left");
  }
  
  // Finale Bewegungen
  lines.push("");
  lines.push("G1 Y262 F2000    ;push bed forward one last time");
  lines.push("");
  lines.push(";====== Safety clear complete =======");
  lines.push("");
  
  console.log(`[A1 Safety Clear] Using ${levels} additional push off levels`);
  
  return lines.join("\n");
}

export function buildA1PrePrintExtrusion(gcode, ctx) {
  // Extract temperatures from GCODE comment
  const temperatureMatch = gcode.match(/;\s*nozzle_temperature\s*=\s*([\d,]+)/i);
  let temperatures = [];
  if (temperatureMatch) {
    temperatures = temperatureMatch[1].split(',').map(t => parseInt(t.trim())).filter(t => !isNaN(t));
  }

  // Extract first extruder from plate JSON if available in sourcePlateText
  let firstExtruder = 0;
  const plateJsonMatch = ctx.sourcePlateText?.match(/"first_extruder"\s*:\s*(\d+)/);
  if (plateJsonMatch) {
    firstExtruder = parseInt(plateJsonMatch[1]);
  }

  // Get the temperature for the first extruder
  let printTemp = 220; // fallback temperature
  if (temperatures.length > firstExtruder) {
    printTemp = temperatures[firstExtruder];
  }

  console.log(`[A1 PrePrint] First extruder: ${firstExtruder}, print temp: ${printTemp}`);

  return `\nG0 E2.2 F800 ; Extrude a little so nozzle is filled for print start you might have to increase this up to E2.5 depending on your filament\nM104 S${printTemp} ; heat up to full temp in first few moves\n`;
}

export function buildA1MPushoffTempSequence(gcode, ctx) {
  // Extract temperatures from GCODE comment
  const temperatureMatch = gcode.match(/;\s*nozzle_temperature\s*=\s*([\d,]+)/i);
  let temperatures = [];
  if (temperatureMatch) {
    temperatures = temperatureMatch[1].split(',').map(t => parseInt(t.trim())).filter(t => !isNaN(t));
  }

  // Extract first extruder from plate JSON if available in sourcePlateText
  let firstExtruder = 0;
  const plateJsonMatch = ctx.sourcePlateText?.match(/"first_extruder"\s*:\s*(\d+)/);
  if (plateJsonMatch) {
    firstExtruder = parseInt(plateJsonMatch[1]);
  }

  // Get the temperature for the first extruder
  let baseTemp = 220; // fallback temperature
  if (temperatures.length > firstExtruder) {
    baseTemp = temperatures[firstExtruder];
  }

  // Calculate cooling temperature (baseTemp - 20)
  const coolingTemp = Math.max(180, baseTemp - 20);

  console.log(`[A1M Pushoff] First extruder: ${firstExtruder}, base temp: ${baseTemp}, cooling temp: ${coolingTemp}`);

  return [
    "M106 P1 S255 ; turn on fan to cool tip of nozzle, prevents oozing",
    `M109 S${coolingTemp} ; wait for warm up but don't fully heat yet to prevent oozing`,
    "G90",
    "M83",
    "M400"
  ].join("\n");
}

export function buildA1MPushoffExtrusionSequence(gcode, ctx) {
  // Extract temperatures from GCODE comment
  const temperatureMatch = gcode.match(/;\s*nozzle_temperature\s*=\s*([\d,]+)/i);
  let temperatures = [];
  if (temperatureMatch) {
    temperatures = temperatureMatch[1].split(',').map(t => parseInt(t.trim())).filter(t => !isNaN(t));
  }

  // Extract first extruder from plate JSON if available in sourcePlateText
  let firstExtruder = 0;
  const plateJsonMatch = ctx.sourcePlateText?.match(/"first_extruder"\s*:\s*(\d+)/);
  if (plateJsonMatch) {
    firstExtruder = parseInt(plateJsonMatch[1]);
  }

  // Get the temperature for the first extruder (full print temperature)
  let printTemp = 220; // fallback temperature
  if (temperatures.length > firstExtruder) {
    printTemp = temperatures[firstExtruder];
  }

  console.log(`[A1M Pushoff Extrusion] First extruder: ${firstExtruder}, print temp: ${printTemp}`);

  return [
    "G0 E1 F800 ;Extrude a little so nozzle is filled for print start you might have to increase this up to E1.3 depending on your filament",
    `M104 S${printTemp} ; heat up to full temp in first few moves`
  ].join("\n");
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

export function bumpFirstThreeExtrusionsX1P1(gcode, plateIndex = -1) {
  const lines = gcode.split(/\r?\n/);
  const reG1 = /^\s*G1\b/i;
  const reX = /\bX[-+]?\d*\.?\d+/i;
  const reY = /\bY[-+]?\d*\.?\d+/i;
  const reE = /\bE([-+]?\d*\.?\d+)/i;
  const reEsub = /\bE[-+]?\d*\.?\d+/i;

  const targetTotalE = 3; // Target total extrusion value
  let foundCount = 0;
  const hitIndices = [];

  // Find the first three extrude commands
  for (let i = 0; i < lines.length && foundCount < 3; i++) {
    const raw = lines[i];
    if (/^\s*;/.test(raw)) continue; // Skip comments
    const code = raw.split(';', 1)[0]; // Remove inline comments
    if (!reG1.test(code)) continue; // Must be G1 command
    if (!reX.test(code) || !reY.test(code)) continue; // Must have X and Y coordinates
    const mE = code.match(reE);
    if (!mE) continue; // Must have E parameter
    const eVal = parseFloat(mE[1]);
    if (!Number.isFinite(eVal) || eVal <= 0) continue; // E value must be positive
    
    hitIndices.push(i);
    foundCount++;
  }

  if (hitIndices.length === 0) return gcode; // No extrude commands found

  // Calculate how to distribute the target E3 value across the found commands
  const distributedE = targetTotalE / hitIndices.length;

  // Modify each found extrude command
  for (const hit of hitIndices) {
    const raw = lines[hit];
    const code = raw.split(';', 1)[0];
    const comment = raw.includes(';') ? raw.substring(raw.indexOf(';')) : '';
    
    const newCode = code.replace(reEsub, `E${distributedE.toFixed(5)}`);
    lines[hit] = newCode + comment;
  }

  return lines.join('\n');
}

export function bumpFirstThreeExtrusionsA1PushOff(gcode, plateIndex = -1) {
  const lines = gcode.split(/\r?\n/);
  const reG1 = /^\s*G1\b/i;
  const reX = /\bX[-+]?\d*\.?\d+/i;
  const reY = /\bY[-+]?\d*\.?\d+/i;
  const reE = /\bE([-+]?\d*\.?\d+)/i;
  const reEsub = /\bE[-+]?\d*\.?\d+/i;

  const extrudeIncrease = 0.5 / 3; // 0.167 per command, total 0.5
  let foundCount = 0;
  const hitIndices = [];

  // Find the first three extrude commands
  for (let i = 0; i < lines.length && foundCount < 3; i++) {
    const raw = lines[i];
    if (/^\s*;/.test(raw)) continue; // Skip comments
    const code = raw.split(';', 1)[0]; // Remove inline comments
    if (!reG1.test(code)) continue; // Must be G1 command
    if (!reX.test(code) || !reY.test(code)) continue; // Must have X and Y coordinates
    const mE = code.match(reE);
    if (!mE) continue; // Must have E parameter
    const eVal = parseFloat(mE[1]);
    if (!Number.isFinite(eVal) || eVal <= 0) continue; // E value must be positive
    
    hitIndices.push(i);
    foundCount++;
  }

  if (hitIndices.length === 0) return gcode; // No extrude commands found

  // Modify each found extrude command
  for (const hit of hitIndices) {
    const raw = lines[hit];
    const code = raw.split(';', 1)[0];
    const comment = raw.includes(';') ? raw.substring(raw.indexOf(';')) : '';
    
    const mE = code.match(reE);
    if (mE) {
      const originalE = parseFloat(mE[1]);
      const newE = originalE + extrudeIncrease;
      const newCode = code.replace(reEsub, `E${newE.toFixed(5)}`);
      lines[hit] = newCode + comment;
    }
  }

  return lines.join('\n');
}

