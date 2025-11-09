// /src/utils/flush.ts

/**
 * Flush volume calculation options
 */
export interface FlushOptions {
  /** Maximum flush volume in mm³ */
  maxFlush?: number;
  /** Minimum flush volume in mm³ */
  minFlush?: number;
}

/**
 * Converts a hex color string to RGB array.
 *
 * @param hex - Hex color string (with or without #)
 * @returns RGB array [r, g, b] where each value is 0-255
 *
 * @example
 * ```ts
 * hexToRgb("#ff0000") // [255, 0, 0]
 * hexToRgb("00ff00")  // [0, 255, 0]
 * hexToRgb("invalid") // [204, 204, 204] (fallback #cccccc)
 * ```
 */
export function hexToRgb(hex: string): [number, number, number] {
  const m = /^#?([0-9a-f]{6})$/i.exec(hex);
  if (!m || !m[1]) return [204, 204, 204]; // Fallback #cccccc
  const int = parseInt(m[1], 16);
  return [(int >> 16) & 255, (int >> 8) & 255, int & 255];
}

/**
 * Calculates the Euclidean distance between two colors in RGB space.
 *
 * @param aHex - First hex color
 * @param bHex - Second hex color
 * @returns Distance value (0 to ~441.67)
 *
 * @example
 * ```ts
 * colorDistance("#000000", "#000000") // 0 (identical)
 * colorDistance("#000000", "#ffffff") // ~441.67 (max distance)
 * ```
 */
export function colorDistance(aHex: string, bHex: string): number {
  const [ar, ag, ab] = hexToRgb(aHex);
  const [br, bg, bb] = hexToRgb(bHex);
  const dr = ar - br, dg = ag - bg, db = ab - bb;
  return Math.sqrt(dr * dr + dg * dg + db * db); // 0 .. ~441.67
}

/**
 * Builds a flush volume matrix from an array of filament colors.
 *
 * Generates a row-major matrix where each cell [i,j] represents the
 * flush volume needed when switching from filament i to filament j.
 * The diagonal is always 0 (no flush needed for same filament).
 *
 * The flush volume is calculated using a heuristic that scales linearly
 * from minFlush to maxFlush based on color distance in RGB space.
 *
 * @param colors - Array of hex color strings
 * @param options - Flush volume calculation options
 * @returns Flat array representing row-major matrix (length = colors.length²)
 *
 * @example
 * ```ts
 * buildFlushVolumesMatrixFromColors(["#000000", "#ffffff"])
 * // Returns [0, 850, 850, 0] for maxFlush=850, minFlush=0
 * // Matrix: [[0, 850], [850, 0]]
 * ```
 */
export function buildFlushVolumesMatrixFromColors(
  colors: string[],
  { maxFlush = 850, minFlush = 0 }: FlushOptions = {}
): number[] {
  const n = colors.length;
  const DMAX = Math.sqrt(3 * 255 * 255); // ~441.6729
  const toFlush = (d: number): number => {
    if (d <= 0) return 0;
    const v = Math.round(minFlush + (maxFlush - minFlush) * (d / DMAX));
    return Math.max(0, Math.min(maxFlush, v));
  };

  const out: number[] = [];
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      const colorI = colors[i];
      const colorJ = colors[j];
      if (colorI && colorJ) {
        out.push(i === j ? 0 : toFlush(colorDistance(colorI, colorJ)));
      } else {
        out.push(0);
      }
    }
  }
  return out;
}

/**
 * Builds a flush volumes vector (2 entries per filament).
 *
 * Each filament gets two entries with the same value (standard = 140mm³).
 * This is used for certain printer configurations that need paired flush values.
 *
 * @param n - Number of filaments
 * @param value - Flush volume value per entry
 * @returns Array of length n*2, filled with the specified value (as strings)
 *
 * @example
 * ```ts
 * buildFlushVolumesVector(3, 140) // ["140", "140", "140", "140", "140", "140"]
 * ```
 */
export function buildFlushVolumesVector(n: number, value: number = 140): string[] {
  return Array(Math.max(0, n * 2)).fill(String(value));
}
