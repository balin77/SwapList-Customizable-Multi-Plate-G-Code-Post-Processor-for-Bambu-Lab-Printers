// /src/utils/amsUtils.js

/**
 * Parsed einen Parameter-Blob wie " P0 S3 A" aus M620/M621-Zeilen.
 * - P<p>  = AMS-Device (Standard 0)
 * - S<s>  = Slot (0–255, Standard 255 = "auto"/unspezifiziert)
 * - A     = Flag (true/false)
 */
// Unterstützt: " P0 S3 A", "S3A", "S3 A", nur "S3", mit/ohne P.
export function _parseAmsParams(paramBlob = "") {
  const src = String(paramBlob);

  // P optional (A1M hat i.d.R. keinen P-Parameter)
  const mP = /(?:^|\s)P(\d{1,3})\b/i.exec(src);
  const p = mP ? +mP[1] : 0;

  // S gefolgt von Ziffern — danach darf z.B. "A" direkt kommen (S3A) oder Whitespace/EOL
  const mS = /(?:^|\s)S(\d{1,3})(?=\D|$)/i.exec(src);
  const s = mS ? +mS[1] : 255;   // 255 = unspezifiziert/auto

  // A-Flag: entweder als eigenes Token (" A") oder komprimiert an S dran ("S3A")
  const hasACompact = /S\d+A\b/i.test(src);
  const hasAToken   = /(?:^|\s)A\b/i.test(src);
  const A = hasACompact || hasAToken;

  return { p, s, A };
}
