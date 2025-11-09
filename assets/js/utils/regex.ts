// /src/utils/regex.ts

/** Escapes special characters in a string for use in a RegExp. */
export function _escRe(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}