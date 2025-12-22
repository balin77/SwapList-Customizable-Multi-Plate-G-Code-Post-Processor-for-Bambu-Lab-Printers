# Refactoring Plan: Maximaler Code-Sharing in @swapmod/core

**Ziel**: So viel Business-Logik wie möglich in `@swapmod/core` verschieben, damit Web und Desktop denselben Code nutzen können.

**Strategie**: Dependency Injection - UI-Dependencies als optionale Callbacks übergeben.

---

## 📊 Analyse: UI-Dependencies

### Aktueller Status (laut MIGRATION_STATUS.md)

**Im Core** ✅:
- `types/` - Type Definitions
- `config/filamentConfig/` - Filament Presets
- `utils/` - Reine Utility-Funktionen

**NICHT im Core** ❌ (wegen UI-Dependencies):
- `io/` - Benötigt DOM/State/Progressbar
- `gcode/` - Benötigt State Management
- `commands/` - Benötigt UI-Callbacks
- `config/materialConfig.ts` - Benötigt DOM-Zugriff

### Gefundene UI-Dependencies

**IO-Module** (`io/*.ts`):
```typescript
// read3mf.ts
import { state } from "../config/state.js";
import { initPlateX1P1UI, makeListSortable, installPlateButtons } from "../ui/plates.js";
import { wirePlateSwatches, updateAllPlateSwatchColors } from "../ui/filamentColors.js";
import { update_statistics } from "../ui/statistics.js";
import { showError } from "../ui/infobox.js";
// + document.getElementById, DOM manipulation

// export3mf.ts, exportGcode.ts, ioUtils.ts
// → ähnliche UI-Dependencies
```

**GCODE-Module** (`gcode/*.ts`):
```typescript
// buildGcode.ts
import {
  getSecurePushOffEnabled,
  getUserBedRaiseOffset,
  getCooldownTargetBedTemp,
  // ... viele Settings-Getter
} from "../ui/settings.js";

// readGcode.ts, gcodeManipulation.ts, gcodeUtils.ts
// → State-Zugriff, UI-Updates
```

**Commands-Module** (`commands/*.ts`):
```typescript
// swapRules.ts, applySwapRules.ts
// → Callbacks für Progress, State-Updates
```

---

## 🎯 Refactoring-Strategie: Dependency Injection

### Prinzip

**Vorher** (tight coupling):
```typescript
// core/io/read3mf.ts
import { state } from "../config/state.js";
import { showError } from "../ui/infobox.js";

export async function read3mf(file: File) {
  state.plates = plates; // direkter State-Zugriff
  showError("Error!"); // direkter UI-Aufruf
}
```

**Nachher** (loose coupling):
```typescript
// core/io/read3mf.ts
export interface Read3mfCallbacks {
  onProgress?: (progress: number, message: string) => void;
  onError?: (message: string) => void;
  onPlatesLoaded?: (plates: Plate[]) => void;
}

export async function read3mf(
  file: File | Blob,
  callbacks?: Read3mfCallbacks
): Promise<{ plates: Plate[], metadata: any }> {
  // Business-Logik (JSZip, Parsing, etc.)
  const plates = /* ... */;

  // Optional: Callbacks aufrufen
  callbacks?.onPlatesLoaded?.(plates);

  // Rückgabe für programmatische Nutzung
  return { plates, metadata };
}
```

**Web-Nutzung**:
```typescript
// web/src/io/read3mf-web.ts
import { read3mf } from '@swapmod/core';
import { state } from '../config/state.js';
import { showError } from '../ui/infobox.js';

export async function read3mfWeb(file: File) {
  const result = await read3mf(file, {
    onError: (msg) => showError(msg),
    onPlatesLoaded: (plates) => {
      state.plates = plates;
      renderPlates(plates);
    }
  });

  return result;
}
```

**Desktop-Nutzung**:
```typescript
// desktop/src/io/read3mf-desktop.ts
import { read3mf } from '@swapmod/core';
import { sendNotification } from '@tauri-apps/api/notification';

export async function read3mfDesktop(filePath: string) {
  const blob = await readBinaryFile(filePath);

  const result = await read3mf(blob, {
    onError: (msg) => sendNotification({ title: 'Error', body: msg }),
    onPlatesLoaded: (plates) => {
      // Desktop-spezifische State-Updates
      desktopState.plates = plates;
    }
  });

  return result;
}
```

---

## 📦 Refactoring-Schritte

### Phase 1: Settings-System refactoren (Höchste Priorität)

**Problem**: `buildGcode.ts` importiert 10+ Getter aus `ui/settings.js`

**Lösung**: Settings als Objekt übergeben

**Vorher**:
```typescript
// gcode/buildGcode.ts
import { getSecurePushOffEnabled, getUserBedRaiseOffset } from "../ui/settings.js";

export function buildGcode(plates: Plate[]) {
  const pushOffEnabled = getSecurePushOffEnabled();
  const raiseOffset = getUserBedRaiseOffset();
  // ...
}
```

**Nachher**:
```typescript
// core/gcode/buildGcode.ts
export interface GcodeSettings {
  securePushOffEnabled?: boolean;
  extraPushOffLevels?: number;
  userBedRaiseOffset?: number;
  cooldownTargetBedTemp?: number;
  cooldownMaxTime?: number;
  // ... alle Settings
}

export function buildGcode(
  plates: Plate[],
  settings: GcodeSettings = {}
): string {
  const pushOffEnabled = settings.securePushOffEnabled ?? false;
  const raiseOffset = settings.userBedRaiseOffset ?? 0;
  // ...
}
```

**Web-Adapter**:
```typescript
// web/src/gcode/buildGcode-web.ts
import { buildGcode, type GcodeSettings } from '@swapmod/core';
import {
  getSecurePushOffEnabled,
  getUserBedRaiseOffset,
  // ... alle Getter
} from '../ui/settings.js';

export function buildGcodeWeb(plates: Plate[]): string {
  const settings: GcodeSettings = {
    securePushOffEnabled: getSecurePushOffEnabled(),
    extraPushOffLevels: getExtraPushOffLevels(),
    userBedRaiseOffset: getUserBedRaiseOffset(),
    cooldownTargetBedTemp: getCooldownTargetBedTemp(),
    cooldownMaxTime: getCooldownMaxTime(),
    // ... alle Settings sammeln
  };

  return buildGcode(plates, settings);
}
```

---

### Phase 2: IO-Module refactoren

#### 2.1 read3mf.ts

**Core-Version** (`core/io/read3mf.ts`):
```typescript
export interface Read3mfCallbacks {
  onProgress?: (progress: number, message: string) => void;
  onError?: (message: string) => void;
  onWarning?: (message: string) => void;
}

export interface Read3mfResult {
  plates: Plate[];
  metadata: ProjectMetadata;
  warnings?: string[];
}

export async function read3mf(
  file: File | Blob,
  callbacks?: Read3mfCallbacks
): Promise<Read3mfResult> {
  try {
    callbacks?.onProgress?.(0, 'Loading 3MF file...');

    const zip = await JSZip.loadAsync(file);

    callbacks?.onProgress?.(30, 'Parsing metadata...');
    // ... parse project.3mf

    callbacks?.onProgress?.(60, 'Extracting plates...');
    // ... extract plates

    callbacks?.onProgress?.(100, 'Done!');

    return {
      plates,
      metadata,
      warnings: []
    };

  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    callbacks?.onError?.(message);
    throw error;
  }
}
```

**Web-Adapter** (`web/src/io/read3mf-web.ts`):
```typescript
import { read3mf } from '@swapmod/core';
import { state } from '../config/state.js';
import { showError } from '../ui/infobox.js';
import { updateProgressbar } from '../ui/progressbar.js';
import {
  initPlateX1P1UI,
  makeListSortable,
  installPlateButtons
} from '../ui/plates.js';

export async function read3mfWeb(file: File) {
  const result = await read3mf(file, {
    onProgress: (progress, message) => {
      updateProgressbar(progress, message);
    },
    onError: (message) => {
      showError(message);
      // Rollback state
      state.my_files.pop();
    },
    onWarning: (message) => {
      console.warn('[read3mf]', message);
    }
  });

  // State aktualisieren
  state.plates = result.plates;
  state.metadata = result.metadata;

  // UI rendern
  initPlateX1P1UI();
  makeListSortable();
  installPlateButtons();

  return result;
}
```

#### 2.2 export3mf.ts

**Core-Version**:
```typescript
export interface Export3mfCallbacks {
  onProgress?: (progress: number, message: string) => void;
}

export async function export3mf(
  plates: Plate[],
  combinedGcode: string,
  metadata: ProjectMetadata,
  callbacks?: Export3mfCallbacks
): Promise<Blob> {
  callbacks?.onProgress?.(0, 'Creating 3MF archive...');

  const zip = new JSZip();

  callbacks?.onProgress?.(30, 'Adding metadata...');
  // ... add project.3mf

  callbacks?.onProgress?.(60, 'Adding GCODE...');
  // ... add gcode

  callbacks?.onProgress?.(100, 'Done!');

  return await zip.generateAsync({ type: 'blob' });
}
```

#### 2.3 exportGcode.ts

**Core-Version**:
```typescript
export async function exportGcode(
  gcode: string,
  filename: string,
  callbacks?: { onProgress?: (n: number, msg: string) => void }
): Promise<Blob> {
  callbacks?.onProgress?.(50, 'Generating GCODE...');

  const blob = new Blob([gcode], { type: 'text/plain' });

  callbacks?.onProgress?.(100, 'Done!');

  return blob;
}
```

**Web-Adapter** (mit Browser-Download):
```typescript
// web/src/io/exportGcode-web.ts
import { exportGcode } from '@swapmod/core';

export async function exportGcodeWeb(gcode: string, filename: string) {
  const blob = await exportGcode(gcode, filename, {
    onProgress: updateProgressbar
  });

  // Browser-Download
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  a.click();
  URL.revokeObjectURL(url);
}
```

**Desktop-Adapter** (mit Tauri File Save):
```typescript
// desktop/src/io/exportGcode-desktop.ts
import { exportGcode } from '@swapmod/core';
import { save } from '@tauri-apps/api/dialog';
import { writeBinaryFile } from '@tauri-apps/api/fs';

export async function exportGcodeDesktop(gcode: string, filename: string) {
  const blob = await exportGcode(gcode, filename);

  const savePath = await save({
    defaultPath: filename,
    filters: [{ name: 'GCODE', extensions: ['gcode'] }]
  });

  if (savePath) {
    const arrayBuffer = await blob.arrayBuffer();
    await writeBinaryFile(savePath, new Uint8Array(arrayBuffer));
  }
}
```

---

### Phase 3: GCODE-Module refactoren

#### 3.1 buildGcode.ts (bereits oben beschrieben)

#### 3.2 readGcode.ts

**Core-Version**:
```typescript
export function parseGcode(
  gcode: string,
  callbacks?: { onProgress?: (n: number) => void }
): GcodeParseResult {
  callbacks?.onProgress?.(0);

  // ... parse logic

  callbacks?.onProgress?.(100);

  return { sections, metadata };
}
```

#### 3.3 gcodeManipulation.ts

**Bereits UI-unabhängig** → direkt nach Core verschieben ✅

---

### Phase 4: Commands-Module refactoren

#### 4.1 swapRules.ts

**Bereits UI-unabhängig** → direkt nach Core verschieben ✅

#### 4.2 applySwapRules.ts

**Core-Version**:
```typescript
export interface ApplyRulesCallbacks {
  onRuleApplied?: (ruleName: string) => void;
  onProgress?: (current: number, total: number) => void;
}

export function applySwapRules(
  gcode: string,
  rules: SwapRule[],
  context: RuleContext,
  callbacks?: ApplyRulesCallbacks
): string {
  let result = gcode;

  for (let i = 0; i < rules.length; i++) {
    callbacks?.onProgress?.(i, rules.length);

    const rule = rules[i];
    result = applyRule(result, rule, context);

    callbacks?.onRuleApplied?.(rule.name);
  }

  return result;
}
```

---

### Phase 5: Config-Module refactoren

#### 5.1 materialConfig.ts

**Problem**: `document.getElementById('material_config')`

**Lösung**: Config als JSON/Objekt exportieren

**Core-Version**:
```typescript
// core/config/materialConfig.ts
export interface MaterialConfig {
  materials: Material[];
  defaultMaterial: string;
}

export const defaultMaterialConfig: MaterialConfig = {
  materials: [
    { id: 'PLA', name: 'PLA', temp: 210 },
    { id: 'PETG', name: 'PETG', temp: 240 },
    // ...
  ],
  defaultMaterial: 'PLA'
};

export function getMaterialByType(type: string): Material | undefined {
  return defaultMaterialConfig.materials.find(m => m.id === type);
}
```

**Web-Adapter**:
```typescript
// web/src/config/materialConfig-web.ts
import { defaultMaterialConfig } from '@swapmod/core';

export function loadMaterialConfigFromDOM(): MaterialConfig {
  const element = document.getElementById('material_config');
  if (element) {
    return JSON.parse(element.textContent || '{}');
  }
  return defaultMaterialConfig;
}
```

---

## 📋 Implementierungs-Checkliste

### Phase 1: Settings (höchste Priorität)
- [ ] `GcodeSettings` Interface in `core/types/index.ts` erstellen
- [ ] `buildGcode()` in Core refactoren (Settings-Parameter)
- [ ] `buildGcodeWeb()` Web-Adapter erstellen
- [ ] Alle Settings-Getter in Web sammeln

### Phase 2: IO-Module
- [ ] `read3mf()` in Core mit Callbacks refactoren
- [ ] `export3mf()` in Core mit Callbacks refactoren
- [ ] `exportGcode()` in Core mit Callbacks refactoren
- [ ] `ioUtils.ts` analysieren und aufteilen
- [ ] Web-Adapter für alle IO-Funktionen erstellen

### Phase 3: GCODE-Module
- [ ] `gcodeManipulation.ts` direkt nach Core verschieben ✅
- [ ] `readGcode.ts` mit Callbacks refactoren
- [ ] `gcodeUtils.ts` analysieren (wahrscheinlich schon UI-frei)
- [ ] `m73ProgressTransform.ts` analysieren

### Phase 4: Commands-Module
- [ ] `swapRules.ts` direkt nach Core verschieben ✅
- [ ] `applySwapRules.ts` mit Callbacks refactoren
- [ ] `plateRestrictions.ts` analysieren

### Phase 5: Config-Module
- [ ] `materialConfig.ts` als JSON/Objekt exportieren
- [ ] Web-Adapter für DOM-basierte Config-Ladung

---

## 🎯 Erwartetes Endergebnis

### Core-Package Exports

```typescript
// @swapmod/core/index.ts

// Types
export * from './types/index.js';

// IO
export { read3mf, type Read3mfCallbacks, type Read3mfResult } from './io/read3mf.js';
export { export3mf, type Export3mfCallbacks } from './io/export3mf.js';
export { exportGcode } from './io/exportGcode.js';

// GCODE
export { buildGcode, type GcodeSettings } from './gcode/buildGcode.js';
export { parseGcode, splitIntoSections } from './gcode/readGcode.js';
export * from './gcode/gcodeManipulation.js';

// Commands
export { swapRules } from './commands/swapRules.js';
export { applySwapRules, type ApplyRulesCallbacks } from './commands/applySwapRules.js';
export * from './commands/plateRestrictions.js';

// Config
export { defaultMaterialConfig, getMaterialByType } from './config/materialConfig.js';
export { PRESET_INDEX } from './config/filamentConfig/index.js';

// Utils
export * from './utils/amsUtils.js';
export * from './utils/colors.js';
export * from './utils/time.js';
export * from './utils/regex.js';
```

### Code-Verteilung

**Geschätzte Aufteilung**:
- **Core**: ~80-85% der Business-Logik
- **Web**: ~15-20% (UI-Layer, DOM-Adapter, State Management)
- **Desktop**: ~15-20% (Tauri-Integration, Native-Adapter)

**Duplikation**: <5% (nur minimale Adapter-Logik)

---

## ⚡ Vorteile dieser Architektur

### 1. Maximaler Code-Sharing
- ✅ Alle Parsing-Logik in Core
- ✅ Alle GCODE-Generierung in Core
- ✅ Alle Regeln in Core
- ✅ Web und Desktop nutzen identische Business-Logik

### 2. Testbarkeit
```typescript
// Tests ohne UI-Dependencies
import { read3mf, buildGcode } from '@swapmod/core';

test('read3mf parses valid file', async () => {
  const blob = await loadTestFile('test.3mf');
  const result = await read3mf(blob); // Keine UI nötig!
  expect(result.plates).toHaveLength(3);
});
```

### 3. Flexibilität
- Web kann Browser-Download nutzen
- Desktop kann Native File Dialogs nutzen
- CLI könnte hinzugefügt werden ohne Code-Änderung in Core

### 4. Keine Breaking Changes
- Web-Code nutzt Adapter (drop-in replacement)
- Bestehende Funktionalität bleibt identisch
- Schrittweise Migration möglich

---

## 🚀 Nächste Schritte

**Empfohlene Reihenfolge**:

1. **Settings-System** (1-2h)
   - Größter Impact
   - Blockiert `buildGcode()` Migration

2. **GCODE-Module** (2-3h)
   - `gcodeManipulation.ts` → Core (einfach)
   - `buildGcode.ts` → Core (nach Settings)
   - `readGcode.ts` → Core

3. **IO-Module** (3-4h)
   - `read3mf.ts` → Core (komplex wegen UI)
   - `export3mf.ts` → Core
   - `exportGcode.ts` → Core

4. **Commands** (1-2h)
   - `swapRules.ts` → Core (einfach)
   - `applySwapRules.ts` → Core

5. **Testing** (1-2h)
   - Web-App funktioniert noch?
   - Alle Features getestet?

**Total: ~8-13 Stunden** für komplettes Refactoring

---

## 💡 Alternativen (falls zu aufwendig)

### Minimal-Variante
Nur **reine Funktionen** in Core, Rest bleibt in web/desktop:
- `gcodeManipulation.ts` ✅
- `swapRules.ts` ✅
- Utility-Funktionen ✅

**Aufwand**: 1-2h
**Code-Sharing**: ~40%

### Mittel-Variante
Minimal + **Settings als Objekt**:
- `buildGcode()` mit Settings-Parameter

**Aufwand**: 3-4h
**Code-Sharing**: ~60%

### Maximal-Variante (dieser Plan)
**Alles** in Core mit Dependency Injection

**Aufwand**: 8-13h
**Code-Sharing**: ~80-85%

---

## ❓ Fragen zum Diskutieren

1. **Wie viel Code-Sharing ist das Ziel?**
   - Minimal (40%)
   - Mittel (60%)
   - Maximal (80%+)

2. **Wie viel Zeit ist verfügbar?**
   - Wenig: Minimal-Variante
   - Mittel: Settings + GCODE
   - Viel: Full Refactoring

3. **Testing-Strategie?**
   - Vor Refactoring: E2E-Tests schreiben?
   - Schrittweise testen nach jedem Modul?

4. **Breaking Changes akzeptabel?**
   - Nein → Adapter-Pattern (wie hier beschrieben)
   - Ja → Direkter Rewrite

---

**Bereit zum Start? Sag mir, welche Variante du bevorzugst!** 🚀
