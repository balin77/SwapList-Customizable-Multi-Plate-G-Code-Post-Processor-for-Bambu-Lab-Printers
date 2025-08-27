// /src/utils/flush.js
export function hexToRgb(hex) {
    const m = /^#?([0-9a-f]{6})$/i.exec(hex);
    if (!m) return [204, 204, 204]; // Fallback #cccccc
    const int = parseInt(m[1], 16);
    return [(int >> 16) & 255, (int >> 8) & 255, int & 255];
  }
  
  export function colorDistance(aHex, bHex) {
    const [ar, ag, ab] = hexToRgb(aHex);
    const [br, bg, bb] = hexToRgb(bHex);
    const dr = ar - br, dg = ag - bg, db = ab - bb;
    return Math.sqrt(dr*dr + dg*dg + db*db); // 0 .. ~441.67
  }
  
  /**
   * Erzeuge Flush-Matrix (row-major, als flache Liste) aus Farben.
   * Heuristik: linear auf [0..maxFlush] skaliert, Diagonale 0.
   */
  export function buildFlushVolumesMatrixFromColors(colors, {maxFlush = 850, minFlush = 0} = {}) {
    const n = colors.length;
    const DMAX = Math.sqrt(3 * 255 * 255); // ~441.6729
    const toFlush = (d) => {
      if (d <= 0) return 0;
      const v = Math.round(minFlush + (maxFlush - minFlush) * (d / DMAX));
      return Math.max(0, Math.min(maxFlush, v));
    };
  
    const out = [];
    for (let i = 0; i < n; i++) {
      for (let j = 0; j < n; j++) {
        out.push(i === j ? 0 : toFlush(colorDistance(colors[i], colors[j])));
      }
    }
    return out;
  }
  
  /** 2× pro Filament, Standard 140 */
  export function buildFlushVolumesVector(n, value = 140) {
    return Array(Math.max(0, n*2)).fill(String(value));
  }
  