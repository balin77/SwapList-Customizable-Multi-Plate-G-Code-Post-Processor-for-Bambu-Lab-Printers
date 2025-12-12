// /src/utils/imageColorMapping.ts

/**
 * Utilities for dynamic plate image color mapping
 * Combines plate_no_light_*.png with lighting effects from plate_*.png
 */

/**
 * RGB color representation
 */
interface RGBColor {
  r: number;
  g: number;
  b: number;
}

/**
 * RGB mapping entry with original color
 */
interface RGBMappingEntry extends RGBColor {
  original: RGBColor;
}

/**
 * Color mapping from old to new colors
 */
export type ColorMapping = Record<string, string>;

/**
 * Extracts lighting information from two images as a hybrid lighting mask.
 * Stores both multiplicative and additive lighting information.
 *
 * @param litImageData - Image with lighting effects
 * @param unlitImageData - Image without lighting effects
 * @returns Lighting mask with R=multiplicative factor, G=additive amount, B=blend mode
 */
function extractLightingMask(litImageData: ImageData, unlitImageData: ImageData): ImageData {
  const canvas = document.createElement('canvas');
  canvas.width = litImageData.width;
  canvas.height = litImageData.height;
  const ctx = canvas.getContext('2d');
  if (!ctx) throw new Error('Could not get 2D context');

  const maskData = ctx.createImageData(canvas.width, canvas.height);

  const lit = litImageData.data;
  const unlit = unlitImageData.data;
  const mask = maskData.data;

  for (let i = 0; i < lit.length; i += 4) {
    // Calculate average brightness for lit and unlit pixels
    const litBrightness = ((lit[i] ?? 0) + (lit[i + 1] ?? 0) + (lit[i + 2] ?? 0)) / 3;
    const unlitBrightness = ((unlit[i] ?? 0) + (unlit[i + 1] ?? 0) + (unlit[i + 2] ?? 0)) / 3;

    // For dark colors (black/near-black), lighting is ADDITIVE (lit = unlit + light)
    // For bright colors, lighting is MULTIPLICATIVE (lit = unlit * factor)

    const DARK_THRESHOLD = 80; // Below this, use additive lighting (increased from 30 to handle dark gray objects)

    if (unlitBrightness < DARK_THRESHOLD) {
      // ADDITIVE lighting for dark colors (e.g., black objects)
      // For dark objects, store the ABSOLUTE brightness from the lit image
      // This way, when recoloring to black, we can apply the lighting as grayscale

      // Store in mask:
      // R channel: Stores the absolute lit brightness (0-255)
      // G channel: not used
      // B channel: 255 (signals this is additive mode for dark colors)

      const absoluteLitBrightness = Math.max(0, Math.min(255, Math.round(litBrightness)));

      mask[i] = absoluteLitBrightness; // Absolute lit brightness
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
 * Replaces colors in the unlit image based on mapping.
 *
 * @param unlitImageData - Base image without lighting
 * @param colorMapping - Map of old hex color -> new hex color
 * @returns Image with replaced colors
 */
function replaceColorsInImage(unlitImageData: ImageData, colorMapping: ColorMapping): ImageData {
  const canvas = document.createElement('canvas');
  canvas.width = unlitImageData.width;
  canvas.height = unlitImageData.height;
  const ctx = canvas.getContext('2d');
  if (!ctx) throw new Error('Could not get 2D context');

  const newImageData = ctx.createImageData(canvas.width, canvas.height);

  const source = unlitImageData.data;
  const target = newImageData.data;

  // Convert color mapping to RGB with tolerance for near-matches
  const rgbMapping: Record<string, RGBMappingEntry> = {};
  for (const [oldHex, newHex] of Object.entries(colorMapping)) {
    const oldRgb = hexToRgb(oldHex);
    const newRgb = hexToRgb(newHex);
    if (oldRgb && newRgb) {
      const oldKey = `${oldRgb.r},${oldRgb.g},${oldRgb.b}`;
      rgbMapping[oldKey] = { ...newRgb, original: oldRgb };
    }
  }

  for (let i = 0; i < source.length; i += 4) {
    const r = source[i];
    const g = source[i + 1];
    const b = source[i + 2];
    const a = source[i + 3];

    // Try exact match first
    const key = `${r},${g},${b}`;
    let newColor: RGBMappingEntry | undefined = rgbMapping[key];

    // If no exact match, try fuzzy matching with adaptive tolerance
    if (!newColor) {
      for (const [_mappedKey, color] of Object.entries(rgbMapping)) {
        const orig = color.original;

        // Adaptive tolerance based on brightness of original color
        // Dark colors (like black) need higher tolerance because:
        // 1. Slicer may use slightly different shades (e.g., RGB(45,45,45) instead of pure black)
        // 2. PNG compression artifacts
        // 3. Shading/gradients in the unlit image
        const origBrightness = (orig.r + orig.g + orig.b) / 3;
        const tolerance = origBrightness < 50 ? 80 : 10; // Very high tolerance for dark colors, low for bright

        if (r !== undefined && g !== undefined && b !== undefined &&
            Math.abs(r - orig.r) <= tolerance &&
            Math.abs(g - orig.g) <= tolerance &&
            Math.abs(b - orig.b) <= tolerance) {
          newColor = color;
          break;
        }
      }
    }

    if (newColor) {
      target[i] = newColor.r;
      target[i + 1] = newColor.g;
      target[i + 2] = newColor.b;
    } else {
      target[i] = r ?? 0;
      target[i + 1] = g ?? 0;
      target[i + 2] = b ?? 0;
    }
    target[i + 3] = a ?? 255;
  }

  return newImageData;
}

/**
 * Applies hybrid lighting mask to recolored image.
 * Supports both multiplicative (for bright colors) and additive (for dark colors) lighting.
 *
 * @param recoloredImageData - Image with new colors
 * @param lightingMask - Hybrid lighting mask (R=mult factor, G=additive, B=mode)
 * @returns Final image with lighting applied
 */
function applyLightingMask(recoloredImageData: ImageData, lightingMask: ImageData): ImageData {
  const canvas = document.createElement('canvas');
  canvas.width = recoloredImageData.width;
  canvas.height = recoloredImageData.height;
  const ctx = canvas.getContext('2d');
  if (!ctx) throw new Error('Could not get 2D context');

  const finalImageData = ctx.createImageData(canvas.width, canvas.height);

  const recolored = recoloredImageData.data;
  const mask = lightingMask.data;
  const final = finalImageData.data;

  let additiveCount = 0;
  let multiplicativeCount = 0;

  for (let i = 0; i < recolored.length; i += 4) {
    const modeFlag = mask[i + 2]; // B channel: 255=additive, 0=multiplicative
    const recoloredBrightness = ((recolored[i] ?? 0) + (recolored[i + 1] ?? 0) + (recolored[i + 2] ?? 0)) / 3;

    if (modeFlag !== undefined && modeFlag > 127) {
      // ADDITIVE mode (for dark/black colors in ORIGINAL image)
      // R channel contains absolute lit brightness from original
      const absoluteLitBrightness = mask[i] ?? 0;
      additiveCount++;

      // If recolored pixel is bright, apply lighting multiplicatively
      if (recoloredBrightness > 80) {
        // For bright recolored pixels, calculate a factor from the lit brightness
        // Normalize brightness to a factor (dim areas ~0.7, bright areas ~1.3)
        const factor = 0.5 + (absoluteLitBrightness / 128); // Maps 0-255 to 0.5-2.5 range

        final[i] = Math.min(255, Math.max(0, Math.round((recolored[i] ?? 0) * factor)));
        final[i + 1] = Math.min(255, Math.max(0, Math.round((recolored[i + 1] ?? 0) * factor)));
        final[i + 2] = Math.min(255, Math.max(0, Math.round((recolored[i + 2] ?? 0) * factor)));
      } else {
        // For dark recolored pixels (especially black), apply lighting as absolute grayscale
        // This makes shadows/lighting visible on black surfaces
        // The absoluteLitBrightness directly represents how bright this pixel should be

        // Apply brightness directly as grayscale (no amplification)
        const amplifiedBrightness = Math.min(255, Math.max(0, Math.round(absoluteLitBrightness * 1.0))); // 1.0x = original brightness

        final[i] = amplifiedBrightness;
        final[i + 1] = amplifiedBrightness;
        final[i + 2] = amplifiedBrightness;
      }
    } else {
      // MULTIPLICATIVE mode (for normal/bright colors)
      // final = recolored * factor
      const brightnessFactor = (mask[i] ?? 0) / 128; // R channel holds multiplicative factor
      multiplicativeCount++;

      final[i] = Math.min(255, Math.max(0, (recolored[i] ?? 0) * brightnessFactor));
      final[i + 1] = Math.min(255, Math.max(0, (recolored[i + 1] ?? 0) * brightnessFactor));
      final[i + 2] = Math.min(255, Math.max(0, (recolored[i + 2] ?? 0) * brightnessFactor));
    }

    final[i + 3] = recolored[i + 3] ?? 255; // Alpha unchanged
  }

  return finalImageData;
}

/**
 * Converts hex color to RGB object.
 *
 * @param hex - Hex color string (#ffffff)
 * @returns RGB object or null if invalid
 *
 * @example
 * ```ts
 * hexToRgb("#ff0000") // { r: 255, g: 0, b: 0 }
 * hexToRgb("invalid") // null
 * ```
 */
function hexToRgb(hex: string): RGBColor | null {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  if (!result || !result[1] || !result[2] || !result[3]) return null;
  return {
    r: parseInt(result[1], 16),
    g: parseInt(result[2], 16),
    b: parseInt(result[3], 16)
  };
}

/**
 * Loads image data from blob URL.
 *
 * @param blobUrl - URL created with URL.createObjectURL
 * @returns Promise resolving to image data
 */
function loadImageDataFromBlob(blobUrl: string): Promise<ImageData> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => {
      const canvas = document.createElement('canvas');
      canvas.width = img.width;
      canvas.height = img.height;
      const ctx = canvas.getContext('2d');
      if (!ctx) {
        reject(new Error('Could not get 2D context'));
        return;
      }
      ctx.drawImage(img, 0, 0);
      const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
      resolve(imageData);
    };
    img.onerror = reject;
    img.src = blobUrl;
  });
}

/**
 * Converts ImageData to blob URL.
 *
 * @param imageData - Image data to convert
 * @returns Promise resolving to blob URL
 */
function imageDataToBlobUrl(imageData: ImageData): Promise<string> {
  const canvas = document.createElement('canvas');
  canvas.width = imageData.width;
  canvas.height = imageData.height;
  const ctx = canvas.getContext('2d');
  if (!ctx) throw new Error('Could not get 2D context');

  ctx.putImageData(imageData, 0, 0);

  return new Promise((resolve) => {
    canvas.toBlob((blob) => {
      if (blob) {
        resolve(URL.createObjectURL(blob));
      } else {
        throw new Error('Failed to create blob');
      }
    });
  });
}

/**
 * Pre-calculates and stores the lighting mask for a plate.
 * This should be called once during initial plate loading.
 *
 * @param litImageUrl - URL of plate_*.png (with lighting)
 * @param unlitImageUrl - URL of plate_no_light_*.png (without lighting)
 * @returns The calculated lighting mask, or null on error
 *
 * @example
 * ```ts
 * const mask = await calculateLightingMask(litUrl, unlitUrl);
 * if (mask) {
 *   // Store mask for later use
 *   plateLightingMasks.set(plateId, mask);
 * }
 * ```
 */
export async function calculateLightingMask(
  litImageUrl: string,
  unlitImageUrl: string
): Promise<ImageData | null> {
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
 * Creates dynamically recolored plate image using a cached shadowmap.
 *
 * Main function that combines color replacement with pre-calculated lighting.
 *
 * @param unlitImageUrl - URL of plate_no_light_*.png (without lighting)
 * @param cachedLightingMask - Pre-calculated lighting mask (shadowmap)
 * @param colorMapping - Map of old hex colors to new hex colors
 * @returns New blob URL with recolored image
 *
 * @example
 * ```ts
 * const newImageUrl = await createRecoloredPlateImage(
 *   unlitUrl,
 *   cachedMask,
 *   { "#000000": "#ff0000", "#ffffff": "#00ff00" }
 * );
 * plateImage.src = newImageUrl;
 * ```
 */
export async function createRecoloredPlateImage(
  unlitImageUrl: string,
  cachedLightingMask: ImageData | null,
  colorMapping: ColorMapping
): Promise<string> {
  try {
    // Load unlit image
    const unlitImageData = await loadImageDataFromBlob(unlitImageUrl);

    // Use cached lighting mask if available
    let lightingMask = cachedLightingMask;

    // If no cached mask is provided, create a neutral multiplicative mask as fallback
    if (!lightingMask) {
      // Create a neutral multiplicative mask as fallback
      const canvas = document.createElement('canvas');
      canvas.width = unlitImageData.width;
      canvas.height = unlitImageData.height;
      const ctx = canvas.getContext('2d');
      if (!ctx) throw new Error('Could not get 2D context');

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
 * Extracts original filament colors from plate metadata.
 *
 * @param plateElement - Plate DOM element with filament data
 * @returns Array of hex colors
 *
 * @example
 * ```ts
 * const colors = extractOriginalFilamentColors(plateElement);
 * // ["#ff0000", "#00ff00", "#0000ff"]
 * ```
 */
export function extractOriginalFilamentColors(plateElement: Element): string[] {
  const colors: string[] = [];
  const filamentRows = plateElement.querySelectorAll('.fl_settings');

  filamentRows.forEach(row => {
    const colorSwatch = row.querySelector('.swatch') as HTMLElement | null;
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
 * Converts RGB color string to hex.
 *
 * @param rgb - RGB color string like "rgb(255, 0, 0)"
 * @returns Hex color string or null
 *
 * @example
 * ```ts
 * rgbToHex("rgb(255, 0, 0)") // "#ff0000"
 * ```
 */
function rgbToHex(rgb: string): string | null {
  const result = rgb.match(/\d+/g);
  if (result && result.length >= 3 && result[0] && result[1] && result[2]) {
    const r = parseInt(result[0]);
    const g = parseInt(result[1]);
    const b = parseInt(result[2]);
    return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
  }
  return null;
}
