// "use strict";

var my_files = [];

//var result = document.getElementById("result");
var fileInput;

var li_prototype;

var playlist_ol;

var p_scale;

//var ams_max;
var ams_max_file_id;

var enable_md5 = true;

var open_in_bbs = false;

var last_file = false;

var instant_processing = false;

// Printing mode: "A1M" (default) or "X1P1"
var CURRENT_MODE = null;  // "A1M" | "X1" | "P1" | null
var USE_PURGE_START = false;
var USE_BEDLEVEL_COOLING = false; // default: aus

const PRINTER_MODEL_MAP = {
  "Bambu Lab X1 Carbon": "X1",
  "Bambu Lab X1":        "X1",
  "Bambu Lab X1E":       "X1",
  "Bambu Lab A1 mini":   "A1M",
  "Bambu Lab P1S":       "P1",
  "Bambu Lab P1P":       "P1",
};

function parsePrinterModelFromGcode(gtext){
  const m = gtext.match(/^[ \t]*;[ \t]*printer_model\s*=\s*(.+)$/mi);
  if (!m) return null;
  const raw = m[1].trim();

  if (/^Bambu Lab X1(?: Carbon|E)?$/i.test(raw)) return "X1";
  if (/^Bambu Lab A1 mini$/i.test(raw))          return "A1M";
  if (/^Bambu Lab P1(?:S|P)$/i.test(raw))        return "P1";
  return "UNSUPPORTED"; // alles andere
}

function ensureModeOrReject(detectedMode, fileName){
  if (detectedMode === "UNSUPPORTED" || !detectedMode){
    alert(`This printer model is not supported yet in this app (file: ${fileName}).`);
    return false;
  }

  if (CURRENT_MODE == null){
    setMode(detectedMode);
    // Radios visuell spiegeln (falls sichtbar)
    const map = { A1M:'mode_a1m', X1:'mode_x1', P1:'mode_p1' };
    const rb = document.getElementById(map[detectedMode]);
    if (rb) rb.checked = true;
    return true;
  }

  if (CURRENT_MODE !== detectedMode){
    alert(
      `Printer mismatch.\nLoaded queue is ${CURRENT_MODE}, new file is ${detectedMode}.\n`+
      `The new plate will not be added.`
    );
    return false;
  }
  return true;
}

function modeFromPrinterModel(model){
  return model ? PRINTER_MODEL_MAP[model] || null : null;
}

// Prüft den GCode-Text auf einen erkennbaren Druckermodus und setzt/validiert CURRENT_MODE
function setMode(mode) {
  CURRENT_MODE = mode;
  document.body.setAttribute("data-mode", mode);

  const isX1P1 = (mode === 'X1' || mode === 'P1');

  const mo = document.getElementById('mode_options');
  const xset = document.getElementById('x1p1-settings');

  if (mo) mo.classList.toggle('hidden', !isX1P1);
  if (xset) xset.classList.toggle('hidden', !isX1P1);

  if (isX1P1) {
    const sel = document.getElementById('object-count');
    renderCoordInputs(parseInt((sel && sel.value) ? sel.value : "1", 10));
  }

  // Per-plate X1/P1-Sektionen zeigen/verstecken
  document.querySelectorAll('.plate-x1p1-settings').forEach(el => {
    el.classList.toggle('hidden', !isX1P1);
  });

  console.log("Mode switched to:", mode);
}

function _escRe(s) { return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"); }



function toggle_settings(state) {
  document.getElementById("settings_wrapper").style.display = state ? "table-cell" : "none";
}

// run initialisation after the page was loaded
window.addEventListener("DOMContentLoaded", () => {
  initialize_page();
});

// Eingabefelder für Koordinaten generieren
function renderCoordInputs(count, targetDiv) {
  // targetDiv = container der aktuellen Plate (z.B. el.querySelector('.object-coords'))
  if (!targetDiv) return;

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

function initialize_page() {

  // mode toggle listeners
  var mA1 = document.getElementById('mode_a1m');
  var mX1 = document.getElementById('mode_x1');
  var mP1 = document.getElementById('mode_p1');
  if (mA1 && mX1 && mP1){
    // Deaktivieren: nur noch per detect → setMode()
    mA1.disabled = true;
    mX1.disabled = true;
    mP1.disabled = true;

    // Optional: Tooltip
    mA1.title = mX1.title = mP1.title = "Printer mode is set automatically from the loaded file(s).";

  }
  // Purge-Checkbox
  var chkPurge = document.getElementById('opt_purge');
  if (chkPurge) {
    chkPurge.addEventListener('change', () => {
      USE_PURGE_START = chkPurge.checked;
      console.log("USE_PURGE_START:", USE_PURGE_START);
    });
    USE_PURGE_START = chkPurge.checked;
  }

  // Cooling-Bedlevel Checkbox
  var chkCool = document.getElementById('opt_bedlevel_cooling');
  if (chkCool) {
    chkCool.addEventListener('change', () => {
      USE_BEDLEVEL_COOLING = chkCool.checked;
      console.log("USE_BEDLEVEL_COOLING:", USE_BEDLEVEL_COOLING);
    });
    USE_BEDLEVEL_COOLING = chkCool.checked; // initial übernehmen (default false)
  }


  // nach dem Radiobutton-Setup & setMode(...):

  const objectCountSel = document.getElementById("object-count");
  if (objectCountSel) {
    // initial
    renderCoordInputs(parseInt(objectCountSel.value || "1", 10));
    // on change
    objectCountSel.addEventListener("change", e => {
      renderCoordInputs(parseInt(e.target.value || "1", 10));
    });
  }

  fileInput = document.getElementById("file");
  li_prototype = document.getElementById("list_item_prototype");
  playlist_ol = document.getElementById("playlist_ol");
  err = document.getElementById("err");
  p_scale = document.getElementById("progress_scale");

  update_progress(-1);

  const app_body = document.body;
  //app_body.addEventListener("dragover", focusDropzone());

  const drop_zone = document.getElementById("drop_zone");
  const drop_zone_instant = document.getElementById("drop_zone_instant");

  ['dragend', 'dragleave', 'drop'].forEach(evt => {
    drop_zone.addEventListener(evt, dragOutHandler);
    drop_zone_instant.addEventListener(evt, dragOutHandler);
  });

  drop_zone.addEventListener("dragover", (e) => dragOverHandler(e, e.target));
  [...drop_zone.children].forEach(child => {
    child.addEventListener("dragover", (e) => dragOverHandler(e, e.target.parentElement));
  });

  drop_zone_instant.addEventListener("dragover", (e) => dragOverHandler(e, e.target));
  [...drop_zone_instant.children].forEach(child => {
    child.addEventListener("dragover", (e) => dragOverHandler(e, e.target.parentElement));
  });

  drop_zone_instant.addEventListener("drop", (e) => dropHandler(e, true));
  drop_zone.addEventListener("drop", (e) => dropHandler(e, false));

  drop_zone.addEventListener("click", () => {
    fileInput.click();
    instant_processing = false;
  });


  /*
  drop_zone_instant.addEventListener("click", () => {
    fileInput.click();
    instant_processing=true;});
  */

  fileInput.addEventListener("change", function (evt) {
    var files = evt.target.files;
    console.log("FILES:");
    console.log(files);

    for (var i = 0; i < files.length; i++) {
      if ((i + 1) == files.length) last_file = true;
      else last_file = false;
      handleFile(files[i]);
    }
    console.log("FILES processing done...");
  });
}

function getUserBedRaiseOffset() {
  const el = document.getElementById("raisebed_offset_mm");
  const v = el ? parseFloat(el.value) : 30;
  return Number.isFinite(v) ? Math.max(0, Math.min(200, v)) : 30;
}

function getCooldownTargetBedTemp() {
  const el = document.getElementById("cooldown_target_bed_temp");
  const v = el ? parseFloat(el.value) : 23;
  // wir erlauben 0..120°C
  return Number.isFinite(v) ? Math.max(0, Math.min(120, v)) : 23;
}

function dropHandler(ev, instant) {
  ev.preventDefault();

  Array.from(document.getElementsByClassName("drop_zone_active")).forEach(
    function (element, index, array) {
      element.classList.remove("drop_zone_active");
    });

  instant_processing = instant;

  if (ev.dataTransfer.items) {
    [...ev.dataTransfer.items].forEach((item, i) => {

      if (item.kind === "file") {
        const file = item.getAsFile();

        if ((i + 1) == ev.dataTransfer.items.length) last_file = true;
        else last_file = false;
        handleFile(file);
      }
    });

  } else {
    [...ev.dataTransfer.files].forEach((file, i) => {
      if ((i + 1) == ev.dataTransfer.files.length) last_file = true;
      else last_file = false;
      handleFile(file);
    });
  }
}

function focusDropzone() {
  document.getElementById("drop_zones_wrapper").classList.add("focused");
}

function defocusDropzone() {
  document.getElementById("drop_zones_wrapper").classList.remove("focused");
}

function dragOverHandler(ev, tar) {
  console.log("File(s) in drop zone");
  tar.classList.add("drop_zone_active");
  ev.preventDefault();
}

function dragOutHandler(ev) {
  ev.target.classList.remove("drop_zone_active");
  ev.preventDefault();
}

function update_progress(i){
  // p_scale zeigt auf #progress_scale
  if (i < 0){
    console.log("Progressbar:", i);
    p_scale.style.width = "0%";
    // wieder ausblenden
    p_scale.parentElement.style.opacity = "0";
  } else {
    // einblenden + Breite setzen
    p_scale.parentElement.style.opacity = "1";
    const pct = Math.max(0, Math.min(100, i|0));
    p_scale.style.width = pct + "%";
  }
}


const err_default = "Please use sliced files in *.3mf or *.gcode.3mf formats. Usage of plane *.gcode files is not supported."
const err00 = "File not readable. " + "\n" + err_default;
const err01 = "No sliced data found. " + "\n" + err_default;

function reject_file(msg) {
  alert(msg);
  my_files.pop();
}

function adj_field_length(trg, min, max) {
  if (trg.value == "")
    trg_val = trg.placeholder;
  else
    trg_val = trg.value;

  trg.style.width = Math.min(max, (Math.max(min, trg_val.length + 2))) + 'ch';
}

function custom_file_name(trg) {
  if (trg.value == "") {
    trg.value = trg.placeholder;
    trg.select();
  }
}

function renderPlateCoordInputs(li, count) {
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


function initPlateX1P1UI(li) {
  const sel = li.querySelector('.obj-count');
  if (!sel) return;
  // initial
  renderPlateCoordInputs(li, parseInt(sel.value || "1", 10));
  // on change
  sel.addEventListener('change', (e) => {
    renderPlateCoordInputs(li, parseInt(e.target.value || "1", 10));
  });
}

const PUSH_START = ";<<< PUSH_OFF_EXECUTION_START";
const PUSH_END = ";>>> PUSH_OFF_EXECUTION_END";

function readPlateXCoordsSorted(li) {
  const inputs = li.querySelectorAll(
    '.plate-x1p1-settings .obj-coords .obj-coord-row input.obj-x'
  );
  return [...inputs]
    .map(inp => parseFloat(inp.value))
    .filter(v => Number.isFinite(v))
    .sort((a, b) => b - a);
}


// baut die 2-Zeilen-Sequenz für jede X-Koordinate
function buildPushOffSequence(xs) {
  if (!xs || !xs.length) return "";

  return xs.map(x => {
    const xOff = (x - 8).toFixed(2); // 2 Nachkommastellen, wenn du magst
    return [
      `G1 X${xOff} Y254 F1200`, // rausfahren hoch
      `G1 X${xOff} Y5 F300`,    // langsam runter
      `G1 X${xOff} Y254 F2000`  // schnell zurück
    ].join("\n");
  }).join("\n");
}

function parseMaxZHeight(gcodeStr) {
  const m = gcodeStr.match(/^[ \t]*;[ \t]*max_z_height:\s*([0-9]+(?:\.[0-9]+)?)/m);
  return m ? parseFloat(m[1]) : null; // mm
}

function buildPushOffPayload(gcode, ctx) {
  // ctx.coords: absteigend sortierte X‑Koordinaten je Platte
  const perObjectSeq = buildPushOffSequence(ctx.coords || []);

  // max_z_height aus dem Original‑Plate‑GCode lesen (oder ersatzweise aus gcode)
  const maxZ = parseMaxZHeight(ctx.sourcePlateText || gcode);
  const staircaseSeq = buildFixedPushOffMultiZ(maxZ);

  return [perObjectSeq, staircaseSeq].filter(Boolean).join("\n");
}


function buildRaiseBedAfterCooldownPayload(gcodeSection, ctx) {
  const src = ctx.sourcePlateText || gcodeSection || "";
  const header = (splitIntoSections(src).header || src);
  const maxZ = parseMaxZHeight(header);

  const offset = getUserBedRaiseOffset();         // ← Userwert (z.B. 30 mm)
  let targetZ = 1;
  if (Number.isFinite(maxZ)) {
    targetZ = Math.max(1, +(maxZ - offset).toFixed(1)); // eine Nachkommastelle
  }

  console.log("[raiseBedAfterCooldown] maxZ=", maxZ, "offset=", offset, "→ Z=", targetZ);

  return [
    ";=== Raise Bed Level (after cooldown) ===",
    "M400",
    `G1 Z${targetZ} F600`,
    "M400 P100"
  ].join("\n");
}

function buildCooldownFansWaitPayload(gcodeSection, ctx) {
  const target = getCooldownTargetBedTemp();         // z.B. 23 °C
  const sVal = Math.max(0, Math.round(target - 5)); // S = target − 5 (ganzzahlig)
  const lines = 40;  // Anzahl Wiederholungen wie bisher (~60 min Kommentar)

  const waits = Array.from({ length: lines }, () => `  M190 S${sVal} ; wait for bed temp`).join("\n");

  return `; ====== Cool Down =====
M106 P2 S255        ;turn Aux fan on
M106 P3 S200        ;turn on chamber cooling fan
M400

${waits}

M106 P2 S0         ;turn off Aux fan 
M106 P3 S0         ;turn off chamber cooling fan 
M400
;>>> Cooldown_fans_wait END`;
}


function resolveDynamicPayload(fnId, gcode, ctx) {
  switch (fnId) {
    case "raiseBedAfterCoolDown":
      return buildRaiseBedAfterCooldownPayload(gcode, ctx);
    case "cooldownFansWait":
      return buildCooldownFansWaitPayload(gcode, ctx);
    case "buildPushOffPayload":
      return buildPushOffPayload(gcode, ctx);
    default:
      return "";
  }
}


function buildFixedPushOffMultiZ(maxZmm) {
  if (!Number.isFinite(maxZmm)) return "";

  const XsDesc = [200, 150, 100, 50];         // absteigend
  const fmt = v => {
    const s = (Math.round(v * 1000) / 1000).toString();
    return s.replace(/(\.\d*?)0+$/, '$1').replace(/\.$/, '');
  };

  const Z_MIN = 1;    // mm
  const STEP = 30;   // mm (3 cm)
  const MAX_STEPS = 50; // harte Kappe, falls maxZ extrem groß ist

  const lines = [];
  let steps = 0;

  // erste Treppenstufe ist maxZ - 30mm, dann weiter runter
  for (let z = maxZmm - STEP; z > Z_MIN && steps < MAX_STEPS; z -= STEP, steps++) {
    lines.push(`;--- PUSH_OFF staircase at Z=${fmt(Math.max(z, Z_MIN))} mm ---`);
    lines.push(`G1 Z${fmt(Math.max(z, Z_MIN))} F600`);
    for (const X of XsDesc) {
      const xOff = fmt(X - 8);
      lines.push(`G1 X${xOff} Y254 F1000`);
      lines.push(`G1 X${xOff} Y5   F1000`);
      lines.push(`G1 X${xOff} Y254 F1000`);
    }
  }

  // falls die Schleife nie unter 1 mm kam, füge eine letzte Stufe bei 1 mm hinzu
  if (steps === 0 || (maxZmm - STEP) > Z_MIN) {
    lines.push(`;--- PUSH_OFF staircase at Z=${fmt(Z_MIN)} mm (floor) ---`);
    lines.push(`G1 Z${fmt(Z_MIN)} F600`);
    for (const X of XsDesc) {
      const xOff = fmt(X - 8);
      lines.push(`G1 X${xOff} Y254 F1000`);
      lines.push(`G1 X${xOff} Y5   F1000`);
      lines.push(`G1 X${xOff} Y254 F1000`);
    }
  }

  return lines.join("\n");
}

// ersetzt den Inhalt zwischen Start/End-Markern
function injectBetweenMarkers(gcode, startMark, endMark, content) {
  const s = gcode.indexOf(startMark);
  if (s === -1) return gcode;
  const e = gcode.indexOf(endMark, s);
  if (e === -1 || e < s) return gcode;

  const insertPos = s + startMark.length;
  const before = gcode.slice(0, insertPos);
  const after = gcode.slice(e);

  const needsNLBefore = before.length && before[before.length - 1] !== '\n';
  const needsNLAfter = after.length && after[0] !== '\n';

  const middle = (needsNLBefore ? "\n" : "") + (content.endsWith("\n") ? content : content + "\n");
  const tail = (needsNLAfter ? "\n" : "") + after;

  return before + middle + tail;
}

// M73 "Print finished" (wir lassen NUR den letzten im Gesamtergebnis stehen)
const M73_FINISH_RE = /^[ \t]*M73[ \t]+P100[ \t]+R0[^\n]*\n?/gmi;

// Entfernt ALLE Vorkommen
function removeAllM73FinishLines(g) {
  return g.replace(M73_FINISH_RE, "");
}

// Behält NUR das letzte Vorkommen; falls keins existiert, hängt eins am Ende an
function keepOnlyLastM73Finish(g) {
  const matches = [...g.matchAll(M73_FINISH_RE)];
  if (matches.length === 0) {
    return g.replace(/\s*$/, "") + "\nM73 P100 R0\n";
  }
  if (matches.length === 1) return g; // schon ok

  // Alle bis auf das letzte entfernen (ohne Index-Verschiebungsfehler -> Ranges zusammensetzen)
  const last = matches[matches.length - 1];
  const rangesToDrop = matches.slice(0, -1).map(m => [m.index, m.index + m[0].length]);

  let out = "";
  let cursor = 0;
  for (const [a, b] of rangesToDrop) {
    out += g.slice(cursor, a);
    cursor = b;
  }
  out += g.slice(cursor); // Rest inkl. letztem M73
  return out;
}

function validatePlateXCoords() {
  if (!(CURRENT_MODE === 'X1' || CURRENT_MODE === 'P1')) {
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

function removePlate(btn){
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

// read the content of 3mf file
function handleFile(f) {
  var current_file_id = my_files.length;
  const file_name_field = document.getElementById("file_name");
  if (current_file_id == 0) {
    file_name_field.placeholder = f.name.split(".gcode.").join(".").split(".3mf")[0];
  }
  else {
    file_name_field.placeholder = "mix"
  }
  adj_field_length(file_name_field, 5, 26);
  my_files.push(f);

  JSZip.loadAsync(f)
    .then(async function (zip) {
      parser = new DOMParser();

      var model_config_file = zip.file("Metadata/model_settings.config").async("text");
      var model_config_xml = parser.parseFromString(await model_config_file, "text/xml");
      const plateNode = model_config_xml.querySelector("[key='gcode_file']");

      if (!plateNode) { reject_file(err01); return; }

      const firstPlatePath = plateNode.getAttribute("value");
      if (!firstPlatePath) { reject_file(err01); return; }

      // Eine GCODE-Datei öffnen (reicht für Modelldetektion)
      const firstPlateText = await zip.file(firstPlatePath).async("text");
      const detectedMode   = parsePrinterModelFromGcode(firstPlateText);

      if (!ensureModeOrReject(detectedMode, f.name)) {
        // Frühe Rückkehr: nichts wurde in Arrays/UI eingefügt
        return;
      }

      var model_plates = model_config_xml.getElementsByTagName("plate");

      if (model_plates.length == 0) {
        reject_file(err01);
        return;
      }

      if (model_plates[0].querySelectorAll("[key='gcode_file']").length == 0) {
        reject_file(err01);
        return;
      }

      //change UI layout
      document.getElementById("drop_zones_wrapper").classList.add("mini_drop_zone");
      document.getElementById("action_buttons").classList.remove("hidden");
      document.getElementById("mode_switch").classList.remove("hidden");  // ← NEU
      document.getElementById("statistics").classList.remove("hidden");

      var slice_config_file = zip.file("Metadata/slice_info.config").async("text");
      var slicer_config_xml = parser.parseFromString(await slice_config_file, "text/xml");

      for (var i = 0; i < model_plates.length; i++) {
        (function () {
          const gcode_tag = model_plates[i].querySelectorAll("[key='gcode_file']");
          const plate_name = gcode_tag[0].getAttribute("value");
          if (plate_name == "") return;

          console.log("plate_name found", plate_name);

          var relativePath = zip.file(plate_name);
          if (!relativePath) return;

          var li = li_prototype.cloneNode(true);
          li.removeAttribute("id");
          playlist_ol.appendChild(li);
          initPlateX1P1UI(li);

          var f_name = li.getElementsByClassName("f_name")[0];
          var p_name = li.getElementsByClassName("p_name")[0];
          var p_icon = li.getElementsByClassName("p_icon")[0];
          var f_id = li.getElementsByClassName("f_id")[0];
          var p_time = li.getElementsByClassName("p_time")[0];
          var p_filaments = li.getElementsByClassName("p_filaments")[0];
          var p_filament_prototype = li.getElementsByClassName("p_filament_prototype")[0];

          li.classList.remove("hidden");

          f_name.textContent = f.name;
          f_name.title = f.name;

          p_name.textContent = plate_name.split("Metadata").join("").split(".gcode").join("");
          p_name.title = plate_name;

          f_id.title = current_file_id;
          f_id.innerText = "[" + current_file_id + "]";

          var icon_name = model_plates[i].querySelectorAll("[key='thumbnail_file']")[0].getAttribute("value");
          console.log("icon_name", icon_name);

          var img_file = zip.file(icon_name);
          console.log("img_file", img_file);

          img_file.async("blob").then(function (u8) {
            p_icon.src = URL.createObjectURL(u8);
          });

          var queryBuf = "[key='index'][value='" + (i + 1) + "']";
          var buf = slicer_config_xml.querySelectorAll(queryBuf);

          if (buf.length > 0)
            var config_filaments = buf[0].parentElement.getElementsByTagName("filament");
          else
            var config_filaments = slicer_config_xml.getElementsByTagName("plate")[0].getElementsByTagName("filament");

          var my_fl;

          for (var filament_id = 0; filament_id < config_filaments.length; filament_id++) {
            my_fl = p_filament_prototype.cloneNode(true);
            p_filaments.appendChild(my_fl);

            my_fl.getElementsByClassName("f_color")[0].style.backgroundColor = config_filaments[filament_id].getAttribute("color");
            my_fl.getElementsByClassName("f_color")[0].dataset.f_color = config_filaments[filament_id].getAttribute("color");
            my_fl.getElementsByClassName("f_slot")[0].innerText = config_filaments[filament_id].getAttribute("id");
            my_fl.getElementsByClassName("f_type")[0].innerText = config_filaments[filament_id].getAttribute("type");
            my_fl.getElementsByClassName("f_used_m")[0].innerText = config_filaments[filament_id].getAttribute("used_m");
            my_fl.getElementsByClassName("f_used_g")[0].innerText = config_filaments[filament_id].getAttribute("used_g");
            my_fl.className = "p_filament";
          }

          relativePath.async("string").then(async function (content) {

            const time_flag = "total estimated time: ";
            const time_place = content.indexOf(time_flag) + time_flag.length;
            const time_sting = content.slice(time_place, content.indexOf("\n", time_place));
            p_time.innerText = time_sting;

            var time_int = 0;

            var t = time_sting.match(/\d+[s]/);
            time_int = t ? parseInt(t) : 0;

            t = time_sting.match(/\d+[m]/);
            time_int += (t ? parseInt(t) : 0) * 60;

            t = time_sting.match(/\d+[h]/);
            time_int += (t ? parseInt(t) : 0) * 60 * 60;

            t = time_sting.match(/\d+[d]/);
            time_int += (t ? parseInt(t) : 0) * 60 * 60 * 24;

            p_time.title = await time_int;

            update_statistics();

            console.log("plate_name:" + relativePath.name + " time-string", time_sting);
          });
        })();
      }

      var filaments = slicer_config_xml.getElementsByTagName("filament");
      console.log("filaments.length", filaments.length);
      var max_id = 0;
      console.log("filaments:", filaments);

      for (var i = 0; i < filaments.length; i++) {
        if (filaments[i].id > max_id) max_id = filaments[i].id;
        console.log("filaments[i].id:", filaments[i].id);
        console.log("max_id:", max_id);
      }

      if (last_file) {
        makeListSortable(playlist_ol);
        if (instant_processing)
          export_3mf();
      }
    }, function (e) {
      var errorDiv = document.createElement("div");
      errorDiv.className = "alert alert-danger";
      errorDiv.textContent = "Error reading " + f.name + ": " + e.message;
      err.appendChild(errorDiv);
      reject_file(err00);
    });
}


function disableBetweenMarkers(gcode, start, end, { useRegex = false } = {}) {
  const esc = s => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const startRe = useRegex ? new RegExp(start, "m")
    : new RegExp(`(^|\\n)[ \\t]*${esc(start)}[^\n]*\\n`, "m");
  const mStart = gcode.match(startRe);
  if (!mStart) return gcode;
  const sIdx = (mStart.index ?? 0) + mStart[0].length;

  const endRe = useRegex ? new RegExp(end, "m")
    : new RegExp(`(^|\\n)[ \\t]*${esc(end)}[^\n]*\\n`, "m");
  const rest = gcode.slice(sIdx);
  const mEnd = rest.match(endRe);
  if (!mEnd) return gcode;
  const eIdx = sIdx + (mEnd.index ?? 0);

  // → Inhalt komplett entfernen
  return gcode.slice(0, sIdx) + gcode.slice(eIdx);
}


function isRuleActive(rule, ctx) {
  if (!rule || rule.enabled === false) return false;
  const w = rule.when || {};
  if (w.modes && w.modes.length && !w.modes.includes(ctx.mode)) return false;

  const requireTrue = w.requireTrue || [];
  const requireFalse = w.requireFalse || [];
  for (const id of requireTrue) {
    const el = document.getElementById(id);
    if (!el || !el.checked) return false;
  }
  for (const id of requireFalse) {
    const el = document.getElementById(id);
    if (el && el.checked) return false;
  }

  const onlyIf = rule.onlyIf || {};
  if (Number.isFinite(onlyIf.plateIndexGreaterThan) && !(ctx.plateIndex > onlyIf.plateIndexGreaterThan)) return false;
  if (Number.isFinite(onlyIf.plateIndexEquals) && !(ctx.plateIndex === onlyIf.plateIndexEquals)) return false;
  if (typeof onlyIf.isLastPlate === "boolean" && !(!!ctx.isLastPlate === onlyIf.isLastPlate)) return false;

  return true;
}



function _findLineAfterIndex(src, idx) {
  const nl = src.indexOf("\n", idx);
  return (nl === -1) ? src.length : nl + 1;
}

function _findLineStartBeforeIndex(src, idx) {
  const prevNl = src.lastIndexOf("\n", idx - 1);
  return (prevNl === -1) ? 0 : prevNl + 1;
}

function _matchLineRegex(raw, isRegex) {
  // Zeilenweise suchen; Ende darf \n ODER Dateiende sein.
  if (isRegex) return new RegExp(raw, "gm");
  return new RegExp(`(^|\\n)[ \\t]*${_escRe(raw)}[^\\n]*(?:\\r?\\n|$)`, "gm");
}

function _commentNonEmptyLines(block) {
  return block.split(/\r?\n/).map(line => line.trim() ? `; ${line}` : line).join("\n");
}

// Prepend-Block (idempotent, mit optionalen Markerhüllen)
function prependBlock(gcode, block, { guardId = "", wrapWithMarkers = true } = {}) {
  if (!block) return gcode;
  if (wrapWithMarkers && guardId && _alreadyInserted(gcode, guardId)) return gcode;

  let payload = block.replace(/\r\n/g, "\n");
  if (wrapWithMarkers && guardId) {
    payload = `;<<< INSERT:${guardId} START\n` + payload + `\n;>>> INSERT:${guardId} END\n`;
  }
  const needsNL = (gcode[0] && gcode[0] !== '\n') ? "\n" : "";
  return payload + needsNL + gcode;
}

// Anker-basiert hinter eine Zeile einfügen (first/last Vorkommen)
function insertAfterAnchor(gcode, anchor, payload, {
  useRegex = false, occurrence = "last", guardId = "", wrapWithMarkers = true
} = {}) {
  if (!payload) return gcode;

  const re = useRegex
    ? new RegExp(anchor, "gm")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(anchor)}[^\\n]*(\\n|$)`, "gm"); // ← (\n|$)

  let match = null;
  if (occurrence === "first") {
    match = re.exec(gcode);
  } else {
    let m, last = null;
    while ((m = re.exec(gcode)) !== null) {
      if (m[0].length === 0) break;
      last = m;
    }
    match = last;
  }
  if (!match) return gcode;

  const insertPos = match.index + match[0].length;
  let block = payload.replace(/\r\n/g, "\n");
  if (wrapWithMarkers && guardId) {
    if (_alreadyInserted(gcode, guardId)) return gcode;
    block = `;<<< INSERT:${guardId} START\n${block}\n;>>> INSERT:${guardId} END\n`;
  }
  return gcode.slice(0, insertPos) + block + gcode.slice(insertPos);
}


function disableSpecificLinesInRange(gcode, start, end, lines, { useRegex = false } = {}) {
  if (!Array.isArray(lines) || lines.length === 0) return gcode;
  const sRe = useRegex ? new RegExp(start, "m")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(start)}[^\\n]*\\n`, "m");
  const mS = gcode.match(sRe);
  if (!mS) return gcode;
  const sIdx = (mS.index ?? 0) + mS[0].length;

  const eRe = useRegex ? new RegExp(end, "m")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(end)}[^\\n]*\\n`, "m");
  const rest = gcode.slice(sIdx);
  const mE = rest.match(eRe);
  if (!mE) return gcode;
  const eIdx = sIdx + mE.index;

  const before = gcode.slice(0, sIdx);
  let middle = gcode.slice(sIdx, eIdx);
  const after = gcode.slice(eIdx);

  for (const raw of lines) {
    const lineRe = new RegExp(`(^|\\n)[ \\t]*${_escRe(raw)}[^\n]*(\\n|$)`, "m");
    middle = middle.replace(lineRe, ""); // Zeile komplett entfernen
  }
  return before + middle + after;
}


// Ersetzt die alte Version
function _matchLineRegex(raw, isRegex) {
  // Wir wollen IMMER zeilenweise suchen und lastIndex nutzen -> "gm".
  const pattern = isRegex
    ? raw
    : `(^|\\n)[ \\t]*${_escRe(raw)}[^\\n]*\\n`; // ganze Zeile mit Marker inkl. \n
  return new RegExp(pattern, "gm");
}

function disableInnerBetweenMarkers(gcode, opts) {
  const { start, end, innerStart, innerEnd, useRegex = false, innerUseRegex = false } = opts;
  const outerRange = _findRange(gcode, start, end, useRegex);
  if (!outerRange.found) return gcode;

  const before = gcode.slice(0, outerRange.sIdx);
  let middle = gcode.slice(outerRange.sIdx, outerRange.eIdx);
  const after = gcode.slice(outerRange.eIdx);

  // Reuse disableBetweenMarkers on the middle part
  middle = disableBetweenMarkers(middle, innerStart, innerEnd, { useRegex: innerUseRegex });

  return before + middle + after;
}



function buildRuleContext(plateIndex, extra = {}) {
  return {
    mode: CURRENT_MODE,
    plateIndex,
    totalPlates: extra.totalPlates ?? 0,
    isLastPlate: (extra.totalPlates ? plateIndex === extra.totalPlates - 1 : false),
    ...extra
  };
}


// ===== Section Split/Join =====

const RE_EXEC_START = /^[ \t]*;[ \t]*EXECUTABLE_BLOCK_START[^\n]*\n?/m;
const RE_START_END = /^[ \t]*;[ \t]*MACHINE_START_GCODE_END[^\n]*\n?/m;
const RE_END_START = /^[ \t]*;[ \t]*MACHINE_END_GCODE_START[^\n]*\n?/m;

function _lineEnd(src, idx) {
  if (idx < 0) return -1;
  const nl = src.indexOf("\n", idx);
  return (nl === -1) ? src.length : nl + 1;
}

/**
 * Schneidet gcode in: header, startseq, body, endseq.
 * - header:   [0 .. execIdx)                   (Marker nicht enthalten)
 * - startseq: [execIdx .. startEndLineEnd)     (EXEC.. inkl.; START_END inkl.)
 * - body:     [startEndLineEnd .. endStartIdx) (Zeilen nach START_END bis vor END_START)
 * - endseq:   [endStartIdx .. EOF]             (END_START inkl.)
 */
function splitIntoSections(gcode) {
  const mExec = RE_EXEC_START.exec(gcode);
  const execIdx = mExec ? mExec.index : -1;
  const execLineEnd = mExec ? _lineEnd(gcode, execIdx) : -1;

  const mStartEnd = RE_START_END.exec(gcode);
  const startEndIdx = mStartEnd ? mStartEnd.index : -1;
  const startEndLineEnd = mStartEnd ? _lineEnd(gcode, startEndIdx) : -1;

  const mEndStart = RE_END_START.exec(gcode);
  const endStartIdx = mEndStart ? mEndStart.index : -1;

  // Vollständiger, idealer Fall
  if (execIdx >= 0 && startEndLineEnd >= 0 && endStartIdx >= 0) {
    return {
      header: gcode.slice(0, execIdx),
      startseq: gcode.slice(execIdx, startEndLineEnd),
      body: gcode.slice(startEndLineEnd, endStartIdx),
      endseq: gcode.slice(endStartIdx)
    };
  }

  // Fallbacks – robust bleiben
  // 1) Wenn nur EXEC vorhanden → header + (Rest als start/body/end heuristisch)
  if (execIdx >= 0 && startEndLineEnd < 0 && endStartIdx < 0) {
    return {
      header: gcode.slice(0, execIdx),
      startseq: gcode.slice(execIdx),
      body: "",
      endseq: ""
    };
  }
  // 2) EXEC & START_END vorhanden
  if (execIdx >= 0 && startEndLineEnd >= 0 && endStartIdx < 0) {
    return {
      header: gcode.slice(0, execIdx),
      startseq: gcode.slice(execIdx, startEndLineEnd),
      body: gcode.slice(startEndLineEnd),
      endseq: ""
    };
  }
  // 3) Nur END_START gefunden → alles davor als body, ab Marker endseq
  if (execIdx < 0 && startEndLineEnd < 0 && endStartIdx >= 0) {
    return {
      header: "",
      startseq: "",
      body: gcode.slice(0, endStartIdx),
      endseq: gcode.slice(endStartIdx)
    };
  }
  // 4) Nichts erkannt → alles als body
  return { header: "", startseq: "", body: gcode, endseq: "" };
}

function joinSections(parts) {
  return (parts.header || "") + (parts.startseq || "") + (parts.body || "") + (parts.endseq || "");
}


// ===== Regel-Engine mit Abschnitt-Scopes =====

function applySwapRulesToGcode(gcode, rules, ctx) {
  let parts = splitIntoSections(gcode);

  // sortiert nach order (default 100)
  const sorted = (rules || []).slice().sort((a, b) => (a.order ?? 100) - (b.order ?? 100));
  console.log(`[SWAP_RULE] plate=${ctx.plateIndex} rules order:`, sorted.map(r => `${r.order ?? 100}:${r.id}`));

  const runOn = (src, rule) => {
    let out = src;
    const scope = rule.scope || "body";
    const extra = { scopeDetails: {} };

    try {
      switch (rule.action) {
        case "remove_lines_matching": {
          const matches = _countPattern(src, rule.pattern, rule.patternFlags || "gm");
          extra.matches = matches;
          out = removeLinesMatching(out, rule.pattern, rule.patternFlags || "gm");
          break;
        }
        case "keep_only_last_matching": {
          const matches = _countPattern(src, rule.pattern, rule.patternFlags || "gm");
          extra.matches = matches;
          out = keepOnlyLastMatching(out, rule.pattern, rule.patternFlags || "gm",
            rule.appendIfMissing || "");
          break;
        }
        case "prepend": {
          let payload = rule.payload || "";
          if (!payload && rule.payloadVar) payload = resolvePayloadVar(rule.payloadVar);
          extra.alreadyInserted = !!(rule.wrapWithMarkers !== false && rule.id && _alreadyInserted(src, rule.id));
          extra.payloadBytes = (payload || "").length;
          out = prependBlock(out, payload, { guardId: rule.id || "", wrapWithMarkers: rule.wrapWithMarkers !== false });
          break;
        }
        case "bump_first_extrusion_to_e3": {
          out = bumpFirstExtrusionToE3(out, ctx.plateIndex ?? -1);
          break;
        }
        case "disable_between": {
          const r = _findRange(out, rule.start, rule.end, !!rule.useRegex);
          extra.rangeFound = r.found;
          out = disableBetweenMarkers(out, rule.start, rule.end, { useRegex: !!rule.useRegex });
          break;
        }
        case "disable_lines": {
          const r = _findRange(out, rule.start, rule.end, !!rule.useRegex);
          extra.rangeFound = r.found;
          extra.lines = (rule.lines || []).length;
          out = disableSpecificLinesInRange(out, rule.start, rule.end, rule.lines || [], { useRegex: !!rule.useRegex });
          break;
        }
        case "disable_inner_between": {
          const r = _findRange(out, rule.start, rule.end, !!rule.useRegex);
          extra.outerRangeFound = r.found;
          extra.innerStartSeen = _countPattern(out, rule.innerStart, rule.innerUseRegex ? "m" : "gm") > 0;
          extra.innerEndSeen = _countPattern(out, rule.innerEnd, rule.innerUseRegex ? "m" : "gm") > 0;
          out = disableInnerBetweenMarkers(out, {
            start: rule.start,
            end: rule.end,
            useRegex: !!rule.useRegex,
            innerStart: rule.innerStart,
            innerEnd: rule.innerEnd,
            innerUseRegex: !!rule.innerUseRegex,
            allPairs: true
          });
          break;
        }
        case "insert_after": {
          let payload = rule.payload || "";
          if (!payload && rule.payloadFnId) payload = resolveDynamicPayload(rule.payloadFnId, out, ctx);
          extra.anchorFound = _hasAnchor(out, rule.anchor, !!rule.useRegex);
          extra.payloadBytes = (payload || "").length;
          const before = out;
          out = insertAfterAnchor(out, rule.anchor, payload, {
            useRegex: !!rule.useRegex,
            occurrence: rule.occurrence || "last",
            guardId: rule.id || "",
            wrapWithMarkers: rule.wrapWithMarkers !== false
          });
          if (out === before) extra.reason = extra.anchorFound ? "guardId_alreadyInserted_or_noChange" : "anchor_not_found";
          break;
        }
        default:
          extra.note = "unknown_action";
          break;
      }
    } catch (e) {
      extra.error = (e && e.message) ? e.message : String(e);
      console.error("[SWAP_RULE_ERROR]", { id: rule.id, action: rule.action, scope, plate: ctx.plateIndex, error: extra.error });
    }

    _logRule(rule, ctx, scope, src, out, extra);
    return out;
  };

  for (const rule of sorted) {
    const why = _ruleActiveWhy(rule, ctx);
    if (why !== "active") {
      console.debug("[SWAP_RULE] skipped", { id: rule.id, action: rule.action, plate: ctx.plateIndex, reason: why, scope: rule.scope || "body" });
      continue;
    }

    const scope = (rule.scope || "body");
    if (scope === "all") {
      const wholeBefore = joinSections(parts);
      const wholeAfter = runOn(wholeBefore, rule);
      parts = splitIntoSections(wholeAfter);
    } else if (scope === "header") {
      parts.header = runOn(parts.header, rule);
    } else if (scope === "startseq" || scope === "start" || scope === "start_sequence") {
      parts.startseq = runOn(parts.startseq, rule);
    } else if (scope === "body") {
      parts.body = runOn(parts.body, rule);
    } else if (scope === "endseq" || scope === "end" || scope === "end_sequence") {
      parts.endseq = runOn(parts.endseq, rule);
    } else {
      console.warn("[SWAP_RULE] unknown scope", { id: rule.id, scope, plate: ctx.plateIndex });
    }
  }

  return joinSections(parts);
}



async function export_3mf() {
  try {
    if (!validatePlateXCoords()) return;
    update_progress(5);
    console.log("--- export_3mf (rules) ---");

    // 1) Platten einsammeln (pre-loop) + X-Koords pro Platte
    const my_plates = playlist_ol.getElementsByTagName("li");
    const platesOnce = [];
    const coordsOnce = [];

    for (let i = 0; i < my_plates.length; i++) {
      const c_f_id = my_plates[i].getElementsByClassName("f_id")[0].title;
      const c_file = my_files[c_f_id];
      const c_pname = my_plates[i].getElementsByClassName("p_name")[0].title;
      const p_rep = my_plates[i].getElementsByClassName("p_rep")[0].value * 1;

      if (p_rep > 0) {
        const z = await JSZip.loadAsync(c_file);
        const plateText = await z.file(c_pname).async("text");
        const xsDesc = readPlateXCoordsSorted(my_plates[i]); // absteigend

        for (let r = 0; r < p_rep; r++) {
          platesOnce.push(plateText);
          coordsOnce.push(xsDesc);
        }
      }
    }

    if (platesOnce.length === 0) {
      alert("Keine aktiven Platten (Repeats=0).");
      update_progress(-1);
      return;
    }

    // 2) Regeln pro Platte anwenden (pre-loop)
    const totalPlates = platesOnce.length;
    let modifiedPerPlate = platesOnce.map((src, i) => {
      const ctx = buildRuleContext(i, {
        totalPlates,
        coords: coordsOnce[i] || [],
        sourcePlateText: src
      });

      // Beim Start jeder Platte (z.B. in export_3mf vor applySwapRulesToGcode):
      console.log(`\n===== RULE PASS for plate ${i + 1}/${totalPlates} (mode=${CURRENT_MODE}) =====`);
      return applySwapRulesToGcode(src, (window.SWAP_RULES || []), ctx);
    });

    // 3) Loops
    const loops = Math.max(1, (document.getElementById("loops").value * 1) || 1);
    let combinedPlates = [];
    for (let i = 0; i < loops; i++) combinedPlates = combinedPlates.concat(modifiedPerPlate);

    // 4) (Optional) AMS-Optimierung auf dem Endsatz
    if (typeof optimizeAMSBlocks === "function") {
      combinedPlates = optimizeAMSBlocks(combinedPlates);
    }

    // Der finale GCode-Inhalt, der in die 3MF kommt:
    const finalGcodeBlob = new Blob(combinedPlates, { type: 'text/x-gcode' });

    update_progress(25);

    // ---------- 5) Bestehendes 3MF als Basis laden und bereinigen ----------
    // Nimm die erste Datei als "Träger"
    const baseZip = await JSZip.loadAsync(my_files[0]);

    // alte Platten-GCodes entfernen
    const oldPlates = await baseZip.file(/plate_\d+\.gcode\b$/);
    oldPlates.forEach(f => baseZip.remove(f.name));

    // ggf. Custom-per-layer XML entfernen (wie in deinem Original)
    if (baseZip.file("Metadata/custom_gcode_per_layer.xml")) {
      await baseZip.remove("Metadata/custom_gcode_per_layer.xml");
    }

    // ---------- 6) project_settings.config vom "größten AMS-Slot"-File übernehmen ----------
    // (ams_max_file_id wird in update_filament_usage() gesetzt)
    const projZip = await JSZip.loadAsync(my_files[ams_max_file_id]);
    const projSettings = await projZip.file("Metadata/project_settings.config").async("text");
    baseZip.file("Metadata/project_settings.config", projSettings);

    // ---------- 7) model_settings & slice_info (eine Platte, Filamentliste) ----------
    // model_settings.config aus deiner Template-Konstante schreiben
    baseZip.file("Metadata/model_settings.config", model_settings_template);

    // slice_info.config einlesen & auf 1 Platte + Filamentstatistik reduzieren
    const sliceInfoStr = await baseZip.file("Metadata/slice_info.config").async("text");
    const slicer_config_xml = parser.parseFromString(sliceInfoStr, "text/xml");

    const platesXML = slicer_config_xml.getElementsByTagName("plate");
    while (platesXML.length > 1) platesXML[platesXML.length - 1].remove();

    const indexNode = platesXML[0].querySelector("[key='index']");
    if (indexNode) indexNode.setAttribute("value", "1");

    // Filamentliste mit deinen Stats neu aufbauen
    let filamentNodes = platesXML[0].getElementsByTagName("filament");
    while (filamentNodes.length > 0) filamentNodes[filamentNodes.length - 1].remove();

    const fil_stat_slots = document.getElementById("filament_total").childNodes;
    for (let i = 0; i < fil_stat_slots.length; i++) {
      const filament_tag = slicer_config_xml.createElement("filament");
      platesXML[0].appendChild(filament_tag);

      filament_tag.id = fil_stat_slots[i].title;
      filament_tag.setAttribute("type", fil_stat_slots[i].dataset.f_type);
      filament_tag.setAttribute("color", fil_stat_slots[i].dataset.f_color);
      filament_tag.setAttribute("used_m", fil_stat_slots[i].dataset.used_m);
      filament_tag.setAttribute("used_g", fil_stat_slots[i].dataset.used_g);
    }

    const s = new XMLSerializer();
    const tmp_str = s.serializeToString(slicer_config_xml);
    baseZip.file("Metadata/slice_info.config", tmp_str.replace(/></g, ">\n<"));

    // ---------- 8) neue Platte_1.gcode schreiben ----------
    baseZip.file("Metadata/plate_1.gcode", finalGcodeBlob);

    // ---------- 9) MD5 erzeugen & 3MF packen ----------
    let hash = "";
    await chunked_md5(enable_md5 ? finalGcodeBlob : new Blob([' ']), async (md5) => {
      hash = md5;
      baseZip.file("Metadata/plate_1.gcode.md5", hash);

      const zipBlob = await baseZip.generateAsync(
        { type: "blob", compression: "DEFLATE", compressionOptions: { level: 3 } },
        (meta) => update_progress(75 + Math.floor(20 * (meta.percent || 0) / 100))
      );

      const fnField = document.getElementById("file_name");
      const baseName = (fnField.value || fnField.placeholder || "output").trim();

      const url = URL.createObjectURL(zipBlob);
      download(baseName + ".swap.3mf", url);

      update_progress(100);
      setTimeout(() => update_progress(-1), 400);
    });

  } catch (err) {
    console.error("export_3mf failed:", err);
    alert("Export fehlgeschlagen: " + (err && err.message ? err.message : err));
    update_progress(-1);
  }
}

// findet erste G1-Zeile mit E und ersetzt den E-Wert durch 3
function forceFirstExtrusionTo3mm(gcode, plateIndex = -1) {
  const lines = gcode.split(/\r?\n/);

  // Regexe
  const reG1 = /^\s*G1\b/i;
  const reX = /\bX[-+]?\d*\.?\d+/i;
  const reY = /\bY[-+]?\d*\.?\d+/i;
  const reE = /\bE([-+]?\d*\.?\d+)/i; // capture E-Wert
  const reEsub = /\bE[-+]?\d*\.?\d+/i;  // zum Ersetzen

  let hit = -1;

  for (let i = 0; i < lines.length; i++) {
    const raw = lines[i];

    // komplette Kommentarzeilen überspringen
    if (/^\s*;/.test(raw)) continue;

    // Inline-Kommentar abtrennen (nur Code links vom ';' ansehen)
    const code = raw.split(';', 1)[0];

    if (!reG1.test(code)) continue;
    if (!reX.test(code) || !reY.test(code)) continue;

    const mE = code.match(reE);
    if (!mE) continue;

    const eVal = parseFloat(mE[1]);
    if (!Number.isFinite(eVal) || eVal <= 0) continue; // “erste Extrusion” => E > 0

    hit = i;
    break;
  }

  if (hit === -1) {
    console.warn(`[forceFirstExtrusionTo3mm] plate=${plateIndex} → keine passende G1‑Extrusion gefunden.`);
    return gcode;
  }

  const before = lines[hit];
  lines[hit] = lines[hit].replace(reEsub, 'E3');
  const after = lines[hit];

  // ausführlicher Log
  console.log(`[forceFirstExtrusionTo3mm] plate=${plateIndex} line=${hit + 1}`);
  console.log('  before:', before);
  console.log('   after:', after);

  return lines.join('\n');
}

function _countPattern(src, pattern, flags = "gm") {
  try { return [...src.matchAll(new RegExp(pattern, flags))].length; }
  catch (_) { return 0; }
}

function _hasAnchor(src, anchor, useRegex = false) {
  const re = useRegex
    ? new RegExp(anchor, "gm")
    : new RegExp(`(^|\\n)[ \\t]*${_escRe(anchor)}[^\\n]*(\\n|$)`, "gm"); // ← (\n|$)
  return re.test(src);
}

function _findRange(src, start, end, useRegex = false) {
  const esc = s => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const sRe = useRegex ? new RegExp(start, "m")
    : new RegExp(`(^|\\n)[ \\t]*${esc(start)}[^\\n]*\\n`, "m");
  const mS = src.match(sRe);
  if (!mS) return { found: false };
  const sIdx = (mS.index ?? 0) + mS[0].length;

  const eRe = useRegex ? new RegExp(end, "m")
    : new RegExp(`(^|\\n)[ \\t]*${esc(end)}[^\\n]*\\n`, "m");
  const rest = src.slice(sIdx);
  const mE = rest.match(eRe);
  if (!mE) return { found: false };
  return { found: true, sIdx, eIdx: sIdx + (mE.index ?? 0) };
}

function _logRule(rule, ctx, scope, before, after, extra = {}) {
  const applied = (after !== before);
  const delta = after.length - before.length;
  const payload = {
    id: rule.id, action: rule.action, scope,
    plate: ctx.plateIndex, totalPlates: ctx.totalPlates,
    mode: ctx.mode, isLastPlate: !!ctx.isLastPlate,
    applied, deltaBytes: delta,
    ...extra
  };
  // Erfolg -> info, sonst warn (noch sichtbar)
  (applied ? console.info : console.warn)("[SWAP_RULE]", payload);
}

function _ruleActiveWhy(rule, ctx) {
  // Nur fürs Loggen: warum inaktiv?
  const w = rule.when || {};
  if (w.modes && w.modes.length && !w.modes.includes(ctx.mode)) return "mode_mismatch";
  for (const id of (w.requireTrue || [])) { const el = document.getElementById(id); if (!el || !el.checked) return `requireTrue_missing:${id}`; }
  for (const id of (w.requireFalse || [])) { const el = document.getElementById(id); if (el && el.checked) return `requireFalse_blocked:${id}`; }
  const onlyIf = rule.onlyIf || {};
  if (Number.isFinite(onlyIf.plateIndexGreaterThan) && !(ctx.plateIndex > onlyIf.plateIndexGreaterThan)) return "plateIndexGreaterThan_false";
  if (Number.isFinite(onlyIf.plateIndexEquals) && !(ctx.plateIndex === onlyIf.plateIndexEquals)) return "plateIndexEquals_false";
  if (typeof onlyIf.isLastPlate === "boolean" && !(!!ctx.isLastPlate === onlyIf.isLastPlate)) return "isLastPlate_mismatch";
  return "active";
}



function disable_gcode_line(str, index) {
  if (index > str.length - 1) return str;
  return str.substring(0, index) + ";" + str.substring(index + 1);
}

function disable_gcode_block(str, index) {
  if (index > str.length - 1) return str;
  const block_end = str.substring(index).search(/\n[^\s]/);
  var replacement_string = "M109 S230 \n ;SWAP - AMS block removed";
  while (replacement_string.length < block_end - 1) { replacement_string += "/"; }
  replacement_string += "\n";
  return str.substring(0, index) + replacement_string + str.substring(index + block_end);
}

function disable_ams_block(str, index) {
  if (index > str.length - 1) return str;
  const rel = str.substring(index);
  const p = rel.indexOf("M621 S");
  if (p === -1) {
    // Kein Ende gefunden → nichts tun
    return str;
  }
  const block_end = str.substring(index).search("M621 S");
  var replacement_string = ";SWAP - AMS block removed";
  while (replacement_string.length < block_end - 1) { replacement_string += "/"; }
  replacement_string += ";";
  if (replacement_string.length > 2000) return str;
  else return str.substring(0, index) + replacement_string + str.substring(index + block_end);
}

function chunked_md5(my_content, callback) {
  var blobSlice = File.prototype.slice || File.prototype.mozSlice || File.prototype.webkitSlice,
    chunkSize = 2097152,
    chunks = Math.ceil(my_content.size / chunkSize),
    currentChunk = 0,
    spark = new SparkMD5.ArrayBuffer(),
    fileReader = new FileReader();

  fileReader.onload = function (e) {
    console.log('read chunk nr', currentChunk + 1, 'of', chunks);
    spark.append(e.target.result);
    currentChunk++;
    update_progress(25 + 50 / chunks * currentChunk);

    if (currentChunk < chunks) {
      loadNext();
    } else {
      var my_hash = spark.end();
      console.log('finished loading');
      console.info('computed hash', my_hash);
      callback(my_hash);
    }
  };

  fileReader.onerror = function () {
    console.warn('oops, something went wrong.');
  };

  function loadNext() {
    var start = currentChunk * chunkSize,
      end = ((start + chunkSize) >= my_content.size) ? my_content.size : start + chunkSize;

    fileReader.readAsArrayBuffer(blobSlice.call(my_content, start, end));
  }

  loadNext();
}

function _alreadyInserted(gcode, guardId) {
  if (!guardId) return false;
  const re = new RegExp(`(^|\\n)[ \\t]*;<<< INSERT:${_escRe(guardId)} START[ \\t]*\\n`, "m");
  return re.test(gcode);
}

function keepOnlyLastMatching(gcode, pattern, flags = "gm", appendIfMissing = "") {
  const re = new RegExp(pattern, flags);
  const matches = [...gcode.matchAll(re)];
  if (matches.length === 0) {
    if (appendIfMissing) {
      const nl = gcode.endsWith("\n") ? "" : "\n";
      return gcode + nl + appendIfMissing + "\n";
    }
    return gcode;
  }
  if (matches.length === 1) return gcode;

  // alle bis auf den letzten auskommentieren
  const last = matches[matches.length - 1];
  let out = "";
  let cursor = 0;
  for (let i = 0; i < matches.length - 1; i++) {
    const m = matches[i];
    out += gcode.slice(cursor, m.index);
    const original = m[0];
    const commented = original.replace(/^/m, "; ");
    out += commented;
    cursor = m.index + original.length;
  }
  out += gcode.slice(cursor);
  return out;
}

function bumpFirstExtrusionToE3(gcode, plateIndex = -1) {
  const lines = gcode.split(/\r?\n/);
  const reG1 = /^\s*G1\b/i;
  const reX = /\bX[-+]?\d*\.?\d+/i;
  const reY = /\bY[-+]?\d*\.?\d+/i;
  const reE = /\bE([-+]?\d*\.?\d+)/i;
  const reEsub = /\bE[-+]?\d*\.?\d+/i;

  let hit = -1;
  for (let i = 0; i < lines.length; i++) {
    const raw = lines[i];
    if (/^\s*;/.test(raw)) continue;
    const code = raw.split(';', 1)[0];
    if (!reG1.test(code)) continue;
    if (!reX.test(code) || !reY.test(code)) continue;
    const mE = code.match(reE);
    if (!mE) continue;
    const eVal = parseFloat(mE[1]);
    if (!Number.isFinite(eVal) || eVal <= 0) continue;
    hit = i; break;
  }
  if (hit === -1) return gcode;

  lines[hit] = lines[hit].replace(reEsub, 'E3');
  return lines.join('\n');
}

function resolvePayloadVar(varName) {
  const v = (window && window[varName]) || (globalThis && globalThis[varName]);
  return (typeof v === "string") ? v : "";
}

function removeLinesMatching(gcode, pattern, flags = "gm") {
  const re = new RegExp(pattern, flags);
  return gcode.replace(re, "");
}


function download(filename, datafileurl) {
  var element = document.createElement('a');
  console.log("datafileurl", datafileurl);
  element.setAttribute('href', datafileurl);
  element.setAttribute('download', filename);
  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
  console.log("download_started");
}

function update_statistics() {
  update_filament_usage();
  update_total_time();
}

function update_filament_usage() {
  var type = [];
  var used_m = [];
  var used_g = [];
  var f_type = [];
  var f_color = [];

  var ams_max = -1;

  const fil_stat = document.getElementById("filament_total");
  var my_fil_data = playlist_ol.getElementsByClassName("p_filament");

  console.log("my_fil_data.length: " + my_fil_data.length);
  console.log("my_fil_data", my_fil_data);

  for (var i = 0; i < my_fil_data.length; i++) {
    let slot = my_fil_data[i].getElementsByClassName("f_slot")[0].innerText - 1;
    if (!used_m[slot]) used_m[slot] = 0;
    if (!used_g[slot]) used_g[slot] = 0;

    let r = my_fil_data[i].parentElement.parentElement.getElementsByClassName("p_rep")[0].value * 1;
    console.log("repeats", r);

    used_m[slot] += r * my_fil_data[i].getElementsByClassName("f_used_m")[0].innerText;
    used_g[slot] += r * my_fil_data[i].getElementsByClassName("f_used_g")[0].innerText;
    f_type[slot] = my_fil_data[i].getElementsByClassName("f_type")[0].innerText;
    f_color[slot] = my_fil_data[i].getElementsByClassName("f_color")[0].dataset.f_color;

    console.log("slot", slot);
    console.log("f_used_m.innerText", 10 * my_fil_data[i].getElementsByClassName("f_used_m")[0].innerText);

    if (slot > ams_max && r > 0) {
      ams_max = slot;
      ams_max_file_id = my_fil_data[i].parentElement.parentElement.getElementsByClassName("f_id")[0].title;
      console.log("f_id element: ", my_fil_data[i].parentElement.parentElement.getElementsByClassName("f_id"));
      console.log("file id with highest AMS slot=", ams_max_file_id);
    }
  }

  const loops = document.getElementById("loops").value * 1;
  used_m = used_m.map(m => m * loops);
  used_g = used_g.map(g => g * loops);

  console.log("loops: ", loops);

  fil_stat.innerHTML = "";
  for (var e = 0; e < used_m.length; e++) {
    if (used_m[e] && used_g[e]) {
      var slot_stat = document.createElement("div");
      slot_stat.innerHTML = "Slot " + (e + 1) + ": <br>" + Math.round(used_m[e] * 100) / 100 + "m <br> " + Math.round(used_g[e] * 100) / 100 + "g";
      slot_stat.dataset.used_m = Math.round(used_m[e] * 100) / 100;
      slot_stat.dataset.used_g = Math.round(used_g[e] * 100) / 100;
      slot_stat.dataset.f_type = f_type[e];
      slot_stat.dataset.f_color = f_color[e];
      slot_stat.title = e + 1;
      fil_stat.appendChild(slot_stat);
    }
  }
}

function update_total_time() {
  const total_time = document.getElementById("total_time");
  const loops = document.getElementById("loops").value * 1;
  const used_plates_element = document.getElementById("used_plates");

  var used_plates = 0;
  var my_t = 0;

  var my_plates = playlist_ol.getElementsByTagName("li");

  for (var i = 0; i < my_plates.length; i++) {
    var p_rep = my_plates[i].getElementsByClassName("p_rep")[0].value;
    if (p_rep > 0) {
      var p_time = my_plates[i].getElementsByClassName("p_time")[0].title;
      my_t += p_rep * p_time;
      my_plates[i].classList.remove("inactive");
      used_plates += p_rep * 1;
    }
    else {
      my_plates[i].classList.add("inactive");
    }
  }

  used_plates *= loops;
  my_t *= loops;
  total_time.innerText = my_t.toDHMS();
  used_plates_element.innerText = used_plates;
}

Number.prototype.toDHMS = function () {
  var sec_num = this;
  var days = Math.floor(sec_num / (3600 * 24));
  var hours = Math.floor((sec_num - (days * 3600 * 24)) / 3600);
  var minutes = Math.floor((sec_num - (days * 3600 * 24) - (hours * 3600)) / 60);
  var seconds = sec_num - (days * 3600 * 24) - (hours * 3600) - (minutes * 60);
  return (days ? days + "d " : "") + (hours ? hours + "h " : "") + minutes + "m " + seconds + "s ";
}

/**
 * Make an li-list sortable.
 * © W.S. Toh – MIT license
 */
function makeListSortable(target) {
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
        i.parentNode.insertBefore(current, i.nextSibling);

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

async function collectPlateGcodesOnce() {
  const my_plates = playlist_ol.getElementsByTagName("li");
  const list = [];

  for (let i = 0; i < my_plates.length; i++) {
    const c_f_id = my_plates[i].getElementsByClassName("f_id")[0].title;
    const c_file = my_files[c_f_id];
    const c_p_name = my_plates[i].getElementsByClassName("p_name")[0].title;
    const p_rep = my_plates[i].getElementsByClassName("p_rep")[0].value * 1;

    if (p_rep > 0) {
      const z = await JSZip.loadAsync(c_file);
      const plateText = await z.file(c_p_name).async("text");
      for (let r = 0; r < p_rep; r++) list.push(plateText);
    }
  }
  // list = [GCODE-Plate, GCODE-Plate, …] in Reihenfolge & mit Wiederholungen
  return list;
}

// Loops anwenden (1..N)
function applyLoops(arr, loops) {
  let out = [];
  for (let i = 0; i < loops; i++) out = out.concat(arr);
  return out;
}

function optimizeAMSBlocks(gcodeArray) {
  // Defensive: falscher Typ -> nichts tun
  if (!Array.isArray(gcodeArray)) return gcodeArray;

  // Wir erkennen AMS-Swaps an "\nM620 S"
  const ams_flag = "\nM620 S";

  // Sammeln der Fundstellen
  const ams_flag_index = [];   // Index im jeweiligen String (Position des Buchstabens nach dem \n)
  const ams_flag_plate = [];   // Index der Platte (Element im Array)
  const ams_flag_value = [];   // Zahlenwert nach "M620 S" (z.B. 255, 0..3, ...)

  for (let plate = 0; plate < gcodeArray.length; plate++) {
    const g = gcodeArray[plate];
    let searchFrom = 0;
    while (true) {
      const idx = g.indexOf(ams_flag, searchFrom);
      if (idx === -1) break;

      // Index speichern (+1 wie im Original)
      ams_flag_index.push(idx + 1);
      ams_flag_plate.push(plate);

      // Wert extrahieren: substring ab "M620 S" (idx+7) bis 2–3 Ziffern bzw. bis Leerzeichen/Zeilenumbruch
      let raw = g.substring(idx + 7, idx + 10); // 2–3 Zeichen
      if (raw[2] === "\n" || raw[2] === " ") raw = raw.substring(0, 2);

      const val = parseInt(raw, 10);
      ams_flag_value.push(Number.isFinite(val) ? val : NaN);

      searchFrom = idx + 1;
    }
  }

  // Redundante AMS-Swaps entfernen:
  // Wie im Original: wenn wir eine Folge ... X, 255, X ... erkennen,
  // wird der 255-Block und der darauffolgende Block deaktiviert.
  for (let i = 0; i < ams_flag_value.length - 1; i++) {
    // Schutz gegen i-1 < 0 und i+1 >= length
    if (i === 0 || i + 1 >= ams_flag_value.length) continue;

    if (ams_flag_value[i] === 255 && ams_flag_value[i - 1] === ams_flag_value[i + 1]) {
      const plateA = ams_flag_plate[i];
      const plateB = ams_flag_plate[i + 1];
      const idxA = ams_flag_index[i];
      const idxB = ams_flag_index[i + 1];

      // Deaktivieren (ersetzt den AMS-Block durch kommentierte Platzhalter, siehe deine disable_ams_block)
      gcodeArray[plateA] = disable_ams_block(gcodeArray[plateA], idxA);
      gcodeArray[plateB] = disable_ams_block(gcodeArray[plateB], idxB);

      // Debug (optional)
      try {
        console.log("AMS swap redundancy removed at pair:", i,
          "plateA:", plateA, "plateB:", plateB);
      } catch (e) { }
    }
  }

  return gcodeArray;
}


async function export_gcode_txt() {
  if (!validatePlateXCoords()) return;   // Koordinaten-Check (nur X1/P1)
  try {
    update_progress(5);

    // 1) Platten einsammeln (pre-loop) + X-Koords pro Platte
    const my_plates = playlist_ol.getElementsByTagName("li");
    const platesOnce = [];
    const coordsOnce = [];

    for (let i = 0; i < my_plates.length; i++) {
      const c_f_id = my_plates[i].getElementsByClassName("f_id")[0].title;
      const c_file = my_files[c_f_id];
      const c_pname = my_plates[i].getElementsByClassName("p_name")[0].title;
      const p_rep = my_plates[i].getElementsByClassName("p_rep")[0].value * 1;

      if (p_rep > 0) {
        const z = await JSZip.loadAsync(c_file);
        const plateText = await z.file(c_pname).async("text");
        const xsDesc = readPlateXCoordsSorted(my_plates[i]); // absteigend

        for (let r = 0; r < p_rep; r++) {
          platesOnce.push(plateText);
          coordsOnce.push(xsDesc);
        }
      }
    }

    if (platesOnce.length === 0) {
      alert("Keine aktiven Platten (Repeats=0).");
      update_progress(-1);
      return;
    }

    // 2) Original (nur Loops, keine Modifikationen)
    const loops = Math.max(1, (document.getElementById("loops").value * 1) || 1);
    const originalLooped = applyLoops(platesOnce, loops);
    const originalCombined = originalLooped.join("\n");

    // 3) Regeln pro Platte anwenden (pre-loop)
    const totalPlates = platesOnce.length;
    let modifiedPerPlate = platesOnce.map((src, i) => {
      const ctx = buildRuleContext(i, {
        totalPlates,
        coords: coordsOnce[i] || [],
        sourcePlateText: src
      });
      console.log(`\n===== RULE PASS for plate ${i + 1}/${totalPlates} (mode=${CURRENT_MODE}) =====`);
      return applySwapRulesToGcode(src, (window.SWAP_RULES || []), ctx);
    });

    // 4) Loops auf die modifizierten Platten anwenden
    let modifiedLooped = applyLoops(modifiedPerPlate, loops);

    // 5) Optional: AMS-Optimierung auf dem Endsatz
    if (typeof optimizeAMSBlocks === "function") {
      modifiedLooped = optimizeAMSBlocks(modifiedLooped);
    }

    const modifiedCombined = modifiedLooped.join("\n");

    // 6) ZIP vorbereiten + schreiben
    update_progress(25);
    const file_name_field = document.getElementById("file_name");
    const base = (file_name_field.value || file_name_field.placeholder || "output_file_name").trim();
    const modeTag = (CURRENT_MODE || "A1M");
    const purgeTag = (CURRENT_MODE === 'X1' || CURRENT_MODE === 'P1') ? (USE_PURGE_START ? "_purge" : "_standard") : "";
    const stamp = new Date().toISOString().replace(/[:.]/g, "-");

    const zip = new JSZip();
    const root = zip.folder(`${base}_gcode_exports_${modeTag}${purgeTag}_${stamp}`);

    // Kombinierte Dateien
    root.file(`${base}_${modeTag}${purgeTag}_original_combined.txt`, originalCombined);
    root.file(`${base}_${modeTag}${purgeTag}_modified_combined.txt`, modifiedCombined);

    // Pro Platte (vor Loops) – Nummern 1..N
    const platesFolder = root.folder("per_plate_preloop");
    for (let i = 0; i < platesOnce.length; i++) {
      const idx = String(i + 1).padStart(2, "0");
      platesFolder.file(`plate_${idx}_original.txt`, platesOnce[i]);
      platesFolder.file(`plate_${idx}_modified.txt`, modifiedPerPlate[i]);
    }

    // Manifest
    const manifest = [
      `name: ${base}`,
      `mode: ${modeTag}${purgeTag}`,
      `loops: ${loops}`,
      `plates_preloop: ${platesOnce.length}`,
      `timestamp: ${stamp}`,
      `notes:`,
      `  - original_combined = nur Repeats+Loops, keine Modifikationen`,
      `  - modified_combined = ausschließlich via SWAP_RULES transformiert`,
      `  - per_plate_preloop = je Platte (vor Loops) original & modifiziert`,
      `  - keine Start/End/Push-Off/M73/A1M-Prepend Logik im Codepfad – alles per Regeln`,
      ``
    ].join("\n");
    root.file("manifest.txt", manifest);

    // 7) ZIP erstellen & downloaden
    update_progress(60);
    const zipBlob = await zip.generateAsync(
      { type: "blob", compression: "DEFLATE", compressionOptions: { level: 3 } },
      (meta) => { update_progress(60 + Math.floor(35 * (meta.percent || 0) / 100)); }
    );

    const zipUrl = URL.createObjectURL(zipBlob);
    download(`${base}_${modeTag}${purgeTag}_gcode_exports.zip`, zipUrl);

    update_progress(100);
    setTimeout(() => update_progress(-1), 500);
  } catch (err) {
    console.error("GCODE txt export failed:", err);
    alert("TXT-Export fehlgeschlagen: " + (err.message || err));
    update_progress(-1);
  }
}

