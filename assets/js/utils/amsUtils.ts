// /src/utils/amsUtils.ts

/**
 * Parsed AMS parameter result
 */
export interface AMSParams {
  /** AMS device number (default 0) */
  p: number;
  /** Slot number (0-255, 255 = auto/unspecified) */
  s: number;
  /** A-Flag */
  A: boolean;
}

/**
 * Parses an AMS parameter blob from M620/M621 GCODE lines.
 *
 * Supported formats:
 * - " P0 S3 A"
 * - "S3A"
 * - "S3 A"
 * - "S3"
 * - With or without P parameter
 *
 * @param paramBlob - Parameter string to parse
 * @returns Parsed AMS parameters
 *
 * @example
 * ```ts
 * _parseAmsParams("P0 S3 A") // { p: 0, s: 3, A: true }
 * _parseAmsParams("S3A")     // { p: 0, s: 3, A: true }
 * _parseAmsParams("S3")      // { p: 0, s: 3, A: false }
 * ```
 */
export function _parseAmsParams(paramBlob: string = ""): AMSParams {
  const src = String(paramBlob);

  // P optional (A1M typically has no P parameter)
  const mP = /(?:^|\s)P(\d{1,3})\b/i.exec(src);
  const p = (mP && mP[1]) ? +mP[1] : 0;

  // S followed by digits — can be followed by "A" directly (S3A) or whitespace/EOL
  const mS = /(?:^|\s)S(\d{1,3})(?=\D|$)/i.exec(src);
  const s = (mS && mS[1]) ? +mS[1] : 255;   // 255 = unspecified/auto

  // A-Flag: either as its own token (" A") or compact attached to S ("S3A")
  const hasACompact = /S\d+A\b/i.test(src);
  const hasAToken   = /(?:^|\s)A\b/i.test(src);
  const A = hasACompact || hasAToken;

  return { p, s, A };
}
