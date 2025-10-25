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
  if (!state.P0.slots) state.P0.slots = [{}, {}, {}, {}];
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

// Add this helper function after toHexAny()
function getSwatchHex(swatch) {
  if (!swatch) return null;
  // First try to get original color from dataset
  if (swatch.dataset.f_color) return swatch.dataset.f_color;
  // Otherwise try to get from style
  return toHexAny(swatch.style.backgroundColor);
}

// ===== Defaults ===================================================
// nicht belegte Slots → grau
const DEFAULT_SLOT_COLORS = ["#cccccc", "#cccccc", "#cccccc", "#cccccc"];

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
    const idx = Math.max(0, Math.min(3, slot1 - 1));

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
  if (sIndex < 0 || sIndex >= 4) return;
  const p0 = ensureP0();
  if (!p0.slots) p0.slots = [];
  if (!p0.slots[sIndex]) p0.slots[sIndex] = {};
  p0.slots[sIndex].color = hex;

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

  const derived = [null, null, null, null];
  const slotColorConflicts = new Map(); // Track conflicts: slot -> [color1, color2, ...]

  const list = document.getElementById("playlist_ol");
  if (list) {
    list.querySelectorAll("li.list_item .p_filament").forEach(row => {
      const slotSpan = row.querySelector(".f_slot");
      const sw = row.querySelector(".f_color");
      if (!slotSpan || !sw) return;

      const slot1 = parseInt(slotSpan.textContent?.trim() || "0", 10);
      const idx = slot1 - 1;
      if (idx < 0 || idx > 3) return;

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

  for (let i = 0; i < 4; i++) {
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

  for (let i = 0; i < 4; i++) {
    const item = document.createElement("div");
    item.className = "slot-dropdown-item";
    item.dataset.slotIndex = String(i);

    const dot = document.createElement("span");
    dot.className = "dot";
    dot.style.background = getSlotColor(i); // Slotfarbe (aus Plates abgeleitet)

    const lab = document.createElement("span");
    lab.textContent = `Slot ${i + 1}`;

    if (i === cur) item.classList.add("current");
    item.append(dot, lab);
    item.addEventListener("click", () => { applySlotSelectionToPlate(anchorEl, i); closeMenu(); });
    menu.appendChild(item);
  }

  // KEIN "Edit slot color…" – entfernt.

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

// ===== Statistik: vier Slots erzwingen + Swatch oben ============
function ensureFourSlotDivs(host) {
  for (let i = 1; i <= 4; i++) {
    let div = host.querySelector(`:scope > div[title="${i}"]`) || host.querySelector(`:scope > div[data-slot="${i}"]`);
    if (!div) {
      div = document.createElement("div");
      div.setAttribute("title", String(i));
      div.innerHTML = `Slot ${i}: <br> 0.00m <br> 0.00g`;
      host.appendChild(div);
    }
  }
}

export function renderTotalsColors() {
  const host = document.getElementById("filament_total"); if (!host) return;
  ensureFourSlotDivs(host);

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
    const idx = Math.max(0, Math.min(3, slot1 - 1));
    sw.dataset.slotIndex = String(idx);
    // Farbe absichtlich NICHT ändern – wir lesen sie beim Ableiten aus!
  });
}

/**
 * Updates the plate image colors based on current slot assignments
 * @param {Element} plateElement - The plate li element
 */
async function updatePlateImageColors(plateElement) {
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

    // Create recolored image
    const newImageUrl = await createRecoloredPlateImage(
      plateIcon.dataset.litImageUrl,
      plateIcon.dataset.unlitImageUrl,
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


/** Öffnet den Dialog für Statistics-Slot */
export function openStatsSlotDialog(slotIndex) {
  const curColor  = getSlotColor(slotIndex);
  const sl        = (ensureP0().slots[slotIndex] || {});
  const curType   = sl.meta?.type   || "PLA";
  const curVendor = sl.meta?.vendor || "Generic";

  // Gefilterter Katalog passend zu Mode + 0.2er Nozzle
  const { candidates, vendorsByMaterial } = catalogForCurrentPrinterAndNozzle();

  const fallbackMaterials = ["PLA","PETG","ABS","ASA","TPU","PC","PA","PVA","Other"];
  const fallbackVendors   = ["Bambu","Polymaker","eSun","Generic","Other"];

  // Vendor- und Materiallisten aus den Kandidaten ableiten
  const vendorList = Object.keys(vendorsByMaterial);
  const vendors    = vendorList.length ? vendorList.sort() : fallbackVendors;

  const initialVendor   = vendors.includes(curVendor) ? curVendor : vendors[0];
  const materialsForV   = vendorsByMaterial[initialVendor] || fallbackMaterials;
  const initialMaterial = materialsForV.includes(curType) ? curType : materialsForV[0];

  // Modal bauen
  const backdrop = document.createElement("div");
  backdrop.className = "slot-modal-backdrop";
  const modal = document.createElement("div");
  modal.className = "slot-modal";
  modal.innerHTML = `
    <h4>Slot ${slotIndex + 1}</h4>
    <div class="row">
      <label>Color:</label>
      <input type="color" id="slotColor" value="${curColor}">
    </div>
    <div class="row">
      <label>Producer:</label>
      <select id="slotVendor"></select>
    </div>
    <div class="row">
      <label>Material:</label>
      <select id="slotType"></select>
    </div>
    <div class="actions">
      <button id="slotCancel">Cancel</button>
      <button id="slotSave">Save</button>
    </div>
  `;
  backdrop.appendChild(modal);
  document.body.appendChild(backdrop);

  const $       = sel => modal.querySelector(sel);
  const vendSel = $("#slotVendor");
  const typeSel = $("#slotType");

  // Helper zum Befüllen
  function fillSelect(sel, values, selected) {
    sel.innerHTML = values
      .map(v => `<option value="${v}" ${v === selected ? "selected" : ""}>${v}</option>`)
      .join("");
  }

  // Initiale Befüllung
  fillSelect(vendSel, vendors,        initialVendor);
  fillSelect(typeSel, materialsForV,  initialMaterial);

  // Wenn Vendor wechselt → Materials neu filtern
  vendSel.addEventListener("change", () => {
    const mats = vendorsByMaterial[vendSel.value] || fallbackMaterials;
    const keep = mats.includes(typeSel.value) ? typeSel.value : mats[0];
    fillSelect(typeSel, mats, keep);
  });

  // Buttons
  $("#slotCancel").onclick = () => backdrop.remove();
  $("#slotSave").onclick = () => {
    const color  = $("#slotColor").value;
    const type   = typeSel.value;
    const vendor = vendSel.value;

    // passenden Preset-Eintrag suchen (falls vorhanden)
    const entry = candidates.find(e => e.material === type && e.vendor === vendor) || null;

    // globale Slot-Metadaten setzen
    setGlobalSlotMeta(slotIndex, { color, type, vendor });

    // presetFile / setting_id am Slot für Export hinterlegen
    const slot = ensureP0().slots[slotIndex];
    slot.meta = slot.meta || {};
    slot.meta.presetFile = entry?.file || null;
    slot.meta.setting_id = entry?.settings?.setting_id ?? entry?.data?.setting_id ?? null;

    // Statistics-Zeile aktualisieren (Export liest das später aus)
    const box = document.querySelector(`#filament_total > div[title="${slotIndex + 1}"]`);
    if (box) {
      box.dataset.f_color  = toHexAny(color);
      box.dataset.f_type   = type;
      box.dataset.f_vendor = vendor;
      if (entry?.file) box.dataset.preset_file = entry.file;
    }

    // Anzeige auffrischen
    if (typeof updateAllPlateSwatchColors === "function") {
      updateAllPlateSwatchColors();
    }

    // Plate-Bilder mit neuen Farben aktualisieren
    updateAllPlateImages();

    backdrop.remove();
  };
}


