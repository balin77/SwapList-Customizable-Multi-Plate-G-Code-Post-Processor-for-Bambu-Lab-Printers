// /src/ui/filamentColors.js
import { state } from "../config/state.js";
import { update_statistics } from "../ui/statistics.js"; 

// ===== Defaults ===================================================
// nicht belegte Slots → grau
const DEFAULT_SLOT_COLORS = ["#cccccc", "#cccccc", "#cccccc", "#cccccc"];

// Neu: eine Zeile nach Statistikfarbe neu bemalen
export function repaintPlateRowBySlot(row){
  const sw   = row.querySelector(".f_color");
  const span = row.querySelector(".f_slot");
  const slot1 = parseInt(span?.textContent?.trim() || "1", 10) || 1;
  const idx = Math.max(0, Math.min(3, slot1-1));
  sw.style.background = getSlotColor(idx);    // <- Farbe aus Statistik
  sw.dataset.slotIndex = String(idx);
}

// Neu: ganze Plate neu bemalen
export function repaintPlateFromStats(li){
  li.querySelectorAll(".p_filaments .p_filament").forEach(repaintPlateRowBySlot);
}

// Neu: alle Plates neu bemalen
export function repaintAllPlateSwatchesFromStats(){
  document.querySelectorAll("li.list_item").forEach(repaintPlateFromStats);
}

function ensureP0() {
    const GA = state.GLOBAL_AMS;
    if (!GA.devices) GA.devices = [];
    if (!GA.devices[0]) {
        GA.devices[0] = {
            id: 0,
            slots: [0, 1, 2, 3].map(i => ({ key: `P0S${i}`, color: null, conflict: false, manual: false }))
        };
    } else {
        // forward-compat: fehlende Flags nachziehen
        GA.devices[0].slots.forEach(sl => { if (sl.manual == null) sl.manual = false; });
    }
    return GA.devices[0];
}


function toHexAny(c) {
    if (!c) return "";
    // bereits hex?
    if (/^#([0-9a-f]{3}|[0-9a-f]{6})$/i.test(c)) return c;
    // rgb/rgba -> hex
    const m = /rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/i.exec(c);
    if (m) {
        const [r, g, b] = m.slice(1).map(n => (+n).toString(16).padStart(2, "0"));
        return `#${r}${g}${b}`;
    }
    // Fallback über Canvas normalisieren
    const ctx = document.createElement("canvas").getContext("2d");
    ctx.fillStyle = "#000"; ctx.fillStyle = c;
    const std = ctx.fillStyle;
    if (/^#/.test(std)) return std;
    const m2 = /rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/i.exec(std);
    if (m2) {
        const [r, g, b] = m2.slice(1).map(n => (+n).toString(16).padStart(2, "0"));
        return `#${r}${g}${b}`;
    }
    return ""; // unbekannt
}

function getSwatchHex(el) {
    let c = el?.dataset?.f_color || el?.style?.backgroundColor || "";
    if (!c && el) c = getComputedStyle(el).backgroundColor;
    return toHexAny(c);
}


// --- AKTUALISIERT: globale Farbe setzen + beides nachziehen
export function setGlobalSlotColor(sIndex, hex) {
  const dev = ensureP0();
  const sl = dev.slots[sIndex];
  if (!sl) return;
  sl.color = toHexAny(hex);
  sl.manual = true;
  renderTotalsColors();                 // Statistics einfärben
  updateAllPlateSwatchColors();         // Plates nachziehen (nur background)
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

      if (!derived[idx]) derived[idx] = hex; // „erste gewinnt“
    });
  }

  for (let i = 0; i < 4; i++) {
    const sl = dev.slots[i];
    if (sl.manual) continue; // manuelle Overrides nicht überschreiben
    sl.color = derived[i] || DEFAULT_SLOT_COLORS[i];
    sl.conflict = false;
  }

  renderTotalsColors();
}



// ===== Plate-Swatches (Anzeige der SLOT-FARBE) ====================
// Ab jetzt zeigen die Plate-Swatches die Slotfarbe (global) – und NICHT mehr die reine Filamentfarbe.
// Bestehende Funktion: jetzt beim Sync direkt aus Statistik bemalen
export function syncPlateFilamentSwatches(li) {
  li.querySelectorAll(".p_filament").forEach(row => {
    const sw = row.querySelector(".f_color");
    const slotSpan = row.querySelector(".f_slot");
    if (!sw || !slotSpan) return;
    const slot1 = parseInt(slotSpan.textContent?.trim() || "1", 10) || 1;
    sw.dataset.slotIndex = String(Math.max(0, Math.min(3, slot1 - 1)));
  });
}



export function syncPlateFilamentSwatchesAlt(li){
  li.querySelectorAll(".p_filaments .p_filament").forEach(row => {
    const sw = row.querySelector(".f_color");
    const slotSpan = row.querySelector(".f_slot");
    const slot1 = parseInt(slotSpan?.textContent?.trim() || "1", 10) || 1;
    const idx = Math.max(0, Math.min(3, slot1-1));

    // WICHTIG: Original-Filamentfarbe merken, damit deriveGlobalSlotColorsFromPlates()
    // weiterhin von den eingelesenen Farben ableitet (nicht von der gepainteten Slotfarbe)
    if (!sw.dataset.f_color && sw.style.backgroundColor){
      sw.dataset.f_color = toHexAny(sw.style.backgroundColor);
    }

    sw.dataset.slotIndex = String(idx);
    sw.style.background  = getSlotColor(idx); // <- Sofort mit Statistikfarbe malen
  });
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

  // m/g in den Statistics auf den neuen Slot umbuchen
  update_statistics();
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

// ===== Alle Plate-Swatches anhand der Slotfarben einfärben =========
export function updateAllPlateSwatchColors() {
    const list = document.getElementById("playlist_ol");
    if (!list) return;
    list.querySelectorAll("li.list_item .p_filaments .p_filament").forEach(row => {
        const slotSpan = row.querySelector(".f_slot");
        const sw = row.querySelector(".f_color");
        if (!slotSpan || !sw) return;
        const slot1 = parseInt(slotSpan.textContent?.trim() || "1", 10) || 1;
        const idx = Math.max(0, Math.min(3, slot1 - 1));
        const hex = getSlotColor(idx);
        // Wichtig: NUR die Anzeige (background) ändern – dataset.f_color bleibt die Filamentfarbe!
        sw.style.background = hex;
    });
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

// ===== Auto-Fix: wenn update_statistics() DOM neu schreibt =======
export function installFilamentTotalsAutoFix() {
    const host = document.getElementById("filament_total"); if (!host) return;
    let pending = false;
    const obs = new MutationObserver(() => {
        if (pending) return;
        pending = true;
        requestAnimationFrame(() => {
            pending = false;
            deriveGlobalSlotColorsFromPlates(); // zuerst aus Plates ableiten
            renderTotalsColors();               // dann oben neu setzen
            updateAllPlateSwatchColors();       // und schließlich die Plates einfärben
        });
    });
    obs.observe(host, { childList: true, subtree: true });
}

// … oben: ensureP0(), toHexAny(), getSlotColor(), setGlobalSlotColor(), …

function setGlobalSlotMeta(sIndex, meta){
  const dev = ensureP0();
  const sl = dev.slots[sIndex];
  if (!sl) return;
  sl.meta = sl.meta || {};
  if (meta.color != null)  sl.color = toHexAny(meta.color);
  if (meta.type != null)   sl.meta.type = meta.type;
  if (meta.vendor != null) sl.meta.vendor = meta.vendor;
  sl.manual = true;
  renderTotalsColors();
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

// --- NEU: alle Plate-Swatches anhand der globalen Slotfarben neu einfärben
export function recolorAllPlateSwatchesFromGlobal() {
  document.querySelectorAll(".p_filaments .f_color").forEach(sw => {
    const idx = +(sw.dataset.slotIndex || 0);
    const hex = getSlotColor(idx);
    if (!hex) return;
    sw.style.background = hex;
    // NICHT: sw.dataset.f_color = hex;
  });
}

/** Öffnet den Dialog für Statistics-Slot */
export function openStatsSlotDialog(slotIndex){
  // aktuelle Werte
  const curColor  = getSlotColor(slotIndex);
  const dev = ensureP0();
  const sl  = dev.slots[slotIndex] || {};
  const curType   = sl.meta?.type || "PLA";
  const curVendor = sl.meta?.vendor || "Generic";

  const backdrop = document.createElement("div");
  backdrop.className = "slot-modal-backdrop";
  const modal = document.createElement("div");
  modal.className = "slot-modal";
  modal.innerHTML = `
    <h4>Slot ${slotIndex+1}</h4>
    <div class="row">
      <label>Farbe:</label>
      <input type="color" id="slotColor" value="${curColor}">
    </div>
    <div class="row">
      <label>Material:</label>
      <select id="slotType">
        ${["PLA","PETG","ABS","ASA","TPU","PC","PA","PVA","Other"].map(x =>
          `<option value="${x}" ${x===curType?"selected":""}>${x}</option>`).join("")}
      </select>
    </div>
    <div class="row">
      <label>Producer:</label>
      <select id="slotVendor">
        ${["Polymaker","Bambu Lab","eSun","Generic","Other"].map(x =>
          `<option value="${x}" ${x===curVendor?"selected":""}>${x}</option>`).join("")}
      </select>
    </div>
    <div class="actions">
      <button id="slotCancel">Cancel</button>
      <button id="slotSave">Save</button>
    </div>
  `;
  backdrop.appendChild(modal);
  document.body.appendChild(backdrop);

  const $ = sel => modal.querySelector(sel);
  $("#slotCancel").onclick = () => backdrop.remove();
  $("#slotSave").onclick = () => {
    const color  = $("#slotColor").value;
    const type   = $("#slotType").value;
    const vendor = $("#slotVendor").value;

    setGlobalSlotMeta(slotIndex, { color, type, vendor });

    // zusätzlich die aktuell sichtbare Statistics-Zeile aktualisieren,
    // damit export_3mf die Daten direkt aus dem DOM lesen kann:
    const box = document.querySelector(`#filament_total > div[title="${slotIndex+1}"]`);
    if (box) {
      box.dataset.f_color = toHexAny(color);
      box.dataset.f_type  = type;
      box.dataset.f_vendor = vendor;
    }

    backdrop.remove();
  };
}
