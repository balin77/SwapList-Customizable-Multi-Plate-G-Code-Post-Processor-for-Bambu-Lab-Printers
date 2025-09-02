# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Build for production**: `npm run build`
- **Development with watch mode**: `npm run dev`
- **Generate filament index**: `node scripts/gen-filament-index.mjs` (runs automatically with build/dev)

The build system uses esbuild to bundle `assets/js/index.js` into `dist/bundle.js`.

## Architecture Overview

This is a client-side web application for converting Bambu Lab/Orca Slicer multi-plate projects into SWAP files or customized GCODE. The application runs entirely in the browser with no server dependencies.

### Core Structure

- **Entry Point**: `assets/js/index.js` → initializes via `initialize_page()` from `config/initialize.js`
- **Build Output**: `dist/bundle.js` (bundled with esbuild, loaded by `index.html`)
- **UI**: Single-page application with drag-and-drop file processing

### Key Modules

- **`assets/js/config/`**: Application initialization, state management, and configuration
  - `initialize.js`: Main app initialization and event binding
  - `state.js`: Global application state
  - `mode.js`: Printer mode detection and management
  - `materialConfig.js`: Material and filament configuration
  - `filamentConfig/`: Filament profiles and registry

- **`assets/js/io/`**: File input/output operations
  - `read3mf.js`: 3MF file parsing and plate extraction
  - `readGcode.js`: GCODE file parsing
  - `export3mf.js`: SWAP file generation
  - `exportGcode.js`: GCODE export functionality

- **`assets/js/gcode/`**: GCODE processing and manipulation
  - `buildGcode.js`: GCODE generation and assembly
  - `gcodeManipulation.js`: GCODE modification utilities
  - `readGcode.js`: GCODE parsing and analysis

- **`assets/js/commands/`**: Rule engine for GCODE modifications
  - `swapRules.js`: Declarative rules for printer-specific GCODE modifications
  - `applySwapRules.js`: Rule application engine

- **`assets/js/ui/`**: User interface components
  - `plates.js`: Plate management and display
  - `statistics.js`: Usage statistics calculation
  - `filamentColors.js`: Color management and AMS slot mapping
  - `dropzone.js`: File drop functionality
  - `settings.js`: Settings panel management

- **`assets/js/utils/`**: Utility functions
  - `amsUtils.js`: AMS (Automatic Material System) utilities
  - `colors.js`: Color conversion and manipulation
  - `utils.js`: General utilities

### Printer Support

The application auto-detects printer models from GCODE headers and supports:
- **A1M**: Bambu Lab A1 Mini (SWAP mode)
- **X1**: Bambu Lab X1 series (automated routines)
- **P1**: Bambu Lab P1 series (automated routines)

### Rule Engine

The core feature is a declarative rule system in `commands/swapRules.js` that applies printer-specific modifications:
- **Scopes**: `startseq`, `endseq`, `body`, `all`
- **Actions**: `disable_between`, `insert_after`, `insert_before`, `remove_lines_matching`, etc.
- **Conditions**: Mode-specific, option-dependent, plate context-aware
- **Examples**: Disable bed leveling on subsequent plates, inject cooldown sequences, manage AMS slot remapping

### AMS Slot Remapping

Advanced feature allowing per-plate slot reassignment with GCODE rewriting:
- UI allows clicking filament swatches to change slot assignments
- Export process rewrites `M620`/`M621` commands to match UI mappings
- Preserves parameter syntax and handles both A1M (`M620 S3A`) and X1/P1 (`M620`) variants

### File Processing Pipeline

1. **Input**: Drag-and-drop 3MF or GCODE files
2. **Parsing**: Extract plates, metadata, and GCODE content
3. **Processing**: Apply printer-specific rules and user settings
4. **Export**: Generate SWAP files (.swap.3mf) or modified GCODE

### Development Notes

- Uses ES6 modules with esbuild bundling
- No external framework dependencies (vanilla JavaScript)
- Extensive use of JSZip for 3MF file manipulation
- Client-side only - no network requests or data uploads
- Supports offline usage when saved locally