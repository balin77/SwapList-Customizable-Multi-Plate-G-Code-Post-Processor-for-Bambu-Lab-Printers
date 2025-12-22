# Migration Plan: Monorepo + Tauri Desktop App

## Übersicht

Dieser Plan migriert das SwapMod-Projekt in eine Monorepo-Struktur mit:
- **Shared Core**: Wiederverwendbare Business-Logik
- **Web App**: Bestehende Web-Anwendung
- **Tauri Desktop**: Native Desktop-Anwendung

**Geschätzte Gesamtdauer**: 2-3 Wochen (schrittweise, nebenbei machbar)

---

## Phase 0: Vorbereitung (1-2 Stunden)

### 0.1 Backup erstellen
```bash
# Erstelle Git-Tag für aktuellen Stand
git tag -a v1.0-pre-migration -m "Before monorepo migration"
git push origin v1.0-pre-migration

# Erstelle auch lokales Backup
cd ..
cp -r "Swapmod Website" "Swapmod Website BACKUP"
```

### 0.2 Tools installieren
```bash
# pnpm global installieren (Package Manager)
npm install -g pnpm

# Tauri CLI installieren
npm install -g @tauri-apps/cli

# Rust installieren (für Tauri)
# Windows: https://rustup.rs/ herunterladen und installieren
# Nach Installation:
rustup update
```

### 0.3 Dependencies dokumentieren
```bash
# Aktuelle dependencies sichern
cp package.json package.json.backup
```

**Checkpoint**: Tools installiert, Backup erstellt ✅

---

## Phase 1: Monorepo-Struktur aufsetzen (2-3 Stunden)

### 1.1 Neue Ordnerstruktur erstellen

```bash
# Im Parent-Ordner (3d Print/Diverse Utility für Printer/Swapmod/)
cd "c:\Users\guble\OneDrive\3d Print\Diverse Utility für Printer\Swapmod"

# Neues Monorepo erstellen
mkdir swapmod-monorepo
cd swapmod-monorepo

# Package-Ordner erstellen
mkdir packages
cd packages

# Drei Sub-Packages erstellen
mkdir core
mkdir web
mkdir desktop
```

**Zielstruktur**:
```
swapmod-monorepo/
├── packages/
│   ├── core/          # Shared business logic
│   ├── web/           # Web application
│   └── desktop/       # Tauri desktop app
├── package.json       # Root package.json
├── pnpm-workspace.yaml
└── .gitignore
```

### 1.2 Root package.json erstellen

```bash
cd swapmod-monorepo
pnpm init
```

Erstelle `package.json`:
```json
{
  "name": "swapmod-workspace",
  "version": "1.0.0",
  "private": true,
  "description": "SwapMod Monorepo - Multi-platform GCODE converter",
  "scripts": {
    "dev": "pnpm --parallel --filter './packages/*' dev",
    "build": "pnpm --recursive --filter './packages/*' build",
    "build:core": "pnpm --filter @swapmod/core build",
    "build:web": "pnpm --filter @swapmod/web build",
    "build:desktop": "pnpm --filter @swapmod/desktop build",
    "dev:web": "pnpm --filter @swapmod/web dev",
    "dev:desktop": "pnpm --filter @swapmod/desktop tauri dev",
    "typecheck": "pnpm --recursive --filter './packages/*' typecheck",
    "clean": "pnpm --recursive --filter './packages/*' clean"
  },
  "devDependencies": {
    "typescript": "^5.7.2"
  },
  "engines": {
    "node": ">=18.0.0",
    "pnpm": ">=8.0.0"
  }
}
```

### 1.3 pnpm workspace konfigurieren

Erstelle `pnpm-workspace.yaml`:
```yaml
packages:
  - 'packages/*'
```

### 1.4 Root .gitignore erstellen

Erstelle `.gitignore`:
```gitignore
# Dependencies
node_modules/
.pnpm-store/

# Build outputs
dist/
build/
out/

# Logs
*.log
npm-debug.log*
pnpm-debug.log*

# OS
.DS_Store
Thumbs.db

# IDEs
.vscode/
.idea/
*.swp
*.swo

# Environment
.env
.env.local

# Tauri
**/src-tauri/target/
**/src-tauri/Cargo.lock
```

**Checkpoint**: Monorepo-Grundstruktur steht ✅

---

## Phase 2: Core Package extrahieren (4-6 Stunden)

### 2.1 Core Package initialisieren

```bash
cd packages/core
pnpm init
```

Erstelle `packages/core/package.json`:
```json
{
  "name": "@swapmod/core",
  "version": "1.0.0",
  "description": "SwapMod Core - Shared business logic for GCODE conversion",
  "type": "module",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "import": "./dist/index.js"
    },
    "./types": {
      "types": "./dist/types/index.d.ts"
    }
  },
  "scripts": {
    "build": "tsc --project tsconfig.build.json",
    "dev": "tsc --project tsconfig.build.json --watch",
    "typecheck": "tsc --noEmit",
    "clean": "rimraf dist"
  },
  "dependencies": {
    "jszip": "^3.10.1"
  },
  "devDependencies": {
    "@types/node": "^20.11.5",
    "rimraf": "^5.0.5",
    "typescript": "^5.7.2"
  }
}
```

### 2.2 Core TypeScript konfigurieren

Erstelle `packages/core/tsconfig.json`:
```json
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "declarationMap": true,
    "composite": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

Erstelle `packages/core/tsconfig.build.json`:
```json
{
  "extends": "./tsconfig.json",
  "exclude": ["src/**/*.test.ts", "src/**/*.spec.ts"]
}
```

### 2.3 Basis TypeScript Config (Root)

Erstelle `swapmod-monorepo/tsconfig.base.json`:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "lib": ["ES2022", "DOM"],
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "allowSyntheticDefaultImports": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  }
}
```

### 2.4 Code von Web zu Core verschieben

**Zu verschiebende Module** (aus aktuellem `assets/js/`):

```bash
# Im alten Projekt-Ordner
cd "c:\Users\guble\OneDrive\3d Print\Diverse Utility für Printer\Swapmod\Swapmod Website"

# Erstelle src-Ordner in core
mkdir "c:\...\swapmod-monorepo\packages\core\src"

# Kopiere diese Ordner nach packages/core/src/:
# - types/
# - io/ (read3mf.ts, readGcode.ts, export3mf.ts, exportGcode.ts)
# - gcode/ (buildGcode.ts, gcodeManipulation.ts)
# - commands/ (swapRules.ts, applySwapRules.ts, plateRestrictions.ts)
# - utils/ (ohne DOM-spezifische utils)
# - config/materialConfig.ts
# - config/filamentConfig/
```

**Manuelle Schritte**:
1. Kopiere Ordner zu `packages/core/src/`
2. Entferne UI/DOM-abhängige Funktionen aus utils
3. Erstelle `packages/core/src/index.ts` als Entry-Point

Erstelle `packages/core/src/index.ts`:
```typescript
// Type exports
export * from './types/index.js';

// IO exports
export { read3mf } from './io/read3mf.js';
export { readGcode } from './io/readGcode.js';
export { export3mf } from './io/export3mf.js';
export { exportGcode } from './io/exportGcode.js';

// GCODE exports
export { buildGcode } from './gcode/buildGcode.js';
export * from './gcode/gcodeManipulation.js';

// Commands exports
export { swapRules } from './commands/swapRules.js';
export { applySwapRules } from './commands/applySwapRules.js';
export * from './commands/plateRestrictions.js';

// Config exports
export * from './config/materialConfig.js';
export { filamentRegistry } from './config/filamentConfig/index.js';

// Utils exports (non-DOM)
export * from './utils/amsUtils.js';
export * from './utils/colors.js';
export * from './utils/time.js';
export * from './utils/regex.js';
// Note: DOM-dependent utils stay in web/desktop packages
```

### 2.5 Core Package bauen

```bash
cd packages/core
pnpm install
pnpm build
```

**Erwartetes Ergebnis**: `packages/core/dist/` enthält kompilierte `.js` und `.d.ts` Dateien

**Checkpoint**: Core Package funktioniert standalone ✅

---

## Phase 3: Web Package migrieren (3-4 Stunden)

### 3.1 Web Package initialisieren

```bash
cd packages/web
pnpm init
```

Erstelle `packages/web/package.json`:
```json
{
  "name": "@swapmod/web",
  "version": "1.0.0",
  "description": "SwapMod Web Application",
  "type": "module",
  "scripts": {
    "dev": "node scripts/gen-filament-index.mjs && node esbuild.config.mjs --watch",
    "build": "node scripts/gen-filament-index.mjs && node esbuild.config.mjs",
    "typecheck": "tsc --noEmit",
    "serve": "serve public -p 3000",
    "clean": "rimraf dist"
  },
  "dependencies": {
    "@swapmod/core": "workspace:*",
    "jszip": "^3.10.1"
  },
  "devDependencies": {
    "@types/node": "^20.11.5",
    "esbuild": "^0.24.0",
    "rimraf": "^5.0.5",
    "serve": "^14.2.1",
    "typescript": "^5.7.2"
  }
}
```

**Wichtig**: `"@swapmod/core": "workspace:*"` - verlinkt auf lokales Core-Package!

### 3.2 Web-Code übertragen

```bash
# Kopiere aus altem Projekt:
# - index.html → packages/web/public/index.html
# - assets/ → packages/web/public/assets/
# - assets/js/ → packages/web/src/ (nur UI-spezifischer Code!)
# - scripts/ → packages/web/scripts/
# - esbuild.config.mjs → packages/web/
```

**Verbleibende Module in web/src/**:
- `ui/` (plates.ts, settings.ts, dropzone.ts, etc.)
- `config/initialize.ts` (mit Imports von @swapmod/core)
- `config/state.ts`
- `config/mode.ts`
- `i18n/`
- `utils/` (nur DOM-abhängige utils)
- `index.ts` (Entry-Point)

### 3.3 Imports anpassen

Ändere in **allen Dateien** in `packages/web/src/`:

**Vorher**:
```typescript
import { buildGcode } from '../gcode/buildGcode.js';
import type { Plate } from '../types/index.js';
```

**Nachher**:
```typescript
import { buildGcode } from '@swapmod/core';
import type { Plate } from '@swapmod/core';
```

### 3.4 esbuild.config anpassen

Bearbeite `packages/web/esbuild.config.mjs`:
```javascript
import esbuild from 'esbuild';

const isWatch = process.argv.includes('--watch');

const config = {
  entryPoints: ['src/index.ts'],
  bundle: true,
  outfile: 'public/dist/bundle.js',
  platform: 'browser',
  target: 'es2022',
  format: 'esm',
  sourcemap: true,
  minify: !isWatch,
  // External packages are bundled (workspace dependencies)
  external: [],
};

if (isWatch) {
  const ctx = await esbuild.context(config);
  await ctx.watch();
  console.log('👀 Watching for changes...');
} else {
  await esbuild.build(config);
  console.log('✅ Build complete');
}
```

### 3.5 Web TypeScript Config

Erstelle `packages/web/tsconfig.json`:
```json
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src",
    "noEmit": true,
    "paths": {
      "@swapmod/core": ["../core/src/index.ts"],
      "@swapmod/core/*": ["../core/src/*"]
    }
  },
  "include": ["src/**/*"],
  "references": [
    { "path": "../core" }
  ]
}
```

### 3.6 Web Package testen

```bash
cd packages/web
pnpm install
pnpm build
pnpm serve
# Browser öffnen: http://localhost:3000
```

**Checkpoint**: Web-App läuft im Monorepo ✅

---

## Phase 4: Tauri Desktop App erstellen (4-5 Stunden)

### 4.1 Tauri Projekt initialisieren

```bash
cd packages/desktop
pnpm create tauri-app .
```

**Interaktive Prompts beantworten**:
- Project name: `swapmod-desktop`
- Window title: `SwapMod`
- UI recipe: `Vanilla` (wir nutzen eigenes Setup)
- Package manager: `pnpm`

### 4.2 Desktop package.json anpassen

Bearbeite `packages/desktop/package.json`:
```json
{
  "name": "@swapmod/desktop",
  "version": "1.0.0",
  "description": "SwapMod Desktop Application",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "tauri": "tauri",
    "tauri:dev": "tauri dev",
    "tauri:build": "tauri build",
    "typecheck": "tsc --noEmit",
    "clean": "rimraf dist src-tauri/target"
  },
  "dependencies": {
    "@swapmod/core": "workspace:*",
    "@tauri-apps/api": "^2.2.0",
    "jszip": "^3.10.1"
  },
  "devDependencies": {
    "@tauri-apps/cli": "^2.2.0",
    "@types/node": "^20.11.5",
    "rimraf": "^5.0.5",
    "typescript": "^5.7.2",
    "vite": "^5.0.11"
  }
}
```

### 4.3 Vite Config für Desktop

Erstelle `packages/desktop/vite.config.ts`:
```typescript
import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
  root: './src',
  build: {
    outDir: '../dist',
    emptyOutDir: true,
  },
  resolve: {
    alias: {
      '@swapmod/core': resolve(__dirname, '../core/src'),
    },
  },
  clearScreen: false,
  server: {
    port: 1420,
    strictPort: true,
  },
  envPrefix: ['VITE_', 'TAURI_'],
});
```

### 4.4 Desktop UI erstellen

Erstelle `packages/desktop/src/index.html`:
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SwapMod Desktop</title>
  <link rel="stylesheet" href="./styles.css">
</head>
<body>
  <div id="app">
    <h1>SwapMod Desktop</h1>
    <div id="drop-zone" class="drop-zone">
      <p>Drop 3MF or GCODE files here</p>
    </div>
    <div id="content"></div>
  </div>
  <script type="module" src="/main.ts"></script>
</body>
</html>
```

Erstelle `packages/desktop/src/main.ts`:
```typescript
import { open } from '@tauri-apps/api/dialog';
import { readBinaryFile } from '@tauri-apps/api/fs';
import { read3mf, buildGcode } from '@swapmod/core';

// Desktop-spezifische Initialisierung
async function initializeDesktop() {
  console.log('SwapMod Desktop initializing...');

  const dropZone = document.getElementById('drop-zone');

  if (dropZone) {
    dropZone.addEventListener('click', async () => {
      const selected = await open({
        multiple: false,
        filters: [{
          name: 'GCODE Files',
          extensions: ['3mf', 'gcode']
        }]
      });

      if (selected && typeof selected === 'string') {
        await handleFile(selected);
      }
    });
  }
}

async function handleFile(filePath: string) {
  console.log('Processing file:', filePath);

  try {
    const fileData = await readBinaryFile(filePath);

    if (filePath.endsWith('.3mf')) {
      const blob = new Blob([fileData]);
      const result = await read3mf(blob);
      console.log('Parsed 3MF:', result);
      // Weitere Verarbeitung...
    }
  } catch (error) {
    console.error('Error processing file:', error);
  }
}

// App starten
initializeDesktop();
```

Erstelle `packages/desktop/src/styles.css`:
```css
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
  background: #1a1a1a;
  color: #fff;
}

#app {
  padding: 2rem;
}

.drop-zone {
  border: 2px dashed #666;
  border-radius: 8px;
  padding: 4rem;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
}

.drop-zone:hover {
  border-color: #4a9eff;
  background: rgba(74, 158, 255, 0.1);
}
```

### 4.5 Desktop TypeScript Config

Erstelle `packages/desktop/tsconfig.json`:
```json
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "lib": ["ES2022", "DOM"],
    "outDir": "./dist",
    "rootDir": "./src",
    "noEmit": true,
    "paths": {
      "@swapmod/core": ["../core/src/index.ts"],
      "@swapmod/core/*": ["../core/src/*"]
    }
  },
  "include": ["src/**/*"],
  "references": [
    { "path": "../core" }
  ]
}
```

### 4.6 Tauri Konfiguration

Bearbeite `packages/desktop/src-tauri/tauri.conf.json`:
```json
{
  "productName": "SwapMod",
  "version": "1.0.0",
  "identifier": "com.swapmod.desktop",
  "build": {
    "beforeDevCommand": "pnpm dev",
    "beforeBuildCommand": "pnpm build",
    "devUrl": "http://localhost:1420",
    "frontendDist": "../dist"
  },
  "app": {
    "windows": [
      {
        "title": "SwapMod - GCODE Converter",
        "width": 1200,
        "height": 800,
        "resizable": true,
        "fullscreen": false,
        "fileDropEnabled": true
      }
    ],
    "security": {
      "csp": null
    }
  },
  "bundle": {
    "active": true,
    "targets": "all",
    "icon": [
      "icons/32x32.png",
      "icons/128x128.png",
      "icons/128x128@2x.png",
      "icons/icon.icns",
      "icons/icon.ico"
    ]
  }
}
```

### 4.7 Tauri Permissions (File System Access)

Erstelle `packages/desktop/src-tauri/capabilities/default.json`:
```json
{
  "identifier": "default",
  "description": "Default permissions for SwapMod",
  "permissions": [
    "core:default",
    "dialog:allow-open",
    "dialog:allow-save",
    "fs:allow-read-file",
    "fs:allow-write-file"
  ]
}
```

### 4.8 Desktop App testen

```bash
cd packages/desktop
pnpm install
pnpm tauri dev
```

**Erwartetes Ergebnis**: Desktop-App öffnet sich, Drag & Drop funktioniert

**Checkpoint**: Tauri Desktop App läuft ✅

---

## Phase 5: Web-UI in Desktop integrieren (3-4 Stunden)

### 5.1 Shared UI Components erstellen

Option A: **Copy-Paste Ansatz** (schneller)
```bash
# Kopiere UI-Code von web nach desktop
cp -r packages/web/src/ui packages/desktop/src/
cp -r packages/web/src/i18n packages/desktop/src/
cp packages/web/public/assets/css/styles.css packages/desktop/src/
```

Option B: **Shared UI Package** (sauberer, später)
```bash
# Erstelle packages/ui für geteilte Components
# → Fortgeschrittenes Setup, optional
```

### 5.2 Desktop main.ts erweitern

Bearbeite `packages/desktop/src/main.ts` um Web-UI zu nutzen:
```typescript
import { open } from '@tauri-apps/api/dialog';
import { readBinaryFile, writeBinaryFile } from '@tauri-apps/api/fs';
import { save } from '@tauri-apps/api/dialog';
import { read3mf, buildGcode, type Plate } from '@swapmod/core';

// Import UI modules (aus web kopiert)
import { renderPlates, updatePlateDisplay } from './ui/plates.js';
import { initializeSettings } from './ui/settings.js';
import { initializeI18n } from './i18n/i18n.js';

// State management (ähnlich wie web)
import { state } from './state.js';

async function initializeDesktop() {
  console.log('SwapMod Desktop v1.0');

  // I18n initialisieren
  await initializeI18n();

  // Settings UI
  initializeSettings();

  // File handling
  setupFileHandlers();
}

function setupFileHandlers() {
  // Drop zone click handler
  const dropZone = document.getElementById('drop-zone');
  dropZone?.addEventListener('click', openFileDialog);

  // Export button
  const exportBtn = document.getElementById('export-btn');
  exportBtn?.addEventListener('click', exportFile);
}

async function openFileDialog() {
  const selected = await open({
    multiple: false,
    filters: [{
      name: 'Print Files',
      extensions: ['3mf', 'gcode']
    }]
  });

  if (selected && typeof selected === 'string') {
    await processFile(selected);
  }
}

async function processFile(filePath: string) {
  try {
    const fileData = await readBinaryFile(filePath);
    const blob = new Blob([fileData]);

    if (filePath.endsWith('.3mf')) {
      const result = await read3mf(blob);
      state.plates = result.plates;
      state.metadata = result.metadata;

      // UI updaten (wie in web)
      renderPlates(result.plates);

    } else if (filePath.endsWith('.gcode')) {
      // GCODE handling...
    }
  } catch (error) {
    console.error('File processing error:', error);
    alert(`Error: ${error.message}`);
  }
}

async function exportFile() {
  if (!state.plates || state.plates.length === 0) {
    alert('No plates to export!');
    return;
  }

  const savePath = await save({
    filters: [{
      name: 'SWAP File',
      extensions: ['swap.3mf']
    }]
  });

  if (savePath) {
    try {
      // Build GCODE using core
      const gcode = buildGcode(state.plates, state.printerModel);

      // Export (hier Tauri file write nutzen statt browser download)
      const blob = await export3mf(state.plates, gcode);
      const arrayBuffer = await blob.arrayBuffer();
      await writeBinaryFile(savePath, new Uint8Array(arrayBuffer));

      alert('File saved successfully!');
    } catch (error) {
      console.error('Export error:', error);
      alert(`Export failed: ${error.message}`);
    }
  }
}

// Initialize
initializeDesktop();
```

### 5.3 State Management kopieren

Kopiere `packages/web/src/config/state.ts` nach `packages/desktop/src/state.ts`
- Entferne browser-spezifische Teile
- Behalte AppState interface (kommt von @swapmod/core)

### 5.4 HTML anpassen

Kopiere Layout von `packages/web/public/index.html` → `packages/desktop/src/index.html`
- Behalte selbe Struktur (plates, settings, etc.)
- Entferne web-spezifische Meta-Tags

**Checkpoint**: Desktop hat gleiche UI wie Web ✅

---

## Phase 6: Alte Struktur migrieren (2-3 Stunden)

### 6.1 Git History migrieren

```bash
# Im Monorepo
cd swapmod-monorepo
git init

# Altes Repo als Remote hinzufügen
git remote add old-web "c:\Users\guble\OneDrive\3d Print\Diverse Utility für Printer\Swapmod\Swapmod Website"

# History mergen (optional, fortgeschritten)
git fetch old-web
git merge --allow-unrelated-histories old-web/main

# Oder: Einfach neues Repo starten
git add .
git commit -m "feat: initial monorepo setup with web and desktop packages"
```

### 6.2 GitHub Repository erstellen

```bash
# Auf GitHub: Neues Repo erstellen "swapmod"
# Dann:
git remote add origin https://github.com/DEIN-USERNAME/swapmod.git
git branch -M main
git push -u origin main
```

### 6.3 README aktualisieren

Erstelle `swapmod-monorepo/README.md`:
```markdown
# SwapMod - Multi-Platform GCODE Converter

Convert Bambu Lab/Orca Slicer multi-plate projects into SWAP files or customized GCODE.

## Packages

- **@swapmod/core** - Shared business logic
- **@swapmod/web** - Web application (runs in browser)
- **@swapmod/desktop** - Desktop application (Tauri)

## Quick Start

### Prerequisites
- Node.js 18+
- pnpm 8+
- Rust (for desktop builds)

### Installation
```bash
pnpm install
```

### Development
```bash
# Run web app
pnpm dev:web

# Run desktop app
pnpm dev:desktop

# Run both
pnpm dev
```

### Build
```bash
# Build all
pnpm build

# Build specific package
pnpm build:web
pnpm build:desktop
```

## Project Structure

```
swapmod-monorepo/
├── packages/
│   ├── core/          # Shared TypeScript library
│   ├── web/           # Browser-based application
│   └── desktop/       # Native desktop app (Tauri)
└── package.json       # Workspace root
```

## License

MIT
```

### 6.4 Deployment Workflows

Erstelle `.github/workflows/build.yml`:
```yaml
name: Build All Packages

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]

    steps:
      - uses: actions/checkout@v4

      - uses: pnpm/action-setup@v2
        with:
          version: 8

      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'

      - name: Install Rust (for Tauri)
        uses: dtolnay/rust-toolchain@stable

      - name: Install dependencies
        run: pnpm install

      - name: Type check
        run: pnpm typecheck

      - name: Build all packages
        run: pnpm build

      - name: Build desktop app
        run: pnpm build:desktop
```

**Checkpoint**: Altes Projekt erfolgreich migriert ✅

---

## Phase 7: Desktop-spezifische Features (Optional, 2-4 Stunden)

### 7.1 Native File Associations

Bearbeite `packages/desktop/src-tauri/tauri.conf.json`:
```json
{
  "bundle": {
    "fileAssociations": [
      {
        "ext": ["3mf"],
        "name": "3MF Print File",
        "description": "3D Manufacturing Format",
        "role": "Editor"
      },
      {
        "ext": ["gcode"],
        "name": "GCODE File",
        "description": "G-Code 3D Printer Instructions",
        "role": "Editor"
      }
    ]
  }
}
```

### 7.2 Native Menüs

Erstelle `packages/desktop/src-tauri/src/menu.rs`:
```rust
use tauri::{CustomMenuItem, Menu, MenuItem, Submenu};

pub fn create_menu() -> Menu {
    let open = CustomMenuItem::new("open".to_string(), "Open File...");
    let save = CustomMenuItem::new("save".to_string(), "Save As...");
    let quit = CustomMenuItem::new("quit".to_string(), "Quit");

    let file_menu = Submenu::new(
        "File",
        Menu::new()
            .add_item(open)
            .add_item(save)
            .add_native_item(MenuItem::Separator)
            .add_item(quit),
    );

    Menu::new().add_submenu(file_menu)
}
```

Registriere in `packages/desktop/src-tauri/src/main.rs`:
```rust
mod menu;

fn main() {
    tauri::Builder::default()
        .menu(menu::create_menu())
        .on_menu_event(|event| match event.menu_item_id() {
            "open" => {
                // Trigger file open
                event.window().emit("menu-open", {}).unwrap();
            }
            "save" => {
                event.window().emit("menu-save", {}).unwrap();
            }
            "quit" => {
                std::process::exit(0);
            }
            _ => {}
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
```

### 7.3 System Notifications

In `packages/desktop/src/main.ts`:
```typescript
import { sendNotification } from '@tauri-apps/api/notification';

async function exportFile() {
  // ... export logic ...

  await sendNotification({
    title: 'SwapMod',
    body: 'File exported successfully!',
  });
}
```

### 7.4 Auto-Update (Fortgeschritten)

Bearbeite `packages/desktop/src-tauri/tauri.conf.json`:
```json
{
  "updater": {
    "active": true,
    "endpoints": [
      "https://github.com/USERNAME/swapmod/releases/latest/download/latest.json"
    ],
    "dialog": true,
    "pubkey": "YOUR_PUBLIC_KEY"
  }
}
```

**Checkpoint**: Desktop-App hat native Features ✅

---

## Phase 8: Testing & Finalisierung (2-3 Stunden)

### 8.1 Vergleichstest Web vs Desktop

**Checkliste**:
- [ ] 3MF-Datei öffnen funktioniert
- [ ] GCODE-Datei öffnen funktioniert
- [ ] Plates werden korrekt angezeigt
- [ ] Settings funktionieren
- [ ] Export erzeugt identische Dateien (Web vs Desktop)
- [ ] AMS Slot Remapping funktioniert
- [ ] Filament-Farben werden korrekt dargestellt
- [ ] Multi-Language funktioniert

### 8.2 Performance-Vergleich

```bash
# Build sizes vergleichen
pnpm build
du -sh packages/web/dist/
du -sh packages/desktop/src-tauri/target/release/bundle/
```

**Erwartete Größen**:
- Web: ~500 KB (bundle.js)
- Desktop: ~5-10 MB (Windows .exe)

### 8.3 Documentation vervollständigen

Aktualisiere `CLAUDE.md`:
```markdown
# CLAUDE.md

## Monorepo Structure

This project uses pnpm workspaces with multiple packages:

### Packages
- **@swapmod/core** - Platform-agnostic business logic
- **@swapmod/web** - Browser-based application
- **@swapmod/desktop** - Tauri desktop application

### Development Commands

**Root-Level**:
- `pnpm dev` - Run all packages in watch mode
- `pnpm build` - Build all packages
- `pnpm typecheck` - Type-check all packages

**Package-Specific**:
- `pnpm dev:web` - Web app dev server
- `pnpm dev:desktop` - Desktop app with hot reload
- `pnpm build:core` - Build core library only

### Adding Dependencies

**To core package**:
```bash
pnpm --filter @swapmod/core add <package>
```

**To web package**:
```bash
pnpm --filter @swapmod/web add <package>
```

**To all packages**:
```bash
pnpm add -w <package>
```
```

### 8.4 Changelog erstellen

Erstelle `CHANGELOG.md`:
```markdown
# Changelog

## [2.0.0] - 2025-01-XX

### Added
- 🎉 Monorepo structure with pnpm workspaces
- 🖥️ Native desktop application (Tauri)
- 📦 Shared core library (@swapmod/core)
- 🚀 Multi-platform support (Web + Desktop)

### Changed
- ♻️ Restructured codebase into packages
- 📝 Updated build system for monorepo
- 🔧 Improved TypeScript configuration

### Migration Notes
- Old web app code moved to `packages/web/`
- Business logic extracted to `packages/core/`
- New desktop app in `packages/desktop/`
```

**Checkpoint**: Projekt vollständig getestet und dokumentiert ✅

---

## Phase 9: Deployment (1-2 Stunden)

### 9.1 Web Deployment (Netlify/Vercel)

**Option A: Netlify**
```bash
# netlify.toml im Root erstellen
```

Erstelle `netlify.toml`:
```toml
[build]
  base = "packages/web"
  command = "pnpm build"
  publish = "public"

[build.environment]
  NODE_VERSION = "20"
```

**Option B: Vercel**
```bash
# vercel.json im Root
```

Erstelle `vercel.json`:
```json
{
  "buildCommand": "cd packages/web && pnpm build",
  "outputDirectory": "packages/web/public",
  "framework": null
}
```

### 9.2 Desktop Deployment (GitHub Releases)

Erstelle `.github/workflows/release-desktop.yml`:
```yaml
name: Release Desktop App

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    strategy:
      matrix:
        platform: [windows-latest, macos-latest, ubuntu-latest]

    runs-on: ${{ matrix.platform }}

    steps:
      - uses: actions/checkout@v4

      - uses: pnpm/action-setup@v2
        with:
          version: 8

      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'

      - name: Install Rust
        uses: dtolnay/rust-toolchain@stable

      - name: Install dependencies
        run: pnpm install

      - name: Build desktop app
        run: |
          cd packages/desktop
          pnpm tauri build

      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: swapmod-${{ matrix.platform }}
          path: packages/desktop/src-tauri/target/release/bundle/
```

### 9.3 Release erstellen

```bash
# Tag erstellen
git tag -a v2.0.0 -m "Release v2.0.0 - Monorepo + Desktop"
git push origin v2.0.0

# GitHub Actions baut automatisch
# Artifacts werden als Release hochgeladen
```

**Checkpoint**: Deployment funktioniert ✅

---

## Troubleshooting Guide

### Problem: "Module not found @swapmod/core"

**Lösung**:
```bash
# Im Root
pnpm install
cd packages/core
pnpm build

# Dann in web/desktop
cd ../web
pnpm install
```

### Problem: Tauri build fails auf Windows

**Lösung**:
```bash
# WebView2 installieren
# https://developer.microsoft.com/en-us/microsoft-edge/webview2/

# Visual Studio Build Tools installieren
# https://visualstudio.microsoft.com/downloads/
```

### Problem: TypeScript errors nach Migration

**Lösung**:
```bash
# Alle node_modules löschen
pnpm clean
rm -rf node_modules
rm -rf packages/*/node_modules

# Neu installieren
pnpm install
pnpm typecheck
```

### Problem: Web-App zeigt leere Seite

**Lösung**:
```bash
# Prüfe Console für Fehler
# Häufig: Falscher Pfad in index.html

# In packages/web/public/index.html:
<script type="module" src="/dist/bundle.js"></script>
# Nicht:
<script type="module" src="dist/bundle.js"></script>
```

---

## Success Criteria Checklist

### Phase 1-3: Core + Web ✅
- [ ] Monorepo läuft mit pnpm workspaces
- [ ] Core package baut ohne Fehler
- [ ] Web package importiert Core erfolgreich
- [ ] Web-App funktioniert identisch wie vorher
- [ ] Alle TypeScript types funktionieren

### Phase 4-5: Desktop ✅
- [ ] Tauri App startet
- [ ] File Open/Save funktioniert
- [ ] 3MF/GCODE Parsing funktioniert
- [ ] Export erzeugt valide Dateien
- [ ] UI ist identisch zu Web

### Phase 6-9: Finalisierung ✅
- [ ] Git History migriert
- [ ] CI/CD läuft
- [ ] Dokumentation vollständig
- [ ] Web deployed
- [ ] Desktop releases erstellt

---

## Timeline Estimate

| Phase | Dauer | Kumulativ |
|-------|-------|-----------|
| 0: Vorbereitung | 1-2h | 2h |
| 1: Monorepo Setup | 2-3h | 5h |
| 2: Core Package | 4-6h | 11h |
| 3: Web Migration | 3-4h | 15h |
| 4: Tauri Setup | 4-5h | 20h |
| 5: UI Integration | 3-4h | 24h |
| 6: Git Migration | 2-3h | 27h |
| 7: Desktop Features | 2-4h | 31h |
| 8: Testing | 2-3h | 34h |
| 9: Deployment | 1-2h | 36h |

**Total**: ~36 Stunden (verteilt über 2-3 Wochen bei 2h/Tag)

---

## Next Steps

1. **Starte mit Phase 0** - Backup und Tools installieren
2. **Phase 1-2** - Monorepo + Core (kann an einem Wochenende gemacht werden)
3. **Phase 3** - Web migrieren (testet ob Monorepo funktioniert)
4. **Phase 4-5** - Desktop erstellen (spannendster Teil!)
5. **Phase 6-9** - Polish und Deployment

**Du bist nicht allein**: Bei jedem Schritt kann ich dir helfen!

---

## Fragen?

- Unsicher bei einem Schritt? → Frag mich
- Error aufgetreten? → Zeig mir die Console-Ausgabe
- Möchtest du einen Schritt überspringen? → Wir passen den Plan an
- Brauchst du mehr Details? → Ich erkläre tiefer

**Bereit anzufangen? Sag mir, mit welcher Phase du starten möchtest!** 🚀
