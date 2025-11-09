// /src/utils/time.ts

/** Formatiert Sekunden als "Xd Yh Zm Ws". */
export function secondsToDHMS(sec: number): string {
  const s = Math.max(0, Math.floor(sec));
  const d = Math.floor(s / (3600 * 24));
  const h = Math.floor((s - d * 86400) / 3600);
  const m = Math.floor((s - d * 86400 - h * 3600) / 60);
  const r = s - d * 86400 - h * 3600 - m * 60;
  return (d ? d + "d " : "") + (h ? h + "h " : "") + m + "m " + r + "s ";
}

// Extend Number prototype with toDHMS method
declare global {
  interface Number {
    toDHMS(): string;
  }
}

/** Polyfill für vorhandenen Code, der Number.prototype.toDHMS nutzt. */
if (!Number.prototype.toDHMS) {
  Object.defineProperty(Number.prototype, "toDHMS", {
    value: function (this: number): string {
      return secondsToDHMS(this.valueOf());
    },
    writable: false,
    configurable: false,
    enumerable: false,
  });
}

