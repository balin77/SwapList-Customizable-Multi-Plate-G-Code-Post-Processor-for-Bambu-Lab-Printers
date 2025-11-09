// /src/constants/constants.ts
// Zentrale Konstanten & Marker

import type { PrinterModel } from '../types/index.js';

export const PRINTER_MODEL_MAP: Record<string, PrinterModel> = {
  "Bambu Lab X1 Carbon": "X1",
  "Bambu Lab X1": "X1",
  "Bambu Lab X1E": "X1",
  "Bambu Lab A1 mini": "A1M",
  "Bambu Lab A1": "A1",
  "Bambu Lab P1S": "P1",
  "Bambu Lab P1P": "P1",
} as const;

export const PUSH_START = ";<<< PUSH_OFF_EXECUTION_START" as const;
export const PUSH_END = ";>>> PUSH_OFF_EXECUTION_END" as const;
