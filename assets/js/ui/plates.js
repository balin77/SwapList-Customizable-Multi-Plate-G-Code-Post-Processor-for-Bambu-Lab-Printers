// /src/ui/plates.js

import { state } from "../config/state.js";
import { update_statistics } from "../ui/statistics.js";

export function readPlateXCoordsSorted(li) {
  const inputs = li.querySelectorAll(
    '.plate-x1p1-settings .obj-coords .obj-coord-row input.obj-x'
  );
  return [...inputs]
    .map(inp => parseFloat(inp.value))
    .filter(v => Number.isFinite(v))
    .sort((a, b) => b - a);
}

export function validatePlateXCoords() {
  if (!(state.CURRENT_MODE === 'X1' || state.CURRENT_MODE === 'P1')) {
    return true; // Im A1M-Modus keine Prüfung nötig
  }

  const inputs = document.querySelectorAll('.plate-x1p1-settings .obj-coords input.obj-x');
  let hasError = false;

  inputs.forEach(inp => {
    const val = parseFloat(inp.value);
    if (!Number.isFinite(val) || val === 0) {
      hasError = true;

      // kurz rot highlighten
      inp.classList.add('coord-error');
      setTimeout(() => inp.classList.remove('coord-error'), 5000);
    }
  });

  if (hasError) {
    alert("Warning: Some X coordinates are missing (0). Please enter valid values before exporting.");
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

  // Wenn keine Platten mehr vorhanden → volle Rücksetzung
  const remaining = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)").length;
  if (remaining === 0) {
    // kompletter Reset (lädt Seite neu, setzt CURRENT_MODE usw. zurück)
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
  const n = Math.max(1, Math.min(5, count | 0));

  for (let i = 1; i <= n; i++) {
    const wrap = document.createElement("div");
    wrap.className = "obj-coord";
    wrap.innerHTML = `
      <span class="coord-title">Object ${i}</span>
      <div class="coord-row">
        <label>X <input type="number" id="obj${i}-x" step="1" value="0"></label>
      </div>
    `;
    targetDiv.appendChild(wrap);
  }
}

export function renderPlateCoordInputs(li, count) {
  const coordsWrap = li.querySelector('.obj-coords');
  if (!coordsWrap) return;
  coordsWrap.innerHTML = "";

  const n = Math.max(1, Math.min(5, count | 0));
  for (let i = 1; i <= n; i++) {
    const row = document.createElement('div');
    row.className = 'obj-coord-row';
    row.innerHTML = `
      <b>Object ${i}</b>
      <label>X <input type="number" class="obj-x" step="1" value="0" data-obj="${i}"></label>
    `;
    coordsWrap.appendChild(row);
  }
}

export function initPlateX1P1UI(li) {
  const box = li.querySelector('.plate-x1p1-settings');
  if (box) {
    const isX1P1 = (state.CURRENT_MODE === 'X1' || state.CURRENT_MODE === 'P1');
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

export function duplicatePlate(li){
  const clone = li.cloneNode(true);
  clone.classList.remove('hidden');

  // Button/Wrapper im Klon installieren
  installPlateButtons(clone);

  // Plate-spezifische UI (X1/P1 Koordinaten Select-Listener etc.)
  initPlateX1P1UI(clone);

  // Nach dem Original einfügen
  li.parentNode.insertBefore(clone, li.nextSibling);

  // Statistik neu berechnen (Farblogik bleibt unverändert)
  update_statistics();
}

