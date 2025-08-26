// /src/utils/regex.js

export function _escRe(s) { return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"); }