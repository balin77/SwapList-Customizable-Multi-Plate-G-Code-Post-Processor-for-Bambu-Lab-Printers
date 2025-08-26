// /src/ui/settings.js

export function toggle_settings(state) {
  document.getElementById("settings_wrapper").style.display = state ? "table-cell" : "none";
}

export function custom_file_name(trg) {
  if (trg.value == "") {
    trg.value = trg.placeholder;
    trg.select();
  }
}

// Field length adjustment
export function adj_field_length(trg, min, max) {
  if (trg.value == "")
    trg_val = trg.placeholder;
  else
    trg_val = trg.value;

  trg.style.width = Math.min(max, (Math.max(min, trg_val.length + 2))) + 'ch';
}

export function getUserBedRaiseOffset() {
  const el = document.getElementById("raisebed_offset_mm");
  const v = el ? parseFloat(el.value) : 30;
  return Number.isFinite(v) ? Math.max(0, Math.min(200, v)) : 30;
}

export function getCooldownTargetBedTemp() {
  const el = document.getElementById("cooldown_target_bed_temp");
  const v = el ? parseFloat(el.value) : 23;
  // wir erlauben 0..120°C
  return Number.isFinite(v) ? Math.max(0, Math.min(120, v)) : 23;
}

export function getSecurePushOffEnabled() {
  const el = document.getElementById("opt_secure_pushoff");
  return !!(el && el.checked);
}

export function getExtraPushOffLevels() {
  const el = document.getElementById("extra_pushoff_levels");
  const n = el ? parseInt(el.value, 10) : 1;
  return Number.isFinite(n) ? Math.max(1, Math.min(10, n)) : 1;
}

export function getCooldownMaxTime() {
  const el = document.getElementById("cooldown_max_time");
  const n = el ? parseInt(el.value, 10) : 40;
  return Number.isFinite(n) ? Math.max(5, Math.min(120, n)) : 40;
}

