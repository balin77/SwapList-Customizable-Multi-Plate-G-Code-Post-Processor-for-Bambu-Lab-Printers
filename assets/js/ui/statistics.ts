/**
 * Statistics module for calculating and displaying filament usage, time, weight, and cost
 */

import { state } from "../config/state.js";
import { PRESET_INDEX } from "../config/filamentConfig/registry-generated.js";

/**
 * Update all statistics (filament usage, time, weight, and cost)
 */
export function update_statistics(): void {
  update_filament_usage();
  update_total_time();
  update_total_weight_and_cost();
}

/**
 * Update total time and plate count display
 */
export function update_total_time(): void {
  const total_time_el = document.getElementById("total_time");
  const used_plates_el = document.getElementById("used_plates");
  const loopsEl = document.getElementById("loops") as HTMLInputElement | null;
  const list = state.playlist_ol;

  if (!total_time_el || !used_plates_el || !loopsEl || !list) return;

  const loops = parseFloat(loopsEl.value) || 1;

  let used_plates = 0;
  let seconds_total = 0;

  const my_plates = list.getElementsByTagName("li");

  for (let i = 0; i < my_plates.length; i++) {
    const plate = my_plates[i];
    if (!plate) continue;
    const repEl = plate.getElementsByClassName("p_rep")[0] as HTMLInputElement | undefined;
    const timeEl = plate.getElementsByClassName("p_time")[0] as HTMLElement | undefined;

    const p_rep = parseFloat(repEl?.value || "0") || 0;
    const p_time = parseInt(timeEl?.title || "0", 10) || 0; // Seconds

    if (p_rep > 0) {
      seconds_total += p_rep * p_time;
      plate.classList.remove("inactive");
      used_plates += p_rep;
    } else {
      plate.classList.add("inactive");
    }
  }

  used_plates *= loops;
  seconds_total *= loops;

  total_time_el.innerText = toDHMS(seconds_total);
  used_plates_el.innerText = String(used_plates);
}

/**
 * Convert seconds to DHMS (Days, Hours, Minutes, Seconds) format
 * @param sec_num - Total seconds
 * @returns Formatted time string
 */
function toDHMS(sec_num: number): string {
  const days = Math.floor(sec_num / (3600 * 24));
  const hours = Math.floor((sec_num - (days * 86400)) / 3600);
  const minutes = Math.floor((sec_num - (days * 86400) - (hours * 3600)) / 60);
  const seconds = Math.floor(sec_num - (days * 86400) - (hours * 3600) - (minutes * 60));
  return (days ? days + "d " : "") + (hours ? hours + "h " : "") + minutes + "m " + seconds + "s ";
}

/**
 * Update filament usage statistics and display
 */
export function update_filament_usage(): void {
  const fil_stat = document.getElementById("filament_total");
  const list = state.playlist_ol;
  if (!fil_stat || !list) return;

  const my_fil_data = list.getElementsByClassName("p_filament");

  const used_m: number[] = [];               // [slot] → m
  const used_g: number[] = [];               // [slot] → g
  const slot_type_candidates: string[][] = []; // [slot] → Array of original types
  const slot_tray_info_idx: string[][] = [];   // [slot] → Array of tray_info_idx

  let ams_max = -1;
  let max_slot = -1;

  // Check if we have a forced slot count from user expansion
  const forcedSlotCount = state.forcedSlotCount || 0;

  for (let i = 0; i < my_fil_data.length; i++) {
    const row = my_fil_data[i] as HTMLElement;

    const slotEl = row.getElementsByClassName("f_slot")[0] as HTMLElement | undefined;
    const slotIdx1 = parseInt(slotEl?.innerText || "0", 10);
    if (!Number.isFinite(slotIdx1)) continue;
    const slot = slotIdx1 - 1; // 0..31

    if (!used_m[slot]) used_m[slot] = 0;
    if (!used_g[slot]) used_g[slot] = 0;
    if (!slot_type_candidates[slot]) slot_type_candidates[slot] = [];
    if (!slot_tray_info_idx[slot]) slot_tray_info_idx[slot] = [];

    const repEl = row.parentElement?.parentElement?.getElementsByClassName("p_rep")[0] as HTMLInputElement | undefined;
    const r = parseFloat(repEl?.value || "0") || 0;

    // Get original consumption values (store them in dataset if not already stored)
    const mElement = row.getElementsByClassName("f_used_m")[0] as HTMLElement | undefined;
    const gElement = row.getElementsByClassName("f_used_g")[0] as HTMLElement | undefined;

    if (!mElement || !gElement) continue;

    // Store original values on first run or if not stored
    if (!mElement.dataset['originalValue']) {
      mElement.dataset['originalValue'] = mElement.innerText;
    }
    if (!gElement.dataset['originalValue']) {
      gElement.dataset['originalValue'] = gElement.innerText;
    }

    const mOriginal = parseFloat(mElement.dataset['originalValue']) || 0;
    const gOriginal = parseFloat(gElement.dataset['originalValue']) || 0;

    // Update displayed values to show multiplied consumption
    const mDisplayed = mOriginal * r;
    const gDisplayed = gOriginal * r;

    mElement.innerText = mDisplayed.toFixed(2);
    gElement.innerText = gDisplayed.toFixed(1);

    used_m[slot] += mDisplayed;
    used_g[slot] += gDisplayed;

    const tEl = row.getElementsByClassName("f_type")[0] as HTMLElement | undefined;
    const tOrig = tEl?.dataset?.['origType'] || "";
    const tShow = tEl?.innerText || "";
    const t = tOrig || tShow || "";
    if (t) slot_type_candidates[slot].push(t);

    // Collect tray_info_idx for each slot
    const trayIdx = slotEl?.dataset?.['trayInfoIdx'] || "";
    if (trayIdx && r > 0) slot_tray_info_idx[slot].push(trayIdx);

    if (slot > ams_max && r > 0) {
      ams_max = slot;
      const fidEl = row.parentElement?.parentElement?.getElementsByClassName("f_id")[0] as HTMLElement | undefined;
      if (fidEl?.title) {
        state.ams_max_file_id = parseInt(fidEl.title, 10);
      }
    }

    // Track the maximum slot number that has any usage
    if (r > 0 && slot > max_slot) {
      max_slot = slot;
    }
  }

  const loopsEl = document.getElementById("loops") as HTMLInputElement | null;
  const loops = parseFloat(loopsEl?.value || "1") || 1;

  // Calculate number of slots in 4-slot increments (4, 8, 12, 16, 20, 24, 28, 32)
  // If user forced a slot count, use it directly (don't round up)
  // Otherwise, round up based on max_slot
  let num_slots: number;
  if (forcedSlotCount > 0) {
    // User explicitly expanded - use exact forced count
    num_slots = Math.min(32, forcedSlotCount);
  } else {
    // Auto-calculate based on usage - round up to next multiple of 4
    const minSlots = Math.max(4, max_slot + 1);
    num_slots = Math.min(32, Math.ceil(minSlots / 4) * 4);
  }

  const used_m_scaled = Array.from({ length: num_slots }, (_, s) => (used_m[s] || 0) * loops);
  const used_g_scaled = Array.from({ length: num_slots }, (_, s) => (used_g[s] || 0) * loops);

  // Ensure the correct number of slot divs exist
  ensureSlotDivs(fil_stat, num_slots);

  for (let s = 0; s < num_slots; s++) {
    const m = used_m_scaled[s] || 0;
    const g = used_g_scaled[s] || 0;

    const div = fil_stat.querySelector<HTMLDivElement>(`:scope > div[title="${s + 1}"]`);
    if (!div) continue;

    // Save swatch (if present) before overwriting
    const sw = div.querySelector<HTMLDivElement>(":scope > .f_color");

    const mRounded = Math.round(m * 100) / 100;
    const gRounded = Math.round(g * 100) / 100;

    // Get material type for this slot
    const typeFirst = (slot_type_candidates[s] || []).find(Boolean) || div.dataset['f_type'] || "";
    // Show "N/A" if slot is empty (no usage)
    const materialDisplay = (m === 0 && g === 0) ? "N/A" : (typeFirst || "N/A");

    // Determine label format based on number of colors
    // Format: Slot #, Material, g, m (progressively reduced)
    let label: string;
    if (num_slots <= 4) {
      // 1-4 colors: "Slot 1 \n Material \n g \n m" (full display, no colon)
      label = `Slot ${s + 1} <br>${materialDisplay} <br> ${gRounded}g <br> ${mRounded}m`;
    } else if (num_slots <= 8) {
      // 5-8 colors: "Material \n g" (no "Slot X", no m)
      label = `${materialDisplay} <br> ${gRounded}g`;
    } else {
      // 9-32 colors: only "g" (minimal display - grams only, no material type)
      label = `${gRounded}g`;
    }

    // Rewrite content
    div.innerHTML = label;

    // Re-insert swatch at the top (if it existed)
    if (sw) {
      div.insertBefore(sw, div.firstChild);
      div.insertBefore(document.createElement("br"), sw.nextSibling);
    }

    // Dataset for export/picker
    div.dataset['used_m'] = String(mRounded);
    div.dataset['used_g'] = String(gRounded);
    div.dataset['f_type'] = typeFirst;

    // Store first tray_info_idx for this slot (if available)
    const trayIdxFirst = (slot_tray_info_idx[s] || []).find(Boolean) || "";
    div.dataset['trayInfoIdx'] = trayIdxFirst;

    // Optional: Dim slots without usage instead of hiding them
    div.style.opacity = (m === 0 && g === 0) ? "0.7" : "1";
  }

  // Call plate swatch repaint if available
  if (typeof window.repaintAllPlateSwatchesFromStats === "function") {
    window.repaintAllPlateSwatchesFromStats();
  }

  // Update expand button visibility - pass actual usage data
  updateExpandButtonVisibility(num_slots, used_g_scaled);
}

/**
 * Updates the visibility of the slot expansion button
 * Only show when ALL current slots are used AND we're at a multiple of 4 (not at 32)
 */
function updateExpandButtonVisibility(currentSlotCount: number, usedGrams: number[]): void {
  const fil_stat = document.getElementById("filament_total");
  if (!fil_stat) return;

  // Remove existing button if present
  let expandBtn = fil_stat.querySelector<HTMLDivElement>('.stats-expand-btn');

  // Check if all current slots are actually used (have any usage > 0)
  let allSlotsUsed = true;
  for (let i = 0; i < currentSlotCount; i++) {
    if ((usedGrams[i] || 0) === 0) {
      allSlotsUsed = false;
      break;
    }
  }

  // Show button only if:
  // 1. All current slots are used
  // 2. We're at a multiple of 4
  // 3. Not at max (32)
  const shouldShowButton = allSlotsUsed && currentSlotCount % 4 === 0 && currentSlotCount < 32;

  if (shouldShowButton) {
    // Create button if it doesn't exist
    if (!expandBtn) {
      expandBtn = document.createElement('div');
      expandBtn.className = 'stats-expand-btn';
      expandBtn.innerHTML = '+';
      expandBtn.title = 'Add 4 more slots';
      expandBtn.addEventListener('click', expandSlotCount);
      fil_stat.appendChild(expandBtn);
    }
  } else {
    // Remove button if it exists
    if (expandBtn) {
      expandBtn.remove();
    }
  }
}

/**
 * Expands the slot count to the next multiple of 4
 */
function expandSlotCount(): void {
  // Get current slot count from statistics
  const fil_stat = document.getElementById("filament_total");
  if (!fil_stat) return;

  const currentSlots = fil_stat.querySelectorAll(':scope > div[title]').length;
  // Calculate next multiple of 4 (e.g., 4→8, 8→12, 12→16, etc.)
  const newSlotCount = Math.min(32, Math.ceil((currentSlots + 1) / 4) * 4); // Cap at 32

  // Store forced slot count in state
  state.forcedSlotCount = newSlotCount;

  // Trigger update
  update_filament_usage();
}

/**
 * Ensure the correct number of slot divs exist in the container
 */
function ensureSlotDivs(host: HTMLElement, numSlots: number): void {
  // Check if we need to rebuild the slot structure
  const currentSlots = host.querySelectorAll<HTMLDivElement>(':scope > div[title]');
  const needRebuild = currentSlots.length !== numSlots;

  if (needRebuild) {
    // Save existing swatches before rebuilding
    const savedSwatches = new Map<string, HTMLDivElement>();
    currentSlots.forEach(div => {
      const slotNum = div.getAttribute('title');
      const swatch = div.querySelector<HTMLDivElement>(':scope > .f_color');
      if (slotNum && swatch) {
        savedSwatches.set(slotNum, swatch.cloneNode(true) as HTMLDivElement);
      }
    });

    // Clear and rebuild
    host.innerHTML = "";
    for (let i = 1; i <= numSlots; i++) {
      const div = document.createElement("div");
      div.setAttribute("title", String(i));

      // Restore swatch if it existed
      const savedSwatch = savedSwatches.get(String(i));
      if (savedSwatch) {
        div.appendChild(savedSwatch);
        div.appendChild(document.createElement("br"));
      }

      // Default content based on number of slots
      if (numSlots <= 4) {
        div.innerHTML += `Slot ${i} <br> N/A <br> 0.00g <br> 0.00m`;
      } else if (numSlots <= 8) {
        div.innerHTML += `N/A <br> 0.00g`;
      } else {
        div.innerHTML += `0.00g`;
      }

      host.appendChild(div);
    }
  }
}

/**
 * Update total weight and cost display
 */
export function update_total_weight_and_cost(): void {
  const totalWeightEl = document.getElementById("total_weight");
  const totalCostEl = document.getElementById("total_cost");
  const costPerKgInput = document.getElementById("cost_per_kg") as HTMLInputElement | null;
  const filStatEl = document.getElementById("filament_total");

  if (!totalWeightEl || !totalCostEl || !costPerKgInput || !filStatEl) return;

  let totalWeightGrams = 0;

  // Get all slot divs from filament statistics
  const slotDivs = filStatEl.querySelectorAll<HTMLDivElement>(':scope > div[title]');

  slotDivs.forEach(div => {
    const slotNum = parseInt(div.getAttribute('title') || "0", 10);
    if (!slotNum) return;

    const usedG = parseFloat(div.dataset['used_g'] || '0');
    if (usedG <= 0) return;

    totalWeightGrams += usedG;
  });

  // Get the user-specified cost per kg
  const userCostPerKg = parseFloat(costPerKgInput.value) || 25.4;

  // Calculate total cost based on total weight and user's cost per kg
  const totalCostValue = (totalWeightGrams / 1000) * userCostPerKg;

  // Update weight display
  totalWeightEl.innerText = totalWeightGrams.toFixed(1) + 'g';

  // Update cost display
  totalCostEl.innerText = '$' + totalCostValue.toFixed(2);

  // Set default cost per kg from the first found filament cost, or keep current value
  if (!costPerKgInput.dataset['userModified'] && totalWeightGrams > 0) {
    const firstEntry = (PRESET_INDEX || []).find(e => {
      const filamentId = e.settings?.filament_id;
      if (!filamentId) return false;
      // Check if this filament is used in any slot
      return Array.from(slotDivs).some(div => div.dataset['trayInfoIdx'] === filamentId);
    });

    if (firstEntry && firstEntry.settings?.filament_cost) {
      const defaultCost = parseFloat(firstEntry.settings.filament_cost[0] || '25.4');
      if (costPerKgInput.value !== String(defaultCost)) {
        costPerKgInput.value = defaultCost.toFixed(1);
      }
    }
  }
}

// Track when user manually modifies the cost per kg input
document.addEventListener('DOMContentLoaded', () => {
  const costPerKgInput = document.getElementById("cost_per_kg") as HTMLInputElement | null;
  if (costPerKgInput) {
    costPerKgInput.addEventListener('input', () => {
      costPerKgInput.dataset['userModified'] = 'true';
      update_total_weight_and_cost();
    });
  }
});
