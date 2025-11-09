// /src/utils/colors.ts

/**
 * Converts a color string (hex or rgb/rgba) to hexadecimal format.
 * @param c - Color string (e.g., "#fff", "#ffffff", "rgb(255,255,255)", "rgba(255,255,255,1)")
 * @returns Hexadecimal color string (e.g., "#ffffff")
 */
export function colorToHex(c: string | undefined | null): string {
  // akzeptiert bereits Hex
  if (c && /^#([0-9a-f]{3}|[0-9a-f]{6})$/i.test(c)) return c;
  // rgb(a)
  const m = /rgba?\((\d+),\s*(\d+),\s*(\d+)/i.exec(c || "");
  if (!m || !m[1] || !m[2] || !m[3]) return '#ffffff';
  const to2 = (v: string): string =>
    ('0' + Math.max(0, Math.min(255, +v)).toString(16)).slice(-2);
  return '#' + to2(m[1]) + to2(m[2]) + to2(m[3]);
}