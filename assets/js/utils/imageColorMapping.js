// /src/utils/imageColorMapping.js

/**
 * Utilities for dynamic plate image color mapping
 * Combines plate_no_light_*.png with lighting effects from plate_*.png
 */

/**
 * Extracts lighting information from two images as a hybrid lighting mask
 * Stores both multiplicative and additive lighting information
 * @param {ImageData} litImageData - Image with lighting effects
 * @param {ImageData} unlitImageData - Image without lighting effects
 * @returns {ImageData} Lighting mask with R=multiplicative factor, G=additive amount, B=blend mode
 */
function extractLightingMask(litImageData, unlitImageData) {
  const canvas = document.createElement('canvas');
  canvas.width = litImageData.width;
  canvas.height = litImageData.height;
  const ctx = canvas.getContext('2d');
  const maskData = ctx.createImageData(canvas.width, canvas.height);

  const lit = litImageData.data;
  const unlit = unlitImageData.data;
  const mask = maskData.data;

  for (let i = 0; i < lit.length; i += 4) {
    // Calculate average brightness for lit and unlit pixels
    const litBrightness = (lit[i] + lit[i + 1] + lit[i + 2]) / 3;
    const unlitBrightness = (unlit[i] + unlit[i + 1] + unlit[i + 2]) / 3;

    // For dark colors (black/near-black), lighting is ADDITIVE (lit = unlit + light)
    // For bright colors, lighting is MULTIPLICATIVE (lit = unlit * factor)

    const DARK_THRESHOLD = 80; // Below this, use additive lighting (increased from 30 to handle dark gray objects)

    if (unlitBrightness < DARK_THRESHOLD) {
      // ADDITIVE lighting for dark colors (e.g., black objects)
      // lit = unlit + additive_light
      // So: additive_light = lit - unlit
      const additiveDelta = litBrightness - unlitBrightness;

      // Store in mask:
      // R channel: Stores the sign and magnitude of delta
      //   - Values 0-127: negative delta (127 = 0, 0 = -127)
      //   - Values 128-255: positive delta (128 = 0, 255 = +127)
      // G channel: not used for additive (was previously used incorrectly)
      // B channel: 255 (signals this is additive)

      // Encode delta: map from [-127, +127] to [0, 255] with 127 as zero point
      const encodedDelta = Math.max(0, Math.min(255, Math.round(additiveDelta + 127)));

      mask[i] = encodedDelta; // Encoded delta
      mask[i + 1] = 0; // Not used
      mask[i + 2] = 255; // Mode flag: 255 = additive
    } else {
      // MULTIPLICATIVE lighting for normal/bright colors
      // lit = unlit * factor
      const brightnessFactor = litBrightness / unlitBrightness;

      // Store in mask:
      // R channel: multiplicative factor (128 = 1.0, 255 = 2.0, 64 = 0.5)
      // G channel: not used
      // B channel: 0 (signals this is multiplicative)
      const grayValue = Math.min(255, Math.max(0, brightnessFactor * 128));
      mask[i] = grayValue; // Multiplicative factor
      mask[i + 1] = 0; // Not used for multiplicative
      mask[i + 2] = 0; // Mode flag: 0 = multiplicative
    }

    mask[i + 3] = 255; // Alpha
  }

  return maskData;
}

/**
 * Replaces colors in the unlit image based on mapping
 * @param {ImageData} unlitImageData - Base image without lighting
 * @param {Object} colorMapping - Map of old hex color -> new hex color
 * @returns {ImageData} Image with replaced colors
 */
function replaceColorsInImage(unlitImageData, colorMapping) {
  const canvas = document.createElement('canvas');
  canvas.width = unlitImageData.width;
  canvas.height = unlitImageData.height;
  const ctx = canvas.getContext('2d');
  const newImageData = ctx.createImageData(canvas.width, canvas.height);

  const source = unlitImageData.data;
  const target = newImageData.data;

  // Convert color mapping to RGB with tolerance for near-matches
  const rgbMapping = {};
  for (const [oldHex, newHex] of Object.entries(colorMapping)) {
    const oldRgb = hexToRgb(oldHex);
    const newRgb = hexToRgb(newHex);
    if (oldRgb && newRgb) {
      const oldKey = `${oldRgb.r},${oldRgb.g},${oldRgb.b}`;
      rgbMapping[oldKey] = { ...newRgb, original: oldRgb };
      console.log(`[replaceColorsInImage] Mapping: ${oldHex} (${oldKey}) -> ${newHex} (${newRgb.r},${newRgb.g},${newRgb.b})`);
    }
  }

  let exactMatches = 0;
  let fuzzyMatches = 0;
  let noMatches = 0;
  const samplePixels = [];

  for (let i = 0; i < source.length; i += 4) {
    const r = source[i];
    const g = source[i + 1];
    const b = source[i + 2];
    const a = source[i + 3];

    // Try exact match first
    const key = `${r},${g},${b}`;
    let newColor = rgbMapping[key];

    if (newColor) {
      exactMatches++;
      if (exactMatches <= 5) {
        samplePixels.push({ type: 'exact', from: key, to: `${newColor.r},${newColor.g},${newColor.b}` });
      }
    }

    // If no exact match, try fuzzy matching with adaptive tolerance
    if (!newColor) {
      for (const [mappedKey, color] of Object.entries(rgbMapping)) {
        const orig = color.original;

        // Adaptive tolerance based on brightness of original color
        // Dark colors (like black) need higher tolerance because:
        // 1. Slicer may use slightly different shades (e.g., RGB(45,45,45) instead of pure black)
        // 2. PNG compression artifacts
        // 3. Shading/gradients in the unlit image
        const origBrightness = (orig.r + orig.g + orig.b) / 3;
        const tolerance = origBrightness < 50 ? 80 : 10; // Very high tolerance for dark colors, low for bright

        if (Math.abs(r - orig.r) <= tolerance &&
            Math.abs(g - orig.g) <= tolerance &&
            Math.abs(b - orig.b) <= tolerance) {
          newColor = color;
          fuzzyMatches++;
          if (fuzzyMatches <= 5) {
            samplePixels.push({ type: 'fuzzy', from: key, to: `${newColor.r},${newColor.g},${newColor.b}`, tolerance });
          }
          break;
        }
      }
    }

    if (newColor) {
      target[i] = newColor.r;
      target[i + 1] = newColor.g;
      target[i + 2] = newColor.b;
    } else {
      target[i] = r;
      target[i + 1] = g;
      target[i + 2] = b;
      if (a > 0) noMatches++; // Only count non-transparent pixels
    }
    target[i + 3] = a;
  }

  console.log(`[replaceColorsInImage] Stats: ${exactMatches} exact matches, ${fuzzyMatches} fuzzy matches, ${noMatches} no matches (non-transparent)`);
  console.log(`[replaceColorsInImage] Sample pixels:`, samplePixels);

  return newImageData;
}

/**
 * Applies hybrid lighting mask to recolored image
 * Supports both multiplicative (for bright colors) and additive (for dark colors) lighting
 * @param {ImageData} recoloredImageData - Image with new colors
 * @param {ImageData} lightingMask - Hybrid lighting mask (R=mult factor, G=additive, B=mode)
 * @returns {ImageData} Final image with lighting applied
 */
function applyLightingMask(recoloredImageData, lightingMask) {
  const canvas = document.createElement('canvas');
  canvas.width = recoloredImageData.width;
  canvas.height = recoloredImageData.height;
  const ctx = canvas.getContext('2d');
  const finalImageData = ctx.createImageData(canvas.width, canvas.height);

  const recolored = recoloredImageData.data;
  const mask = lightingMask.data;
  const final = finalImageData.data;

  let additiveCount = 0;
  let multiplicativeCount = 0;

  for (let i = 0; i < recolored.length; i += 4) {
    const modeFlag = mask[i + 2]; // B channel: 255=additive, 0=multiplicative

    if (modeFlag > 127) {
      // ADDITIVE mode (for dark/black colors)
      // Decode delta from R channel: map from [0, 255] to [-127, +127] with 127 as zero point
      const encodedDelta = mask[i]; // R channel holds encoded delta
      const additiveDelta = encodedDelta - 127;
      additiveCount++;

      const recoloredBrightness = (recolored[i] + recolored[i + 1] + recolored[i + 2]) / 3;

      // If recolored pixel is bright, we need to convert additive to multiplicative
      if (recoloredBrightness > 80) {
        // For bright colors, convert additive delta to multiplicative factor
        // Original: lit_original = unlit_original + delta
        // We want: lit_new = unlit_new * factor
        //
        // The "darkness" effect should be proportional:
        // If original was darkened by -2 from 26 (factor ~0.92),
        // we want to darken the new color by the same relative amount
        //
        // Approximate factor from delta: factor ≈ 1 + (delta / original_brightness)
        // Since we don't know original brightness here, use a simpler approach:
        // Convert small deltas to multiplicative factors

        const factor = 1 + (additiveDelta / 50); // Scale delta to factor (empirical)

        final[i] = Math.min(255, Math.max(0, Math.round(recolored[i] * factor)));
        final[i + 1] = Math.min(255, Math.max(0, Math.round(recolored[i + 1] * factor)));
        final[i + 2] = Math.min(255, Math.max(0, Math.round(recolored[i + 2] * factor)));
      } else {
        // For dark recolored pixels, keep additive logic
        final[i] = Math.min(255, Math.max(0, Math.round(recolored[i] + additiveDelta)));
        final[i + 1] = Math.min(255, Math.max(0, Math.round(recolored[i + 1] + additiveDelta)));
        final[i + 2] = Math.min(255, Math.max(0, Math.round(recolored[i + 2] + additiveDelta)));
      }
    } else {
      // MULTIPLICATIVE mode (for normal/bright colors)
      // final = recolored * factor
      const brightnessFactor = mask[i] / 128; // R channel holds multiplicative factor
      multiplicativeCount++;

      final[i] = Math.min(255, Math.max(0, recolored[i] * brightnessFactor));
      final[i + 1] = Math.min(255, Math.max(0, recolored[i + 1] * brightnessFactor));
      final[i + 2] = Math.min(255, Math.max(0, recolored[i + 2] * brightnessFactor));
    }

    final[i + 3] = recolored[i + 3]; // Alpha unchanged
  }

  console.log(`[applyLightingMask] Stats: ${additiveCount} additive pixels, ${multiplicativeCount} multiplicative pixels`);

  return finalImageData;
}

/**
 * Converts hex color to RGB object
 * @param {string} hex - Hex color string (#ffffff)
 * @returns {Object|null} {r, g, b} or null if invalid
 */
function hexToRgb(hex) {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result ? {
    r: parseInt(result[1], 16),
    g: parseInt(result[2], 16),
    b: parseInt(result[3], 16)
  } : null;
}

/**
 * Loads image data from blob URL
 * @param {string} blobUrl - URL created with URL.createObjectURL
 * @returns {Promise<ImageData>} Image data
 */
function loadImageDataFromBlob(blobUrl) {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => {
      const canvas = document.createElement('canvas');
      canvas.width = img.width;
      canvas.height = img.height;
      const ctx = canvas.getContext('2d');
      ctx.drawImage(img, 0, 0);
      const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
      resolve(imageData);
    };
    img.onerror = reject;
    img.src = blobUrl;
  });
}

/**
 * Converts ImageData to blob URL
 * @param {ImageData} imageData - Image data to convert
 * @returns {Promise<string>} Blob URL
 */
function imageDataToBlobUrl(imageData) {
  const canvas = document.createElement('canvas');
  canvas.width = imageData.width;
  canvas.height = imageData.height;
  const ctx = canvas.getContext('2d');
  ctx.putImageData(imageData, 0, 0);

  return new Promise((resolve) => {
    canvas.toBlob((blob) => {
      resolve(URL.createObjectURL(blob));
    });
  });
}

/**
 * Pre-calculates and stores the lighting mask for a plate
 * This should be called once during initial plate loading
 * @param {string} litImageUrl - URL of plate_*.png (with lighting)
 * @param {string} unlitImageUrl - URL of plate_no_light_*.png (without lighting)
 * @returns {Promise<ImageData>} The calculated lighting mask
 */
export async function calculateLightingMask(litImageUrl, unlitImageUrl) {
  try {
    // Load both images
    const [litImageData, unlitImageData] = await Promise.all([
      loadImageDataFromBlob(litImageUrl),
      loadImageDataFromBlob(unlitImageUrl)
    ]);

    // Check dimensions match
    if (litImageData.width !== unlitImageData.width ||
        litImageData.height !== unlitImageData.height) {
      throw new Error('Image dimensions do not match');
    }

    // Extract and return lighting mask
    return extractLightingMask(litImageData, unlitImageData);
  } catch (error) {
    console.error('Error calculating lighting mask:', error);
    return null;
  }
}

/**
 * Main function: Creates dynamically recolored plate image using a cached shadowmap
 * @param {string} unlitImageUrl - URL of plate_no_light_*.png (without lighting)
 * @param {ImageData} cachedLightingMask - Pre-calculated lighting mask (shadowmap)
 * @param {Object} colorMapping - Map of old hex colors to new hex colors
 * @returns {Promise<string>} New blob URL with recolored image
 */
export async function createRecoloredPlateImage(unlitImageUrl, cachedLightingMask, colorMapping) {
  try {
    // Load unlit image
    const unlitImageData = await loadImageDataFromBlob(unlitImageUrl);

    // Use cached lighting mask if available
    let lightingMask = cachedLightingMask;

    // If no cached mask is provided, log a warning (shouldn't happen in normal flow)
    if (!lightingMask) {
      console.warn('No cached lighting mask provided, color changes may accumulate incorrectly');
      // Create a neutral multiplicative mask as fallback
      const canvas = document.createElement('canvas');
      canvas.width = unlitImageData.width;
      canvas.height = unlitImageData.height;
      const ctx = canvas.getContext('2d');
      lightingMask = ctx.createImageData(canvas.width, canvas.height);
      for (let i = 0; i < lightingMask.data.length; i += 4) {
        lightingMask.data[i] = 128;     // neutral multiplicative factor (1.0)
        lightingMask.data[i + 1] = 0;   // no additive component
        lightingMask.data[i + 2] = 0;   // mode: multiplicative
        lightingMask.data[i + 3] = 255; // full alpha
      }
    }

    // Replace colors in unlit image
    const recoloredImage = replaceColorsInImage(unlitImageData, colorMapping);

    // Apply lighting mask
    const finalImage = applyLightingMask(recoloredImage, lightingMask);

    // Convert to blob URL
    return await imageDataToBlobUrl(finalImage);

  } catch (error) {
    console.error('Error creating recolored plate image:', error);
    // Fallback: return original unlit image
    return unlitImageUrl;
  }
}

/**
 * Utility: Extract original filament colors from plate metadata
 * @param {Element} plateElement - Plate DOM element with filament data
 * @returns {Array<string>} Array of hex colors
 */
export function extractOriginalFilamentColors(plateElement) {
  const colors = [];
  const filamentRows = plateElement.querySelectorAll('.fl_settings');

  filamentRows.forEach(row => {
    const colorSwatch = row.querySelector('.swatch');
    if (colorSwatch) {
      const bgColor = colorSwatch.style.backgroundColor;
      // Convert RGB to hex if needed
      if (bgColor.startsWith('rgb')) {
        const hex = rgbToHex(bgColor);
        if (hex) colors.push(hex);
      } else if (bgColor.startsWith('#')) {
        colors.push(bgColor);
      }
    }
  });

  return colors;
}

/**
 * Converts RGB color string to hex
 * @param {string} rgb - RGB color string like "rgb(255, 0, 0)"
 * @returns {string|null} Hex color string or null
 */
function rgbToHex(rgb) {
  const result = rgb.match(/\d+/g);
  if (result && result.length >= 3) {
    const r = parseInt(result[0]);
    const g = parseInt(result[1]);
    const b = parseInt(result[2]);
    return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
  }
  return null;
}