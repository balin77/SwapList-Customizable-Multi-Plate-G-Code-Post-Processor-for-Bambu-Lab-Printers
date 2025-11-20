/**
 * Filament colors module for managing slot colors and AMS slot assignments
 */

import { state } from "../config/state.js";
import { update_statistics } from "../ui/statistics.js";
import { PRESET_INDEX } from "../config/filamentConfig/registry-generated.js";
import { createRecoloredPlateImage } from "../utils/imageColorMapping.js";
import { showWarning } from "./infobox.js";

// Internal slot structure
interface SlotData {
  color?: string;
  manual?: boolean;
  conflict?: boolean;
  meta?: {
    type?: string;
    vendor?: string;
  };
}

interface P0Device {
  slots: SlotData[];
}

/**
 * Helper function to calculate luminance and determine contrasting background
 */
function getContrastingBackground(hexColor: string): string {
  // Convert hex to RGB
  const hex = hexColor.replace('#', '');
  const r = parseInt(hex.substr(0, 2), 16);
  const g = parseInt(hex.substr(2, 2), 16);
  const b = parseInt(hex.substr(4, 2), 16);

  // Calculate relative luminance (WCAG formula)
  const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;

  // Only black or white background based on luminance
  if (luminance > 0.5) {
    // Light color - use black background
    return '#000000';
  } else {
    // Dark color - use white background
    return '#ffffff';
  }
}

/**
 * Ensure P0 device structure exists in state
 */
function ensureP0(): P0Device {
  if (!state.P0) (state as any).P0 = {} as P0Device;
  if (!(state as any).P0.slots) (state as any).P0.slots = Array(32).fill(null).map(() => ({}));
  return (state as any).P0 as P0Device;
}

/**
 * Convert any color format to hex
 */
function toHexAny(color: string | undefined): string {
  if (!color) return "#cccccc";
  if (color.startsWith("#")) return color;
  const m = color.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)/);
  if (!m) return "#cccccc";
  return "#" + m.slice(1).map(x => (+x).toString(16).padStart(2, "0")).join("");
}

/**
 * Lookup vendor by filament_id (tray_info_idx) in registry
 */
function lookupVendorByFilamentId(filamentId: string): string {
  if (!filamentId) {
    console.log("[lookupVendor] No filamentId provided");
    return "Unknown";
  }

  // Search in PRESET_INDEX for matching filament_id in settings object
  const entry = (PRESET_INDEX || []).find(e => e.settings?.filament_id === filamentId);

  console.log(`[lookupVendor] Searching for filament_id="${filamentId}":`, entry ? `Found vendor="${entry.vendor}"` : "Not found");

  return entry?.vendor || "Unknown";
}

/**
 * Get hex color from a swatch element
 */
function getSwatchHex(swatch: HTMLElement | null): string | null {
  if (!swatch) return null;
  // First try to get original color from dataset
  if (swatch.dataset['f_color']) return swatch.dataset['f_color'];
  // Otherwise try to get from style
  return toHexAny(swatch.style.backgroundColor);
}

// Default slot colors (up to 32 slots)
const DEFAULT_SLOT_COLORS = Array(32).fill("#cccccc");

/**
 * Update all plate swatch colors based on current slot assignments
 */
export function updateAllPlateSwatchColors(): void {
  const list = document.getElementById("playlist_ol");
  if (!list) return;

  Array.from(list.querySelectorAll<HTMLElement>("li.list_item .p_filaments .p_filament")).forEach(row => {
    const sw = row.querySelector<HTMLElement>(".f_color");
    const slotSpan = row.querySelector<HTMLElement>(".f_slot");
    if (!sw || !slotSpan) return;

    const slot1 = parseInt(slotSpan.textContent?.trim() || "1", 10) || 1;
    const idx = Math.max(0, Math.min(31, slot1 - 1));

    // Store original color in dataset if not already present
    if (!sw.dataset['f_color'] && sw.style.backgroundColor) {
      sw.dataset['f_color'] = toHexAny(sw.style.backgroundColor);
    }

    // Set slot index and current color
    sw.dataset['slotIndex'] = String(idx);
    const currentColor = getSlotColor(idx);
    sw.style.backgroundColor = currentColor;
    sw.style.background = currentColor;
  });
}

/**
 * Set global slot color (for statistics slots)
 */
export function setGlobalSlotColor(sIndex: number, hex: string): void {
  if (sIndex < 0 || sIndex >= 32) return;
  const p0 = ensureP0();
  if (!p0.slots) p0.slots = [];
  if (!p0.slots[sIndex]) p0.slots[sIndex] = {};
  p0.slots[sIndex].color = hex;
  p0.slots[sIndex].manual = true; // Mark as manually changed

  // Auto-enable OVERRIDE_METADATA when color is manually changed
  import('../config/state.js').then(({ state }) => {
    if (!state.OVERRIDE_METADATA) {
      state.OVERRIDE_METADATA = true;
      const checkbox = document.getElementById("opt_override_metadata") as HTMLInputElement | null;
      if (checkbox) checkbox.checked = true;
      console.log("Auto-enabled OVERRIDE_METADATA due to manual color change");
    }
  });

  // Update UI - important: both calls!
  renderTotalsColors();
  updateAllPlateSwatchColors();
}

/**
 * Get global slot color by index
 */
export function getSlotColor(sIndex: number): string {
  const sl = ensureP0().slots[sIndex];
  return (sl && sl.color) || DEFAULT_SLOT_COLORS[sIndex] || "#cccccc";
}

/**
 * Derive global slot colors from plates
 * Scans all plates and sets P0 slot colors to the FIRST found filament color per slot
 */
export function deriveGlobalSlotColorsFromPlates(): void {
  const dev = ensureP0();

  const derived: (string | null)[] = Array(32).fill(null);
  const slotColorConflicts = new Map<number, Set<string>>(); // Track conflicts: slot -> [color1, color2, ...]

  const list = document.getElementById("playlist_ol");
  if (list) {
    Array.from(list.querySelectorAll<HTMLElement>("li.list_item .p_filament")).forEach(row => {
      const slotSpan = row.querySelector<HTMLElement>(".f_slot");
      const sw = row.querySelector<HTMLElement>(".f_color");
      if (!slotSpan || !sw) return;

      const slot1 = parseInt(slotSpan.textContent?.trim() || "0", 10);
      const idx = slot1 - 1;
      if (idx < 0 || idx > 31) return;

      const hex = getSwatchHex(sw);
      if (!hex) return;

      // Track all colors found for each slot
      if (!slotColorConflicts.has(idx)) {
        slotColorConflicts.set(idx, new Set());
      }
      slotColorConflicts.get(idx)!.add(hex);

      if (!derived[idx]) derived[idx] = hex; // "first wins"
    });
  }

  // Check for color conflicts and show warning
  checkForSlotColorConflicts(slotColorConflicts);

  for (let i = 0; i < 32; i++) {
    const sl = dev.slots[i];
    if (sl?.manual) continue; // don't overwrite manual overrides
    if (sl) {
      sl.color = derived[i] || DEFAULT_SLOT_COLORS[i];
      sl.conflict = false;
    }
  }

  renderTotalsColors();
}

// Debounce mechanism to prevent multiple warnings
let _conflictWarningTimeout: ReturnType<typeof setTimeout> | null = null;
let _lastConflictHash: string | null = null;

/**
 * Checks for color conflicts between plates for the same slots and shows warnings
 */
function checkForSlotColorConflicts(slotColorConflicts: Map<number, Set<string>>): void {
  const conflictedSlots: Array<{ slot: number; colors: string[] }> = [];

  slotColorConflicts.forEach((colors, slotIndex) => {
    if (colors.size > 1) {
      conflictedSlots.push({
        slot: slotIndex + 1, // Convert to 1-based slot number
        colors: Array.from(colors).sort() // Sort for consistent hashing
      });
    }
  });

  if (conflictedSlots.length > 0) {
    // Create a hash of the current conflicts to avoid duplicate warnings
    const conflictHash = JSON.stringify(conflictedSlots);

    if (conflictHash === _lastConflictHash) {
      return; // Same conflicts already shown
    }

    // Clear any pending warning
    if (_conflictWarningTimeout) {
      clearTimeout(_conflictWarningTimeout);
    }

    // Debounce the warning display
    _conflictWarningTimeout = setTimeout(() => {
      _lastConflictHash = conflictHash;

      const conflictMessages = conflictedSlots.map(conflict => {
        const colorList = conflict.colors.map(color => {
          const backgroundColor = getContrastingBackground(color);
          return `<span style="color: ${color}; background-color: ${backgroundColor}; padding: 2px 6px; border-radius: 4px; font-weight: bold; border: 1px solid ${color};">${color}</span>`;
        }).join(', ');
        return `Slot ${conflict.slot}: ${colorList}`;
      }).join('<br>');

      const message = `⚠️ Color conflicts detected! Multiple plates use different colors for the same slots:<br><br>${conflictMessages}<br><br>The slot colors will be adjusted to match the first loaded plate.`;

      // Show as warning with 20 second auto-hide and HTML enabled
      showWarning(message, 20000, true);

      // Ensure PNG images are updated with the correct colors after conflict resolution
      setTimeout(() => {
        updateAllPlateImages();
      }, 100);
    }, 200); // 200ms debounce
  } else {
    // No conflicts - clear the last hash
    _lastConflictHash = null;
  }
}

/**
 * Auto-enable Override Metadata when slot changes occur
 */
export function autoEnableOverrideMetadata(): void {
  import('../config/state.js').then(({ state }) => {
    if (!state.OVERRIDE_METADATA) {
      state.OVERRIDE_METADATA = true;
      const checkbox = document.getElementById("opt_override_metadata") as HTMLInputElement | null;
      if (checkbox) checkbox.checked = true;
      console.log("Auto-enabled OVERRIDE_METADATA due to slot change");
    }
  });
}

/**
 * Check if Override Metadata should be auto-disabled
 */
export function checkAutoDisableOverrideMetadata(): void {
  // DISABLED: Override will no longer be automatically deactivated
  // The user must manually deactivate it if desired
  console.log("checkAutoDisableOverrideMetadata: Auto-disable is disabled - user must manually toggle override");
}

/**
 * Check if Override Metadata should be auto-toggled based on slot modifications
 */
export function checkAutoToggleOverrideMetadata(): void {
  // Check if there are currently any slots deviating from their original values
  const hasAnyModifiedSlots = hasModifiedSlotsInAnyPlate();
  console.log('checkAutoToggleOverrideMetadata: hasModifiedSlots =', hasAnyModifiedSlots);

  import('../config/state.js').then(({ state }) => {
    console.log('Current OVERRIDE_METADATA state:', state.OVERRIDE_METADATA);
    if (hasAnyModifiedSlots && !state.OVERRIDE_METADATA) {
      // Enable when modified slots are found
      state.OVERRIDE_METADATA = true;
      const checkbox = document.getElementById("opt_override_metadata") as HTMLInputElement | null;
      if (checkbox) checkbox.checked = true;
      console.log("Auto-enabled OVERRIDE_METADATA due to slot change");
    } else {
      // IMPORTANT: Override is NOT automatically deactivated, even if no modified slots remain
      // The user must manually deactivate it if desired
      console.log('No OVERRIDE_METADATA change - stays at current state');
    }
  });
}

/**
 * Check if any plate has modified slots
 */
function hasModifiedSlotsInAnyPlate(): boolean {
  const plates = Array.from(document.querySelectorAll<HTMLElement>("#playlist_ol li.list_item"));
  console.log('Checking', plates.length, 'plates for modified slots');

  for (const plate of plates) {
    // Only check active plates (Repeats > 0)
    const repInput = plate.querySelector<HTMLInputElement>(".p_rep");
    const reps = parseFloat(repInput?.value || "0");
    if (reps <= 0) continue;

    // Check slots in this plate
    const slots = Array.from(plate.querySelectorAll<HTMLElement>(".p_filament .f_slot"));
    for (const slot of slots) {
      const originalSlot = parseInt(slot.dataset['origSlot'] || "0", 10);
      const currentSlot = parseInt((slot.textContent || "").trim() || "0", 10);

      // If original slot exists and differs from current
      if (originalSlot > 0 && currentSlot > 0 && originalSlot !== currentSlot) {
        return true;
      }
    }
  }

  return false;
}

/**
 * Get all unique slots used in a specific plate (by index)
 */
function getSlotsUsedInPlate(plateElement: HTMLElement): Set<number> {
  const slots = new Set<number>();
  const slotElements = Array.from(plateElement.querySelectorAll<HTMLElement>(".p_filament .f_slot"));

  for (const slotEl of slotElements) {
    const slotNum = parseInt((slotEl.textContent || "").trim() || "0", 10);
    if (slotNum > 0) {
      slots.add(slotNum);
    }
  }

  return slots;
}

/**
 * Check if removing a specific plate would leave any slots orphaned
 */
export function hasOrphanedSlotsAfterRemoval(plateToRemove: HTMLElement): boolean {
  // Get all slots used in the plate to be removed
  const removedSlots = getSlotsUsedInPlate(plateToRemove);

  if (removedSlots.size === 0) {
    return false; // No slots used in removed plate
  }

  // Get all remaining plates (excluding the one to be removed)
  const allPlates = Array.from(document.querySelectorAll<HTMLElement>("#playlist_ol li.list_item:not(.hidden)"));
  const remainingSlots = new Set<number>();

  for (const plate of allPlates) {
    if (plate === plateToRemove) continue; // Skip the plate to be removed

    const plateSlots = getSlotsUsedInPlate(plate);
    plateSlots.forEach(slot => remainingSlots.add(slot));
  }

  // Check if any slot from removed plate is not in remaining plates
  for (const slot of removedSlots) {
    if (!remainingSlots.has(slot)) {
      console.log(`Orphaned slot detected: Slot ${slot} will not be used in any remaining plate`);
      return true;
    }
  }

  return false;
}

/**
 * Apply slot selection to a plate row
 */
export function applySlotSelectionToPlate(anchorEl: HTMLElement, newIndex: number): void {
  const row = anchorEl.closest<HTMLElement>(".p_filament");
  if (!row) return;

  // Update only this row
  const slotSpan = row.querySelector<HTMLElement>(".f_slot");
  if (slotSpan) slotSpan.textContent = String(newIndex + 1);

  // Display swatch color from global slot colors
  anchorEl.dataset['slotIndex'] = String(newIndex);
  const hex = getSlotColor(newIndex);
  anchorEl.style.background = hex;

  // IMPORTANT: Do NOT set dataset.f_color (original color remains preserved)!

  // Prevent global slot color derivation during slot reassignment
  _skipColorDerivation = true;

  // Rebate m/g in statistics to the new slot
  update_statistics();

  // Auto-enable/disable Override metadata based on slot changes
  checkAutoToggleOverrideMetadata();

  // Update plate image colors when slot assignment changes
  updatePlateImageColors(row.closest<HTMLElement>('li.list_item'));

  // Reset flag after a short delay to allow other operations
  setTimeout(() => {
    _skipColorDerivation = false;
  }, 100);
}

// Dropdown menu state
let _openMenu: HTMLDivElement | null = null;
let _openAnchor: HTMLElement | null = null;
let _justClosed = false;

/**
 * Close the currently open slot dropdown menu
 */
function closeMenu(): void {
  if (_openMenu) { _openMenu.remove(); _openMenu = null; _openAnchor = null; }
  _justClosed = true;
  setTimeout(() => { _justClosed = false; }, 0); // swallow immediate re-open in same click
}

/**
 * Open slot dropdown menu for selecting slot assignments
 */
export function openSlotDropdown(anchorEl: HTMLElement): void {
  if (_justClosed) return; // ignore click that just closed the menu
  // Toggle: click on same swatch closes it again
  if (_openMenu && _openAnchor === anchorEl) { closeMenu(); return; }
  closeMenu(); _openAnchor = anchorEl;

  const cur = +(anchorEl.dataset['slotIndex'] || 0);
  const menu = document.createElement("div");
  menu.className = "slot-dropdown";
  menu.setAttribute("data-role", "slot-dropdown");

  // Get used slots from statistics (only show slots that are actually displayed in statistics)
  const usedSlots = getUsedSlotsFromStatistics();

  // Show only the slots that are displayed in statistics
  for (const slotIndex of usedSlots) {
    const item = document.createElement("div");
    item.className = "slot-dropdown-item";
    item.dataset['slotIndex'] = String(slotIndex);

    const dot = document.createElement("span");
    dot.className = "dot";
    dot.style.background = getSlotColor(slotIndex); // Slot color (derived from plates)

    const lab = document.createElement("span");
    lab.textContent = `Slot ${slotIndex + 1}`;

    if (slotIndex === cur) item.classList.add("current");
    item.append(dot, lab);
    item.addEventListener("click", () => { applySlotSelectionToPlate(anchorEl, slotIndex); closeMenu(); });
    menu.appendChild(item);
  }

  // Add separator and "Add New Slot" option only if:
  // 1. We can add more slots (< 32)
  // 2. All current slots are used
  const currentSlotCount = usedSlots.length;
  if (currentSlotCount < 32) {
    // Check if all current slots are actually used
    const allSlotsUsed = areAllSlotsUsed(currentSlotCount);

    if (allSlotsUsed) {
      const sep = document.createElement("div");
      sep.className = "slot-dropdown-sep";
      menu.appendChild(sep);

      // Add "Add New Slot" option
      const addItem = document.createElement("div");
      addItem.className = "slot-dropdown-item slot-dropdown-more";
      addItem.innerHTML = "+ Add new slot";
      addItem.title = "Add 4 more slots";
      addItem.addEventListener("click", () => {
        expandSlotsFromDropdown();
        closeMenu();
      });
      menu.appendChild(addItem);
    }
  }

  document.body.appendChild(menu);
  const r = anchorEl.getBoundingClientRect();
  menu.style.left = `${window.scrollX + r.left}px`;
  menu.style.top = `${window.scrollY + r.bottom + 6}px`;

  setTimeout(() => {
    document.addEventListener("mousedown", (ev: MouseEvent) => {
      if (!_openMenu) return;
      if (!_openMenu.contains(ev.target as Node)) closeMenu();
    }, { once: true });
  }, 0);

  _openMenu = menu;
}

/**
 * Get max used slot across all plates
 */
// @ts-expect-error - function reserved for future use
function getMaxUsedSlot(): number {
  let max = 4;
  const list = document.getElementById("playlist_ol");
  if (list) {
    Array.from(list.querySelectorAll<HTMLElement>("li.list_item .p_filament .f_slot")).forEach(slotSpan => {
      const slot1 = parseInt(slotSpan.textContent?.trim() || "0", 10);
      if (slot1 > max) max = slot1;
    });
  }
  return max;
}

/**
 * Get used slots from statistics display (0-based indices)
 */
function getUsedSlotsFromStatistics(): number[] {
  const usedSlots: number[] = [];
  const filamentTotal = document.getElementById("filament_total");

  if (!filamentTotal) return [0, 1, 2, 3]; // Fallback to 4 slots

  // Get all slot divs that are currently displayed in statistics
  const slotDivs = Array.from(filamentTotal.querySelectorAll<HTMLDivElement>(":scope > div[title]"));

  slotDivs.forEach(div => {
    const slotTitle = div.getAttribute("title");
    const slotId = parseInt(slotTitle || "0", 10); // 1-based
    if (slotId >= 1 && slotId <= 32) {
      usedSlots.push(slotId - 1); // Convert to 0-based
    }
  });

  // Sort by slot index
  usedSlots.sort((a, b) => a - b);

  return usedSlots.length > 0 ? usedSlots : [0, 1, 2, 3]; // Fallback to 4 slots
}

/**
 * Checks if all current slots have usage (used for showing expand button)
 */
function areAllSlotsUsed(slotCount: number): boolean {
  const filamentTotal = document.getElementById("filament_total");
  if (!filamentTotal) return false;

  // Check each slot div for usage
  const slotDivs = Array.from(filamentTotal.querySelectorAll<HTMLDivElement>(':scope > div[title]'));
  for (let i = 0; i < Math.min(slotCount, slotDivs.length); i++) {
    const div = slotDivs[i];
    if (!div) continue;
    const usedG = parseFloat(div.dataset['used_g'] || '0');
    if (usedG <= 0) {
      return false; // Found an unused slot
    }
  }

  return true; // All slots are used
}

/**
 * Expands the slot count to the next multiple of 4 (called from dropdown menu)
 */
function expandSlotsFromDropdown(): void {
  // Get current slot count from statistics
  const filamentTotal = document.getElementById("filament_total");
  if (!filamentTotal) return;

  const currentSlots = filamentTotal.querySelectorAll(':scope > div[title]').length;
  // Calculate next multiple of 4 (e.g., 4→8, 8→12, 12→16, etc.)
  const newSlotCount = Math.min(32, Math.ceil((currentSlots + 1) / 4) * 4); // Cap at 32

  // Store forced slot count in state
  state.forcedSlotCount = newSlotCount;

  // Trigger update
  update_statistics();
}

/**
 * Render colors in the totals statistics box
 */
export function renderTotalsColors(): void {
  const host = document.getElementById("filament_total");
  if (!host) return;

  Array.from(host.querySelectorAll<HTMLDivElement>(":scope > div[title]")).forEach(div => {
    const slot1 = +(div.getAttribute("title") || "0");
    if (!slot1) return;
    let sw = div.querySelector<HTMLDivElement>(":scope > .f_color");
    if (!sw) {
      sw = document.createElement("div");
      sw.className = "f_color";
      div.insertBefore(sw, div.firstChild);           // at the top
      div.insertBefore(document.createElement("br"), sw.nextSibling);
    }
    const idx = slot1 - 1;
    const hex = getSlotColor(idx);
    sw.dataset['slotIndex'] = String(idx);
    sw.dataset['f_color'] = hex;
    sw.style.background = hex;
  });
}

// Flag to prevent color derivation during slot reassignments
let _skipColorDerivation = false;

/**
 * Auto-fix: when update_statistics() rewrites DOM
 */
export function installFilamentTotalsAutoFix(): void {
  const host = document.getElementById("filament_total");
  if (!host) return;

  let pending = false;
  const obs = new MutationObserver(() => {
    if (pending) return;
    pending = true;
    requestAnimationFrame(() => {
      pending = false;
      if (!_skipColorDerivation) {
        deriveGlobalSlotColorsFromPlates(); // first derive from plates
      }
      renderTotalsColors();               // then set colors at top
      updateAllPlateSwatchColors();       // and color plates
      updateAllPlateImages();             // and update plate images
    });
  });
  obs.observe(host, { childList: true, subtree: true });
}

/**
 * Set global slot metadata (type, vendor, color)
 */
// @ts-expect-error - function reserved for future use
function setGlobalSlotMeta(sIndex: number, meta: { color?: string; type?: string; vendor?: string }): void {
  const dev = ensureP0();
  const sl = dev.slots[sIndex];
  if (!sl) return;
  sl.meta = sl.meta || {};
  if (meta.color != null) sl.color = toHexAny(meta.color);
  if (meta.type != null) sl.meta.type = meta.type;
  if (meta.vendor != null) sl.meta.vendor = meta.vendor;
  sl.manual = true;
  renderTotalsColors();

  // Auto-enable OVERRIDE_METADATA when slot settings are manually changed
  import('../config/state.js').then(({ state }) => {
    if (!state.OVERRIDE_METADATA) {
      state.OVERRIDE_METADATA = true;
      const checkbox = document.getElementById("opt_override_metadata") as HTMLInputElement | null;
      if (checkbox) checkbox.checked = true;
      console.log("Auto-enabled OVERRIDE_METADATA due to manual slot settings change");
    }
  });
}

/**
 * Wire plate swatches (set up dataset without changing colors)
 */
export function wirePlateSwatches(li: HTMLElement): void {
  Array.from(li.querySelectorAll<HTMLElement>(".p_filaments .p_filament")).forEach(row => {
    const sw = row.querySelector<HTMLElement>(".f_color");
    const slotSpan = row.querySelector<HTMLElement>(".f_slot");
    if (!sw || !slotSpan) return;
    const slot1 = parseInt(slotSpan.textContent?.trim() || "1", 10) || 1;
    const idx = Math.max(0, Math.min(31, slot1 - 1));
    sw.dataset['slotIndex'] = String(idx);
    // Color intentionally NOT changed – we read it during derivation!
  });
}

/**
 * Updates the plate image colors based on current slot assignments
 */
export async function updatePlateImageColors(plateElement: HTMLElement | null): Promise<void> {
  if (!plateElement) return;

  const plateIcon = plateElement.querySelector<HTMLImageElement>('.p_icon');
  if (!plateIcon || !plateIcon.dataset['litImageUrl'] || !plateIcon.dataset['unlitImageUrl']) {
    console.log('Plate image update skipped: missing image URLs');
    return;
  }

  try {
    // Build color mapping from original colors to current slot colors
    const colorMapping: Record<string, string> = {};

    // Get current filament rows
    const filamentRows = Array.from(plateElement.querySelectorAll<HTMLElement>('.p_filaments .p_filament'));
    filamentRows.forEach(row => {
      const swatch = row.querySelector<HTMLElement>('.f_color');
      const slotSpan = row.querySelector<HTMLElement>('.f_slot');

      if (swatch && slotSpan) {
        // Get original color from dataset (stored during import)
        const originalColor = swatch.dataset['f_color'];

        // Get current slot index
        const slotIndex = parseInt(swatch.dataset['slotIndex'] || '0', 10);
        const currentSlotColor = getSlotColor(slotIndex);

        if (originalColor && currentSlotColor) {
          colorMapping[originalColor] = currentSlotColor;
        }
      }
    });

    // Only update if we have color mappings
    if (Object.keys(colorMapping).length === 0) {
      console.log('No color mappings found for plate image update');
      return;
    }

    // Get cached lighting mask
    const cachedLightingMask = (plateIcon as any)._cachedLightingMask;
    if (!cachedLightingMask) {
      return;
    }

    // Create recolored image using cached shadowmap
    const newImageUrl = await createRecoloredPlateImage(
      plateIcon.dataset['unlitImageUrl'],
      cachedLightingMask,
      colorMapping
    );

    // Update the displayed image
    if (newImageUrl !== plateIcon.src) {
      // Clean up old URL if it was dynamically generated
      if (plateIcon.dataset['dynamicImageUrl']) {
        URL.revokeObjectURL(plateIcon.dataset['dynamicImageUrl']);
      }

      plateIcon.src = newImageUrl;
      plateIcon.dataset['dynamicImageUrl'] = newImageUrl;
    }

  } catch (error) {
    console.error('Failed to update plate image colors:', error);
  }
}

/**
 * Updates all plate images with current color mappings
 */
async function updateAllPlateImages(): Promise<void> {
  const plateElements = Array.from(document.querySelectorAll<HTMLElement>('#playlist_ol li.list_item:not(.hidden)'));

  // Process plates in parallel for better performance
  const updatePromises = plateElements.map(plateElement =>
    updatePlateImageColors(plateElement)
  );

  try {
    await Promise.all(updatePromises);
    console.log(`Updated ${plateElements.length} plate images`);
  } catch (error) {
    console.error('Error updating some plate images:', error);
  }
}

/**
 * Get vendor-material mapping from preset index
 */
// @ts-expect-error - function reserved for future use
function getVendorMaterialMap(presetIndex: typeof PRESET_INDEX): Record<string, string[]> {
  const map: Record<string, Set<string>> = {};
  presetIndex.forEach(item => {
    if (!map[item.vendor]) {
      map[item.vendor] = new Set();
    }
    const vendorSet = map[item.vendor];
    if (vendorSet) {
      vendorSet.add(item.material);
    }
  });
  // Convert Sets to Arrays
  const result: Record<string, string[]> = {};
  Object.keys(map).forEach(vendor => {
    const vendorSet = map[vendor];
    if (vendorSet) {
      result[vendor] = Array.from(vendorSet);
    }
  });
  return result;
}

/**
 * Get printer aliases for a specific mode
 */
function printerAliasesForMode(mode: string | null): Set<string> {
  // Filenames contain e.g. "X1C", "P1S", "A1M"
  switch ((mode || "").toUpperCase()) {
    case "X1": return new Set(["X1", "X1C", "X1E"]);
    case "P1": return new Set(["P1", "P1S", "P1P"]);
    case "A1M": return new Set(["A1M", "A1"]);
    default: return new Set(); // if unknown: no matches
  }
}

/**
 * Get catalog for current printer and nozzle
 */
export function catalogForCurrentPrinterAndNozzle(): {
  candidates: typeof PRESET_INDEX;
  vendorsByMaterial: Record<string, string[]>;
} {
  const mode = state.PRINTER_MODEL;                // "X1" | "P1" | "A1M"
  const allow = printerAliasesForMode(mode);
  const want02 = !!state.NOZZLE_IS_02;            // true if 0.2mm

  // Candidates: only files with matching printer and optionally 0.2 nozzle
  const candidates = (PRESET_INDEX || []).filter(e => {
    const p = (e.printer || "").toUpperCase();
    if (!allow.has(p)) return false;
    if (want02 && !e.nozzle02) return false;
    return true;
  });

  // Mapping Vendor -> [Materials] from candidates
  const vendorsByMaterial: Record<string, Set<string>> = {};
  for (const e of candidates) {
    const v = e.vendor || "Unknown";
    const m = e.material || "Unknown";
    if (!vendorsByMaterial[v]) vendorsByMaterial[v] = new Set();
    const vendorSet = vendorsByMaterial[v];
    if (vendorSet) {
      vendorSet.add(m);
    }
  }
  // Convert Sets to Arrays
  const vendorsByMaterialArray: Record<string, string[]> = {};
  for (const v of Object.keys(vendorsByMaterial)) {
    const vendorSet = vendorsByMaterial[v];
    if (vendorSet) {
      vendorsByMaterialArray[v] = Array.from(vendorSet).sort();
    }
  }

  return { candidates, vendorsByMaterial: vendorsByMaterialArray };
}

/**
 * Open stats slot dialog for editing slot color and viewing metadata
 */
export function openStatsSlotDialog(slotIndex: number): void {
  const curColor = getSlotColor(slotIndex);

  // Read data from statistics box dataset (derived from plates)
  const box = document.querySelector<HTMLDivElement>(`#filament_total > div[title="${slotIndex + 1}"]`);
  const trayInfoIdx = box?.dataset?.['trayInfoIdx'] || "";
  const curType = box?.dataset?.['f_type'] || "Unknown";

  // Lookup vendor by tray_info_idx
  const curVendor = lookupVendorByFilamentId(trayInfoIdx);

  // Get i18n instance
  const i18n = window.i18nInstance;

  // Build modal (color editable, rest read-only)
  const backdrop = document.createElement("div");
  backdrop.className = "slot-modal-backdrop";
  const modal = document.createElement("div");
  modal.className = "slot-modal";
  modal.innerHTML = `
    <h4>${i18n ? i18n.t('colorPicker.title', { slot: slotIndex + 1 }) : `Slot ${slotIndex + 1} Information`}</h4>
    <div class="row">
      <label>${i18n ? i18n.t('colorPicker.color') : 'Color:'}</label>
      <input type="color" id="slotColor" value="${curColor}">
    </div>
    <div class="row">
      <label>${i18n ? i18n.t('colorPicker.producer') : 'Producer:'}</label>
      <span style="font-weight: bold;">${curVendor}</span>
    </div>
    <div class="row">
      <label>${i18n ? i18n.t('colorPicker.material') : 'Material:'}</label>
      <span style="font-weight: bold;">${curType}</span>
    </div>
    ${trayInfoIdx ? `<div class="row"><label>${i18n ? i18n.t('colorPicker.filamentId') : 'Filament ID:'}</label><span style="font-family: monospace; color: #666;">${trayInfoIdx}</span></div>` : ''}
    <div class="actions">
      <button id="slotCancel">${i18n ? i18n.t('colorPicker.cancel') : 'Cancel'}</button>
      <button id="slotSave">${i18n ? i18n.t('colorPicker.save') : 'Save'}</button>
    </div>
  `;
  backdrop.appendChild(modal);
  document.body.appendChild(backdrop);

  const $ = <T extends HTMLElement = HTMLElement>(sel: string): T | null => modal.querySelector<T>(sel);

  // Buttons
  const cancelBtn = $("#slotCancel");
  const saveBtn = $("#slotSave");
  const colorInput = $("#slotColor") as HTMLInputElement | null;

  if (cancelBtn) cancelBtn.onclick = () => backdrop.remove();
  if (saveBtn) saveBtn.onclick = () => {
    const newColor = colorInput?.value || curColor;

    // Only update color (WITHOUT Override activation)
    // Since Type and Vendor come from plates and are not editable,
    // changing the color should NOT activate the override
    setGlobalSlotColor(slotIndex, newColor);

    // Update statistics row
    if (box) {
      box.dataset['f_color'] = toHexAny(newColor);
    }

    // Refresh display
    if (typeof updateAllPlateSwatchColors === "function") {
      updateAllPlateSwatchColors();
    }

    // Update plate images with new colors
    updateAllPlateImages();

    backdrop.remove();
  };

  // Close on backdrop click
  backdrop.onclick = (e: MouseEvent) => {
    if (e.target === backdrop) backdrop.remove();
  };
}
