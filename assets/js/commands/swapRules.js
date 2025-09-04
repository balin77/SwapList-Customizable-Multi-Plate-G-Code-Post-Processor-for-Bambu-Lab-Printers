// /src/commands/swapRules.js

export const SWAP_START_A1M = `;swap ini code
G91 ; 
G0 Z50 F1000; 
G0 Z-20; 
G90; 
G28 XY; 
G0 Y-4 F5000; grab 
G0 Y145;  pull and fix the plate
G0 Y115 F1000; rehook 
G0 Y180 F5000; pull
G4 P500; wait  
G0 Y186.5 F200; fix the plate
G4 P500; wait  
G0 Y3 F15000; back 
G0 Y-5 F200; snap 
G4 P500; wait  
G0 Y10 F1000; load 
G0 Y20 F15000; ready `;

export const SWAP_END_A1M = `;swap 
G0 X-10 F5000; 
G0 Z175; 
G0 Y-5 F2000;  
G0 Y186.5 F2000;  
G0 Y182 F10000;  
G0 Z186 ; 
G0 Y120 F500; 
G0 Y-4 Z175 F5000; 
G0 Y145; 
G0 Y115 F1000; 
G0 Y25 F500; 
G0 Y85 F1000; 
G0 Y180 F2000; 
G4 P500; wait  
G0 Y186.5 F200; 
G4 P500; wait  
G0 Y3 F3000; 
G0 Y-5 F200; 
G4 P500; wait  
G0 Y10 F1000; 
G0 Z100 Y186 F2000; 
G0 Y150; 
G4 P1000; wait  `;

// commands.js
export const SWAP_RULES = [
  // Beispiel: Bed‑Leveling in allen Platten außer der ersten deaktivieren
  // Das lösen wir per Kontextflag (plateIndex) direkt in app.js (siehe unten).
  {
    id: "bed_leveling_start_block",
    description: "Disable bed leveling if plateIndex > 0",
    enabled: true,
    start: ";===== bed leveling ==================================",
    end: ";===== bed leveling end ================================",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["X1", "P1"],
      requireTrue: [],            // keine Checkbox
      requireFalse: []
    },
    onlyIf: { plateIndexGreaterThan: 0 }, // <— Kontextbedingung
    action: "disable_between"
  },
  {
    id: "disable_filament_purge_after_first",
    description: "Disable filament purge on all but first plate when option enabled",
    enabled: true,
    order: 50,
    action: "disable_between",
    start: "M412 S1 ; ===turn on filament runout detection===",
    end: "M109 S200 ; drop nozzle temp, make filament shink a bit",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["X1", "P1"],                // nur X1/P1 relevant
      requireTrue: ["opt_filament_purge_off"], // nur wenn Checkbox an
      requireFalse: []
    },
    onlyIf: {
      plateIndexGreaterThan: 0           // nur auf 2. Plate und später
    }
  },
  {
    id: "first_layer_scan",
    description: "Disable register first layer scan block",
    enabled: true,
    start: ";=========register first layer scan=====",
    end: ";=============turn on fans to prevent PLA jamming=================",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["X1"],   // nur für diese Modi
      requireTrue: [],     // keine Checkbox notwendig
      requireFalse: []      // keine Ausschluss-Checkbox
    },
    action: "disable_between"
  },
  {
    id: "scanner_clarity",
    description: "Disable scanner clarity check",
    enabled: true,
    start: ";===== check scanner clarity ===========================",
    end: ";===== check scanner clarity end =======================",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["X1"],   // nur für diese Modi
      requireTrue: [],     // keine Checkbox notwendig
      requireFalse: []      // keine Ausschluss-Checkbox
    },
    action: "disable_between"
  },
  {
    id: "mech_mode_fast_check",
    description: "Disable mech mode fast check block",
    enabled: true,
    start: ";===== mech mode fast check============================",
    end: ";start heatbed  scan====================================",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["X1", "P1"],   // nur für diese Modi
      requireTrue: [],     // keine Checkbox notwendig
      requireFalse: []      // keine Ausschluss-Checkbox
    },
    onlyIf: { plateIndexGreaterThan: 0 }, // <— Kontextbedingung
    action: "disable_between"
  },
  {
    id: "nozzle_load_line_inner",
    description: "Disable lines between T1000 and M400 within nozzle load line block",
    enabled: true,
    // äußere Schranken (grobe Grenzen)
    start: ";===== nozzle load line ===============================",
    end: ";===== for Textured PEI Plate",
    useRegex: false,
    scope: "startseq",
    // innere Schranken (feiner Bereich)
    innerStart: "T1000",
    innerEnd: "M400",
    innerUseRegex: false,

    when: {
      modes: ["X1", "P1"],
      requireTrue: [],
      requireFalse: []
    },
    action: "disable_inner_between"
  },
  {
    id: "extrinsic_para_cali_paint",
    description: "Disable extrinsic parameter calibration paint",
    enabled: true,
    start: ";===== draw extrinsic para cali paint =================",
    end: ";========turn off light and wait extrude temperature =============",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["X1"],   // nur für diese Modi anwenden
      requireTrue: [],     // keine Checkbox-Bedingung
      requireFalse: []      // keine Ausschluss-Bedingung
    },
    action: "disable_between"
  },
  {
    id: "purge_line_wipe_nozzle",
    description: "Disable purge line to wipe the nozzle",
    enabled: true,
    start: ";===== purge line to wipe the nozzle ============================",
    end: "; MACHINE_START_GCODE_END",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["X1"],   // nur für X1 und P1
      requireTrue: [],     // keine zusätzlichen Bedingungen
      requireFalse: []      // keine Ausschlussbedingungen
    },
    action: "disable_between"
  },
  {
    id: "save_calibration_data",
    description: "Disable saving calibration data (M973 S4 + M400)",
    enabled: true,
    start: ";========turn off light and wait extrude temperature =============",
    end: ";===== purge line to wipe the nozzle ============================",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["X1"],   // nur in X1/P1
      requireTrue: [],
      requireFalse: []
    },
    action: "disable_lines",
    lines: [
      "M973 S4 ; turn off scanner",
      "M400 ; wait all motion done before implement the emprical L parameters"
    ]
  },
  {
    id: "lower_print_bed_after_print",
    description: "Disable lowering of print bed after print",
    enabled: true,
    start: "M17 S",
    end: "M17 R ; restore z current",
    useRegex: false,
    scope: "endseq",
    when: {
      modes: ["X1", "P1"],   // nur für diese Modi
      requireTrue: [],
      requireFalse: []
    },
    action: "disable_between"
  },
  {
    id: "cooldown_optional_lift",
    description: "Optional pre-cooldown lift & safety moves",
    enabled: true,
    order: 10,
    action: "insert_after",
    anchor: "M17 R ; restore z current",
    occurrence: "last",
    useRegex: false,
    scope: "endseq",
    wrapWithMarkers: true,
    when: {
      modes: ["X1", "P1"],
      requireTrue: ["opt_bedlevel_cooling"],  // nur, wenn aktiv
      requireFalse: []
    },
    payload:
      `; ====== Cool Down : optional lift =====
  M400                ;wait for all print moves to be done
  M17 Z0.4            ;lower z motor current to reduce impact if there is something in the top
  G1 Z1 F600          ;move nozzle up, BE VERY CAREFUL this can hit the top of your print, extruder or AMS
  M400                ;wait all motion done`
  },
  {
    id: "cooldown_fans_wait",
    description: "Cool down sequence with fans and timed bed waits",
    enabled: true,
    order: 20,
    action: "insert_after",
    // Falls optional_lift vorhanden → daran anhängen, sonst an M17 R ...
    anchor: "(^|\\n)[ \\t]*;>>> INSERT:cooldown_optional_lift END[ \\t]*(\\n|$)|(^|\\n)[ \\t]*M17 R ; restore z current[ \\t]*(\\n|$)",
    occurrence: "last",
    useRegex: true,           // ← WICHTIG!
    scope: "endseq",
    wrapWithMarkers: true,
    when: { modes: ["X1", "P1"], requireTrue: [], requireFalse: [] },
    payloadFnId: "cooldownFansWait"
  },
  {
    id: "raise_bed_after_cooldown",
    description: "Raise Bed Level after cooldown using max_z_height",
    enabled: true,
    order: 30,                         // nach cooldown_fans_wait (z.B. 20)
    action: "insert_after",
    // Wir verankern an das Ende des zuvor eingefügten Cooldown-Blocks:
    anchor: ";>>> Cooldown_fans_wait END",
    occurrence: "last",
    useRegex: false,
    scope: "endseq",
    wrapWithMarkers: true,             // idempotent
    when: {
      modes: ["X1", "P1"],
      requireTrue: [],
      requireFalse: []
    },
    // Dynamischer Inhalt wird in app.js generiert:
    payloadFnId: "raiseBedAfterCoolDown"
  },
  {
    id: "push_off_sequence",
    description: "Insert push-off sequence after raising bed",
    enabled: true,
    order: 40,
    action: "insert_after",
    anchor: ";>>> INSERT:raise_bed_after_cooldown END",  // direkt an die vorige Regel anhängen
    occurrence: "last",
    useRegex: false,
    scope: "endseq",
    wrapWithMarkers: true,
    when: {
      modes: ["X1", "P1"],
      requireTrue: [],
      requireFalse: []
    },
    // Dynamisch generierter Inhalt (siehe Payload-Builder unten)
    payloadFnId: "buildPushOffPayload"
  },
  /* 1) M73: In allen Platten außer der letzten alle "M73 P100 R0" auskommentieren */
  {
    id: "m73_drop_nonlast",
    description: "Disable M73 P100 R0 on all but last plate (X1/P1)",
    enabled: true,
    order: 90,
    scope: "endseq",
    action: "remove_lines_matching",
    // globaler Regex, keine äußeren Marker nötig:
    pattern: "^\\s*M73\\s+P100\\s+R0[^\n]*$",
    patternFlags: "gmi",
    when: { modes: ["X1", "P1"], requireTrue: [], requireFalse: [] },
    onlyIf: { isLastPlate: false }
  },
  /* 3) Erste Extrusion pro Platte auf E3 anheben */
  {
    id: "first_extrusion_bump",
    description: "Raise first extrusion to E3 per plate",
    enabled: true,
    scope: "body",
    order: 80,
    when: { modes: ["X1", "P1"], requireTrue: [], requireFalse: [] },
    action: "bump_first_extrusion_to_e3"   // nutzt deine bestehende Logik als Helper
  },
  {
    id: "remove_header_non_first_plates",
    description: "Remove header from all plates except the first one",
    enabled: true,
    order: 5, // Early order to run before other rules
    action: "remove_header_block",
    scope: "all",
    when: { modes: ["X1", "P1", "A1M"], requireTrue: [], requireFalse: [] },
    onlyIf: { plateIndexGreaterThan: 0 }
  },
  {
    id: "add_plate_marker_first_plate",
    description: "Add plate marker after EXECUTABLE_BLOCK_START on first plate",
    enabled: true,
    order: 6,
    action: "insert_after",
    scope: "all",
    useRegex: true,
    occurrence: "first",
    anchor: "(^|\\n)[ \\t]*;[ \\t]*EXECUTABLE_BLOCK_START[ \\t]*(\\n|$)",
    when: { modes: ["X1", "P1", "A1M"], requireTrue: [], requireFalse: [] },
    onlyIf: { plateIndexEquals: 0 },
    payload: "; start printing plate 1\n",
    wrapWithMarkers: false
  },
  {
    id: "a1m_prepend_startseg",
    description: "Insert A1M start segment AFTER ; EXECUTABLE_BLOCK_START on first plate",
    enabled: true,
    order: 10,
    action: "insert_after",
    scope: "all",
    useRegex: true,
    occurrence: "first",
    anchor: "(^|\\n)[ \\t]*;[ \\t]*EXECUTABLE_BLOCK_START[ \\t]*(\\n|$)",
    when: { modes: ["A1M"], requireTrue: [], requireFalse: [] },
    onlyIf: { plateIndexEquals: 0 },
    payload: SWAP_START_A1M,
    wrapWithMarkers: true
  },
  {
    id: "a1m_append_endseg",
    description: "Insert A1M end segment BEFORE ; EXECUTABLE_BLOCK_END on every plate",
    enabled: true,
    order: 90,
    action: "insert_before",
    scope: "all",
    useRegex: true,
    occurrence: "last",
    anchor: "(^|\\n)[ \\t]*;[ \\t]*EXECUTABLE_BLOCK_END[ \\t]*(\\n|$)",
    when: { modes: ["A1M"], requireTrue: [], requireFalse: [] },
    payload: SWAP_END_A1M,
    wrapWithMarkers: true
  }
];

