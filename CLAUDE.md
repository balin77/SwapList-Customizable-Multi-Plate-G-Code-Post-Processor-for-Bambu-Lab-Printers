# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Build for production**: `npm run build`
- **Development with watch mode**: `npm run dev`
- **Generate filament index**: `node scripts/gen-filament-index.mjs` (runs automatically with build/dev)
- **Type checking**: `npx tsc --noEmit` (check TypeScript types without building)

The build system uses esbuild to bundle `assets/js/index.ts` into `dist/bundle.js`.

## TypeScript Migration

This project has been fully migrated to TypeScript for improved type safety and developer experience:

- **Type Definitions**: All core types are in `assets/js/types/index.ts`
- **Strict Configuration**: `tsconfig.json` uses strict type checking
- **ES Modules**: All imports use `.js` extensions (standard for ES modules with TypeScript)
- **Build Process**: esbuild handles TypeScript compilation automatically
- **No Runtime Changes**: Migration is purely additive - no functional changes

## Architecture Overview

This is a client-side web application for converting Bambu Lab/Orca Slicer multi-plate projects into SWAP files or customized GCODE. The application runs entirely in the browser with no server dependencies.

### Core Structure

- **Entry Point**: `assets/js/index.ts` → initializes via `initialize_page()` from `config/initialize.ts`
- **Build Output**: `dist/bundle.js` (bundled with esbuild, loaded by `index.html`)
- **UI**: Single-page application with drag-and-drop file processing
- **Type System**: Comprehensive TypeScript types throughout the codebase

### Key Modules

- **`assets/js/types/`**: TypeScript type definitions
  - `index.ts`: Core type definitions (PrinterModel, AppState, SwapRule, etc.)

- **`assets/js/config/`**: Application initialization, state management, and configuration
  - `initialize.ts`: Main app initialization and event binding
  - `state.ts`: Global application state (typed with AppState interface)
  - `mode.ts`: Printer mode detection and management
  - `materialConfig.ts`: Material and filament configuration
  - `filamentConfig/`: Filament profiles and registry

- **`assets/js/io/`**: File input/output operations
  - `read3mf.ts`: 3MF file parsing and plate extraction
  - `readGcode.ts`: GCODE file parsing
  - `export3mf.ts`: SWAP file generation
  - `exportGcode.ts`: GCODE export functionality

- **`assets/js/gcode/`**: GCODE processing and manipulation
  - `buildGcode.ts`: GCODE generation and assembly
  - `gcodeManipulation.ts`: GCODE modification utilities
  - `readGcode.ts`: GCODE parsing and analysis

- **`assets/js/commands/`**: Rule engine for GCODE modifications
  - `swapRules.ts`: Declarative rules for printer-specific GCODE modifications (typed with SwapRule[])
  - `applySwapRules.ts`: Rule application engine
  - `plateRestrictions.ts`: Plate validation rules

- **`assets/js/ui/`**: User interface components
  - `plates.ts`: Plate management and display
  - `statistics.ts`: Usage statistics calculation
  - `filamentColors.ts`: Color management and AMS slot mapping
  - `dropzone.ts`: File drop functionality
  - `settings.ts`: Settings panel management

- **`assets/js/utils/`**: Utility functions
  - `amsUtils.ts`: AMS (Automatic Material System) utilities
  - `colors.ts`: Color conversion and manipulation
  - `utils.ts`: General utilities
  - `time.ts`: Time formatting utilities
  - `regex.ts`: Regular expression utilities

- **`assets/js/i18n/`**: Internationalization
  - `i18n.ts`: Multi-language support system

### Printer Support

The application auto-detects printer models from GCODE headers and supports:
- **A1M**: Bambu Lab A1 Mini (SWAP mode)
- **X1**: Bambu Lab X1 series (automated routines)
- **P1**: Bambu Lab P1 series (automated routines)

### Rule Engine

The core feature is a declarative rule system in `commands/swapRules.ts` that applies printer-specific modifications:
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

- **Language**: TypeScript with strict type checking
- **Modules**: ES6 modules with esbuild bundling
- **Framework**: No external framework dependencies (vanilla TypeScript)
- **3MF Handling**: Extensive use of JSZip for 3MF file manipulation
- **Privacy**: Client-side only - no network requests or data uploads
- **Offline**: Supports offline usage when saved locally
- **Type Safety**: Comprehensive type definitions prevent runtime errors
- **IDE Support**: Full IntelliSense and autocomplete support