// /src/ui/plates.js

import { state } from "../config/state.js";
import { update_statistics } from "../ui/statistics.js";
import { checkAutoToggleOverrideMetadata } from "./filamentColors.js";
import { showWarning } from "./infobox.js";
import { autoPopulatePlateCoordinates } from "../utils/plateUtils.js";
import { updatePlateSelector, getObjectCoordsForPlate } from "./settings.js";

export function readPlateXCoordsSorted(li) {
  // Try to get plate index from the DOM
  const plates = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)");
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
  const inputs = li.querySelectorAll(
    '.plate-x1p1-settings .obj-coords .obj-coord-row input.obj-x'
  );
  return [...inputs]
    .map(inp => parseFloat(inp.value))
    .filter(v => Number.isFinite(v))
    .sort((a, b) => b - a);
}

export async function validatePlateXCoords() {
  if (!(state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1')) {
    return true; // Im A1M-Modus keine Prüfung nötig
  }

  // Import here to avoid circular dependency
  let allSettings = null;
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
        settings.objectCoords.forEach((coord, coordIndex) => {
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
            const inputs = plateSettings.querySelectorAll('.obj-coords-grid .obj-x');
            if (inputs[firstErrorCoordIndex]) {
              inputs[firstErrorCoordIndex].classList.add('coord-error');
              setTimeout(() => inputs[firstErrorCoordIndex].classList.remove('coord-error'), 5000);

              // Scroll to the problematic input field
              inputs[firstErrorCoordIndex].scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
          }
        }, 200);
      } catch (error) {
        console.error('Could not auto-select plate with error:', error);
      }
    }
  } else {
    // Fallback to old method if new settings not available
    const inputs = document.querySelectorAll('.plate-x1p1-settings .obj-coords input.obj-x, .obj-coords-grid input.obj-x');
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
    return false; // ungültig
  }
  return true; // alles ok
}

export function removePlate(btn) {
  const li = btn.closest("li.list_item");
  if (!li) return;

  // Plate aus der Queue entfernen
  li.remove();

  // Stats neu berechnen
  if (typeof update_statistics === "function") update_statistics();

  // Auto-disable Override metadata wenn keine modified plates mehr vorhanden
  checkAutoToggleOverrideMetadata();

  // Update plate selector
  updatePlateSelector();

  // Wenn keine Platten mehr vorhanden → volle Rücksetzung
  const remaining = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)").length;
  if (remaining === 0) {
    // kompletter Reset (lädt Seite neu, setzt PRINTER_MODEL usw. zurück)
    location.reload();
  }
}

/**
 * Make an li-list sortable.
 * © W.S. Toh – MIT license
 */
export function makeListSortable(target) {
  target.classList.add("slist");
  let items = target.getElementsByTagName("li"), current = null;

  for (let i of items) {
    i.draggable = true;

    i.ondragstart = (ev) => {
      current = i;
      current.classList.add("targeted");
      for (let it of items) {
        if (it != current) { it.classList.add("hint"); }
      }
    };

    i.ondragenter = (ev) => {
      if (i != current) { i.classList.add("active"); }
    };

    i.ondragleave = () => {
      i.classList.remove("active");
    };

    i.ondragend = () => {
      for (let it of items) {
        it.classList.remove("hint");
        it.classList.remove("active");
        it.classList.remove("targeted");
      }
    };

    i.ondragover = (evt) => { evt.preventDefault(); };

    i.ondrop = (evt) => {
      evt.preventDefault();
      if (i != current) {
        // Check if the current item was selected before moving
        const wasCurrentSelected = current.classList.contains("plate-selected");

        let currentpos = 0, droppedpos = 0;
        for (let it = 0; it < items.length; it++) {
          if (current == items[it]) { currentpos = it; }
          if (i == items[it]) { droppedpos = it; }
        }

        if (currentpos < droppedpos) {
          i.parentNode.insertBefore(current, i.nextSibling);
        } else {
          i.parentNode.insertBefore(current, i);
        }

        // If the moved item was selected, keep it selected after moving
        if (wasCurrentSelected) {
          // Remove selection from all plates first
          const allPlates = target.querySelectorAll("li.list_item:not(.hidden)");
          allPlates.forEach(plate => plate.classList.remove("plate-selected"));

          // Re-add selection to the moved plate
          current.classList.add("plate-selected");

          // Update the selectedPlateIndex and reorder settings to match the new position
          const newIndex = Array.from(allPlates).indexOf(current);
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

// Eingabefelder für Koordinaten generieren
export function renderCoordInputs(count, targetDiv) {
  // targetDiv = container der aktuellen Plate (z.B. el.querySelector('.object-coords'))
  if (!targetDiv) {
    // globaler Fallback-Container
    targetDiv = document.querySelector('#x1p1-settings .obj-coords');
    if (!targetDiv) return;
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

export function renderPlateCoordInputs(li, count) {
  const coordsWrap = li.querySelector('.obj-coords');
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

export function initPlateX1P1UI(li) {
  const box = li.querySelector('.plate-x1p1-settings');
  if (box) {
    const isX1P1 = (state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1');
    box.classList.toggle('hidden', !isX1P1);   // <- Sichtbarkeit korrekt setzen
  }

  const sel = li.querySelector('.obj-count');
  if (!sel) return;

  // initial
  renderPlateCoordInputs(li, parseInt(sel.value || "1", 10));

  // on change
  sel.addEventListener('change', (e) => {
    renderPlateCoordInputs(li, parseInt(e.target.value || "1", 10));
  });

  // Note: Auto-populate is now handled in read3mf.js after plate data is fully loaded
}

export function installPlateButtons(li){
  const img = li.querySelector('.p_icon');
  if (!img) return;

  let wrap = img.parentElement;
  if (!wrap || !wrap.classList.contains('p_imgwrap')) {
    wrap = document.createElement('div');
    wrap.className = 'p_imgwrap';
    img.parentNode.insertBefore(wrap, img);
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

function deepCopyDatasets(sourceEl, targetEl) {
  // Kopiere alle dataset-Eigenschaften des Hauptelements
  if (sourceEl.dataset && targetEl.dataset) {
    for (const key in sourceEl.dataset) {
      targetEl.dataset[key] = sourceEl.dataset[key];
    }
  }

  // Rekursiv für alle Kindelemente
  const sourceChildren = sourceEl.children;
  const targetChildren = targetEl.children;
  
  for (let i = 0; i < sourceChildren.length && i < targetChildren.length; i++) {
    deepCopyDatasets(sourceChildren[i], targetChildren[i]);
  }
}

export function duplicatePlate(li){
  const clone = li.cloneNode(true);
  clone.classList.remove('hidden');

  // Deep Copy aller dataset-Eigenschaften
  deepCopyDatasets(li, clone);

  // Kopiere plate time Werte explizit
  const originalTime = li.getElementsByClassName("p_time")[0];
  const cloneTime = clone.getElementsByClassName("p_time")[0];
  if (originalTime && cloneTime) {
    cloneTime.innerText = originalTime.innerText;
    cloneTime.title = originalTime.title;
  }

  // Button/Wrapper im Klon installieren
  installPlateButtons(clone);

  // Plate-spezifische UI (X1/P1 Koordinaten Select-Listener etc.)
  initPlateX1P1UI(clone);

  // Am Ende der Liste einfügen statt direkt nach dem Original
  li.parentNode.appendChild(clone);

  // Statistik neu berechnen (Farblogik bleibt unverändert)
  update_statistics();

  // Update plate selector after adding new plate
  updatePlateSelector();

  // Re-apply sortable functionality to include the new duplicated plate
  makeListSortable(li.parentNode);

  // Auto-populate coordinates for duplicated plate (same as original)
  if (state.PRINTER_MODEL === 'X1' || state.PRINTER_MODEL === 'P1') {
    setTimeout(() => {
      autoPopulatePlateCoordinates(clone).catch(error => {
        console.error("Failed to auto-populate duplicated plate coordinates:", error);
      });
    }, 200); // Small delay to ensure UI is ready
  }
}


