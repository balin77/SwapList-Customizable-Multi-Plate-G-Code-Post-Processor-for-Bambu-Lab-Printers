// /src/gcode/m73ProgressTransform.ts

/**
 * Progress entry for M73 commands
 */
interface ProgressEntry {
  /** Percentage complete (0-100) */
  percent: number;
  /** Remaining time in minutes */
  remaining: number;
}

/**
 * Plate progress data
 */
interface PlateProgressData {
  /** Progress entries for this plate */
  entries: ProgressEntry[];
  /** Estimated total time for this plate in minutes */
  estimatedMinutes: number;
}

/**
 * Transforms M73 layer progress (L parameter) from per-plate to global counting
 *
 * @param gcodeArray - Array of GCODE strings (one per plate)
 * @returns Transformed GCODE array with global layer counting
 */
export function transformM73LayerProgressGlobal(gcodeArray: string[]): string[] {
  if (!Array.isArray(gcodeArray) || gcodeArray.length === 0) {
    return gcodeArray;
  }

  // First pass: analyze each plate to find min and max layer
  const plateLayerCounts: number[] = [];
  const plateMinLayers: number[] = [];
  for (let plateIdx = 0; plateIdx < gcodeArray.length; plateIdx++) {
    const gcode = gcodeArray[plateIdx];
    if (!gcode) continue;
    let minLayer = Infinity;
    let maxLayer = 0;

    // Find all M73 L* commands
    const m73LayerPattern = /M73\s+L(\d+)/gi;
    let match: RegExpExecArray | null;
    while ((match = m73LayerPattern.exec(gcode)) !== null) {
      const layerCapture = match[1];
      if (typeof layerCapture !== 'string') continue;
      const layerNum = parseInt(layerCapture, 10);
      if (!isNaN(layerNum)) {
        if (layerNum < minLayer) minLayer = layerNum;
        if (layerNum > maxLayer) maxLayer = layerNum;
      }
    }

    // Calculate the number of layers in this plate
    // If layers are 0-127, then count = 127 - 0 + 1 = 128
    // If layers are 1-128, then count = 128 - 1 + 1 = 128
    const layerCount = (minLayer === Infinity) ? 0 : (maxLayer - minLayer + 1);
    plateLayerCounts.push(layerCount);
    plateMinLayers.push(minLayer === Infinity ? 0 : minLayer);

    console.log(`[M73 Layer Transform] Plate ${plateIdx}: layers ${minLayer}-${maxLayer}, count=${layerCount}`);
  }

  // Calculate cumulative layer offsets for each plate
  const layerOffsets: number[] = [0]; // First plate starts at 0
  for (let i = 1; i < plateLayerCounts.length; i++) {
    const prevOffset = layerOffsets[i - 1];
    const prevCount = plateLayerCounts[i - 1];
    if (prevOffset !== undefined && prevCount !== undefined) {
      layerOffsets[i] = prevOffset + prevCount;
    }
  }

  console.log('[M73 Layer Transform] Plate layer counts:', plateLayerCounts);
  console.log('[M73 Layer Transform] Cumulative offsets:', layerOffsets);

  // Second pass: transform M73 L* commands in each plate
  const transformedGcodeArray: string[] = [];
  for (let plateIdx = 0; plateIdx < gcodeArray.length; plateIdx++) {
    const gcode = gcodeArray[plateIdx];
    const offset = layerOffsets[plateIdx];
    const minLayer = plateMinLayers[plateIdx];

    if (gcode === undefined || offset === undefined || minLayer === undefined) {
      transformedGcodeArray.push(gcode || '');
      continue;
    }

    // Replace M73 L* commands with global layer numbers
    // Formula: globalLayer = (originalLayer - minLayer) + offset
    // This normalizes layers to start at 0, then applies the global offset
    const transformed = gcode.replace(/M73\s+L(\d+)/gi, (match, layerStr: string) => {
      const originalLayer = parseInt(layerStr, 10);
      if (isNaN(originalLayer)) {
        return match; // Keep original if parsing fails
      }

      const globalLayer = (originalLayer - minLayer) + offset;
      return `M73 L${globalLayer}`;
    });

    transformedGcodeArray.push(transformed);
  }

  console.log('[M73 Layer Transform] Global layer transformation completed');
  return transformedGcodeArray;
}

/**
 * Transforms M73 percentage progress (P and R parameters) from per-plate to global interpolation
 *
 * @param gcodeArray - Array of GCODE strings (one per plate)
 * @returns Transformed GCODE array with global percentage/time
 */
export function transformM73PercentageProgressGlobal(gcodeArray: string[]): string[] {
  if (!Array.isArray(gcodeArray) || gcodeArray.length === 0) {
    return gcodeArray;
  }

  // First pass: collect all M73 P* R* entries from all plates
  const plateProgressData: PlateProgressData[] = [];
  let totalEstimatedMinutes = 0;

  for (let plateIdx = 0; plateIdx < gcodeArray.length; plateIdx++) {
    const gcode = gcodeArray[plateIdx];
    if (!gcode) continue;
    const progressEntries: ProgressEntry[] = [];

    // Find all M73 P* R* commands
    const m73ProgressPattern = /M73\s+P(\d+)\s+R(\d+)/gi;
    let match: RegExpExecArray | null;
    while ((match = m73ProgressPattern.exec(gcode)) !== null) {
      const percentCapture = match[1];
      const remainingCapture = match[2];
      if (typeof percentCapture !== 'string' || typeof remainingCapture !== 'string') continue;
      const percent = parseInt(percentCapture, 10);
      const remaining = parseInt(remainingCapture, 10);

      if (!isNaN(percent) && !isNaN(remaining)) {
        progressEntries.push({ percent, remaining });
      }
    }

    // Estimate total time for this plate from the first entry (R should be highest at start)
    const plateEstimatedTime = progressEntries.length > 0
      ? Math.max(...progressEntries.map(e => e.remaining))
      : 0;

    plateProgressData.push({
      entries: progressEntries,
      estimatedMinutes: plateEstimatedTime
    });

    totalEstimatedMinutes += plateEstimatedTime;
  }

  console.log('[M73 Percentage Transform] Plate estimated times:', plateProgressData.map(p => p.estimatedMinutes));
  console.log('[M73 Percentage Transform] Total estimated minutes:', totalEstimatedMinutes);

  if (totalEstimatedMinutes === 0) {
    console.log('[M73 Percentage Transform] No time data found, returning original');
    return gcodeArray;
  }

  // Calculate time offsets: cumulative sum of previous plates' estimated times
  const timeOffsets: number[] = [0];
  for (let i = 1; i < plateProgressData.length; i++) {
    const prevOffset = timeOffsets[i - 1];
    const prevData = plateProgressData[i - 1];
    if (prevOffset !== undefined && prevData !== undefined) {
      timeOffsets[i] = prevOffset + prevData.estimatedMinutes;
    }
  }

  console.log('[M73 Percentage Transform] Time offsets:', timeOffsets);

  // Second pass: transform M73 P* R* commands
  const transformedGcodeArray: string[] = [];
  for (let plateIdx = 0; plateIdx < gcodeArray.length; plateIdx++) {
    const gcode = gcodeArray[plateIdx];
    const plateData = plateProgressData[plateIdx];
    const timeOffset = timeOffsets[plateIdx];

    if (gcode === undefined || plateData === undefined || timeOffset === undefined) {
      transformedGcodeArray.push(gcode || '');
      continue;
    }

    const plateEstimatedTime = plateData.estimatedMinutes;

    // Replace M73 P* R* commands
    const transformed = gcode.replace(/M73\s+P(\d+)\s+R(\d+)/gi, (match, percentStr: string, remainingStr: string) => {
      const platePercent = parseInt(percentStr, 10);
      const plateRemaining = parseInt(remainingStr, 10);

      if (isNaN(platePercent) || isNaN(plateRemaining)) {
        return match; // Keep original if parsing fails
      }

      // Calculate elapsed time on current plate
      // If plate is at P%, then (100-P)% remains
      // R is remaining time, so elapsed = estimatedTime - R
      const plateElapsedMinutes = plateEstimatedTime - plateRemaining;

      // Global elapsed = time from previous plates + elapsed on current plate
      const globalElapsedMinutes = timeOffset + plateElapsedMinutes;

      // Global percentage = (globalElapsed / totalEstimatedTime) * 100
      const globalPercent = Math.round((globalElapsedMinutes / totalEstimatedMinutes) * 100);

      // Global remaining = total - globalElapsed
      const globalRemaining = Math.max(0, totalEstimatedMinutes - globalElapsedMinutes);

      return `M73 P${Math.min(100, globalPercent)} R${Math.round(globalRemaining)}`;
    });

    transformedGcodeArray.push(transformed);
  }

  console.log('[M73 Percentage Transform] Global percentage transformation completed');
  return transformedGcodeArray;
}

/**
 * Inserts M73.2 R1.0 command before the first M73 L1 on each plate (starting from plate 2)
 *
 * This command resets the layer counter on Bambu Lab printers, allowing per-plate layer counting.
 * The command is inserted with a newline before and after for proper formatting.
 *
 * @param gcodeArray - Array of GCODE strings (one per plate)
 * @returns Modified GCODE array with M73.2 R1.0 commands inserted
 */
export function insertM73ResetCommands(gcodeArray: string[]): string[] {
  if (!Array.isArray(gcodeArray) || gcodeArray.length === 0) {
    return gcodeArray;
  }

  const modifiedGcodeArray: string[] = [];

  for (let plateIdx = 0; plateIdx < gcodeArray.length; plateIdx++) {
    let gcode = gcodeArray[plateIdx];

    if (gcode === undefined) {
      modifiedGcodeArray.push('');
      continue;
    }

    // Only insert M73.2 R1.0 for plates after the first one (plateIdx >= 1)
    if (plateIdx >= 1) {
      // Find the first occurrence of M73 L1 (not L10, L11, etc., just L1)
      const m73L1Pattern = /M73\s+L1(?:\s|$)/i;
      const match = m73L1Pattern.exec(gcode);

      if (match && match.index !== undefined) {
        // Insert M73.2 R1.0 before the first M73 L1 command
        const insertPosition = match.index;
        const beforeM73L1 = gcode.substring(0, insertPosition);
        const fromM73L1 = gcode.substring(insertPosition);

        // Insert with newline before and after
        gcode = beforeM73L1 + '\nM73.2 R1.0\n' + fromM73L1;

        console.log(`[M73.2 Reset] Inserted M73.2 R1.0 before first M73 L1 on plate ${plateIdx + 1}`);
      } else {
        console.log(`[M73.2 Reset] Warning: No M73 L1 found on plate ${plateIdx + 1}, skipping M73.2 R1.0 insertion`);
      }
    }

    modifiedGcodeArray.push(gcode);
  }

  console.log('[M73.2 Reset] M73.2 R1.0 insertion completed');
  return modifiedGcodeArray;
}

/**
 * Calculates the maximum global layer index across all plates
 *
 * This function assumes the GCODE has already been transformed with global layer numbers
 *
 * @param gcodeArray - Array of GCODE strings (one per plate)
 * @returns Maximum layer index (0-based), e.g., 1279 for 1280 layers
 */
export function calculateTotalGlobalLayers(gcodeArray: string[]): number {
  if (!Array.isArray(gcodeArray) || gcodeArray.length === 0) {
    return 0;
  }

  // Find the maximum layer number across ALL plates
  // Since layers are already globally numbered after transformM73LayerProgressGlobal(),
  // we just need to find the highest layer index
  let globalMaxLayer = 0;

  for (let plateIdx = 0; plateIdx < gcodeArray.length; plateIdx++) {
    const gcode = gcodeArray[plateIdx];
    if (!gcode) continue;

    // Find all M73 L* commands
    const m73LayerPattern = /M73\s+L(\d+)/gi;
    let match: RegExpExecArray | null;
    while ((match = m73LayerPattern.exec(gcode)) !== null) {
      const layerCapture = match[1];
      if (typeof layerCapture !== 'string') continue;
      const layerNum = parseInt(layerCapture, 10);
      if (!isNaN(layerNum) && layerNum > globalMaxLayer) {
        globalMaxLayer = layerNum;
      }
    }
  }

  // Return the maximum layer index (0-based)
  // Example: if globalMaxLayer = 1279, that means layers 0-1279 (1280 total layers)
  console.log(`[Layer Count] Global max layer index: ${globalMaxLayer} (total: ${globalMaxLayer + 1} layers)`);
  return globalMaxLayer;
}

/**
 * Updates the "; total layer number: X" header line in GCODE with the global total
 *
 * @param gcode - GCODE string with header
 * @param totalLayers - Total number of layers (1-based count)
 * @returns Modified GCODE with updated header
 */
export function updateTotalLayerNumberHeader(gcode: string, totalLayers: number): string {
  // Pattern matches "; total layer number: <number>"
  const pattern = /^(;\s*total\s+layer\s+number:\s*)\d+$/im;

  const match = pattern.exec(gcode);
  if (match) {
    const updated = gcode.replace(pattern, `$1${totalLayers}`);
    console.log(`[Header Update] Updated "total layer number" from original value to ${totalLayers}`);
    return updated;
  }

  console.log('[Header Update] No "total layer number" header line found, skipping update');
  return gcode;
}
