/**
 * Swap Rules Module
 *
 * This module defines declarative rules for GCODE modifications based on printer model,
 * app mode, and various conditions. The rule engine applies these rules to generate
 * customized GCODE for multi-plate printing with automatic plate swapping.
 */

import type { SwapRule } from '../types/index.js';

// ============================================================================
// GCODE Snippet Constants
// ============================================================================

export const HEATERS_OFF = `
M104 S0 ; Set Hot-end to 0C (off)
M140 S0 ; Set bed to 0C (off)
`;

export const GCODE_WAIT_30SECONDS = `
G4 P30000 ; wait 30 seconds
`;

/**
 * Generate a wait command with configurable duration
 */
export function generateWaitCommand(seconds: number = 30): string {
  const milliseconds = seconds * 1000;
  return `G4 P${milliseconds} ; wait ${seconds} seconds\n`;
}

export const HOMING_All_AXES = `
G28; home all axes
`;

export const HOMING_XY_AXES = `
G28 XY; home xy axes
`;

export const START_SOUND_A1M = `
;=====start printer sound ===================
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A43 B10 L100 C46 D10 M70 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C43 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C41 D10 M80 E41 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E44 F10 N80
M1006 A0 B10 L100 C49 D10 M80 E49 F10 N80
M1006 A0 B10 L100 C0 D10 M80 E0 F10 N80
M1006 A44 B10 L100 C48 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A43 B10 L100 C46 D10 M60 E39 F10 N80
M1006 W
M18
;=====start printer sound ===================
`;

export const END_SOUND_A1M = `
;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A0 B20 L100 C37 D20 M40 E42 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C46 D10 M80 E46 F10 N80
M1006 A44 B20 L100 C39 D20 M60 E48 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N80
M1006 A44 B20 L100 C49 D20 M80 E41 F20 N80
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N80
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W
;=====printer finish  sound=========
`;

export const SWAP_START_A1M = `
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
G0 X70 Y70 F15000; ready
G28 Z; home z axis
`;

export const SWAP_END_A1M = `
; ==== A1M PLATE_SWAP_FULL ====
; === swapmod: SWAPLIST
G0 X-10 F5000;  park extruder
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
G4 P1000; wait
; ==== A1M PLATE_SWAP_FULL END ====`;

export const A1_3Print_START = `
; ==== A1 PLATE_GRAB_ONLY ====
G91                     ; relative positioning
G380 S2 Z50 F1200       ; lift Z by 50mm
G380 S3 Z-20 F1200      ; lower Z by 20mm
G90                     ; return to absolute positioning
G28 XY                  ; home XY axes
G0  X-10 F5000          ; move X slightly out of the way

; --- Grab/Set Sequence ---
;M211 S0                 ; disable soft endstops
G0  Y0   F2500          ; "grab": grip at the back
G0  Y170 F2000          ; "pull": plate forward
G0  Y43 F2000           ; rehook
G0  Y266 F2000          ; pull new plate forward
G0  Y20 F2000           ; move to "set" position
G4  P500
G0  Y0 F300             ; snap plate
G0  Y5 F300             ; let plate fall
G4  P500
G0  X150 Y150 F5000          ; safe park position
G28 Z                   ; home Z axis
; ==== End GRAB_ONLY ====`;

export const A1_3Print_END = `
; ==== A1 PLATE_SWAP_FULL ====
; === swapmod: 3PRINT
G90;
;M211 S0                ; disable soft endstops

; --- Pull off sequence ---

G0 Y266 Z260 F2500      ; bring plate in position and raise Z to activate front hook
G4 P1000
G0 Y50 F1000
G0 Y0 Z160 F2500        ; hook new plate and lower Z

; --- Push build plate off buildplate ---

G0 Y170 F2000           ; rehook old plate at second front hook
G0 Y43 F2000            ; release old plate from bed almost entirely

; --- Set new plate sequence ---

G0 Y266 F2000           ; pull new plate forward and push off old plate
G0  Y20 F2000           ; move to "set" position
G4  P500
G0  Y0 F300             ; snap plate
G0  Y5 F300             ; let plate fall
G4  P500
G0  Y150 F2000          ; safe park position
; ==== A1 PLATE_SWAP_FULL END ====`;

export const A1_JOBOX_START = `
; ==== A1 JOBOX GRAB_ONLY ====
G28 XY                      ; home XY axes
G0 X-33 Z30                 ; position X and Z for plate grab
G0 Y0 F2000                 ; move to grab position
G0 Y256 F2000               ; initial pull
G0 Y210 F2000               ; reposition
G0 Y265 F2000               ; full pull
G0 Y-2 F2000                ; push back slightly
G0 Y15 F2000                ; small adjustment
G0 Y-2 F2000                ; push back again
G0 Y20 F2000                ; set position
G0 Y100 F2000               ; park position
G28                         ; home all axes
G0 Z50                      ; lift Z for safety
; ==== End JOBOX GRAB_ONLY ====
`;

export const A1_JOBOX_END = `
; ==== A1 PLATE_SWAP_FULL ====
; === swapmod: JOBOX
G0 Y265 F2000               ; print bed to front position
G0 X-37 F2000               ; move print head to side for plate swap NEW!!
G0 Z-12 F2000               ; lower Z to engage front hook
G0 Y250 F2000               ; engage front hook and pull plate back
G0 Y240 Z250 F2000          ; bring print head to safe height before pull back
;G0 Y100 F2000              ; move old plate to intermediate position (not necessary??)
G0 Y0 F2000                 ; move back to remove old plate and grab new plate
G0 Y256 F2000               ; initial pull of new plate
G0 Y210 F2000               ; reposition new plate
G0 Y10 F2000                ; position old plate for throw off
G0 Y265 F2000               ; throw off old plate and pull of new plate
G0 Y-2 F2000                ; set new plate first time
G0 Y15 F2000                ; small adjustment to new plate
G0 Y-2 F2000                ; final fine positioning
G0 Y20 F2000                ; set position
G0 Y100 F2000               ; park position
; ==== A1 PLATE_SWAP_FULL END ====
`;

export const A1_PRINTFLOW_START = `
M17 X1.2 Y1.2 Z0.75 ; START
G28           ; home all axes
;G1 Y0 F2000  ; move the bed backward and grab a new plate
G1 Y250 F3000 ; move the bed with the new plate
G1 Y267 F1500 ; move the bed with the new plate
G1 Y30 F3000;
G1 Y-1.8 F500;
G1 Y8.5 F100;
M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
G1 Y-2 F500
M17 X1.2 Y1.2 Z0.75; motor current to 100% power
G1 Z150 F1500
G1 X150 Y150 F5000; END
G28 Z; Home z axis
`;

export const A1_PRINTFLOW_END = `
; ==== A1 PLATE_SWAP_FULL ====
; === swapmod: PRINTFLOW
M17 X1.2 Y1.2 Z0.75 ; START
G1 Y264 Z235 F4000 ; move the bed all the way forward and hook
G1 Y160 F1000
G1 Y210 F1000
G1 Y80 F1000
G1 Y140 F1000
G1 Y20 F1000 ; move the bed 250mm backward
G1 Y150 F2000 ; move the bed 150mm Forward
G1 Y-1 Z190 F3000 ; move the bed backward and grab a new plate
G28 Y
G1 Y250 F3000 ; move the bed with the new plate
G1 Y267 F1500 ; move the bed with the new plate
G1 Y30 F3000;
M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
G1 Y-2 F500; -1.8
G1 Y8.5 F100;
M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
G1 Y-2 F500; -1.8
M17 X1.2 Y1.2 Z0.75; motor current to 100% power
G1 Z150 F1500
G1 Y150 F3000; END
; ==== A1 PLATE_SWAP_FULL END ====
`;

export const X1_P1_NOZZLE_CLEANING = `
;===== X1/P1 CUSTOM NOZZLE CLEANING START =====

G1 X60 Y265 F15000 ; nozzle wipe position
G92 E0 ; zero extruder
G1 E-0.5 F300 ; retract filament
G1 X100 F5000 ; wipe right
G1 X70 F15000 ; wipe left
G1 X100 F5000 ; wipe right
G1 X70 F15000 ; wipe left
G1 X100 F5000 ; wipe right
G1 X70 F15000 ; wipe left
G1 X100 F5000 ; wipe right
G1 X70 F15000 ; wipe left
G1 X60 F5000 ; clearance

G28 X Y ; Home X and Y axes

;===== X1/P1 CUSTOM NOZZLE CLEANING END =====
`;

export const A1_NOZZLE_CLEANING = `
;===== A1 CUSTOM NOZZLE CLEANING START =====

G92 E0 ; zero extruder
G1 E-0.5 F300 ; retract filament

G1 X55 Y262.5 F15000 ; nozzle wipe position start

G1 Z0.4; nozzle down (matching default z height when original wipe happens)

G1 X20 Y262.5 F15000 ; first wipe

G1 X20 Y262 F15000 ; Y down
G1 X65 Y262 F15000 ; wipe

G1 X65 Y261.5 F15000 ; Y down
G1 X20 Y261.5 F15000 ; wipe

G1 X20 Y261 F15000 ; Y down
G1 X65 Y261 F15000 ; wipe

G1 X65 Y260.5 F15000 ; Y down
G1 X20 Y260.5 F15000 ; wipe

G1 X20 Y260 F15000 ; Y down
G1 X65 Y260 F15000 ; wipe

; X-cross wipe Start
G1 X20 Y262.5 F15000 ; starting position
G1 X20 Y260 F15000 ; down \\ wipe
G1 X65 Y262.5 F15000 ; / wipe
G1 X65 Y260 F15000 ; down
G1 X20 Y262.5 F15000 ; \\ wipe
G1 X20 Y260 F15000 ; down
G1 X65 Y262.5 F15000 ; / wipe
G1 X65 Y260 F15000 ; down

;===== A1 CUSTOM NOZZLE CLEANING END =====
`;

// ============================================================================
// Swap Rules Definition
// ============================================================================

/**
 * Declarative rules for GCODE modifications based on printer model and mode
 *
 * Each rule specifies:
 * - when: conditions for applying the rule (printer model, app mode, options)
 * - onlyIf: context-specific conditions (plate index, etc.)
 * - action: what modification to perform
 * - scope: which part of the GCODE to modify (startseq, endseq, body, all)
 */
export const SWAP_RULES: SwapRule[] = [

  // ===== X1/P1 RULES =====

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
      appModes: ["pushoff"],
      requireTrue: ["opt_disable_bed_leveling"],
      requireFalse: []
    },
    onlyIf: { plateIndexGreaterThan: 0 },
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
      modes: ["X1", "P1"],
      appModes: ["pushoff"],
      requireTrue: ["opt_filament_purge_off"],
      requireFalse: []
    },
    onlyIf: {
      plateIndexGreaterThan: 0
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
      modes: ["X1"],
      appModes: ["pushoff"],
      requireTrue: ["opt_disable_first_layer_scan"],
      requireFalse: []
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
      modes: ["X1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
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
      modes: ["X1", "P1"],
      appModes: ["pushoff"],
      requireTrue: ["opt_disable_mech_mode_fast_check"],
      requireFalse: []
    },
    onlyIf: { plateIndexGreaterThan: 0 },
    action: "disable_between"
  },
  {
    id: "nozzle_load_line_inner",
    description: "Disable lines between T1000 and M400 within nozzle load line block",
    enabled: true,
    start: ";===== nozzle load line ===============================",
    end: ";===== for Textured PEI Plate",
    useRegex: false,
    scope: "startseq",
    innerStart: "T1000",
    innerEnd: "M400",
    innerUseRegex: false,
    when: {
      modes: ["X1", "P1"],
      appModes: ["pushoff"],
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
      modes: ["X1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
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
      modes: ["X1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
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
      modes: ["X1"],
      appModes: ["pushoff"],
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
      modes: ["X1", "P1"],
      appModes: ["pushoff"],
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
      appModes: ["pushoff"],
      requireTrue: ["opt_bedlevel_cooling"],
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
    anchor: "(^|\\n)[ \\t]*;>>> INSERT:cooldown_optional_lift END[ \\t]*(\\n|$)|(^|\\n)[ \\t]*M17 R ; restore z current[ \\t]*(\\n|$)",
    occurrence: "last",
    useRegex: true,
    scope: "endseq",
    wrapWithMarkers: true,
    when: { modes: ["X1", "P1"], appModes: ["pushoff"], requireTrue: [], requireFalse: [] },
    payloadFnId: "cooldownFansWait"
  },
  {
    id: "raise_bed_after_cooldown",
    description: "Raise Bed Level after cooldown using max_z_height",
    enabled: true,
    order: 30,
    action: "insert_after",
    anchor: ";>>> Cooldown_fans_wait END",
    occurrence: "last",
    useRegex: false,
    scope: "endseq",
    wrapWithMarkers: true,
    when: {
      modes: ["X1", "P1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    payloadFnId: "raiseBedAfterCoolDown"
  },
  {
    id: "push_off_sequence",
    description: "Insert push-off sequence after raising bed",
    enabled: true,
    order: 40,
    action: "insert_after",
    anchor:  ";>>> Raise_bed_after_cooldown END",
    occurrence: "last",
    useRegex: false,
    scope: "endseq",
    wrapWithMarkers: true,
    when: {
      modes: ["X1", "P1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    payloadFnId: "buildPushOffPayload"
  },
  {
    id: "m73_drop_nonlast",
    description: "Disable M73 P100 R0 on all but last plate (X1/P1)",
    enabled: true,
    order: 90,
    scope: "endseq",
    action: "remove_lines_matching",
    pattern: "^\\s*M73\\s+P100\\s+R0[^\n]*$",
    patternFlags: "gmi",
    when: { modes: ["X1", "P1"], appModes: ["pushoff"], requireTrue: [], requireFalse: [] },
    onlyIf: { isLastPlate: false }
  },
  {
    id: "first_extrusion_bump",
    description: "Distribute E3 across first three extrusions per plate",
    enabled: true,
    scope: "body",
    order: 80,
    when: { modes: ["X1", "P1"], appModes: ["pushoff"], requireTrue: [], requireFalse: [] },
    action: "bump_first_three_extrusions_x1_p1"
  },

  // ===== UNIVERSAL RULES (ALL PRINTERS) =====

  {
    id: "remove_header_non_first_plates",
    description: "Remove header from all plates except the first one",
    enabled: true,
    order: 5,
    action: "remove_header_block",
    scope: "all",
    when: { modes: ["X1", "P1", "A1M", "A1"], appModes: ["pushoff", "swap"], requireTrue: [], requireFalse: [] },
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
    when: { modes: ["X1", "P1", "A1M", "A1"], appModes: ["pushoff", "swap"], requireTrue: [], requireFalse: [] },
    onlyIf: { plateIndexEquals: 0 },
    payload: "; start printing plate 1\n",
    wrapWithMarkers: false
  },

  // ===== A1 RULES =====

  {
    id: "a1_mech_mode_fast_check",
    description: "Disable mech mode fast check for A1 in pushoff and swap modes",
    enabled: true,
    start: ";===== mech mode fast check start =====================",
    end: ";===== mech mode fast check end =======================",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["A1"],
      appModes: ["pushoff", "swap"],
      requireTrue: ["opt_disable_mech_mode_fast_check"],
      requireFalse: []
    },
    onlyIf: { plateIndexGreaterThan: 0 },
    action: "disable_between"
  },
  {
    id: "a1_bed_leveling",
    description: "Disable bed leveling for A1 in pushoff mode",
    enabled: true,
    start: ";===== bed leveling ==================================",
    end: ";===== bed leveling end ================================",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["A1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    onlyIf: { plateIndexGreaterThan: 0 },
    action: "disable_between"
  },
  {
    id: "a1_extrude_cali_test",
    description: "Disable extrude cali test for A1 in pushoff mode (all plates)",
    enabled: true,
    start: ";===== extrude cali test ===============================",
    end: ";========turn off light and wait extrude temperature =============",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["A1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    action: "disable_between"
  },
  {
    id: "a1_nozzle_cooling_sequence",
    description: "Insert nozzle cooling sequence after extrude temperature setup for A1 in pushoff mode",
    enabled: true,
    order: 25,
    action: "insert_after",
    anchor: ";========turn off light and wait extrude temperature =============\nM1002 gcode_claim_action : 0\nM400",
    occurrence: "last",
    useRegex: false,
    scope: "startseq",
    wrapWithMarkers: true,
    when: {
      modes: ["A1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    payloadFnId: "a1NozzleCoolingSequence"
  },
  {
    id: "a1_pre_print_extrusion",
    description: "Insert pre-print extrusion sequence before MACHINE_START_GCODE_END for A1 in pushoff mode",
    enabled: true,
    order: 30,
    action: "insert_before",
    anchor: "; MACHINE_START_GCODE_END",
    occurrence: "last",
    useRegex: false,
    scope: "startseq",
    wrapWithMarkers: true,
    when: {
      modes: ["A1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    payloadFnId: "a1PrePrintExtrusion"
  },
  {
    id: "a1_endseq_motor_current_block",
    description: "Disable motor current block in endseq for A1 in pushoff mode",
    enabled: true,
    order: 33,
    start: "M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom",
    end: "M17 R ; restore z current",
    useRegex: false,
    scope: "endseq",
    when: {
      modes: ["A1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    action: "disable_between"
  },
  {
    id: "a1_endseq_cooldown_insert",
    description: "Insert cooldown sequence after motor current setting for A1 in pushoff mode",
    enabled: true,
    order: 34,
    action: "insert_after",
    anchor: "M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom",
    occurrence: "last",
    useRegex: false,
    scope: "endseq",
    wrapWithMarkers: true,
    when: {
      modes: ["A1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    payloadFnId: "a1EndseqCooldown"
  },
  {
    id: "a1_safety_clear_sequence",
    description: "Insert safety clear sequence after push-off for A1 in pushoff mode",
    enabled: true,
    order: 35,
    action: "insert_after",
    anchor: "G1 Y-0.5 F300        ; very slow push off use x gantry",
    occurrence: "last",
    useRegex: false,
    scope: "endseq",
    wrapWithMarkers: true,
    when: {
      modes: ["A1"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    payloadFnId: "a1SafetyClear"
  },
  {
    id: "a1_endseq_feedrate_block",
    description: "Disable M17 R to M220 S100 block in endseq for A1/A1M in pushoff mode",
    enabled: true,
    order: 37,
    start: "M17 R ; restore z current",
    end: "M220 S100  ; Reset feedrate magnitude",
    useRegex: false,
    scope: "endseq",
    when: {
      modes: ["A1", "A1M"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    action: "disable_between"
  },

  // ===== A1M (SWAP MODE) RULES =====

  {
    id: "a1m_pushoff_mech_mode_inner_disable",
    description: "Disable code between G1 Z5 F3000 and M975 S1 within mech mode fast check block for A1M in pushoff mode",
    enabled: true,
    start: ";===== mech mode fast check============================",
    end: ";===== wipe nozzle ===============================",
    useRegex: false,
    scope: "startseq",
    innerStart: "G1 Z5 F3000",
    innerEnd: "M975 S1",
    innerUseRegex: false,
    when: {
      modes: ["A1M"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    action: "disable_inner_between"
  },
  {
    id: "a1m_pushoff_disable_filament_type_next_line",
    description: "Disable the line following M1002 set_filament_type within nozzle load line block for A1M in pushoff mode",
    enabled: true,
    start: ";===== nozzle load line ===============================",
    end: "M412 S1 ;    ===turn on  filament runout detection===",
    pattern: "M1002 set_filament_type:",
    useRegex: false,
    patternUseRegex: false,
    scope: "startseq",
    when: {
      modes: ["A1M"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    action: "disable_next_line_after_pattern_in_range"
  },
  {
    id: "a1m_pushoff_disable_m400_s2_to_extrude_cali",
    description: "Disable code between M400 S2 and extrude cali test block for A1M in pushoff mode",
    enabled: true,
    start: "M400 S2",
    end: ";===== extrude cali test ===============================",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["A1M"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    action: "disable_between"
  },
  {
    id: "a1m_pushoff_disable_extrude_cali_test_block",
    description: "Disable extrude cali test block for A1M in pushoff mode",
    enabled: true,
    start: ";===== extrude cali test ===============================",
    end: ";========turn off light and wait extrude temperature =============",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["A1M"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    action: "disable_between"
  },
  {
    id: "a1m_pushoff_insert_temp_sequence_after_extrude_cali",
    description: "Insert temperature control sequence after extrude cali test comment for A1M in pushoff mode",
    enabled: true,
    order: 15,
    action: "insert_after",
    anchor: ";===== extrude cali test ===============================",
    occurrence: "first",
    useRegex: false,
    scope: "startseq",
    wrapWithMarkers: true,
    when: {
      modes: ["A1M"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    payloadFnId: "a1mPushoffTempSequence"
  },
  {
    id: "a1m_pushoff_insert_extrusion_after_m1007",
    description: "Insert extrusion sequence after M1007 S1 for A1M in pushoff mode",
    enabled: true,
    order: 20,
    action: "insert_after",
    anchor: "M1007 S1",
    occurrence: "first",
    useRegex: false,
    scope: "startseq",
    wrapWithMarkers: true,
    when: {
      modes: ["A1M"],
      appModes: ["pushoff"],
      requireTrue: [],
      requireFalse: []
    },
    payloadFnId: "a1mPushoffExtrusionSequence"
  },
  {
    id: "a1m_prepend_startseg",
    description: "Insert A1M start segment AFTER ; EXECUTABLE_BLOCK_START on first plate (SWAP mode only)",
    enabled: true,
    order: 10,
    action: "insert_after",
    scope: "all",
    useRegex: true,
    occurrence: "first",
    anchor: "(^|\\n)[ \\t]*;[ \\t]*EXECUTABLE_BLOCK_START[ \\t]*(\\n|$)",
    when: { modes: ["A1M"], appModes: ["swap"], requireTrue: [], requireFalse: [] },
    onlyIf: { plateIndexEquals: 0 },
    payload: SWAP_START_A1M,
    wrapWithMarkers: true
  },
  {
    id: "wait_before_swap_a1m",
    description: "Insert wait sequence before A1M swap end sequence (SWAP mode only)",
    enabled: true,
    order: 89,
    action: "insert_before",
    scope: "all",
    useRegex: true,
    occurrence: "last",
    anchor: "(^|\\n)[ \\t]*;[ \\t]*EXECUTABLE_BLOCK_END[ \\t]*(\\n|$)",
    when: { modes: ["A1M"], appModes: ["swap"], requireTrue: [], requireFalse: [] },
    payloadFnId: "waitBeforeSwap",
    wrapWithMarkers: true
  },
  {
    id: "a1m_append_endseg",
    description: "Insert A1M end segment BEFORE ; EXECUTABLE_BLOCK_END on every plate (SWAP mode only)",
    enabled: true,
    order: 90,
    action: "insert_before",
    scope: "all",
    useRegex: true,
    occurrence: "last",
    anchor: "(^|\\n)[ \\t]*;[ \\t]*EXECUTABLE_BLOCK_END[ \\t]*(\\n|$)",
    when: { modes: ["A1M"], appModes: ["swap"], requireTrue: [], requireFalse: [] },
    payload: SWAP_END_A1M,
    wrapWithMarkers: true
  },

  // ===== A1 (SWAP MODE) RULES =====

  {
    id: "a1_prepend_startseg",
    description: "Insert A1 start segment AFTER ; EXECUTABLE_BLOCK_START on first plate (SWAP mode only)",
    enabled: true,
    order: 10,
    action: "insert_after",
    scope: "all",
    useRegex: true,
    occurrence: "first",
    anchor: "(^|\\n)[ \\t]*;[ \\t]*EXECUTABLE_BLOCK_START[ \\t]*(\\n|$)",
    when: { modes: ["A1"], appModes: ["swap"], requireTrue: [], requireFalse: [] },
    onlyIf: { plateIndexEquals: 0 },
    payload: A1_3Print_START,
    wrapWithMarkers: true
  },
  {
    id: "wait_before_swap_a1",
    description: "Insert wait sequence before A1 swap end sequence (SWAP mode only)",
    enabled: true,
    order: 89,
    action: "insert_before",
    scope: "all",
    useRegex: true,
    occurrence: "last",
    anchor: "(^|\\n)[ \\t]*;[ \\t]*EXECUTABLE_BLOCK_END[ \\t]*(\\n|$)",
    when: { modes: ["A1"], appModes: ["swap"], requireTrue: [], requireFalse: [] },
    payloadFnId: "waitBeforeSwap",
    wrapWithMarkers: true
  },
  {
    id: "a1_append_endseg",
    description: "Insert A1 end segment BEFORE ; EXECUTABLE_BLOCK_END on every plate (SWAP mode only)",
    enabled: true,
    order: 90,
    action: "insert_before",
    scope: "all",
    useRegex: true,
    occurrence: "last",
    anchor: "(^|\\n)[ \\t]*;[ \\t]*EXECUTABLE_BLOCK_END[ \\t]*(\\n|$)",
    when: { modes: ["A1"], appModes: ["swap"], requireTrue: [], requireFalse: [] },
    payload: A1_3Print_END,
    wrapWithMarkers: true
  },
  {
    id: "a1_first_three_extrusions_pushoff",
    description: "Increase first three extrusions by 0.5 total for A1 in push off mode when hide nozzle load line is active",
    enabled: true,
    order: 85,
    scope: "body",
    action: "bump_first_three_extrusions_a1_pushoff",
    when: {
      modes: ["A1"],
      appModes: ["pushoff"],
      requireTrue: ["opt_purge"],
      requireFalse: []
    }
  },

  // ===== SOUND REMOVAL RULES =====

  {
    id: "a1_a1m_remove_all_start_sounds",
    description: "Remove all start printer sounds for A1/A1M when sound removal mode is 'all'",
    enabled: true,
    order: 100,
    start: ";=====start printer sound ===================",
    end: ";=====avoid end stop =================",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["A1", "A1M"],
      appModes: ["pushoff", "swap"],
      requireTrue: ["opt_disable_printer_sounds"],
      requireFalse: []
    },
    onlyIf: { soundRemovalMode: "all" },
    action: "disable_between"
  },
  {
    id: "a1_remove_all_finish_sounds",
    description: "Remove all finish printer sounds for A1/A1M when sound removal mode is 'all'",
    enabled: true,
    order: 101,
    start: ";=====printer finish  sound=========",
    end: ";M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power",
    useRegex: false,
    scope: "endseq",
    when: {
      modes: ["A1"],
      appModes: ["pushoff", "swap"],
      requireTrue: ["opt_disable_printer_sounds"],
      requireFalse: []
    },
    onlyIf: { soundRemovalMode: "all" },
    action: "disable_between"
  },
  {
    id: "a1m_remove_all_finish_sounds",
    description: "Remove all finish printer sounds for A1/A1M when sound removal mode is 'all'",
    enabled: true,
    order: 101,
    start: ";=====printer finish  sound=========",
    end: "M400 S1",
    useRegex: false,
    scope: "endseq",
    when: {
      modes: ["A1M"],
      appModes: ["pushoff", "swap"],
      requireTrue: ["opt_disable_printer_sounds"],
      requireFalse: []
    },
    onlyIf: { soundRemovalMode: "all" },
    action: "disable_between"
  },
  {
    id: "a1_a1m_remove_between_plates_start_sounds",
    description: "Remove start printer sounds between plates for A1/A1M when sound removal mode is 'between_plates' (all plates except first)",
    enabled: true,
    order: 102,
    start: ";=====start printer sound ===================",
    end: ";=====avoid end stop =================",
    useRegex: false,
    scope: "startseq",
    when: {
      modes: ["A1", "A1M"],
      appModes: ["pushoff", "swap"],
      requireTrue: ["opt_disable_printer_sounds"],
      requireFalse: []
    },
    onlyIf: { soundRemovalMode: "between_plates", plateIndexGreaterThan: 0 },
    action: "disable_between"
  },
  {
    id: "a1_remove_between_plates_finish_sounds",
    description: "Remove finish printer sounds between plates for A1/A1M when sound removal mode is 'between_plates' (all plates except last)",
    enabled: true,
    order: 103,
    start: ";=====printer finish  sound=========",
    end: ";M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power",
    useRegex: false,
    scope: "endseq",
    when: {
      modes: ["A1"],
      appModes: ["pushoff", "swap"],
      requireTrue: ["opt_disable_printer_sounds"],
      requireFalse: []
    },
    onlyIf: { soundRemovalMode: "between_plates", plateIndexLessThan: "lastPlate" },
    action: "disable_between"
  },
  {
    id: "a1m_remove_between_plates_finish_sounds",
    description: "Remove finish printer sounds between plates for A1/A1M when sound removal mode is 'between_plates' (all plates except last)",
    enabled: true,
    order: 103,
    start: ";=====printer finish  sound=========",
    end: "M400 S1",
    useRegex: false,
    scope: "endseq",
    when: {
      modes: ["A1M"],
      appModes: ["pushoff", "swap"],
      requireTrue: ["opt_disable_printer_sounds"],
      requireFalse: []
    },
    onlyIf: { soundRemovalMode: "between_plates", plateIndexLessThan: "lastPlate" },
    action: "disable_between"
  },
];
