// /src/utils/colorToHex.js

export function colorToHex(c) {
  // akzeptiert bereits Hex
  if (/^#([0-9a-f]{3}|[0-9a-f]{6})$/i.test(c)) return c;
  // rgb(a)
  const m = /rgba?\((\d+),\s*(\d+),\s*(\d+)/i.exec(c || "");
  if (!m) return '#ffffff';
  const to2 = v => ('0' + Math.max(0, Math.min(255, +v)).toString(16)).slice(-2);
  return '#' + to2(m[1]) + to2(m[2]) + to2(m[3]);
}