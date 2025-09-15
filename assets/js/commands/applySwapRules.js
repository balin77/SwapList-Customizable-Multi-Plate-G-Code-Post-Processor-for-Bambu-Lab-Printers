// /src/commands/applySwapRules.js

import { splitIntoSections, joinSections, joinSectionsTestMode } from "../gcode/readGcode.js";
import {
  prependBlock,
  insertAfterAnchor,
  insertBeforeAnchor,
  disableBetweenMarkers,
  disableSpecificLinesInRange,
  disableInnerBetweenMarkers,
  removeLinesMatching,
  keepOnlyLastMatching,
} from "../gcode/gcodeManipulation.js";
import { DEV_MODE } from "../index.js";

import {
  bumpFirstExtrusionToE3,
  bumpFirstThreeExtrusionsX1P1,
  bumpFirstThreeExtrusionsA1PushOff,
  buildRaiseBedAfterCooldownPayload,
  buildCooldownFansWaitPayload,
  buildPushOffPayload,
  buildA1NozzleCoolingSequence,
  buildA1PrePrintExtrusion,
  buildA1EndseqCooldown,
  buildA1SafetyClear,
} from "../gcode/buildGcode.js";

import {
  _countPattern,
  _hasAnchor,
  _logRule,
  _ruleActiveWhy,
  resolvePayloadVar,
  _findRange
} from "../gcode/gcodeUtils.js";

import { showWarning } from "../ui/infobox.js";

// ===== Regel-Engine mit Abschnitt-Scopes =====

export function applySwapRulesToGcode(gcode, rules, ctx) {
  let parts = splitIntoSections(gcode);

  // sortiert nach order (default 100)
  const sorted = (rules || []).slice().sort((a, b) => (a.order ?? 100) - (b.order ?? 100));
  console.log(`[SWAP_RULE] plate=${ctx.plateIndex} rules order:`, sorted.map(r => `${r.order ?? 100}:${r.id}`));

  const runOn = (src, rule) => {
    let out = src;
    const scope = rule.scope || "body";
    const extra = { scopeDetails: {} };

    try {
      switch (rule.action) {
        case "remove_lines_matching": {
          const matches = _countPattern(src, rule.pattern, rule.patternFlags || "gm");
          extra.matches = matches;
          out = removeLinesMatching(out, rule.pattern, rule.patternFlags || "gm");
          break;
        }
        case "keep_only_last_matching": {
          const matches = _countPattern(src, rule.pattern, rule.patternFlags || "gm");
          extra.matches = matches;
          out = keepOnlyLastMatching(out, rule.pattern, rule.patternFlags || "gm",
            rule.appendIfMissing || "");
          break;
        }
        case "prepend": {
          let payload = rule.payload || "";
          if (!payload && rule.payloadVar) payload = resolvePayloadVar(rule.payloadVar);
          extra.alreadyInserted = !!(rule.wrapWithMarkers !== false && rule.id && _alreadyInserted(src, rule.id));
          extra.payloadBytes = (payload || "").length;
          out = prependBlock(out, payload, { guardId: rule.id || "", wrapWithMarkers: rule.wrapWithMarkers !== false });
          break;
        }
        case "bump_first_extrusion_to_e3": {
          out = bumpFirstExtrusionToE3(out, ctx.plateIndex ?? -1);
          break;
        }
        case "bump_first_three_extrusions_x1_p1": {
          out = bumpFirstThreeExtrusionsX1P1(out, ctx.plateIndex ?? -1);
          break;
        }
        case "bump_first_three_extrusions_a1_pushoff": {
          out = bumpFirstThreeExtrusionsA1PushOff(out, ctx.plateIndex ?? -1);
          break;
        }
        case "remove_header_block": {
          // Remove header from HEADER_BLOCK_START to CONFIG_BLOCK_END, then add plate marker after EXECUTABLE_BLOCK_START
          const headerStart = out.indexOf('; HEADER_BLOCK_START');
          const configEnd = out.indexOf('; CONFIG_BLOCK_END');
          if (headerStart !== -1 && configEnd !== -1) {
            const afterConfigEnd = configEnd + '; CONFIG_BLOCK_END'.length;
            let nextNewline = out.indexOf('\n', afterConfigEnd);
            if (nextNewline === -1) nextNewline = afterConfigEnd;
            
            // In dev mode, add marker for removed header
            if (DEV_MODE) {
              const removedHeader = out.substring(0, nextNewline);
              const headerMarker = `\n;<<< REMOVED HEADER BLOCK START >>>\n${removedHeader.split('\n').map(line => `; ${line}`).join('\n')}\n;>>> REMOVED HEADER BLOCK END >>>\n`;
              out = headerMarker + out.substring(nextNewline);
            } else {
              // Remove header first
              out = out.substring(nextNewline);
            }
            
            // Find EXECUTABLE_BLOCK_START and add plate marker after it
            const execStart = out.indexOf('; EXECUTABLE_BLOCK_START');
            if (execStart !== -1) {
              const afterExecStart = execStart + '; EXECUTABLE_BLOCK_START'.length;
              let execNewline = out.indexOf('\n', afterExecStart);
              if (execNewline === -1) execNewline = afterExecStart;
              out = out.substring(0, execNewline) + `\n; start printing plate ${ctx.plateIndex + 1}` + out.substring(execNewline);
            } else {
              // Fallback: add at the beginning if EXECUTABLE_BLOCK_START not found
              out = `; start printing plate ${ctx.plateIndex + 1}\n${out}`;
            }
            
            extra.headerRemoved = true;
          } else {
            extra.headerRemoved = false;
            extra.reason = `header markers not found (start=${headerStart}, end=${configEnd})`;
          }
          break;
        }
        case "disable_between": {
          const r = _findRange(out, rule.start, rule.end, !!rule.useRegex);
          extra.rangeFound = r.found;
          out = disableBetweenMarkers(out, rule.start, rule.end, { useRegex: !!rule.useRegex });
          break;
        }
        case "disable_lines": {
          const r = _findRange(out, rule.start, rule.end, !!rule.useRegex);
          extra.rangeFound = r.found;
          extra.lines = (rule.lines || []).length;
          out = disableSpecificLinesInRange(out, rule.start, rule.end, rule.lines || [], { useRegex: !!rule.useRegex });
          break;
        }
        case "disable_inner_between": {
          const r = _findRange(out, rule.start, rule.end, !!rule.useRegex);
          extra.outerRangeFound = r.found;
          extra.innerStartSeen = _countPattern(out, rule.innerStart, rule.innerUseRegex ? "m" : "gm") > 0;
          extra.innerEndSeen = _countPattern(out, rule.innerEnd, rule.innerUseRegex ? "m" : "gm") > 0;
          out = disableInnerBetweenMarkers(out, {
            start: rule.start,
            end: rule.end,
            useRegex: !!rule.useRegex,
            innerStart: rule.innerStart,
            innerEnd: rule.innerEnd,
            innerUseRegex: !!rule.innerUseRegex,
            allPairs: true
          });
          break;
        }
        case "insert_after": {
          let payload = rule.payload || "";
          if (!payload && rule.payloadFnId) payload = resolveDynamicPayload(rule.payloadFnId, out, ctx);
          extra.anchorFound = _hasAnchor(out, rule.anchor, !!rule.useRegex);
          extra.payloadBytes = (payload || "").length;
          const before = out;
          out = insertAfterAnchor(out, rule.anchor, payload, {
            useRegex: !!rule.useRegex,
            occurrence: rule.occurrence || "last",
            guardId: rule.id || "",
            wrapWithMarkers: rule.wrapWithMarkers !== false
          });
          if (out === before) extra.reason = extra.anchorFound ? "guardId_alreadyInserted_or_noChange" : "anchor_not_found";
          break;
        }
        case "insert_before": {
          let payload = rule.payload || "";
          if (!payload && rule.payloadVar) payload = resolvePayloadVar(rule.payloadVar);
          if (!payload && rule.payloadFnId) payload = resolveDynamicPayload(rule.payloadFnId, out, ctx);

          extra.anchorFound = _hasAnchor(out, rule.anchor, !!rule.useRegex);
          extra.payloadBytes = (payload || "").length;

          const beforeS = out;
          out = insertBeforeAnchor(out, rule.anchor, payload, {
            useRegex: !!rule.useRegex,
            occurrence: rule.occurrence || "last",
            guardId: rule.id || "",
            wrapWithMarkers: rule.wrapWithMarkers !== false
          });
          if (out === beforeS) {
            extra.reason = extra.anchorFound
              ? "guardId_alreadyInserted_or_noChange"
              : "anchor_not_found";
          }
          break;
        }

        default:
          extra.note = "unknown_action";
          break;
      }
    } catch (e) {
      extra.error = (e && e.message) ? e.message : String(e);
      console.error("[SWAP_RULE_ERROR]", { id: rule.id, action: rule.action, scope, plate: ctx.plateIndex, error: extra.error });

      // Show warning message in infobox
      const plateNum = (ctx.plateIndex ?? -1) + 1;
      const warningMsg = `SwapRule "${rule.id}" failed on plate ${plateNum}: ${extra.error}`;
      showWarning(warningMsg, 30000); // Show for 30 seconds
    }

    _logRule(rule, ctx, scope, src, out, extra);
    return out;
  };

  for (const rule of sorted) {
    const why = _ruleActiveWhy(rule, ctx);
    if (why !== "active") {
      console.debug("[SWAP_RULE] skipped", { id: rule.id, action: rule.action, plate: ctx.plateIndex, reason: why, scope: rule.scope || "body" });
      continue;
    }

    const scope = (rule.scope || "body");
    if (scope === "all") {
      const wholeBefore = joinSections(parts);
      const wholeAfter = runOn(wholeBefore, rule);
      parts = splitIntoSections(wholeAfter);
    } else if (scope === "header") {
      parts.header = runOn(parts.header, rule);
    } else if (scope === "startseq" || scope === "start" || scope === "start_sequence") {
      parts.startseq = runOn(parts.startseq, rule);
    } else if (scope === "body") {
      parts.body = runOn(parts.body, rule);
    } else if (scope === "endseq" || scope === "end" || scope === "end_sequence") {
      parts.endseq = runOn(parts.endseq, rule);
    } else {
      console.warn("[SWAP_RULE] unknown scope", { id: rule.id, scope, plate: ctx.plateIndex });
    }
  }

  return joinSections(parts);
}

function resolveDynamicPayload(fnId, gcode, ctx) {
  switch (fnId) {
    case "raiseBedAfterCoolDown":
      return buildRaiseBedAfterCooldownPayload(gcode, ctx);
    case "cooldownFansWait":
      return buildCooldownFansWaitPayload(gcode, ctx);
    case "buildPushOffPayload":
      return buildPushOffPayload(gcode, ctx);
    case "a1NozzleCoolingSequence":
      return buildA1NozzleCoolingSequence(gcode, ctx);
    case "a1PrePrintExtrusion":
      return buildA1PrePrintExtrusion(gcode, ctx);
    case "a1EndseqCooldown":
      return buildA1EndseqCooldown(gcode, ctx);
    case "a1SafetyClear":
      return buildA1SafetyClear(gcode, ctx);
    default:
      return "";
  }
}