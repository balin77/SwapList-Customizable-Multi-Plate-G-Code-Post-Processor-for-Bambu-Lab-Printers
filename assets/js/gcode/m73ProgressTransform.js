// /src/gcode/m73ProgressTransform.js

/**
 * Transforms M73 layer progress (L parameter) from per-plate to global counting
 * @param {Array<string>} gcodeArray - Array of GCODE strings (one per plate)
 * @returns {Array<string>} - Transformed GCODE array with global layer counting
 */
export function transformM73LayerProgressGlobal(gcodeArray) {
  if (!Array.isArray(gcodeArray) || gcodeArray.length === 0) {
    return gcodeArray;
  }

  // First pass: analyze each plate to find max layer count
  const plateLayerCounts = [];
  for (let plateIdx = 0; plateIdx < gcodeArray.length; plateIdx++) {
    const gcode = gcodeArray[plateIdx];
    let maxLayer = 0;

    // Find all M73 L* commands
    const m73LayerPattern = /M73\s+L(\d+)/gi;
    let match;
    while ((match = m73LayerPattern.exec(gcode)) !== null) {
      const layerNum = parseInt(match[1], 10);
      if (!isNaN(layerNum) && layerNum > maxLayer) {
        maxLayer = layerNum;
      }
    }

    plateLayerCounts.push(maxLayer);
  }

  // Calculate cumulative layer offsets for each plate
  const layerOffsets = [0]; // First plate starts at 0
  for (let i = 1; i < plateLayerCounts.length; i++) {
    layerOffsets[i] = layerOffsets[i - 1] + plateLayerCounts[i - 1];
  }

  console.log('[M73 Layer Transform] Plate layer counts:', plateLayerCounts);
  console.log('[M73 Layer Transform] Cumulative offsets:', layerOffsets);

  // Second pass: transform M73 L* commands in each plate
  const transformedGcodeArray = [];
  for (let plateIdx = 0; plateIdx < gcodeArray.length; plateIdx++) {
    const gcode = gcodeArray[plateIdx];
    const offset = layerOffsets[plateIdx];

    // Replace M73 L* commands with global layer numbers
    const transformed = gcode.replace(/M73\s+L(\d+)/gi, (match, layerStr) => {
      const originalLayer = parseInt(layerStr, 10);
      if (isNaN(originalLayer)) {
        return match; // Keep original if parsing fails
      }

      const globalLayer = originalLayer + offset;
      return `M73 L${globalLayer}`;
    });

    transformedGcodeArray.push(transformed);
  }

  console.log('[M73 Layer Transform] Global layer transformation completed');
  return transformedGcodeArray;
}

/**
 * Transforms M73 percentage progress (P and R parameters) from per-plate to global interpolation
 * @param {Array<string>} gcodeArray - Array of GCODE strings (one per plate)
 * @returns {Array<string>} - Transformed GCODE array with global percentage/time
 */
export function transformM73PercentageProgressGlobal(gcodeArray) {
  if (!Array.isArray(gcodeArray) || gcodeArray.length === 0) {
    return gcodeArray;
  }

  // First pass: collect all M73 P* R* entries from all plates
  const plateProgressData = [];
  let totalEstimatedMinutes = 0;

  for (let plateIdx = 0; plateIdx < gcodeArray.length; plateIdx++) {
    const gcode = gcodeArray[plateIdx];
    const progressEntries = [];

    // Find all M73 P* R* commands
    const m73ProgressPattern = /M73\s+P(\d+)\s+R(\d+)/gi;
    let match;
    while ((match = m73ProgressPattern.exec(gcode)) !== null) {
      const percent = parseInt(match[1], 10);
      const remaining = parseInt(match[2], 10);

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
  const timeOffsets = [0];
  for (let i = 1; i < plateProgressData.length; i++) {
    timeOffsets[i] = timeOffsets[i - 1] + plateProgressData[i - 1].estimatedMinutes;
  }

  console.log('[M73 Percentage Transform] Time offsets:', timeOffsets);

  // Second pass: transform M73 P* R* commands
  const transformedGcodeArray = [];
  for (let plateIdx = 0; plateIdx < gcodeArray.length; plateIdx++) {
    const gcode = gcodeArray[plateIdx];
    const plateData = plateProgressData[plateIdx];
    const timeOffset = timeOffsets[plateIdx];
    const plateEstimatedTime = plateData.estimatedMinutes;

    // Replace M73 P* R* commands
    const transformed = gcode.replace(/M73\s+P(\d+)\s+R(\d+)/gi, (match, percentStr, remainingStr) => {
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
