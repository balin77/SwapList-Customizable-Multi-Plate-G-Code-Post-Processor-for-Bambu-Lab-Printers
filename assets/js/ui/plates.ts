/**
 * Plates module for managing plate list, coordinates, and drag-and-drop functionality
 */

import { state } from "../config/state.js";
import { update_statistics } from "../ui/statistics.js";
import { checkAutoToggleOverrideMetadata, hasOrphanedSlotsAfterRemoval, updatePlateImageColors } from "./filamentColors.js";
import { showWarning } from "./infobox.js";
import { autoPopulatePlateCoordinates } from "../utils/plateUtils.js";
import { updatePlateSelector, getObjectCoordsForPlate, duplicatePlateSettings } from "./settings.js";

/**
 * Read plate X coordinates sorted in descending order
 */
export function readPlateXCoordsSorted(li: HTMLElement): number[] {
  // Try to get plate index from the DOM
  const plates = document.querySelectorAll<HTMLElement>("#playlist_ol li.list_item:not(.hidden)");
  let plateIndex = -1;

  plates.forEach((plate, index) => {
    if (plate === li) {
      plateIndex = index;
    }
  });

  if (plateIndex >= 0) {
    // Get coordinates from new settings system
    const coords = getObjectCoordsForPlate(plateIndex);
    return coords
      .filter(v => Number.isFinite(v))
      .sort((a, b) => b - a);
  }

  // Fallback to old method if not found in settings
  const inputs = li.querySelectorAll<HTMLInputElement>(
    '.plate-x1p1-settings .obj-coords .obj-coord-row input.obj-x'
  );
  return Array.from(inputs)
    .map(inp => parseFloat(inp.value))
    .filter(v => Number.isFinite(v))
    .sort((a, b) => b - a);
}

/**
 * Validate plate X coordinates for X1/P1 printers
 */
export async function validatePlateXCoords(): Promise<boolean> {
  if (!(state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1')) {
    return true; // No validation needed in A1M mode
  }

  // Import here to avoid circular dependency
  let allSettings: Map<number, any> | null = null;
  try {
    // Use dynamic import to avoid circular dependencies
    const settingsModule = await import('../ui/settings.js');
    allSettings = settingsModule.getAllPlateSettings();
  } catch (error) {
    console.warn('Could not import settings module:', error);
  }
  let hasError = false;

  let firstErrorPlate = -1;
  let firstErrorCoordIndex = -1;

  if (allSettings && allSettings.size > 0) {
    // Validate using the new settings system
    allSettings.forEach((settings, plateIndex) => {
      if (settings.objectCoords && settings.objectCoords.length > 0) {
        settings.objectCoords.forEach((coord: number, coordIndex: number) => {
          if (!Number.isFinite(coord) || coord === 0) {
            hasError = true;
            console.warn(`Plate ${plateIndex}, object ${coordIndex + 1}: Invalid X coordinate (${coord})`);

            // Remember the first error for auto-selection
            if (firstErrorPlate === -1) {
              firstErrorPlate = plateIndex;
              firstErrorCoordIndex = coordIndex;
            }
          }
        });
      }
    });

    // If we found errors, select the first plate with errors and highlight the coordinate
    if (firstErrorPlate !== -1) {
      console.log(`Auto-selecting plate ${firstErrorPlate} with invalid coordinate at position ${firstErrorCoordIndex}`);

      // Import and call the plate selection function
      try {
        const settingsModule = await import('../ui/settings.js');

        // Select the problematic plate (this handles both visual selection and settings display)
        settingsModule.selectPlate(firstErrorPlate);

        // Wait a bit for the UI to update, then highlight the error
        setTimeout(() => {
          const plateSettings = document.getElementById("plate_specific_settings");
          if (plateSettings) {
            const inputs = Array.from(plateSettings.querySelectorAll<HTMLInputElement>('.obj-coords-grid .obj-x'));
            const errorInput = inputs[firstErrorCoordIndex];
            if (errorInput) {
              errorInput.classList.add('coord-error');
              setTimeout(() => errorInput.classList.remove('coord-error'), 5000);

              // Scroll to the problematic input field
              errorInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
          }
        }, 200);
      } catch (error) {
        console.error('Could not auto-select plate with error:', error);
      }
    }
  } else {
    // Fallback to old method if new settings not available
    const inputs = document.querySelectorAll<HTMLInputElement>('.plate-x1p1-settings .obj-coords input.obj-x, .obj-coords-grid input.obj-x');
    inputs.forEach(inp => {
      const val = parseFloat(inp.value);
      if (!Number.isFinite(val) || val === 0) {
        hasError = true;
        inp.classList.add('coord-error');
        setTimeout(() => inp.classList.remove('coord-error'), 5000);
      }
    });
  }

  if (hasError) {
    showWarning("Warning: Some X coordinates are missing (0). Please enter valid values before exporting.");
    return false; // Invalid
  }
  return true; // All OK
}

/**
 * Remove a plate from the list
 */
export function removePlate(btn: HTMLElement): void {
  const li = btn.closest<HTMLElement>("li.list_item");
  if (!li) return;

  // Check if removing this plate will orphan any slots before removal
  const hasOrphanedSlots = hasOrphanedSlotsAfterRemoval(li);

  // Remove plate from queue
  li.remove();

  // Recalculate stats
  if (typeof update_statistics === "function") update_statistics();

  // Auto-enable Override metadata if orphaned slots were found
  if (hasOrphanedSlots) {
    console.log("Auto-enabling OVERRIDE_METADATA due to orphaned slots after plate removal");
    state.OVERRIDE_METADATA = true;
    const checkbox = document.getElementById("opt_override_metadata") as HTMLInputElement | null;
    if (checkbox) checkbox.checked = true;
  } else {
    // Auto-disable Override metadata if no modified plates remain
    checkAutoToggleOverrideMetadata();
  }

  // Update plate selector
  updatePlateSelector();

  // If no plates remain → full reset
  const remaining = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)").length;
  if (remaining === 0) {
    // Complete reset (reloads page, resets PRINTER_MODEL etc.)
    location.reload();
  }
}

/**
 * Make a list sortable via drag and drop
 * © W.S. Toh – MIT license
 */
export function makeListSortable(target: HTMLElement): void {
  target.classList.add("slist");
  const items = target.getElementsByTagName("li");
  let current: HTMLElement | null = null;

  for (const i of Array.from(items)) {
    i.draggable = true;

    i.ondragstart = (_ev: DragEvent) => {
      current = i;
      if (current) {
        current.classList.add("targeted");
      }
      for (const it of Array.from(items)) {
        if (it !== current) { it.classList.add("hint"); }
      }
    };

    i.ondragenter = (_ev: DragEvent) => {
      if (i !== current) { i.classList.add("active"); }
    };

    i.ondragleave = () => {
      i.classList.remove("active");
    };

    i.ondragend = () => {
      for (const it of Array.from(items)) {
        it.classList.remove("hint");
        it.classList.remove("active");
        it.classList.remove("targeted");
      }
    };

    i.ondragover = (evt: DragEvent) => { evt.preventDefault(); };

    i.ondrop = (evt: DragEvent) => {
      evt.preventDefault();
      if (i !== current && current) {
        // Check if the current item was selected before moving
        const wasCurrentSelected = current.classList.contains("plate-selected");

        let currentpos = 0, droppedpos = 0;
        for (let it = 0; it < items.length; it++) {
          if (current === items[it]) { currentpos = it; }
          if (i === items[it]) { droppedpos = it; }
        }

        if (currentpos < droppedpos) {
          i.parentNode!.insertBefore(current, i.nextSibling);
        } else {
          i.parentNode!.insertBefore(current, i);
        }

        // If the moved item was selected, keep it selected after moving
        if (wasCurrentSelected) {
          // Remove selection from all plates first
          const allPlates = target.querySelectorAll<HTMLElement>("li.list_item:not(.hidden)");
          allPlates.forEach(plate => plate.classList.remove("plate-selected"));

          // Re-add selection to the moved plate
          current!.classList.add("plate-selected");

          // Update the selectedPlateIndex and reorder settings to match the new position
          const newIndex = Array.from(allPlates).indexOf(current!);
          if (newIndex >= 0) {
            // Import and update the selectedPlateIndex and reorder settings
            import('./settings.js').then(settingsModule => {
              // Reorder the plate settings to match the new positions
              settingsModule.reorderPlateSettings(currentpos, droppedpos);
              settingsModule.selectPlate(newIndex);
            }).catch(error => {
              console.warn("Could not update selected plate index after reordering:", error);
            });
          }
        }
      }
    };
  }
  console.log("list was made sortable");
}

/**
 * Render coordinate inputs (legacy function)
 */
export function renderCoordInputs(count: number, targetDiv?: HTMLElement): void {
  // targetDiv = container of current plate (e.g., el.querySelector('.object-coords'))
  if (!targetDiv) {
    // Global fallback container
    const fallback = document.querySelector<HTMLElement>('#x1p1-settings .obj-coords');
    if (!fallback) return;
    targetDiv = fallback;
  }

  targetDiv.innerHTML = "";
  const n = Math.max(1, Math.min(20, count | 0));

  for (let i = 1; i <= n; i++) {
    const wrap = document.createElement("div");
    wrap.className = "obj-coord";
    wrap.innerHTML = `
      <span class="coord-title">Object ${i}</span>
      <div class="coord-row">
        <label>X <input type="number" id="obj${i}-x" step="1" value="0" min="0" max="255"></label>
      </div>
    `;
    targetDiv.appendChild(wrap);
  }
}

/**
 * Render plate coordinate inputs
 */
export function renderPlateCoordInputs(li: HTMLElement, count: number): void {
  const coordsWrap = li.querySelector<HTMLElement>('.obj-coords');
  if (!coordsWrap) return;
  coordsWrap.innerHTML = "";

  const n = Math.max(1, Math.min(20, count | 0));
  for (let i = 1; i <= n; i++) {
    const row = document.createElement('div');
    row.className = 'obj-coord-row';
    row.innerHTML = `
      <b>Object ${i}</b>
      <label>X <input type="number" class="obj-x" step="1" value="0" min="0" max="255" data-obj="${i}"></label>
    `;
    coordsWrap.appendChild(row);
  }

  // Add auto-populate button BELOW the object list for X1/P1 modes
  if (state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1') {
    const autoBtn = document.createElement('button');
    autoBtn.type = 'button';
    autoBtn.className = 'btn-auto-coords';
    autoBtn.textContent = '📐 Auto-calculate from objects';
    autoBtn.title = 'Automatically calculate object count and X coordinates from plate data';
    autoBtn.onclick = () => {
      autoPopulatePlateCoordinates(li).catch(error => {
        console.error("Failed to auto-populate plate coordinates:", error);
      });
    };
    coordsWrap.appendChild(autoBtn);
  }
}

/**
 * Initialize plate X1/P1 UI
 */
export function initPlateX1P1UI(li: HTMLElement): void {
  const box = li.querySelector<HTMLElement>('.plate-x1p1-settings');
  if (box) {
    const isX1P1 = (state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1');
    box.classList.toggle('hidden', !isX1P1);   // Set visibility correctly
  }

  const sel = li.querySelector<HTMLSelectElement>('.obj-count');
  if (!sel) return;

  // Initial
  renderPlateCoordInputs(li, parseInt(sel.value || "1", 10));

  // On change
  sel.addEventListener('change', (e) => {
    renderPlateCoordInputs(li, parseInt((e.target as HTMLSelectElement).value || "1", 10));
  });

  // Note: Auto-populate is now handled in read3mf.js after plate data is fully loaded
}

/**
 * Install plate buttons (duplicate, remove)
 */
export function installPlateButtons(li: HTMLElement): void {
  const img = li.querySelector<HTMLImageElement>('.p_icon');
  if (!img) return;

  let wrap = img.parentElement;
  if (!wrap || !wrap.classList.contains('p_imgwrap')) {
    wrap = document.createElement('div');
    wrap.className = 'p_imgwrap';
    img.parentNode!.insertBefore(wrap, img);
    wrap.appendChild(img);
  }

  if (!wrap.querySelector('.plate-duplicate')) {
    const btn = document.createElement('button');
    btn.className = 'plate-duplicate';
    btn.type = 'button';
    btn.title = 'Duplicate this plate';
    btn.textContent = '+';
    wrap.appendChild(btn);
  }
}

/**
 * Deep copy datasets from source to target element
 */
function deepCopyDatasets(sourceEl: HTMLElement, targetEl: HTMLElement): void {
  // Copy all dataset properties of the main element
  if (sourceEl.dataset && targetEl.dataset) {
    for (const key in sourceEl.dataset) {
      targetEl.dataset[key] = sourceEl.dataset[key];
    }
  }

  // Copy the cached lighting mask if present (p_icon specific)
  if ((sourceEl as any)._cachedLightingMask && sourceEl.classList.contains('p_icon')) {
    Object.defineProperty(targetEl, '_cachedLightingMask', {
      value: (sourceEl as any)._cachedLightingMask,
      writable: false,
      enumerable: false,
      configurable: true
    });
  }

  // Recursive for all child elements
  const sourceChildren = sourceEl.children;
  const targetChildren = targetEl.children;

  for (let i = 0; i < sourceChildren.length && i < targetChildren.length; i++) {
    deepCopyDatasets(sourceChildren[i] as HTMLElement, targetChildren[i] as HTMLElement);
  }
}

/**
 * Duplicate a plate
 */
export function duplicatePlate(li: HTMLElement): void {
  // Find the index of the original plate
  const plates = document.querySelectorAll<HTMLElement>("#playlist_ol li.list_item:not(.hidden)");
  let originalIndex = -1;
  plates.forEach((plate, index) => {
    if (plate === li) {
      originalIndex = index;
    }
  });

  const clone = li.cloneNode(true) as HTMLElement;
  clone.classList.remove('hidden');

  // Deep copy all dataset properties
  deepCopyDatasets(li, clone);

  // Copy plate time values explicitly
  const originalTime = li.getElementsByClassName("p_time")[0] as HTMLElement | undefined;
  const cloneTime = clone.getElementsByClassName("p_time")[0] as HTMLElement | undefined;
  if (originalTime && cloneTime) {
    cloneTime.innerText = originalTime.innerText;
    cloneTime.title = originalTime.title;
  }

  // Install button/wrapper in clone
  installPlateButtons(clone);

  // Plate-specific UI (X1/P1 coordinate select listeners etc.)
  initPlateX1P1UI(clone);

  // Insert at the end of the list instead of right after the original
  li.parentNode!.appendChild(clone);

  // Duplicate settings to the new plate index (will be at the end)
  const newPlateIndex = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)").length - 1;
  if (originalIndex >= 0) {
    duplicatePlateSettings(originalIndex, newPlateIndex);
    console.log(`Duplicating plate ${originalIndex} to new index ${newPlateIndex}`);
  }

  // Recalculate statistics (color logic remains unchanged)
  update_statistics();

  // Update plate selector after adding new plate
  updatePlateSelector();

  // Re-apply sortable functionality to include the new duplicated plate
  makeListSortable(li.parentNode as HTMLElement);

  // Update plate image with current color mapping
  setTimeout(() => {
    updatePlateImageColors(clone).catch(error => {
      console.error("Failed to update duplicated plate image colors:", error);
    });
  }, 100);

  // Auto-populate coordinates for duplicated plate (same as original)
  if (state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1') {
    setTimeout(() => {
      autoPopulatePlateCoordinates(clone).catch(error => {
        console.error("Failed to auto-populate duplicated plate coordinates:", error);
      });
    }, 200); // Small delay to ensure UI is ready
  }
}
