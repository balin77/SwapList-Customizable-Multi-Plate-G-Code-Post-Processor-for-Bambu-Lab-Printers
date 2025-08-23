// "use strict";

var my_files =[];

//var result = document.getElementById("result");
var fileInput;

var li_prototype;

var playlist_ol;

var p_scale;

//var ams_max;
var ams_max_file_id;

var enable_md5 = true;

var open_in_bbs = false;

var last_file=false;

var instant_processing=false;

// Printing mode: "A1M" (default) or "X1P1"
var CURRENT_MODE = "A1M";
var USE_PURGE_START = false;
var USE_BEDLEVEL_COOLING = false; // default: aus

function setMode(mode){
  CURRENT_MODE = mode;
  document.body.setAttribute("data-mode", mode);

  const isX1P1 = (mode === 'X1' || mode === 'P1');

  const mo   = document.getElementById('mode_options');
  const xset = document.getElementById('x1p1-settings');

  if (mo)   mo.classList.toggle('hidden', !isX1P1);
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


// Sequenzen holen (wirft, wenn nicht definiert)
function getSequences(mode, usePurge){
  const lib = (window.PRINTER_SEQUENCES || {})[mode];
  if (!lib) throw new Error("No sequences defined for mode: " + mode);

  const startTemplate = (lib.start || {}).template || "";
  const start = toggleNozzlePurgeInBlock(startTemplate, /*enable=*/usePurge);

  // End: egal ob 'template' oder 'standard' – zuerst nehmen was da ist
  const endTemplate = (lib.end || {}).template || (lib.end || {}).standard || "";
  const end = toggleCoolingBedlevelInBlock(endTemplate, /*enable=*/USE_BEDLEVEL_COOLING);

  return { start, end };
}


function toggle_settings(state){
	document.getElementById("settings_wrapper").style.display=state?"table-cell":"none";}

// run initialisation after the page was loaded
window.addEventListener("DOMContentLoaded", () => {
initialize_page();
});	

// Eingabefelder für Koordinaten generieren
function renderCoordInputs(count, targetDiv) {
  // targetDiv = container der aktuellen Plate (z.B. el.querySelector('.object-coords'))
  if (!targetDiv) return;

  targetDiv.innerHTML = "";
  const n = Math.max(1, Math.min(5, count|0));

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

function initialize_page()
{

	// mode toggle listeners
	var mA1 = document.getElementById('mode_a1m');
	var mX1 = document.getElementById('mode_x1');
	var mP1 = document.getElementById('mode_p1');
	if(mA1 && mX1 && mP1){
	  mA1.addEventListener('change', ()=> setMode('A1M'));
	  mX1.addEventListener('change', ()=> setMode('X1'));
	  mP1.addEventListener('change', ()=> setMode('P1'));
	  setMode(mA1.checked ? 'A1M' : (mX1.checked ? 'X1' : 'P1'));
	}

	// Purge-Checkbox
	var chkPurge = document.getElementById('opt_purge');
	if (chkPurge){
	  chkPurge.addEventListener('change', ()=> {
		USE_PURGE_START = chkPurge.checked;
		console.log("USE_PURGE_START:", USE_PURGE_START);
	  });
	  USE_PURGE_START = chkPurge.checked;
	}
	
	// Cooling-Bedlevel Checkbox
	var chkCool = document.getElementById('opt_bedlevel_cooling');
	if (chkCool){
	  chkCool.addEventListener('change', ()=> {
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

	const app_body=document.body;
	//app_body.addEventListener("dragover", focusDropzone());

	const drop_zone = document.getElementById("drop_zone");
	const drop_zone_instant = document.getElementById("drop_zone_instant");

	['dragend','dragleave','drop'].forEach( evt => {
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

	fileInput.addEventListener("change", function(evt) {
		var files = evt.target.files;
		console.log("FILES:");
		console.log(files);

		for (var i = 0; i < files.length; i++) {			
			if((i+1)== files.length) last_file=true;
			else last_file=false;
			handleFile(files[i]);			
		}
			console.log("FILES processing done...");
	});
}

function dropHandler(ev, instant) {
  ev.preventDefault();

  Array.from(document.getElementsByClassName("drop_zone_active")).forEach(
		function(element, index, array) {
			element.classList.remove("drop_zone_active");
		});

  instant_processing=instant;
  
  if (ev.dataTransfer.items) {
    [...ev.dataTransfer.items].forEach((item, i) => {

      if (item.kind === "file") {
        const file = item.getAsFile();
					
			if((i+1)== ev.dataTransfer.items.length) last_file=true;
			else last_file=false;
			handleFile(file);			
      }
    });
	
  } else {
    [...ev.dataTransfer.files].forEach((file, i) => {
			if((i+1)== ev.dataTransfer.files.length) last_file=true;
			else last_file=false;
			handleFile(file);	
    });
  }
}

function focusDropzone()
{
	document.getElementById("drop_zones_wrapper").classList.add("focused");
}

function defocusDropzone()
{
	document.getElementById("drop_zones_wrapper").classList.remove("focused");
}

function dragOverHandler(ev, tar) {
  console.log("File(s) in drop zone");
  tar.classList.add("drop_zone_active");
  ev.preventDefault();
}

function dragOutHandler (ev){
	ev.target.classList.remove("drop_zone_active");
	ev.preventDefault();
}

function update_progress(i)
{
console.log("progress at:", i);

if (i<0)
	{
	console.log("Progressbar: " + i );
	p_scale.style.width =0+"%";
	p_scale.parentElement.style.opacity =0;
	}
	else
   {p_scale.parentElement.style.opacity =1;
   p_scale.style.width =i+"%";}
}

const err_default = "Please use sliced files in *.3mf or *.gcode.3mf formats. Usage of plane *.gcode files is not supported."
const err00= "File not readable. " + "\n" + err_default;
const err01= "No sliced data found. " + "\n" + err_default;

function reject_file(msg)
{
	alert(msg);
	my_files.pop();
}

function adj_field_length(trg,min,max)
{
	if(trg.value=="")
		trg_val=trg.placeholder;
	else
	    trg_val=trg.value;

	trg.style.width = Math.min(max,(Math.max(min,trg_val.length + 2))) + 'ch';
}

function custom_file_name(trg){
	if(trg.value==""){
		trg.value=trg.placeholder;
		trg.select();
	}
}

function renderPlateCoordInputs(li, count) {
  const coordsWrap = li.querySelector('.obj-coords');
  if (!coordsWrap) return;
  coordsWrap.innerHTML = "";

  const n = Math.max(1, Math.min(5, count|0));
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
const PUSH_END   = ";>>> PUSH_OFF_EXECUTION_END";

function readPlateXCoordsSorted(li){
  const inputs = li.querySelectorAll(
    '.plate-x1p1-settings .obj-coords .obj-coord-row input.obj-x'
  );
  return [...inputs]
    .map(inp => parseFloat(inp.value))
    .filter(v => Number.isFinite(v))
    .sort((a,b) => b - a);
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

function parseMaxZHeight(gcodeStr){
  const m = gcodeStr.match(/^[ \t]*;[ \t]*max_z_height:\s*([0-9]+(?:\.[0-9]+)?)/m);
  return m ? parseFloat(m[1]) : null; // mm
}

function buildFixedPushOffMultiZ(maxZmm){
  if (!Number.isFinite(maxZmm)) return "";

  const XsDesc = [200,150,100,50];         // absteigend
  const fmt = v => {
    const s = (Math.round(v*1000)/1000).toString();
    return s.replace(/(\.\d*?)0+$/,'$1').replace(/\.$/, '');
  };

  const Z_MIN   = 1;    // mm
  const STEP    = 30;   // mm (3 cm)
  const MAX_STEPS = 50; // harte Kappe, falls maxZ extrem groß ist

  const lines = [];
  let steps = 0;

  // erste Treppenstufe ist maxZ - 30mm, dann weiter runter
  for (let z = maxZmm - STEP; z > Z_MIN && steps < MAX_STEPS; z -= STEP, steps++){
    lines.push(`;--- PUSH_OFF staircase at Z=${fmt(Math.max(z, Z_MIN))} mm ---`);
    lines.push(`G1 Z${fmt(Math.max(z, Z_MIN))} F600`);
    for (const X of XsDesc){
      const xOff = fmt(X - 8);
      lines.push(`G1 X${xOff} Y254 F1000`);
      lines.push(`G1 X${xOff} Y5   F1000`);
      lines.push(`G1 X${xOff} Y254 F1000`);
    }
  }

  // falls die Schleife nie unter 1 mm kam, füge eine letzte Stufe bei 1 mm hinzu
  if (steps === 0 || (maxZmm - STEP) > Z_MIN){
    lines.push(`;--- PUSH_OFF staircase at Z=${fmt(Z_MIN)} mm (floor) ---`);
    lines.push(`G1 Z${fmt(Z_MIN)} F600`);
    for (const X of XsDesc){
      const xOff = fmt(X - 8);
      lines.push(`G1 X${xOff} Y254 F2000`);
      lines.push(`G1 X${xOff} Y5   F2000`);
      lines.push(`G1 X${xOff} Y254 F2000`);
    }
  }

  return lines.join("\n");
}

// ersetzt den Inhalt zwischen Start/End-Markern
function injectBetweenMarkers(gcode, startMark, endMark, content){
  const s = gcode.indexOf(startMark);
  if (s === -1) return gcode;
  const e = gcode.indexOf(endMark, s);
  if (e === -1 || e < s) return gcode;

  const insertPos = s + startMark.length;
  const before = gcode.slice(0, insertPos);
  const after  = gcode.slice(e);

  const needsNLBefore = before.length && before[before.length-1] !== '\n';
  const needsNLAfter  = after.length  && after[0] !== '\n';

  const middle = (needsNLBefore ? "\n" : "") + (content.endsWith("\n") ? content : content + "\n");
  const tail   = (needsNLAfter ? "\n" : "") + after;

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
    return g.replace(/\s*$/,"") + "\nM73 P100 R0\n";
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

// read the content of 3mf file
function handleFile(f) {
		var current_file_id= my_files.length;
		const file_name_field=document.getElementById("file_name");
		if(current_file_id==0){
			file_name_field.placeholder= f.name.split(".gcode.").join(".").split(".3mf")[0];
		}
		else{
			file_name_field.placeholder= "mix"	
		}
		adj_field_length(file_name_field,5,26);
		my_files.push(f);
		
        JSZip.loadAsync(f)
            .then(async function(zip) {
				parser = new DOMParser();
				
				var model_config_file = zip.file("Metadata/model_settings.config").async("text");
				var model_config_xml = parser.parseFromString(await model_config_file,"text/xml");
				var model_plates= model_config_xml.getElementsByTagName("plate");

				if (model_plates.length==0) 
				{reject_file(err01);
					return;
				}

				if(model_plates[0].querySelectorAll("[key='gcode_file']").length==0)
				{reject_file(err01);
				return;
				}
                
                //change UI layout
				document.getElementById("drop_zones_wrapper").classList.add("mini_drop_zone");
                document.getElementById("action_buttons").classList.remove("hidden");
				document.getElementById("mode_switch").classList.remove("hidden");  // ← NEU
                document.getElementById("statistics").classList.remove("hidden");

				var slice_config_file = zip.file("Metadata/slice_info.config").async("text");
				var slicer_config_xml = parser.parseFromString(await slice_config_file,"text/xml");				
				
				for (var i=0; i< model_plates.length; i++){
					(function (){
						const gcode_tag=model_plates[i].querySelectorAll("[key='gcode_file']");
						const plate_name = gcode_tag[0].getAttribute("value");						
						if(plate_name=="") return;
							
						console.log("plate_name found",plate_name);
						
						var relativePath=zip.file(plate_name);
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
						f_name.title=f.name;
					
						p_name.textContent= plate_name.split("Metadata").join("").split(".gcode").join("");
						p_name.title=plate_name;

						f_id.title=current_file_id;
						f_id.innerText="["+current_file_id+"]";
						
						var icon_name = model_plates[i].querySelectorAll("[key='thumbnail_file']")[0].getAttribute("value");
						console.log("icon_name", icon_name);
						
						var img_file = zip.file(icon_name);
						console.log("img_file", img_file);
						
						img_file.async("blob").then(function (u8) {
						p_icon.src=URL.createObjectURL(u8);
						});
						
						var queryBuf="[key='index'][value='"+(i+1)+"']";
						var buf= slicer_config_xml.querySelectorAll(queryBuf);
						
						if(buf.length>0)
						var config_filaments=buf[0].parentElement.getElementsByTagName("filament");
						else
						var config_filaments=slicer_config_xml.getElementsByTagName("plate")[0].getElementsByTagName("filament");
						
						var my_fl;
						
						for (var filament_id=0; filament_id<config_filaments.length; filament_id++)
						{
						my_fl = p_filament_prototype.cloneNode(true);
						p_filaments.appendChild(my_fl);
						
						my_fl.getElementsByClassName("f_color")[0].style.backgroundColor =config_filaments[filament_id].getAttribute("color");
						my_fl.getElementsByClassName("f_color")[0].dataset.f_color=config_filaments[filament_id].getAttribute("color");
						my_fl.getElementsByClassName("f_slot")[0].innerText =config_filaments[filament_id].getAttribute("id");
						my_fl.getElementsByClassName("f_type")[0].innerText =config_filaments[filament_id].getAttribute("type");
						my_fl.getElementsByClassName("f_used_m")[0].innerText =config_filaments[filament_id].getAttribute("used_m");
						my_fl.getElementsByClassName("f_used_g")[0].innerText =config_filaments[filament_id].getAttribute("used_g");
						my_fl.className="p_filament";
						}
						
						relativePath.async("string").then(async function(content) {
							const time_flag = "total estimated time: ";
							const time_place =content.indexOf(time_flag)+time_flag.length;
							const time_sting = content.slice(time_place, content.indexOf("\n", time_place));
							p_time.innerText=time_sting;
							
							var time_int = 0;
							
							var t = time_sting.match(/\d+[s]/);					
							time_int=t?parseInt(t):0;
							
							t = time_sting.match(/\d+[m]/);					
							time_int+=(t?parseInt(t):0)*60;		

							t = time_sting.match(/\d+[h]/);					
							time_int+=(t?parseInt(t):0)*60*60;	

							t = time_sting.match(/\d+[d]/);					
							time_int+=(t?parseInt(t):0)*60*60*24;						
							
							p_time.title = await time_int;

							update_statistics();
							
							console.log("plate_name:" + relativePath.name + " time-string", time_sting);
							});
					})();
				}

				var filaments= slicer_config_xml.getElementsByTagName("filament");
				console.log("filaments.length", filaments.length);
				var max_id=0;
				console.log("filaments:", filaments);				
				
				for (var i=0; i< filaments.length; i++)
				{if(filaments[i].id>max_id) max_id=filaments[i].id;
				console.log("filaments[i].id:", filaments[i].id);
				console.log("max_id:", max_id);
				}
				
				if (last_file)
				{makeListSortable(playlist_ol);
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


// Comment/uncomment all lines between the markers.
// Idempotent: you can call it repeatedly.
function toggleNozzlePurgeInBlock(gcode, enable) {
  const START = /(^|\n)[ \t]*;<<<[ \t]*NOZZLE_PURGE_START[ \t]*\n/;
  const END   = /(^|\n)[ \t]*;>>>[ \t]*NOZZLE_PURGE_END[ \t]*\n/;

  const startMatch = gcode.match(START);
  if (!startMatch) return gcode; // markers not found -> nothing to do
  const startIdx = (startMatch.index ?? 0) + startMatch[0].length;

  const endMatch = gcode.slice(startIdx).match(END);
  if (!endMatch) return gcode; // unclosed -> bail
  const endIdx = startIdx + (endMatch.index ?? 0);

  const before = gcode.slice(0, startIdx);
  const block  = gcode.slice(startIdx, endIdx);
  const after  = gcode.slice(endIdx);

  // normalize newlines
  const lines = block.replace(/\r\n?/g, "\n").split("\n");

  const processed = lines.map(line => {
    const trimmed = line.trim();
    if (!trimmed) return line; // keep empty lines as is
    if (enable) {
      // uncomment leading ';' (optionally followed by a space)
      return line.replace(/^[ \t]*;[ \t]?/, "");
    } else {
      // comment non-comment lines
      return (/^[ \t]*;/.test(line)) ? line : (";" + (line.startsWith(" ") ? "" : " ") + line);
    }
  }).join("\n");

  return before + processed + after;
}

// Kommentiert/ent-kommentiert den Block zwischen den Cooling-Markern.
function toggleCoolingBedlevelInBlock(gcode, enable){
  const START = /(^|\n)[ \t]*;<<<[ \t]*BEDLEVEL_TO_ZERO_FOR_COOLING_START[ \t]*\n/;
  const END   = /(^|\n)[ \t]*;>>>[ \t]*BEDLEVEL_TO_ZERO_FOR_COOLING_END[ \t]*\n/;

  const mStart = gcode.match(START);
  if (!mStart) return gcode;
  const startIdx = (mStart.index ?? 0) + mStart[0].length;

  const rest = gcode.slice(startIdx);
  const mEnd = rest.match(END);
  if (!mEnd) return gcode;

  const endIdx = startIdx + (mEnd.index ?? 0);
  const before = gcode.slice(0, startIdx);
  const block  = gcode.slice(startIdx, endIdx);
  const after  = gcode.slice(endIdx);

  const lines = block.replace(/\r\n?/g, "\n").split("\n");

  const processed = lines.map(line => {
    const trimmed = line.trim();
    if (!trimmed) return line; // Leerzeilen unverändert
    if (enable){
      // ent-kommentieren
      return line.replace(/^[ \t]*;[ \t]?/, "");
    } else {
      // kommentieren
      return (/^[ \t]*;/.test(line)) ? line : ("; " + line);
    }
  }).join("\n");

  return before + processed + after;
}

function toggleBedLevelingBlock(gcode, enable){
  const re = /(;<<< BED_LEVELING_START[\s\S]*?;>>> BED_LEVELING_END)/m;
  return enable ? gcode : gcode.replace(re, match => {
    return match.split("\n").map(line =>
      line.trim() ? ("; " + line) : line
    ).join("\n");
  });
}


// fester Marker (tolerant, erlaubt vorangestellte Spaces und Zusatztext am Ende der Zeile)
const START_END_MARKER_RE = /^[ \t]*;[ \t]*MACHINE_START_GCODE_END[^\n]*\n?/m;

function replaceStartUsingMixedAnchors(body, headerUnescaped, newStartBlock, label = "Start", N_ANCHOR = 32) {
  // Ende der *Header*-Zeile "; machine_start_gcode = ..." als Untergrenze
  const { index: hdrIdx } = readHeaderParamLineStrict(body, "machine_start_gcode");
  const hdrLineEnd = (() => {
    const nl = body.indexOf("\n", hdrIdx);
    return nl === -1 ? body.length : nl + 1;
  })();

  // 1) Start nur über Präfix (kanonisch) finden – ab NACH der Header-Zeile!
  const startOrig = findStartByHeaderPrefix(body, headerUnescaped, N_ANCHOR, /*fromOrig*/ hdrLineEnd);

  // 2) Ende via fester Marker (multiline) ab startOrig
  START_END_MARKER_RE.lastIndex = startOrig;
  const m = START_END_MARKER_RE.exec(body);
  if (!m) {
    console.warn(`[${label}] fester End‑Marker nicht gefunden (ab ${startOrig}).`);
    throw new Error(`${label}: fester End‑Marker "; MACHINE_START_GCODE_END" nicht gefunden`);
  }
  const endOrig = m.index + m[0].length;  // Markerzeile inkl. \n

  // 3) Ersatz bauen (normalize newline, genau eine Abschluss‑NL)
  const repBlock = (newStartBlock || "").replace(/\r\n/g, "\n").replace(/\r/g, "\n");
  const rep = repBlock.endsWith("\n") ? repBlock : (repBlock + "\n");

  // 4) Marker beibehalten (empfohlen)
  const keepMarker = true;
  if (keepMarker) {
    const markerLine = m[0];
    return body.slice(0, startOrig) + rep + markerLine + body.slice(endOrig);
  }
  return body.slice(0, startOrig) + rep + body.slice(endOrig);
}


// 1) baut eine kanonisierte Version + Mapping zurück auf Original-Indizes
function buildCanonicalWithMap(src){
  const out = [];
  const map = [];
  const N = src.length;
  let i = 0;
  const push = (ch, idx) => { out.push(ch); map.push(idx); };

  while (i < N){
    const c = src[i];

    if (c === '\r') { i++; continue; }

    // Spaces/Tabs -> ein ' '
    if (c === ' ' || c === '\t'){
      const s = i;
      while (i < N && (src[i] === ' ' || src[i] === '\t')) i++;
      push(' ', s);
      continue;
    }

    // Newline‑Cluster -> '\n'
    if (c === '\n'){
      const s = i;
      i++; // erstes \n
      while (i < N){
        const d = src[i];
        if (d === '\r' || d === ' ' || d === '\t' || d === '\n') { i++; continue; }
        break;
      }
      push('\n', s);
      continue;
    }

    push(c, i++);
  }
  return { canon: out.join(''), map };
}

// ====== Header -> Präfix/Suffix‑Anker ======
function getHeaderAnchors(headerUnescaped, N_ANCHOR = 32){
  const { canon } = buildCanonicalWithMap(headerUnescaped);
  const trimmed = canon.replace(/^[ \n]+|[ \n]+$/g, '');
  if (!trimmed) throw new Error("Header block is empty (after canonicalize)");

  // zwei Zeilen Präfix
  const lines = trimmed.split('\n');
  const pref2 = (lines[0] || '') + '\n' + (lines[1] || '');
  const prefix = pref2.slice(0, Math.min(N_ANCHOR, pref2.length));

  const suffix = trimmed.slice(-Math.min(N_ANCHOR, trimmed.length));
  return { prefix, suffix, canonFull: trimmed };
}

// findRegionByAnchors(body, headUnescaped, label, N_ANCHOR=32, fromOrig=0, preferLast=false)
function findRegionByAnchors(body, headUnescaped, label, N_ANCHOR = 32, fromOrig = 0, preferLast = false){
  // ---- exakter Treffer (selten): nur NACH fromOrig akzeptieren
  let exactIdx = body.indexOf(headUnescaped, fromOrig);
  if (exactIdx !== -1){
    return { startOrig: exactIdx, endOrig: exactIdx + headUnescaped.length };
  }

  // ---- kanonisch
  const { canon: bodyC, map: bodyMap } = buildCanonicalWithMap(body);
  const { prefix, suffix, canonFull }  = getHeaderAnchors(headUnescaped, N_ANCHOR);

  const fromCanon = origToCanonIndex(bodyMap, Math.max(0, fromOrig));

  // Finde entweder ersten gültigen Treffer (default) oder den letzten
  let bestPrefix = -1, bestSuffix = -1;

  if (!preferLast){
    const p = bodyC.indexOf(prefix, fromCanon);
    if (p === -1) throw new Error(`${label} body block not found (prefix)`);
    const s = bodyC.indexOf(suffix, p + prefix.length);
    if (s === -1) throw new Error(`${label} body block not found (suffix)`);
    bestPrefix = p; bestSuffix = s;
  } else {
    // iteriere alle Präfix-Vorkommen ab fromCanon und nimm das LETZTE, zu dem auch ein Suffix danach existiert
    let searchP = fromCanon;
    while (true){
      const p = bodyC.indexOf(prefix, searchP);
      if (p === -1) break;
      const s = bodyC.indexOf(suffix, p + prefix.length);
      if (s !== -1){ bestPrefix = p; bestSuffix = s; }
      searchP = p + 1;
    }
    if (bestPrefix === -1) throw new Error(`${label} body block not found (prefix/last)`);
    // bestSuffix ist garantiert gesetzt, sonst hätte es keinen gültigen Kandidaten gegeben
  }

  const startOrig = bodyMap[bestPrefix];
  const endCanonLast = bestSuffix + suffix.length - 1;
  const endOrig = Math.min(body.length, (bodyMap[endCanonLast] ?? (body.length - 1)) + 1);

  if (startOrig == null || !(startOrig < endOrig)){
    throw new Error(`${label} body block mapping failed`);
  }
  return { startOrig, endOrig };
}

// ===== nur den Header-Präfix im Body (kanonisch) finden – OHNE Suffix =====
function findStartByHeaderPrefix(body, headUnescaped, N_ANCHOR = 32, fromOrig = 0){
  const { canon: bodyC, map: bodyMap } = buildCanonicalWithMap(body);
  const { canon: headC }               = buildCanonicalWithMap(headUnescaped);

  const trimmed = headC.replace(/^[ \n]+|[ \n]+$/g, '');
  if (!trimmed) throw new Error("Header block is empty (after canonicalize)");

  const lines  = trimmed.split('\n');
  const pref2  = (lines[0] || '') + '\n' + (lines[1] || '');
  const prefix = pref2.slice(0, Math.min(N_ANCHOR, pref2.length));

  // ab fromOrig suchen (in kanonischem Raum ansetzen)
  const fromCanon = origToCanonIndex(bodyMap, Math.max(0, fromOrig));
  const prefixPos = bodyC.indexOf(prefix, fromCanon);
  if (prefixPos === -1) {
    console.warn("[findStartByHeaderPrefix] prefix not found:", JSON.stringify(prefix));
    throw new Error("Start body block not found (prefix-only)");
  }

  const startOrig = bodyMap[prefixPos];
  if (startOrig == null) throw new Error("Start mapping failed");
  return startOrig;
}




// ====== Tail mitfressen (End‑Marker) optional ======
// Frisst optionale Tail-Zeilen (M73..., ; EXECUTABLE_BLOCK_END...) – ohne den
// Zeilenumbruch NACH dem Block zu "verlieren", falls kein Tail folgt.
function extendTail(body, rawEnd){
  let end = rawEnd;

  // Start der nächsten Zeile ermitteln
  const nextNL = body.indexOf("\n", rawEnd);
  const nextLineStart = (nextNL === -1) ? body.length : (nextNL + 1);

  // Ab nächster Zeile nach Tail-Mustern suchen
  const tailRe = /^(?:M73[^\n]*|;\s*EXECUTABLE_BLOCK_END[^\n]*)\n?/my;
  tailRe.lastIndex = nextLineStart;

  const m = tailRe.exec(body);
  if (m && m.index === nextLineStart) {
    // Falls direkt Tail folgt, ggf. mehrere Tail-Zeilen schlucken
    let last = tailRe.lastIndex;
    while (true){
      tailRe.lastIndex = last;
      const n = tailRe.exec(body);
      if (!n || n.index !== last) break;
      last = tailRe.lastIndex;
    }
    end = last;
  }
  return end;
}

// Öffentliche Funktion: ersetzt Block per kurzen Prä-/Suffix-Ankern
function replaceBlockFromHeaderAnchors(body, headerUnescaped, newBlock, label, withTail=false, N_ANCHOR=32){
  const { startOrig, endOrig: rawEnd } =
    findRegionByAnchors(body, headerUnescaped, label, N_ANCHOR);

  const endOrig = withTail ? extendTail(body, rawEnd) : rawEnd;

  // Normalisiere \r\n -> \n und sorge für genau EINE Abschluss-Newline
  const repBlock = (newBlock || "").replace(/\r\n/g, "\n").replace(/\r/g, "\n");
  const rep = repBlock.endsWith("\n") ? repBlock : (repBlock + "\n");

  // Optionales Debug:
  // console.log(`[${label}] start=${startOrig}, rawEnd=${rawEnd}, end=${endOrig}`);

  return body.slice(0, startOrig) + rep + body.slice(endOrig);
}

// Ende der ersten Marker-Zeile (Start-Block) finden
function findEndOfStartMarker(body){
  const RE = /^[ \t]*;[ \t]*MACHINE_START_GCODE_END[^\n]*\n?/m;
  const m = RE.exec(body);
  if (!m) return 0;               // Fallback: ab Dateianfang
  return m.index + m[0].length;   // direkt NACH der Marker-Zeile
}

// kleinstes Canon-Index k mit bodyMap[k] >= fromOrig
function origToCanonIndex(bodyMap, fromOrig){
  for (let k = 0; k < bodyMap.length; k++){
    if (bodyMap[k] >= fromOrig) return k;
  }
  return bodyMap.length; // hinter dem Ende
}

function readHeaderParamLineStrict(gcode, key){
  const re = new RegExp("^;\\s*" + key.replace(/[.*+?^${}()|[\\]\\\\]/g, "\\$&") + "\\s*=\\s*(.*)$", "m");
  const m = gcode.match(re);
  if (!m) throw new Error(`Header parameter "${key}" not found`);
  return { value: m[1], match: m[0], index: m.index };
}

function unescapeGcodeParam(value){
  return value
    .replace(/\\r\\n/g, "\n")
    .replace(/\\n/g, "\n")
    .replace(/\\t/g, "\t");
}

function escapeGcodeParam(value){
  // nur \n und \t escapen – genau wie die Slicer-Zeilen im Header
  return value
    .replace(/\r\n/g, "\n")
    .replace(/\r/g, "\n")
    .replace(/\n/g, "\\n")
    .replace(/\t/g, "\\t");
}

function replaceHeaderParamLineStrict(gcode, key, escapedValue){
  // ersetzt die komplette Zeile "; key = ..." durch die neue
  const { match, index } = readHeaderParamLineStrict(gcode, key);
  const lineStart = index;
  const lineEnd   = gcode.indexOf("\n", lineStart);
  const after     = (lineEnd === -1) ? gcode.length : lineEnd + 1;
  const newLine   = `; ${key} = ${escapedValue}\n`;
  return gcode.slice(0, lineStart) + newLine + gcode.slice(after);
}

// generischer Block‑Toggler zwischen Start/End‑Markern
function toggleBlockBetween(gcode, startRe, endRe, enable){
  const mStart = gcode.match(startRe);
  if (!mStart) return gcode;
  const sIdx = (mStart.index ?? 0) + mStart[0].length;

  const mEnd  = gcode.slice(sIdx).match(endRe);
  if (!mEnd) return gcode;
  const eIdx = sIdx + (mEnd.index ?? 0);

  const before = gcode.slice(0, sIdx);
  const block  = gcode.slice(sIdx, eIdx);
  const after  = gcode.slice(eIdx);

  if (enable) {
    // aus‑kommentiertes wieder aktivieren
    const uncommented = block.split("\n").map(line =>
      line.replace(/^[ \t]*;[ \t]?/, "")
    ).join("\n");
    return before + uncommented + after;
  } else {
    // aktiv → auskommentieren
    const commented = block.split("\n").map(line =>
      line.trim() ? ("; " + line) : line
    ).join("\n");
    return before + commented + after;
  }
}

// speziell für BED_LEVELING im Start‑GCode
function toggleBedLevelingInStart(startGcode, enable){
  const START = /(^|\n)[ \t]*;<<<[ \t]*BED_LEVELING_START[^\n]*\n/;
  const END   = /(^|\n)[ \t]*;>>>[ \t]*BED_LEVELING_END[^\n]*\n/;
  return toggleBlockBetween(startGcode, START, END, enable);
}

function replaceStartEndInBodyOnly(gcode, newStart, newEnd){
  const startHdr = readHeaderParamLineStrict(gcode, "machine_start_gcode").value;
  const endHdr   = readHeaderParamLineStrict(gcode, "machine_end_gcode").value;
  const startRef = unescapeGcodeParam(startHdr);
  const endRef   = unescapeGcodeParam(endHdr);

  let out = gcode;
  out = replaceStartUsingMixedAnchors(out, startRef, newStart, "Start", 32);
  out = replaceEndBlockByAnchors(out, endRef,   newEnd,   "End",   32);
  return out;
}

// Beibehaltener Name:
function replaceStartEndUsingHeaderStrict(gcode, newStart, newEnd){
  return replaceStartEndInBodyOnly(gcode, newStart, newEnd);
}

function replaceEndBlockByAnchors(body, endHeaderUnescaped, newEndBlock, label = "End", N_ANCHOR = 32){
  // Suche erst ab NACH dem Start-Marker
  const searchFrom = findEndOfStartMarker(body);

  // Nimm den letzten gültigen Präfix/Suffix-Treffer im Suchbereich
  const { startOrig, endOrig: rawEnd } =
    findRegionByAnchors(body, endHeaderUnescaped, label, N_ANCHOR, /*fromOrig*/ searchFrom, /*preferLast*/ true);

  // optionalen Tail schlucken
  const endOrig = extendTail(body, rawEnd);

  const repBlock = (newEndBlock || "").replace(/\r\n/g, "\n").replace(/\r/g, "\n");
  const rep = repBlock.endsWith("\n") ? repBlock : (repBlock + "\n");

  return body.slice(0, startOrig) + rep + body.slice(endOrig);
}

// ===== Kompatibilitäts-Wrapper (alter Funktionsname) =====
function replaceEndBlockLoose(out, endRef, newEnd){
  // nutzt obige Anker-Variante; N_ANCHOR nach Bedarf erhöhen (z.B. 40)
  return replaceEndBlockByAnchors(out, endRef, newEnd, "End", 32);
}


async function export_3mf() {
  try {
    if (!validatePlateXCoords()) return; // Koordinaten ungültig
    update_progress(5);
    console.log("--- export_3mf (strict) ---");
    console.log("Current MODE:", CURRENT_MODE, "USE_PURGE_START:", USE_PURGE_START);

    // ---------- 1) Platten einsammeln (inkl. per-Plate-Repeats, VOR Loops) ----------
    const my_plates = playlist_ol.getElementsByTagName("li");
	const platesOnce = [];
	const coordsOnce = []; // << neu

	for (let i = 0; i < my_plates.length; i++) {
	  const c_f_id  = my_plates[i].getElementsByClassName("f_id")[0].title;
	  const c_file  = my_files[c_f_id];
	  const c_pname = my_plates[i].getElementsByClassName("p_name")[0].title;
	  const p_rep   = my_plates[i].getElementsByClassName("p_rep")[0].value*1;

	  if (p_rep > 0) {
		const z = await JSZip.loadAsync(c_file);
		const plateText = await z.file(c_pname).async("text");

		// X-Koordinaten dieser Plate (absteigend)
		const xsDesc = readPlateXCoordsSorted(my_plates[i]);
		for (let r = 0; r < p_rep; r++) {
		  platesOnce.push(plateText);
		  coordsOnce.push(xsDesc); // gleicher Index wie platesOnce
		}
	  }
	  const perc = 5 + Math.floor(15 * (i + 1) / Math.max(1, my_plates.length));
	  update_progress(perc);

	}

    // Nichts zu exportieren?
    if (platesOnce.length === 0) {
      alert("Keine aktiven Platten (Repeats=0).");
      update_progress(-1);
      return;
    }

    // ---------- 2) Sequenzen bestimmen (strict) und pro Platte modifizieren ----------
    let modifiedPerPlate = platesOnce.slice();

	if (CURRENT_MODE === 'X1' || CURRENT_MODE === 'P1') {
	  const seq = getSequences(CURRENT_MODE, USE_PURGE_START); // {start, end}

	  for (let i = 0; i < modifiedPerPlate.length; i++) {
		// Nur erste Plate: Bed Leveling aktiv lassen; alle weiteren deaktivieren
		const startForThisPlate = toggleBedLevelingInStart(seq.start, i === 0);

      modifiedPerPlate[i] = replaceStartEndUsingHeaderStrict(
        modifiedPerPlate[i],
        startForThisPlate,
        seq.end
      );
      // NEU: wenn Hide nozzle load line aktiv ist → erste Extrusion auf 3 mm setzen
      if (document.getElementById("opt_purge")?.checked) {
        modifiedPerPlate[i] = forceFirstExtrusionTo3mm(modifiedPerPlate[i]);
      }
	  }
	} else {
	  // A1 Mini unverändert
	  for (let i = 0; i < modifiedPerPlate.length; i++) {
		modifiedPerPlate[i] += _5vvAp_gC0d3;
	  }
	}
	
	// << NEU: End-GCode zwischen den Markern per Plate füllen
	for (let i = 0; i < modifiedPerPlate.length; i++) {
	  const perObjectSeq = buildPushOffSequence(coordsOnce[i] || []);            // deine bestehende pro‑Objekt‑Sequenz (Xobj−8, 3 Zeilen)
	  const maxZ = parseMaxZHeight(platesOnce[i]);                               // aus Original‑Plate lesen
	  const staircaseSeq = buildFixedPushOffMultiZ(maxZ);                        // neue Z‑Treppen

	  const seqText = [perObjectSeq, staircaseSeq].filter(Boolean).join("\n");   // kombinieren

	  modifiedPerPlate[i] = injectBetweenMarkers(
		modifiedPerPlate[i],
		PUSH_START,
		PUSH_END,
		seqText
	  );
	}

    // ---------- 3) Loops anwenden & A1M-Global-Start ----------
    const loops = Math.max(1, (document.getElementById("loops").value*1) || 1);
    let combinedPlates = [];
    for (let i = 0; i < loops; i++) combinedPlates = combinedPlates.concat(modifiedPerPlate);

    if (CURRENT_MODE === 'A1M' && combinedPlates.length > 0) {
      // globaler Starter nur einmal ganz vorne
      combinedPlates[0] = _1n1_gC0d3 + combinedPlates[0];
    }

    // ---------- 4) AMS-Optimierung (deine Logik) ----------
    if (typeof optimizeAMSBlocks === "function") {
      combinedPlates = optimizeAMSBlocks(combinedPlates);
    }

    /* === NEU: M73-Bereinigung ===
    * - In allen Platten außer der letzten: ALLE M73 P100 R0 entfernen
    * - In der letzten Platte: nur das LETZTE behalten (ggf. eins anhängen)
    */
    for (let i = 0; i < combinedPlates.length; i++) {
      if (i < combinedPlates.length - 1) {
        combinedPlates[i] = removeAllM73FinishLines(combinedPlates[i]);
      } else {
        combinedPlates[i] = keepOnlyLastM73Finish(combinedPlates[i]);
      }
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
      filament_tag.setAttribute("type",    fil_stat_slots[i].dataset.f_type);
      filament_tag.setAttribute("color",   fil_stat_slots[i].dataset.f_color);
      filament_tag.setAttribute("used_m",  fil_stat_slots[i].dataset.used_m);
      filament_tag.setAttribute("used_g",  fil_stat_slots[i].dataset.used_g);
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
        (meta) => update_progress(75 + Math.floor(20*(meta.percent || 0)/100))
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
  const reG1  = /^\s*G1\b/i;
  const reX   = /\bX[-+]?\d*\.?\d+/i;
  const reY   = /\bY[-+]?\d*\.?\d+/i;
  const reE   = /\bE([-+]?\d*\.?\d+)/i; // capture E-Wert
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
  const after  = lines[hit];

  // ausführlicher Log
  console.log(`[forceFirstExtrusionTo3mm] plate=${plateIndex} line=${hit+1}`);
  console.log('  before:', before);
  console.log('   after:', after);

  return lines.join('\n');
}


function disable_gcode_line(str,index) {
    if(index > str.length-1) return str;
    return str.substring(0,index) + ";" + str.substring(index+1);
}

function disable_gcode_block(str,index) {
    if(index > str.length-1) return str;
	const block_end = str.substring(index).search(/\n[^\s]/);
	var replacement_string="M109 S230 \n ;SWAP - AMS block removed";
	while(replacement_string.length<block_end-1)
	 {replacement_string+="/";}
	 replacement_string+="\n";
    return str.substring(0,index) + replacement_string + str.substring(index+block_end);
}

function disable_ams_block(str,index) {
    if(index > str.length-1) return str;
	const block_end = str.substring(index).search("M621 S");
	var replacement_string=";SWAP - AMS block removed";
	while(replacement_string.length<block_end-1)
	 {replacement_string+="/";}
	 replacement_string+=";";
	 if(replacement_string.length>2000) return str; 
	 else return str.substring(0,index) + replacement_string + str.substring(index+block_end);
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
		update_progress(25+50/chunks*currentChunk);

        if (currentChunk < chunks) {
            loadNext();
        } else {
			var my_hash=spark.end();
            console.log('finished loading');
            console.info('computed hash', my_hash);
			callback (my_hash);
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
	
function update_statistics()
{
update_filament_usage();
update_total_time();
}
	
function update_filament_usage()
{
var type=[];
var used_m=[];
var used_g=[];
var f_type=[];
var f_color=[];

var ams_max=-1;

const fil_stat = document.getElementById("filament_total");
var my_fil_data = playlist_ol.getElementsByClassName("p_filament");

console.log("my_fil_data.length: " + my_fil_data.length);
console.log("my_fil_data", my_fil_data);

for (var i=0; i<my_fil_data.length ; i++ ){
	let slot = my_fil_data[i].getElementsByClassName("f_slot")[0].innerText-1;
	if (!used_m[slot])used_m[slot]=0;
	if (!used_g[slot])used_g[slot]=0;
	
	let r = my_fil_data[i].parentElement.parentElement.getElementsByClassName("p_rep")[0].value*1;
	console.log("repeats", r);
	
	used_m[slot]+=r*my_fil_data[i].getElementsByClassName("f_used_m")[0].innerText;
	used_g[slot]+=r*my_fil_data[i].getElementsByClassName("f_used_g")[0].innerText;
	f_type[slot]= my_fil_data[i].getElementsByClassName("f_type")[0].innerText; 
	f_color[slot]= my_fil_data[i].getElementsByClassName("f_color")[0].dataset.f_color; 

	console.log("slot", slot);
	console.log("f_used_m.innerText", 10*my_fil_data[i].getElementsByClassName("f_used_m")[0].innerText);
	
	if (slot > ams_max && r>0)
		{
		ams_max = slot;
		ams_max_file_id=my_fil_data[i].parentElement.parentElement.getElementsByClassName("f_id")[0].title;
		console.log("f_id element: ", my_fil_data[i].parentElement.parentElement.getElementsByClassName("f_id"));
		console.log("file id with highest AMS slot=", ams_max_file_id);
		}
	}
	
	const loops=document.getElementById("loops").value*1;
	used_m = used_m.map(m => m*loops);
	used_g = used_g.map(g => g*loops);
	
	console.log("loops: ", loops);

fil_stat.innerHTML="";
for (var e =0; e<used_m.length; e++)
{if(used_m[e] && used_g[e]){
    var slot_stat = document.createElement("div");
	slot_stat.innerHTML="Slot "+ (e+1) + ": <br>" +  Math.round(used_m[e]*100)/100 + "m <br> " + Math.round(used_g[e]*100)/100 + "g";
	slot_stat.dataset.used_m=Math.round(used_m[e]*100)/100;
	slot_stat.dataset.used_g=Math.round(used_g[e]*100)/100;
	slot_stat.dataset.f_type=f_type[e];
	slot_stat.dataset.f_color=f_color[e];
	slot_stat.title=e+1;
	fil_stat.appendChild(slot_stat);
	}
}
}
	
function update_total_time()
{
const total_time = document.getElementById("total_time");
const loops=document.getElementById("loops").value*1;
const used_plates_element=document.getElementById("used_plates");

var used_plates=0;
var my_t=0;

var my_plates = playlist_ol.getElementsByTagName("li");

for ( var i = 0; i< my_plates.length; i++)
{
var p_rep = my_plates[i].getElementsByClassName("p_rep")[0].value;
if(p_rep>0)
	{
	var p_time = my_plates[i].getElementsByClassName("p_time")[0].title;
	my_t+=p_rep*p_time;
	my_plates[i].classList.remove("inactive");
    used_plates+=p_rep*1;
	}
else 
	{
	my_plates[i].classList.add("inactive");
	}
}

used_plates*=loops;
my_t*=loops;
total_time.innerText = my_t.toDHMS();
used_plates_element.innerText=used_plates;
}

Number.prototype.toDHMS = function () {
    var sec_num = this;
	var days   = Math.floor(sec_num / (3600*24));
    var hours   = Math.floor((sec_num - (days * 3600*24)) / 3600);
    var minutes = Math.floor((sec_num - (days * 3600*24)- (hours * 3600)) / 60);
    var seconds = sec_num - (days * 3600*24) - (hours * 3600) - (minutes * 60);
    return (days? days + "d ":"") + (hours? hours + "h ":"")  + minutes + "m "  + seconds+ "s ";
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
    const p_rep = my_plates[i].getElementsByClassName("p_rep")[0].value*1;

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
function applyLoops(arr, loops){
  let out = [];
  for (let i = 0; i < loops; i++) out = out.concat(arr);
  return out;
}

function optimizeAMSBlocks(gcodeArray){
  // Defensive: falscher Typ -> nichts tun
  if (!Array.isArray(gcodeArray)) return gcodeArray;

  // Wir erkennen AMS-Swaps an "\nM620 S"
  const ams_flag = "\nM620 S";

  // Sammeln der Fundstellen
  const ams_flag_index = [];   // Index im jeweiligen String (Position des Buchstabens nach dem \n)
  const ams_flag_plate = [];   // Index der Platte (Element im Array)
  const ams_flag_value = [];   // Zahlenwert nach "M620 S" (z.B. 255, 0..3, ...)

  for (let plate = 0; plate < gcodeArray.length; plate++){
    const g = gcodeArray[plate];
    let searchFrom = 0;
    while (true){
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
  for (let i = 0; i < ams_flag_value.length - 1; i++){
    // Schutz gegen i-1 < 0 und i+1 >= length
    if (i === 0 || i + 1 >= ams_flag_value.length) continue;

    if (ams_flag_value[i] === 255 && ams_flag_value[i - 1] === ams_flag_value[i + 1]){
      const plateA = ams_flag_plate[i];
      const plateB = ams_flag_plate[i + 1];
      const idxA   = ams_flag_index[i];
      const idxB   = ams_flag_index[i + 1];

      // Deaktivieren (ersetzt den AMS-Block durch kommentierte Platzhalter, siehe deine disable_ams_block)
      gcodeArray[plateA] = disable_ams_block(gcodeArray[plateA], idxA);
      gcodeArray[plateB] = disable_ams_block(gcodeArray[plateB], idxB);

      // Debug (optional)
      try {
        console.log("AMS swap redundancy removed at pair:", i,
          "plateA:", plateA, "plateB:", plateB);
      } catch(e){}
    }
  }

  return gcodeArray;
}


async function export_gcode_txt(){
  if (!validatePlateXCoords()) return;   // Koordinaten ungültig
  try{
    update_progress(5);

    // 1) Basis: Platten einsammeln (mit per-Plate-Repeats, VOR Loops)
    // === Platten einsammeln (pre-loop) + zugehörige X-Listen ===
    const my_plates = playlist_ol.getElementsByTagName("li");
    const platesOnce = [];
    const coordsOnce = [];

    for (let i = 0; i < my_plates.length; i++) {
      const c_f_id  = my_plates[i].getElementsByClassName("f_id")[0].title;
      const c_file  = my_files[c_f_id];
      const c_pname = my_plates[i].getElementsByClassName("p_name")[0].title;
      const p_rep   = my_plates[i].getElementsByClassName("p_rep")[0].value*1;

      if (p_rep > 0) {
        const z = await JSZip.loadAsync(c_file);
        const plateText = await z.file(c_pname).async("text");

        const xsDesc = readPlateXCoordsSorted(my_plates[i]); // X-Koords dieser Plate
        for (let r = 0; r < p_rep; r++) {
          platesOnce.push(plateText);
          coordsOnce.push(xsDesc); // gleicher Index wie platesOnce
        }
      }
    }

    const loops = Math.max(1, (document.getElementById("loops").value*1) || 1);

    // 2) Original (nur Loops anwenden, sonst nichts)
    const originalLooped = applyLoops(platesOnce, loops);
    const originalCombined = originalLooped.join("\n");

    // 3) Modifiziert: Modus-Logik anwenden (pro Platte), dann Loops,
    //    optional identisch zur 3MF-Pipeline AMS-Optimierung
    let modifiedPerPlate = platesOnce.slice();

	if (CURRENT_MODE === 'X1' || CURRENT_MODE === 'P1') {
	  const seq = getSequences(CURRENT_MODE, USE_PURGE_START); // {start, end}

	  for (let i = 0; i < modifiedPerPlate.length; i++) {
		// Nur erste Plate: Bed Leveling aktiv lassen; alle weiteren deaktivieren
		const startForThisPlate = toggleBedLevelingInStart(seq.start, i === 0);

      modifiedPerPlate[i] = replaceStartEndUsingHeaderStrict(
        modifiedPerPlate[i],
        startForThisPlate,
        seq.end
      );
      
      if (document.getElementById("opt_purge")?.checked) {
        modifiedPerPlate[i] = forceFirstExtrusionTo3mm(modifiedPerPlate[i]);
      }
	  }
	} else {
	  // A1 Mini unverändert
	  for (let i = 0; i < modifiedPerPlate.length; i++) {
		modifiedPerPlate[i] += _5vvAp_gC0d3;
	  }
	}
	
	for (let i = 0; i < modifiedPerPlate.length; i++){
	  const perObjectSeq = buildPushOffSequence(coordsOnce[i] || []);
	  const maxZ = parseMaxZHeight(platesOnce[i]);
	  const staircaseSeq = buildFixedPushOffMultiZ(maxZ);
	  const seqText = [perObjectSeq, staircaseSeq].filter(Boolean).join("\n");

	  modifiedPerPlate[i] = injectBetweenMarkers(
		modifiedPerPlate[i],
		PUSH_START,
		PUSH_END,
		seqText
	  );
	}

    let modifiedLooped = applyLoops(modifiedPerPlate, loops);

    if (CURRENT_MODE === 'A1M' && modifiedLooped.length > 0) {
      // globaler Starter nur einmal ganz am Anfang
      modifiedLooped[0] = _1n1_gC0d3 + modifiedLooped[0];
    }

    // Optional: exakt wie bei 3MF-Export redundante AMS-Swaps entfernen
    if (typeof optimizeAMSBlocks === "function") {
      modifiedLooped = optimizeAMSBlocks(modifiedLooped);
    }

    /* === NEU: M73-Bereinigung (TXT) === */
    for (let i = 0; i < modifiedLooped.length; i++) {
      if (i < modifiedLooped.length - 1) {
        modifiedLooped[i] = removeAllM73FinishLines(modifiedLooped[i]);
      } else {
        modifiedLooped[i] = keepOnlyLastM73Finish(modifiedLooped[i]);
      }
    }

    const modifiedCombined = modifiedLooped.join("\n");

    // 4) ZIP vorbereiten
    update_progress(25);
    const file_name_field = document.getElementById("file_name");
    const base = (file_name_field.value || file_name_field.placeholder || "output_file_name").trim();
    const modeTag = (CURRENT_MODE || "A1M");
    const purgeTag = (CURRENT_MODE === 'X1' || CURRENT_MODE === 'P1') ? (USE_PURGE_START ? "_purge" : "_standard") : "";
    const stamp = new Date().toISOString().replace(/[:.]/g,"-");

    const zip = new JSZip();
    const root = zip.folder(`${base}_gcode_exports_${modeTag}${purgeTag}_${stamp}`);

    // 4a) Kombinierte Dateien
    root.file(`${base}_${modeTag}${purgeTag}_original_combined.txt`, originalCombined);
    root.file(`${base}_${modeTag}${purgeTag}_modified_combined.txt`, modifiedCombined);

    // 4b) Pro Platte (vor Loops) – Nummern 1..N
    const platesFolder = root.folder("per_plate_preloop");
    for (let i = 0; i < platesOnce.length; i++){
      const idx = String(i+1).padStart(2,"0");
      platesFolder.file(`plate_${idx}_original.txt`,  platesOnce[i]);
      platesFolder.file(`plate_${idx}_modified.txt`,  modifiedPerPlate[i]);
    }

    // 4c) Manifest
    const manifest = [
      `name: ${base}`,
      `mode: ${modeTag}${purgeTag}`,
      `loops: ${loops}`,
      `plates_preloop: ${platesOnce.length}`,
      `timestamp: ${stamp}`,
      `notes:`,
      `  - original_combined = nur Repeats+Loops, keine Modifikationen`,
      `  - modified_combined = mit Modus-Logik (Start/End), ggf. AMS-Optimierung`,
      `  - per_plate_preloop = je Platte (vor Loops) original & modifiziert`,
      `  - CURRENT_MODE=A1M: globaler Starter nur einmal am Anfang`,
      `  - CURRENT_MODE=X1/P1: Start/End pro Platte ersetzt`,
      ``
    ].join("\n");
    root.file("manifest.txt", manifest);

    // 5) ZIP erstellen & downloaden
    update_progress(60);
    const zipBlob = await zip.generateAsync(
      {type:"blob", compression:"DEFLATE", compressionOptions:{level:3}},
      (meta)=> { update_progress(60 + Math.floor(35*(meta.percent||0)/100)); }
    );

    const zipUrl = URL.createObjectURL(zipBlob);
    download(`${base}_${modeTag}${purgeTag}_gcode_exports.zip`, zipUrl);

    update_progress(100);
    setTimeout(()=>update_progress(-1), 500);
  } catch(err){
    console.error("GCODE txt export failed:", err);
    alert("TXT-Export fehlgeschlagen: " + err.message);
    update_progress(-1);
  }
}

