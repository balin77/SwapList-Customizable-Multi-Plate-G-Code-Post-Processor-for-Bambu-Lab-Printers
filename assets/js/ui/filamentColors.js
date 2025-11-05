// /src/ui/filamentColors.js
import { state } from "../config/state.js";
import { update_statistics } from "../ui/statistics.js";
import { PRESET_INDEX } from "../config/filamentConfig/registry-generated.js";
import { createRecoloredPlateImage, extractOriginalFilamentColors } from "../utils/imageColorMapping.js";
import { showWarning } from "./infobox.js";

// Helper function to calculate luminance and determine contrasting background
function getContrastingBackground(hexColor) {
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

// Add this helper function
function ensureP0() {
  if (!state.P0) state.P0 = {};
  if (!state.P0.slots) state.P0.slots = Array(32).fill(null).map(() => ({}));
  return state.P0;
}

// Also add missing toHexAny helper
function toHexAny(color) {
  if (!color) return "#cccccc";
  if (color.startsWith("#")) return color;
  const m = color.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)/);
  if (!m) return "#cccccc";
  return "#" + m.slice(1).map(x => (+x).toString(16).padStart(2, "0")).join("");
}

// Lookup vendor by filament_id (tray_info_idx) in registry
function lookupVendorByFilamentId(filamentId) {
  if (!filamentId) {
    console.log("[lookupVendor] No filamentId provided");
    return "Unknown";
  }

  // Search in PRESET_INDEX for matching filament_id in settings object
  const entry = (PRESET_INDEX || []).find(e => e.settings?.filament_id === filamentId);

  console.log(`[lookupVendor] Searching for filament_id="${filamentId}":`, entry ? `Found vendor="${entry.vendor}"` : "Not found");

  return entry?.vendor || "Unknown";
}

// Add this helper function after toHexAny()
function getSwatchHex(swatch) {
  if (!swatch) return null;
  // First try to get original color from dataset
  if (swatch.dataset.f_color) return swatch.dataset.f_color;
  // Otherwise try to get from style
  return toHexAny(swatch.style.backgroundColor);
}

// ===== Defaults ===================================================
// nicht belegte Slots → grau (up to 32 slots)
const DEFAULT_SLOT_COLORS = Array(32).fill("#cccccc");

// Alte Funktionen entfernen:
// - repaintPlateRowBySlot
// - repaintPlateFromStats
// - recolorAllPlateSwatchesFromGlobal

// Diese eine zentrale Update-Funktion für Plate-Swatches
export function updateAllPlateSwatchColors() {
  const list = document.getElementById("playlist_ol");
  if (!list) return;

  list.querySelectorAll("li.list_item .p_filaments .p_filament").forEach(row => {
    const sw = row.querySelector(".f_color");
    const slotSpan = row.querySelector(".f_slot");
    if (!sw || !slotSpan) return;

    const slot1 = parseInt(slotSpan.textContent?.trim() || "1", 10) || 1;
    const idx = Math.max(0, Math.min(31, slot1 - 1));

    // Originalfarbe im Dataset speichern falls noch nicht vorhanden
    if (!sw.dataset.f_color && sw.style.backgroundColor) {
      sw.dataset.f_color = toHexAny(sw.style.backgroundColor);
    }

    // Slot-Index und aktuelle Farbe setzen
    sw.dataset.slotIndex = String(idx);
    const currentColor = getSlotColor(idx);
    sw.style.backgroundColor = currentColor;
    sw.style.background = currentColor;
  });
}

// Diese Funktion anpassen
export function setGlobalSlotColor(sIndex, hex) {
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
      const checkbox = document.getElementById("opt_override_metadata");
      if (checkbox) checkbox.checked = true;
      console.log("Auto-enabled OVERRIDE_METADATA due to manual color change");
    }
  });

  // UI aktualisieren - wichtig: beide Aufrufe!
  renderTotalsColors();
  updateAllPlateSwatchColors();
}

// ===== Globale Slotfarben lesen ===================================
export function getSlotColor(sIndex) {
  const sl = ensureP0().slots[sIndex];
  return (sl && sl.color) || DEFAULT_SLOT_COLORS[sIndex] || "#cccccc";
}

// ===== Ableitung: Farben AUS den Plates ===========================
// Scannt alle Plates, setzt P0S0..3 Farbe auf die ERSTE gefundene FILAMENTfarbe je Slot.
// Wichtig: wir lesen die Filamentfarbe aus dataset.f_color (nicht aus background),
// damit spätere Slot-Recolorings die Ableitung nicht verfälschen.
export function deriveGlobalSlotColorsFromPlates() {
  const dev = ensureP0();

  const derived = Array(32).fill(null);
  const slotColorConflicts = new Map(); // Track conflicts: slot -> [color1, color2, ...]

  const list = document.getElementById("playlist_ol");
  if (list) {
    list.querySelectorAll("li.list_item .p_filament").forEach(row => {
      const slotSpan = row.querySelector(".f_slot");
      const sw = row.querySelector(".f_color");
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
      slotColorConflicts.get(idx).add(hex);

      if (!derived[idx]) derived[idx] = hex; // „erste gewinnt"
    });
  }

  // Check for color conflicts and show warning
  checkForSlotColorConflicts(slotColorConflicts);

  for (let i = 0; i < 32; i++) {
    const sl = dev.slots[i];
    if (sl.manual) continue; // manuelle Overrides nicht überschreiben
    sl.color = derived[i] || DEFAULT_SLOT_COLORS[i];
    sl.conflict = false;
  }

  renderTotalsColors();
}

// ===== Color Conflict Detection ====================================

// Debounce mechanism to prevent multiple warnings
let _conflictWarningTimeout = null;
let _lastConflictHash = null;

/**
 * Checks for color conflicts between plates for the same slots and shows warnings
 * @param {Map} slotColorConflicts - Map of slot index to Set of colors found
 */
function checkForSlotColorConflicts(slotColorConflicts) {
  const conflictedSlots = [];

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

// ===== Auto-enable/disable Override Metadata =========================
export function autoEnableOverrideMetadata() {
  import('../config/state.js').then(({ state }) => {
    if (!state.OVERRIDE_METADATA) {
      state.OVERRIDE_METADATA = true;
      const checkbox = document.getElementById("opt_override_metadata");
      if (checkbox) checkbox.checked = true;
      console.log("Auto-enabled OVERRIDE_METADATA due to slot change");
    }
  });
}

export function checkAutoDisableOverrideMetadata() {
  // DEAKTIVIERT: Override wird nicht mehr automatisch deaktiviert
  // Der User muss es manuell deaktivieren, falls gewünscht
  console.log("checkAutoDisableOverrideMetadata: Auto-disable is disabled - user must manually toggle override");
}

export function checkAutoToggleOverrideMetadata() {
  // Prüfen ob aktuell irgendwelche Slots von ihren Originalwerten abweichen
  const hasAnyModifiedSlots = hasModifiedSlotsInAnyPlate();
  console.log('checkAutoToggleOverrideMetadata: hasModifiedSlots =', hasAnyModifiedSlots);

  import('../config/state.js').then(({ state }) => {
    console.log('Current OVERRIDE_METADATA state:', state.OVERRIDE_METADATA);
    if (hasAnyModifiedSlots && !state.OVERRIDE_METADATA) {
      // Enable wenn modifizierte Slots gefunden
      state.OVERRIDE_METADATA = true;
      const checkbox = document.getElementById("opt_override_metadata");
      if (checkbox) checkbox.checked = true;
      console.log("Auto-enabled OVERRIDE_METADATA due to slot change");
    } else {
      // WICHTIG: Override wird NICHT automatisch deaktiviert, auch wenn keine modifizierten Slots mehr vorhanden
      // Der User muss es manuell deaktivieren, falls gewünscht
      console.log('No OVERRIDE_METADATA change - stays at current state');
    }
  });
}

function hasModifiedSlotsInAnyPlate() {
  const plates = document.querySelectorAll("#playlist_ol li.list_item");
  console.log('Checking', plates.length, 'plates for modified slots');

  for (const plate of plates) {
    // Nur aktive plates prüfen (Repeats > 0)
    const repInput = plate.querySelector(".p_rep");
    const reps = parseFloat(repInput?.value || "0");
    if (reps <= 0) continue;

    // Slots in dieser plate prüfen
    const slots = plate.querySelectorAll(".p_filament .f_slot");
    for (const slot of slots) {
      const originalSlot = parseInt(slot.dataset.origSlot || "0", 10);
      const currentSlot = parseInt((slot.textContent || "").trim() || "0", 10);

      // Wenn Original-Slot existiert und sich vom aktuellen unterscheidet
      if (originalSlot > 0 && currentSlot > 0 && originalSlot !== currentSlot) {
        return true;
      }
    }
  }

  return false;
}

/**
 * Get all unique slots used in a specific plate (by index)
 * @param {Element} plateElement - The plate list item element
 * @returns {Set<number>} Set of slot numbers used in the plate
 */
function getSlotsUsedInPlate(plateElement) {
  const slots = new Set();
  const slotElements = plateElement.querySelectorAll(".p_filament .f_slot");

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
 * (used in the removed plate but not in any remaining plate)
 * @param {Element} plateToRemove - The plate element that will be removed
 * @returns {boolean} True if there are orphaned slots, false otherwise
 */
export function hasOrphanedSlotsAfterRemoval(plateToRemove) {
  // Get all slots used in the plate to be removed
  const removedSlots = getSlotsUsedInPlate(plateToRemove);

  if (removedSlots.size === 0) {
    return false; // No slots used in removed plate
  }

  // Get all remaining plates (excluding the one to be removed)
  const allPlates = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)");
  const remainingSlots = new Set();

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

// Slot-Auswahl auf der Plate: nur Zahl updaten + diese Zeile neu bemalen.
export function applySlotSelectionToPlate(anchorEl, newIndex) {
  const row = anchorEl.closest(".p_filament");
  if (!row) return;

  // nur diese Zeile updaten
  const slotSpan = row.querySelector(".f_slot");
  if (slotSpan) slotSpan.textContent = String(newIndex + 1);

  // Anzeige der Swatch-Farbe aus den globalen Slotfarben
  anchorEl.dataset.slotIndex = String(newIndex);
  const hex = getSlotColor(newIndex);
  anchorEl.style.background = hex;

  // WICHTIG: dataset.f_color NICHT setzen (Originalfarbe bleibt erhalten)!

  // Prevent global slot color derivation during slot reassignment
  _skipColorDerivation = true;

  // m/g in den Statistics auf den neuen Slot umbuchen
  update_statistics();

  // Auto-enable/disable Override metadata basierend auf Slot-Änderungen
  checkAutoToggleOverrideMetadata();

  // Update plate image colors when slot assignment changes
  updatePlateImageColors(row.closest('li.list_item'));

  // Reset flag after a short delay to allow other operations
  setTimeout(() => {
    _skipColorDerivation = false;
  }, 100);
}

// ===== Dropdown am Plate-Swatch ==================================
let _openMenu = null;
let _openAnchor = null;
let _justClosed = false;
function closeMenu() {
  if (_openMenu) { _openMenu.remove(); _openMenu = null; _openAnchor = null; }
  _justClosed = true;
  setTimeout(() => { _justClosed = false; }, 0); // swallow immediate re-open in same click
}

export function openSlotDropdown(anchorEl) {
  if (_justClosed) return; // ignore click that just closed the menu
  // Toggle: klick auf dasselbe Swatch schließt wieder
  if (_openMenu && _openAnchor === anchorEl) { closeMenu(); return; }
  closeMenu(); _openAnchor = anchorEl;

  const cur = +(anchorEl.dataset.slotIndex || 0);
  const menu = document.createElement("div");
  menu.className = "slot-dropdown";
  menu.setAttribute("data-role", "slot-dropdown");

  // Get used slots from statistics (only show slots that are actually displayed in statistics)
  const usedSlots = getUsedSlotsFromStatistics();

  // Show only the slots that are displayed in statistics
  for (const slotIndex of usedSlots) {
    const item = document.createElement("div");
    item.className = "slot-dropdown-item";
    item.dataset.slotIndex = String(slotIndex);

    const dot = document.createElement("span");
    dot.className = "dot";
    dot.style.background = getSlotColor(slotIndex); // Slotfarbe (aus Plates abgeleitet)

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
    document.addEventListener("mousedown", (ev) => {
      if (!_openMenu) return;
      if (!_openMenu.contains(ev.target)) closeMenu();
    }, { once: true });
  }, 0);

  _openMenu = menu;
}

// Helper function to get max used slot across all plates
function getMaxUsedSlot() {
  let max = 4;
  const list = document.getElementById("playlist_ol");
  if (list) {
    list.querySelectorAll("li.list_item .p_filament .f_slot").forEach(slotSpan => {
      const slot1 = parseInt(slotSpan.textContent?.trim() || "0", 10);
      if (slot1 > max) max = slot1;
    });
  }
  return max;
}

// Helper function to get used slots from statistics display (0-based indices)
function getUsedSlotsFromStatistics() {
  const usedSlots = [];
  const filamentTotal = document.getElementById("filament_total");

  if (!filamentTotal) return [0, 1, 2, 3]; // Fallback to 4 slots

  // Get all slot divs that are currently displayed in statistics
  const slotDivs = filamentTotal.querySelectorAll(":scope > div[title]");

  slotDivs.forEach(div => {
    const slotTitle = div.getAttribute("title");
    const slotId = parseInt(slotTitle, 10); // 1-based
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
function areAllSlotsUsed(slotCount) {
  const filamentTotal = document.getElementById("filament_total");
  if (!filamentTotal) return false;

  // Check each slot div for usage
  const slotDivs = filamentTotal.querySelectorAll(':scope > div[title]');
  for (let i = 0; i < Math.min(slotCount, slotDivs.length); i++) {
    const div = slotDivs[i];
    const usedG = parseFloat(div.dataset.used_g || '0');
    if (usedG <= 0) {
      return false; // Found an unused slot
    }
  }

  return true; // All slots are used
}

/**
 * Expands the slot count to the next multiple of 4 (called from dropdown menu)
 */
function expandSlotsFromDropdown() {
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

export function renderTotalsColors() {
  const host = document.getElementById("filament_total"); if (!host) return;

  host.querySelectorAll(":scope > div[title]").forEach(div => {
    const slot1 = +(div.getAttribute("title") || "0"); if (!slot1) return;
    let sw = div.querySelector(":scope > .f_color");
    if (!sw) {
      sw = document.createElement("div");
      sw.className = "f_color";
      div.insertBefore(sw, div.firstChild);           // ganz oben
      div.insertBefore(document.createElement("br"), sw.nextSibling);
    }
    const idx = slot1 - 1;
    const hex = getSlotColor(idx);
    sw.dataset.slotIndex = String(idx);
    sw.dataset.f_color = hex;
    sw.style.background = hex;
  });
}

// Flag to prevent color derivation during slot reassignments
let _skipColorDerivation = false;

// ===== Auto-Fix: wenn update_statistics() DOM neu schreibt =======
export function installFilamentTotalsAutoFix() {
  const host = document.getElementById("filament_total");
  if (!host) return;

  let pending = false;
  const obs = new MutationObserver(() => {
    if (pending) return;
    pending = true;
    requestAnimationFrame(() => {
      pending = false;
      if (!_skipColorDerivation) {
        deriveGlobalSlotColorsFromPlates(); // zuerst aus Plates ableiten
      }
      renderTotalsColors();               // dann oben neu setzen
      updateAllPlateSwatchColors();       // und Plates einfärben
      updateAllPlateImages();             // und Plate-Bilder aktualisieren
    });
  });
  obs.observe(host, { childList: true, subtree: true });
}

// … oben: ensureP0(), toHexAny(), getSlotColor(), setGlobalSlotColor(), …

function setGlobalSlotMeta(sIndex, meta) {
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
      const checkbox = document.getElementById("opt_override_metadata");
      if (checkbox) checkbox.checked = true;
      console.log("Auto-enabled OVERRIDE_METADATA due to manual slot settings change");
    }
  });
}

// --- NEU: nur dataset verdrahten, Farbe NICHT anfassen (für initialen Import)
export function wirePlateSwatches(li) {
  li.querySelectorAll(".p_filaments .p_filament").forEach(row => {
    const sw = row.querySelector(".f_color");
    const slotSpan = row.querySelector(".f_slot");
    if (!sw || !slotSpan) return;
    const slot1 = parseInt(slotSpan.textContent?.trim() || "1", 10) || 1;
    const idx = Math.max(0, Math.min(31, slot1 - 1));
    sw.dataset.slotIndex = String(idx);
    // Farbe absichtlich NICHT ändern – wir lesen sie beim Ableiten aus!
  });
}

/**
 * Updates the plate image colors based on current slot assignments
 * @param {Element} plateElement - The plate li element
 */
export async function updatePlateImageColors(plateElement) {
  if (!plateElement) return;

  const plateIcon = plateElement.querySelector('.p_icon');
  if (!plateIcon || !plateIcon.dataset.litImageUrl || !plateIcon.dataset.unlitImageUrl) {
    console.log('Plate image update skipped: missing image URLs');
    return;
  }

  try {
    // Build color mapping from original colors to current slot colors
    const colorMapping = {};

    // Get current filament rows
    const filamentRows = plateElement.querySelectorAll('.p_filaments .p_filament');
    filamentRows.forEach(row => {
      const swatch = row.querySelector('.f_color');
      const slotSpan = row.querySelector('.f_slot');

      if (swatch && slotSpan) {
        // Get original color from dataset (stored during import)
        const originalColor = swatch.dataset.f_color;

        // Get current slot index
        const slotIndex = parseInt(swatch.dataset.slotIndex || '0', 10);
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

    console.log('Updating plate image with color mapping:', colorMapping);

    // Get cached lighting mask
    const cachedLightingMask = plateIcon._cachedLightingMask;
    if (!cachedLightingMask) {
      console.warn('No cached lighting mask found for plate, skipping image update');
      return;
    }

    // Create recolored image using cached shadowmap
    const newImageUrl = await createRecoloredPlateImage(
      plateIcon.dataset.unlitImageUrl,
      cachedLightingMask,
      colorMapping
    );

    // Update the displayed image
    if (newImageUrl !== plateIcon.src) {
      // Clean up old URL if it was dynamically generated
      if (plateIcon.dataset.dynamicImageUrl) {
        URL.revokeObjectURL(plateIcon.dataset.dynamicImageUrl);
      }

      plateIcon.src = newImageUrl;
      plateIcon.dataset.dynamicImageUrl = newImageUrl;
    }

  } catch (error) {
    console.error('Failed to update plate image colors:', error);
  }
}

/**
 * Updates all plate images with current color mappings
 */
async function updateAllPlateImages() {
  const plateElements = document.querySelectorAll('#playlist_ol li.list_item:not(.hidden)');

  // Process plates in parallel for better performance
  const updatePromises = Array.from(plateElements).map(plateElement =>
    updatePlateImageColors(plateElement)
  );

  try {
    await Promise.all(updatePromises);
    console.log(`Updated ${plateElements.length} plate images`);
  } catch (error) {
    console.error('Error updating some plate images:', error);
  }
}

function getVendorMaterialMap(presetIndex) {
  const map = {};
  presetIndex.forEach(item => {
    if (!map[item.vendor]) {
      map[item.vendor] = new Set();
    }
    map[item.vendor].add(item.material);
  });
  // Sets zu Arrays konvertieren
  Object.keys(map).forEach(vendor => {
    map[vendor] = Array.from(map[vendor]);
  });
  return map;
}

function printerAliasesForMode(mode) {
  // Dateinamen enthalten z.B. "X1C", "P1S", "A1M"
  switch ((mode || "").toUpperCase()) {
    case "X1": return new Set(["X1", "X1C", "X1E"]);
    case "P1": return new Set(["P1", "P1S", "P1P"]);
    case "A1M": return new Set(["A1M", "A1"]);
    default: return new Set(); // falls unbekannt: keine Treffer
  }
}

/** Liefert die passenden Presets für das aktuelle Setup. */
export function catalogForCurrentPrinterAndNozzle() {
  const mode = state.PRINTER_MODEL;                // "X1" | "P1" | "A1M"
  const allow = printerAliasesForMode(mode);
  const want02 = !!state.NOZZLE_IS_02;            // true, wenn 0.2mm

  // Kandidaten: nur Dateien mit passendem Drucker und ggf. 0.2-Nozzle
  const candidates = (PRESET_INDEX || []).filter(e => {
    const p = (e.printer || "").toUpperCase();
    if (!allow.has(p)) return false;
    if (want02 && !e.nozzle02) return false;
    return true;
  });

  // Mapping Vendor -> [Materials] aus den Kandidaten
  const vendorsByMaterial = {};
  for (const e of candidates) {
    const v = e.vendor || "Unknown";
    const m = e.material || "Unknown";
    (vendorsByMaterial[v] ||= new Set()).add(m);
  }
  // Sets in Arrays verwandeln
  for (const v of Object.keys(vendorsByMaterial)) {
    vendorsByMaterial[v] = Array.from(vendorsByMaterial[v]).sort();
  }

  return { candidates, vendorsByMaterial };
}


/** Öffnet den Dialog für Statistics-Slot (zeigt Plate-Daten, Farbe editierbar) */
export function openStatsSlotDialog(slotIndex) {
  const curColor = getSlotColor(slotIndex);

  // Lese Daten aus dem Statistics-Box Dataset (aus Plates abgeleitet)
  const box = document.querySelector(`#filament_total > div[title="${slotIndex + 1}"]`);
  const trayInfoIdx = box?.dataset?.trayInfoIdx || "";
  const curType = box?.dataset?.f_type || "Unknown";

  // Lookup vendor by tray_info_idx
  const curVendor = lookupVendorByFilamentId(trayInfoIdx);

  // Modal bauen (Farbe editierbar, Rest read-only)
  const backdrop = document.createElement("div");
  backdrop.className = "slot-modal-backdrop";
  const modal = document.createElement("div");
  modal.className = "slot-modal";
  modal.innerHTML = `
    <h4>Slot ${slotIndex + 1} Information</h4>
    <div class="row">
      <label>Color:</label>
      <input type="color" id="slotColor" value="${curColor}">
    </div>
    <div class="row">
      <label>Producer:</label>
      <span style="font-weight: bold;">${curVendor}</span>
    </div>
    <div class="row">
      <label>Material:</label>
      <span style="font-weight: bold;">${curType}</span>
    </div>
    ${trayInfoIdx ? `<div class="row"><label>Filament ID:</label><span style="font-family: monospace; color: #666;">${trayInfoIdx}</span></div>` : ''}
    <div class="actions">
      <button id="slotCancel">Cancel</button>
      <button id="slotSave">Save</button>
    </div>
  `;
  backdrop.appendChild(modal);
  document.body.appendChild(backdrop);

  const $ = sel => modal.querySelector(sel);

  // Buttons
  $("#slotCancel").onclick = () => backdrop.remove();
  $("#slotSave").onclick = () => {
    const newColor = $("#slotColor").value;

    // Nur Farbe aktualisieren (OHNE Override-Aktivierung)
    // Da Type und Vendor aus Plates kommen und nicht editierbar sind,
    // sollte das Ändern der Farbe NICHT den Override aktivieren
    setGlobalSlotColor(slotIndex, newColor);

    // Statistics-Zeile aktualisieren
    if (box) {
      box.dataset.f_color = toHexAny(newColor);
    }

    // Anzeige auffrischen
    if (typeof updateAllPlateSwatchColors === "function") {
      updateAllPlateSwatchColors();
    }

    // Plate-Bilder mit neuen Farben aktualisieren
    updateAllPlateImages();

    backdrop.remove();
  };

  // Close on backdrop click
  backdrop.onclick = (e) => {
    if (e.target === backdrop) backdrop.remove();
  };
}


