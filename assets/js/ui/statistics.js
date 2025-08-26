// /src/ui/statistics.js

import { state } from "../config/state.js";

export function update_statistics() {
  update_filament_usage();
  update_total_time();
}

export function update_total_time() {
  const total_time_el = document.getElementById("total_time");
  const used_plates_el = document.getElementById("used_plates");
  const loopsEl = document.getElementById("loops");
  const list = state.playlist_ol;

  if (!total_time_el || !used_plates_el || !loopsEl || !list) return;

  const loops = parseFloat(loopsEl.value) || 1;

  let used_plates = 0;
  let seconds_total = 0;

  const my_plates = list.getElementsByTagName("li");

  for (let i = 0; i < my_plates.length; i++) {
    const repEl = my_plates[i].getElementsByClassName("p_rep")[0];
    const timeEl = my_plates[i].getElementsByClassName("p_time")[0];

    const p_rep = parseFloat(repEl?.value) || 0;
    const p_time = parseInt(timeEl?.title, 10) || 0; // Sekunden

    if (p_rep > 0) {
      seconds_total += p_rep * p_time;
      my_plates[i].classList.remove("inactive");
      used_plates += p_rep;
    } else {
      my_plates[i].classList.add("inactive");
    }
  }

  used_plates *= loops;
  seconds_total *= loops;

  total_time_el.innerText = toDHMS(seconds_total);
  used_plates_el.innerText = used_plates;
}

// kleine Helper-Funktion, falls Number.prototype.toDHMS nicht mehr global existiert:
function toDHMS(sec_num) {
  const days = Math.floor(sec_num / (3600 * 24));
  const hours = Math.floor((sec_num - (days * 86400)) / 3600);
  const minutes = Math.floor((sec_num - (days * 86400) - (hours * 3600)) / 60);
  const seconds = Math.floor(sec_num - (days * 86400) - (hours * 3600) - (minutes * 60));
  return (days ? days + "d " : "") + (hours ? hours + "h " : "") + minutes + "m " + seconds + "s ";
}

export function update_filament_usage() {
  const fil_stat = document.getElementById("filament_total");
  const list = state.playlist_ol;
  if (!fil_stat || !list) return;

  const my_fil_data = list.getElementsByClassName("p_filament");

  const used_m = [];  // index = slot
  const used_g = [];
  const f_type = [];
  const f_color = [];

  let ams_max = -1;

  for (let i = 0; i < my_fil_data.length; i++) {
    const row = my_fil_data[i];

    const slotIdx1 = parseInt(row.getElementsByClassName("f_slot")[0]?.innerText, 10);
    if (!Number.isFinite(slotIdx1)) continue;
    const slot = slotIdx1 - 1;

    if (!used_m[slot]) used_m[slot] = 0;
    if (!used_g[slot]) used_g[slot] = 0;

    const repEl = row.parentElement?.parentElement?.getElementsByClassName("p_rep")[0];
    const r = parseFloat(repEl?.value) || 0;

    const mVal = parseFloat(row.getElementsByClassName("f_used_m")[0]?.innerText) || 0;
    const gVal = parseFloat(row.getElementsByClassName("f_used_g")[0]?.innerText) || 0;

    used_m[slot] += r * mVal;
    used_g[slot] += r * gVal;

    f_type[slot]  = row.getElementsByClassName("f_type")[0]?.innerText || "";
    f_color[slot] = row.getElementsByClassName("f_color")[0]?.dataset?.f_color || "";

    if (slot > ams_max && r > 0) {
      ams_max = slot;
      const fidEl = row.parentElement?.parentElement?.getElementsByClassName("f_id")[0];
      state.ams_max_file_id = fidEl?.title ?? state.ams_max_file_id;
    }
  }

  const loopsEl = document.getElementById("loops");
  const loops = parseFloat(loopsEl?.value) || 1;

  const used_m_scaled = used_m.map(m => (m || 0) * loops);
  const used_g_scaled = used_g.map(g => (g || 0) * loops);

  // UI ausgeben
  fil_stat.innerHTML = "";
  for (let s = 0; s < Math.max(used_m_scaled.length, used_g_scaled.length); s++) {
    const m = used_m_scaled[s] || 0;
    const g = used_g_scaled[s] || 0;
    if (m === 0 && g === 0) continue;

    const div = document.createElement("div");
    const mRounded = Math.round(m * 100) / 100;
    const gRounded = Math.round(g * 100) / 100;
    div.innerHTML = `Slot ${s + 1}: <br>${mRounded}m <br> ${gRounded}g`;
    div.dataset.used_m = String(mRounded);
    div.dataset.used_g = String(gRounded);
    div.dataset.f_type = f_type[s] || "";
    div.dataset.f_color = f_color[s] || "";
    div.title = String(s + 1);
    fil_stat.appendChild(div);
  }
}
