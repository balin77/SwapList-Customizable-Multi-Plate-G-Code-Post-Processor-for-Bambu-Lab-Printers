// /src/ui/settings.js

export function toggle_settings(state) {
  const settingsPanel = document.getElementById("settings_panel");
  if (settingsPanel) {
    settingsPanel.classList.toggle("hidden", !state);
  }
  
  // Legacy support - remove old settings wrapper if it exists
  const settingsWrapper = document.getElementById("settings_wrapper");
  if (settingsWrapper) {
    settingsWrapper.style.display = "none";
  }
}

export function show_settings_when_plates_loaded() {
  const plates = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)");
  const hasPlates = plates.length > 0;
  toggle_settings(hasPlates);

  if (hasPlates) {
    updatePlateSelector();
  }
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

// New plate settings management functions

let currentPlateSettings = new Map(); // plateIndex -> settings object
let selectedPlateIndex = 0;

export function updatePlateSelector() {
  const plates = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)");
  const plateSpecificSettings = document.getElementById("plate_specific_settings");

  if (!plateSpecificSettings) return;

  // Add click listeners to plates for selection
  plates.forEach((li, index) => {
    // Remove any existing click listeners
    li.removeEventListener("click", li._plateClickHandler);

    // Create new click handler
    const clickHandler = (event) => {
      // Ignore clicks on buttons, inputs, etc.
      if (event.target.closest('button, input, select, .plate-remove, .plate-duplicate')) {
        return;
      }

      // Update selected plate
      selectPlate(index);
    };

    // Store handler reference for cleanup
    li._plateClickHandler = clickHandler;
    li.addEventListener("click", clickHandler);

    // Make plate visually interactive
    li.style.cursor = "pointer";
  });

  // Show/hide settings based on plate count
  if (plates.length > 0) {
    plateSpecificSettings.classList.remove("hidden");

    // Select first plate by default
    selectPlate(0);
  } else {
    plateSpecificSettings.classList.add("hidden");
  }
}

function selectPlate(plateIndex) {
  const plates = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)");

  // Update visual selection
  plates.forEach((li, index) => {
    if (index === plateIndex) {
      li.classList.add("plate-selected");
    } else {
      li.classList.remove("plate-selected");
    }
  });

  // Update settings display
  selectedPlateIndex = plateIndex;
  displayPlateSettings(plateIndex);
}

// Function removed - now using direct plate clicking

export function displayPlateSettings(plateIndex) {
  const plateSpecificSettings = document.getElementById("plate_specific_settings");
  const template = document.getElementById("plate_settings_template");
  const plates = document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)");

  if (!plateSpecificSettings || !template || plateIndex >= plates.length) return;

  // Clear current settings
  plateSpecificSettings.innerHTML = "";

  // Clone template
  const clone = template.content.cloneNode(true);
  plateSpecificSettings.appendChild(clone);

  // Get the selected plate element
  const plateEl = plates[plateIndex];

  // Initialize settings for this plate if not exists
  if (!currentPlateSettings.has(plateIndex)) {
    initializePlateSettings(plateIndex);
  }

  // Load settings from plate element and our stored settings
  loadPlateSettingsToUI(plateIndex, plateEl);

  // Hide/show purge off option based on plate index
  updatePurgeOffVisibility(plateIndex);

  // Add event listeners for the new settings
  addPlateSettingsEventListeners(plateIndex);
}

function initializePlateSettings(plateIndex) {
  currentPlateSettings.set(plateIndex, {
    objectCount: 1,
    objectCoords: [],
    hidePurgeLoad: true,
    turnOffPurge: false,
    bedRaiseOffset: 30,
    securePushoff: true,
    extraPushoffLevels: 2
  });
}

function loadPlateSettingsToUI(plateIndex, plateEl) {
  const settings = currentPlateSettings.get(plateIndex);
  const plateSpecificSettings = document.getElementById("plate_specific_settings");
  if (!settings || !plateSpecificSettings) return;

  // Object count
  const objCountSelect = plateSpecificSettings.querySelector(".obj-count");
  if (objCountSelect) {
    objCountSelect.value = settings.objectCount;
    objCountSelect.addEventListener("change", (e) => {
      settings.objectCount = parseInt(e.target.value, 10);
      renderPlateCoordinatesInSettings(plateIndex);
    });
    renderPlateCoordinatesInSettings(plateIndex);
  }

  // Hide purge load
  const hidePurgeCheck = plateSpecificSettings.querySelector(".opt_purge_plate");
  if (hidePurgeCheck) {
    hidePurgeCheck.checked = settings.hidePurgeLoad;
    hidePurgeCheck.addEventListener("change", (e) => {
      settings.hidePurgeLoad = e.target.checked;
    });
  }

  // Turn off purge (only for plates > 0)
  const turnOffPurgeCheck = plateSpecificSettings.querySelector(".opt_filament_purge_off_plate");
  if (turnOffPurgeCheck) {
    turnOffPurgeCheck.checked = settings.turnOffPurge;
    turnOffPurgeCheck.addEventListener("change", (e) => {
      settings.turnOffPurge = e.target.checked;
    });
  }

  // Bed raise offset
  const bedRaiseInput = plateSpecificSettings.querySelector(".raisebed_offset_mm_plate");
  if (bedRaiseInput) {
    bedRaiseInput.value = settings.bedRaiseOffset;
    bedRaiseInput.addEventListener("change", (e) => {
      settings.bedRaiseOffset = Math.max(5, Math.min(200, parseInt(e.target.value, 10) || 30));
    });
  }

  // Secure pushoff
  const securePushoffCheck = plateSpecificSettings.querySelector(".opt_secure_pushoff_plate");
  if (securePushoffCheck) {
    securePushoffCheck.checked = settings.securePushoff;
    securePushoffCheck.addEventListener("change", (e) => {
      settings.securePushoff = e.target.checked;
    });
  }

  // Extra pushoff levels
  const extraLevelsInput = plateSpecificSettings.querySelector(".extra_pushoff_levels_plate");
  if (extraLevelsInput) {
    extraLevelsInput.value = settings.extraPushoffLevels;
    extraLevelsInput.addEventListener("change", (e) => {
      settings.extraPushoffLevels = Math.max(1, Math.min(10, parseInt(e.target.value, 10) || 2));
    });
  }
}

function renderPlateCoordinatesInSettings(plateIndex) {
  const plateSpecificSettings = document.getElementById("plate_specific_settings");
  const coordsContainer = plateSpecificSettings?.querySelector(".obj-coords");
  const settings = currentPlateSettings.get(plateIndex);

  if (!coordsContainer || !settings) return;

  coordsContainer.innerHTML = "";
  const count = settings.objectCount;

  // Create grid container
  const gridContainer = document.createElement('div');
  gridContainer.className = 'obj-coords-grid';

  for (let i = 1; i <= count; i++) {
    const coordItem = document.createElement('div');
    coordItem.className = 'obj-coord-item';
    coordItem.innerHTML = `
      <b>Objekt ${i}</b>
      <label>X <input type="number" class="obj-x" step="1" value="${settings.objectCoords[i-1] || 0}" min="0" max="255" data-obj="${i}"></label>
    `;

    const input = coordItem.querySelector('input');
    input.addEventListener("change", (e) => {
      const objIndex = i - 1;
      if (!settings.objectCoords[objIndex]) settings.objectCoords[objIndex] = 0;
      settings.objectCoords[objIndex] = parseInt(e.target.value, 10) || 0;
    });

    gridContainer.appendChild(coordItem);
  }

  coordsContainer.appendChild(gridContainer);
}

function updatePurgeOffVisibility(plateIndex) {
  const plateSpecificSettings = document.getElementById("plate_specific_settings");
  const purgeOffWrapper = plateSpecificSettings?.querySelector(".purge-off-wrapper");
  if (purgeOffWrapper) {
    // Only show for plates after the first one (index > 0)
    purgeOffWrapper.style.display = plateIndex > 0 ? "block" : "none";
  }
}

function addPlateSettingsEventListeners(plateIndex) {
  // Event listeners are already added in loadPlateSettingsToUI
  // This function can be used for additional listeners if needed
}

// Export functions to get per-plate settings
export function getPlateSettings(plateIndex) {
  return currentPlateSettings.get(plateIndex) || null;
}

export function getAllPlateSettings() {
  return currentPlateSettings;
}

// Per-plate versions of existing functions
export function getUserBedRaiseOffsetForPlate(plateIndex) {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.bedRaiseOffset !== undefined) {
    return settings.bedRaiseOffset;
  }
  // Fallback to global setting
  return getUserBedRaiseOffset();
}

export function getSecurePushOffEnabledForPlate(plateIndex) {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.securePushoff !== undefined) {
    return settings.securePushoff;
  }
  // Fallback to global setting
  return getSecurePushOffEnabled();
}

export function getExtraPushOffLevelsForPlate(plateIndex) {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.extraPushoffLevels !== undefined) {
    return settings.extraPushoffLevels;
  }
  // Fallback to global setting
  return getExtraPushOffLevels();
}

export function getHidePurgeLoadForPlate(plateIndex) {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.hidePurgeLoad !== undefined) {
    return settings.hidePurgeLoad;
  }
  // Default for backwards compatibility
  return true;
}

export function getTurnOffPurgeForPlate(plateIndex) {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.turnOffPurge !== undefined) {
    return settings.turnOffPurge;
  }
  // Default for backwards compatibility
  return false;
}

export function getObjectCountForPlate(plateIndex) {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.objectCount !== undefined) {
    return settings.objectCount;
  }
  // Default
  return 1;
}

export function getObjectCoordsForPlate(plateIndex) {
  const settings = getPlateSettings(plateIndex);
  if (settings && settings.objectCoords !== undefined) {
    return settings.objectCoords;
  }
  // Default
  return [];
}

// Helper function for swap rules to get plate-specific settings
export function getSettingForPlate(plateIndex, settingId) {
  const settings = getPlateSettings(plateIndex);
  if (!settings) {
    // Fallback to global DOM element if no plate settings
    const el = document.getElementById(settingId);
    return el && el.checked;
  }

  switch (settingId) {
    case 'opt_purge':
      return settings.hidePurgeLoad !== undefined ? settings.hidePurgeLoad : true;
    case 'opt_filament_purge_off':
      return settings.turnOffPurge !== undefined ? settings.turnOffPurge : false;
    default:
      // For unknown settings, fallback to DOM
      const el = document.getElementById(settingId);
      return el && el.checked;
  }
}

// Make this function available globally for gcodeUtils
window.getSettingForPlate = getSettingForPlate;

