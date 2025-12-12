# AutoEject - Extended Swaplist.app (local)

A lightweight, fully client-side web app for converting **Bambu Lab / Orca Slicer** multi-plate projects into **SWAP files** or customized **GCODE**.
The app runs 100% in your browser – no server, no data collection, no installation required.

This project is based on [swaplist.app](https://swaplist.app) by **Novibar GmbH**, originally designed for the **SWAP mode on the Bambu Lab A1 Mini**.
It has been extended by **Raphael Gubler** to support automated routines for the **P1** and **X1** models.
The GCODE modification concepts implemented here are inspired by ideas from **Factorian Designs by Valerian W.**

---

## 🚀 Features

- **Drop & Convert**
  Drag & drop sliced `.gcode.3mf` files (from Bambu Studio or Orca Slicer) into the app. SWAP files or customized GCODE will be generated instantly.
  **Important**: Only fully sliced project files (format: `filename.gcode.3mf`) are accepted. Unsliced 3D model files or plain `.gcode` files are not supported.

- **App Mode Toggle**
  Switch between **SWAP Mode** and **Push-off Mode** depending on your printer and automation system:
  - **SWAP Mode**: For A1/A1M with Swaplist, 3Print, or Printflow systems
  - **Push-off Mode**: For X1/P1 series with automated push-off sequences

- **Printer Model Auto-Detection**
  - The app reads `; printer_model = ...` from the GCODE header.
  - Supported printers:
    - **Bambu Lab X1 Carbon / X1 / X1E → Mode X1**
    - **Bambu Lab P1P / P1S → Mode P1**
    - **Bambu Lab A1 mini → Mode A1M**
    - **Bambu Lab A1 → Mode A1**
  - Printer selection is automatic; the mode toggle adapts to detected hardware.
  - If an unsupported model is detected → the plate is rejected with a warning.
  - If multiple plates are loaded → only plates from the same printer model are accepted.

- **Automation System Support**
  - **Swapmod**: Original system for A1 Mini automatic plate swapping (A1M only)
  - **JoBox**: Plate swapping system for A1 series
  - **3Print**: Advanced automation system for A1 series
  - **Printflow**: Alternative automation system for A1 series
  - **Push-off Mode**: Built-in automation for X1/P1 series using print head

  **Mode Switching (A1 only)**:
  - Click the system logos (JoBox, 3Print, Printflow) at the top of the app to switch between different plate-swapper systems
  - ⚠️ **CRITICAL WARNING**: You MUST select the correct mode that matches your physically installed plate-swapper system. Using the wrong mode can cause serious damage to your printer!

- **Queue Handling**
  - Multiple plates can be loaded into a print queue.
  - Queue statistics (total time, number of plates) are calculated automatically.
  - Each plate shows duration, repeat count, and filament usage.
  - **Drag & Drop Reordering**: Plates can be reordered by dragging and dropping them in the list.

- **Per-Plate Controls**
  - Each plate has its own **repeat counter**.
  - Object coordinates can be adjusted (X/Y per object).
  - A small "X" button in the top-right corner removes a plate from the queue.
  - If the last plate is removed, the entire app resets automatically.

- **Plate Duplication (+)**
  - Every plate has a small round **+** button on the image. Clicking it duplicates the plate (including repeats and per-plate settings).
  - The button also works on duplicated plates thanks to delegated event handling.

- **AMS Slot Mapping & Color System**
  - Each plate shows its filament swatches and the slot number (1–4).
  - Click a filament swatch on a plate to open a slot dropdown and re-assign the slot **for that plate only** (pure UI change; statistics remain stable).
  - The **Filament usage statistics** block displays four global slot swatches (Slot 1–4). On initial import, their colors are derived from the plates' first occurrences; you can override them via color picker. These global colors are used for the dropdown chips and the statistics view.

- **Per-plate Object Coordinates (X1/P1)**
  - In X1/P1 modes, each plate gets a compact **"Objects on this plate"** section where you can pick the number of objects and enter **X coordinates** per object.
  - Built-in validation guarantees there are no zero/empty X values before export.

- **Advanced Cooldown & Secure Push-off (X1/P1)**
  - Optional **Raise Bed Level for cooling**: raises the bed to fan height to speed up cooling.
  - **Advanced cooldown settings**:
    - Bed raise offset before push-out (mm)
    - Cooldown target bed temperature (°C)
    - Max cooldown time (min) – implemented via repeated `M190` waits
  - **Secure push-off sequence**: performs multiple controlled push-offs at descending Z heights before the final push at Z=1.

- **Startsequence Optimization (X1/P1)**
  - **Disable bed leveling between plates**: Skips bed leveling for all plates after the first one to speed up multi-plate printing
    - *Theory*: The bed was already leveled at print initialization, so re-leveling between plates should not be necessary
    - *Risk*: Small risk that the push-off process may have affected the print head's leveling calibration
    - Use this if print speed is more important than maximum reliability
  - **Disable first layer scan**: Disables the first layer inspection scan to speed up print start
    - Removes the automatic quality check
    - Use this if you consider the scan unnecessary or prefer speed over additional quality assurance

- **Printer Sound Management (A1/A1M)**
  - **Disable printer sounds**: Control sound removal with options to:
    - Remove all printer sounds completely
    - Remove sounds only between plates (keeps start/end sounds)
  - Only affects A1/A1M printers

- **AMS Optimization (A1/A1M)**
  - **Enable AMS redundancy removal**: Automatically removes redundant AMS filament swaps between plates
  - Eliminates unnecessary "unload all" + "load same slot" sequences
  - Makes multi-plate prints more efficient
  - Only available for A1/A1M printers

- **Rule Engine for GCODE (Header/Start/Body/End Scopes)**
  - Rules are declared in `assets/js/commands/swapRules.js` and applied with context (plate index, last plate, current mode).
  - Supported actions: `disable_between`, `disable_specific_lines`, `insert_after`, `insert_before`, `remove_lines_matching`, `keep_only_last_matching`, `bump_first_extrusion_to_e3`.
  - Examples included:
    - Disable bed leveling on plates > 0 (X1/P1)
    - Disable filament purge after first plate (option-controlled)
    - Inject A1 mini start/end sequences
    - Cooldown → raise bed → push-off chain
    - Remove `M73 P100 R0` on non-last plates

- **Settings Panel Organization**
  - **Global Settings**: Apply to all plates (cooling, sounds, AMS optimization, file settings, startsequence)
  - **Per-Plate Settings**: Click any plate to configure individual settings (objects, nozzle, push-off)
  - **Loop Repeats**: Control how many times the entire queue is repeated
  - **Progress Display**: Choose between per-plate or global progress calculation
    - **Per plate**: Shows progress and time remaining for current plate only (default)
    - **Global**: Shows overall progress across all plates in the queue

- **Test File Export**
  - **Generate test file**: Creates files with only start and end sequences (no actual print code)
  - Perfect for verifying plate-swap logic, heating sequences, and GCODE modifications
  - Goes through all plate changes but skips object printing
  - **Configurable wait time**: Set the wait time between plates in test mode (default: 30 seconds)

- **GCODE Safety Checks**
  - When exporting SWAP or GCODE, the app validates:
    - **X coordinates** → must not be zero in X1/P1 mode, otherwise a warning popup appears and the invalid fields are highlighted in red.
    - **Printer mode consistency** → mismatched plates are rejected.

- **Project Settings Override**
  - **Override project & filament settings**: Regenerates filament entries and material/printer settings
  - Essential when using new AMS slot assignments not present in original G-code
  - When disabled, original 3MF metadata is preserved

- **Custom File Name**
  - Define your own output file name (`output_file_name.swap.3mf`).
  - Loop repeats can be set globally for the queue.

- **Debug & Development Tools**
  - **Compare Settings**: Compare original vs. modified project_settings.config
  - **Compare Template**: Compare template vs. modified project settings
  - **Compare GCODE**: Compare test GCODE files line by line
  - All comparisons log differences to browser console for debugging

- **Offline & Secure**
  - All logic runs locally in your browser.
  - No uploads, no servers, no cloud storage.
  - Works even if you save the app as a local `.html` file and run it offline.

## 🔧 AMS Slot Remapping on Export

When you re-assign a slot on a plate (via the swatch dropdown), the app rewrites AMS commands at export time so the GCODE matches your UI mapping:

- **A1 mini**: lines like `M620 S3A` / `M621 S3A` (S = 0..3, `A` flag preserved) are rewritten to the new slot.
- **X1/P1**: AMS commands without suffix are supported (`M620`, `M621`). (Legacy `M620.11 I&` is detected for scanning but not rewritten unless explicitly extended.)

Implementation notes:
- Original slots per plate are stored in the plate DOM and compared to the current UI slot. Differences generate a per-plate override map.
- Rewriting is handled by `applyAmsOverridesToPlate()` during the export pipeline.
- Parameter parsing (e.g. `S` and optional `A`) is robust to whitespace and order; unknown tokens are preserved.

> Tip: Slot changes are **per plate** and do not modify the global statistics colors. Statistics colors can be manually overridden via the color picker in the "Filament usage statistics" block.

### How-to: Slot mapping and colors

- **Change a plate's slot**: Click a filament swatch on that plate → choose "Slot 1–4" from the dropdown.
  This changes the slot **only for that plate** (export will rewrite AMS commands accordingly).
- **Edit global slot colors**: Click a color swatch in **Filament usage statistics** to open a color picker.
  Initial colors are derived from the first seen colors on import; your overrides persist in the UI during the session.
- **Duplicate a plate**: Click the small round **+** button on the plate image. The copy appears right after the original.

### ⚠️ Known Limitations

- Only AMS commands **without** numerical suffix are rewritten by default (`M620`, `M621`).
  If you rely on legacy forms like `M620.11 I&`, extend the override function accordingly.
- Statistics and slot color overrides are session-local (no persistence).
- Export validates X coordinates only in X1/P1 modes (A1M does not use per-object coordinates).

## 💾 Installation

1. Clone this repository or download it as ZIP:
   ```bash
   git clone https://github.com/balin77/SwapList-Customizable-Multi-Plate-G-Code-Post-Processor-for-Bambu-Lab-Printers.git
   ```

2. Open index.html in any modern browser (Chrome, Firefox, Edge).
   That's it – no server required.

## 🎯 Usage

1. Launch index.html in your browser.
2. Drag & drop a sliced `.gcode.3mf` file (from Bambu Studio / Orca Slicer) into the drop zone.
   - **Important**: Only fully sliced project files are accepted (format: `filename.gcode.3mf`)
3. The app automatically detects your printer model and updates the UI.
4. **(A1 only)** Select your installed plate-swapper system by clicking the appropriate logo (JoBox, 3Print, or Printflow)
   - ⚠️ **WARNING**: Using the wrong mode can damage your printer!
5. Configure per-plate or global options if desired:
   - Click on individual plates to access plate-specific settings
   - Adjust global settings (cooling, sounds, progress display, etc.)
   - Drag plates to reorder the print queue
6. Choose one of the actions:
   - Generate SWAP file → creates a new .swap.3mf
   - Export GCODE → creates a plain-text GCODE file with all rules applied
7. Monitor progress with the built-in progress bar.
8. If needed, reset the app with the Reset button.

## 🖨️ Supported Printers

- Bambu Lab X1 Carbon
- Bambu Lab X1
- Bambu Lab X1E
- Bambu Lab A1 mini
- Bambu Lab A1
- Bambu Lab P1P / P1S
- Other models → not yet supported (app will show a warning).

## 🔐 Data Security

- No network requests are made.
- No data is uploaded or stored remotely.
- No cookies, no trackers, no local storage.
- All conversion and processing happens locally in your browser.

## 🛠️ Development

### Commands

- **Build for production**: `npm run build`
- **Development with watch mode**: `npm run dev`
- **Generate filament index**: `node scripts/gen-filament-index.mjs` (runs automatically with build/dev)

### Architecture

The build system uses esbuild to bundle `assets/js/index.js` into `dist/bundle.js`. The application follows a modular structure with clear separation of concerns:

- **Entry Point**: `assets/js/index.js` → initializes via `initialize_page()` from `config/initialize.js`
- **Core modules**: Configuration, I/O operations, GCODE processing, UI components, and utilities
- **Rule Engine**: Declarative rules in `assets/js/commands/swapRules.js` for printer-specific GCODE modifications

## 👏 Credits

- Based on swaplist.app by Novibar GmbH
- Originally designed for the SWAP mode on the A1 Mini
- Extended by Raphael Gubler with automation routines for X1 and P1 models
- GCODE modification ideas by Factorian Designs (Valerian W.)