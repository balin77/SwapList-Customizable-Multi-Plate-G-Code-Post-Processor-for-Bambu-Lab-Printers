// /src/utils/imageColorMapping.js

/**
 * Utilities for dynamic plate image color mapping
 * Combines plate_no_light_*.png with lighting effects from plate_*.png
 */

/**
 * Extracts lighting information from two images as a grayscale brightness mask
 * @param {ImageData} litImageData - Image with lighting effects
 * @param {ImageData} unlitImageData - Image without lighting effects
 * @returns {ImageData} Grayscale lighting mask data (brightness only)
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

    // Calculate lighting factor based on brightness only
    // Avoid division by zero
    const brightnessFactor = unlitBrightness > 0 ? litBrightness / unlitBrightness : 1;

    // Store as grayscale value (same for R, G, B channels)
    // Factor 1.0 = 128, Factor 2.0 = 255, Factor 0.5 = 64
    const grayValue = Math.min(255, Math.max(0, brightnessFactor * 128));
    mask[i] = grayValue;
    mask[i + 1] = grayValue;
    mask[i + 2] = grayValue;
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

  // Convert color mapping to RGB
  const rgbMapping = {};
  for (const [oldHex, newHex] of Object.entries(colorMapping)) {
    const oldRgb = hexToRgb(oldHex);
    const newRgb = hexToRgb(newHex);
    if (oldRgb && newRgb) {
      const oldKey = `${oldRgb.r},${oldRgb.g},${oldRgb.b}`;
      rgbMapping[oldKey] = newRgb;
    }
  }

  for (let i = 0; i < source.length; i += 4) {
    const r = source[i];
    const g = source[i + 1];
    const b = source[i + 2];
    const a = source[i + 3];

    const key = `${r},${g},${b}`;
    const newColor = rgbMapping[key];

    if (newColor) {
      target[i] = newColor.r;
      target[i + 1] = newColor.g;
      target[i + 2] = newColor.b;
    } else {
      target[i] = r;
      target[i + 1] = g;
      target[i + 2] = b;
    }
    target[i + 3] = a;
  }

  return newImageData;
}

/**
 * Applies grayscale lighting mask to recolored image
 * @param {ImageData} recoloredImageData - Image with new colors
 * @param {ImageData} lightingMask - Grayscale lighting information (brightness only)
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

  for (let i = 0; i < recolored.length; i += 4) {
    // Get grayscale brightness factor (same for all channels)
    // Convert mask value back to factor (128 = 1.0)
    const brightnessFactor = mask[i] / 128;

    // Apply same brightness factor to all RGB channels
    final[i] = Math.min(255, Math.max(0, recolored[i] * brightnessFactor));
    final[i + 1] = Math.min(255, Math.max(0, recolored[i + 1] * brightnessFactor));
    final[i + 2] = Math.min(255, Math.max(0, recolored[i + 2] * brightnessFactor));
    final[i + 3] = recolored[i + 3]; // Alpha unchanged
  }

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
      // Create a neutral mask as fallback
      const canvas = document.createElement('canvas');
      canvas.width = unlitImageData.width;
      canvas.height = unlitImageData.height;
      const ctx = canvas.getContext('2d');
      lightingMask = ctx.createImageData(canvas.width, canvas.height);
      for (let i = 0; i < lightingMask.data.length; i += 4) {
        lightingMask.data[i] = 128;     // neutral red factor
        lightingMask.data[i + 1] = 128; // neutral green factor
        lightingMask.data[i + 2] = 128; // neutral blue factor
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