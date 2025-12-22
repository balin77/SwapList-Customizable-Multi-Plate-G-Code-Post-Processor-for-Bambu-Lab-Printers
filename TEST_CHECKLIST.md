# Test Checklist - Nach Refactoring Phase 1

**Datum**: 2025-12-22
**Status**: Bereit zum Testen

---

## ✅ Commits erstellt

### Original-Projekt (Swapmod Website)
```
commit 00d1132
docs: add migration and refactoring plans
- MIGRATION_PLAN.md
- MIGRATION_STATUS.md
- REFACTORING_PLAN.md
- REFACTORING_STATUS.md
```

### Monorepo (swapmod-monorepo)
```
commit 920f219
feat: initial monorepo setup with refactored core package
- 3789 files created
- Core package kompiliert erfolgreich
- Web package kopiert (noch nicht angepasst)
```

---

## 🧪 Test-Plan

### 1. Web-App Funktionstest (Priorität: HOCH)

**Ziel**: Sicherstellen, dass die Web-App noch funktioniert (keine Breaking Changes)

#### Test 1.1: Dev-Server startet
```bash
cd "c:/Users/guble/OneDrive/3d Print/Diverse Utility für Printer/Swapmod/Swapmod Website"
npm run dev
```

**Erwartung**:
- ✅ Server läuft auf Port 5173
- ✅ Keine Build-Errors
- ✅ Browser öffnet App

**Status**: ⏳ Läuft gerade

---

#### Test 1.2: 3MF-Datei laden
**Schritte**:
1. Browser öffnen: http://localhost:5173
2. 3MF-Datei per Drag & Drop laden
3. Plates werden angezeigt

**Erwartung**:
- ✅ Datei wird geladen
- ✅ Plates erscheinen in der Liste
- ✅ Thumbnails sichtbar
- ✅ Keine Console-Errors

**Status**: ⏳ Zu testen

---

#### Test 1.3: Settings öffnen
**Schritte**:
1. Settings-Icon klicken
2. Settings-Panel öffnet sich
3. Settings ändern (z.B. Secure Push-off)

**Erwartung**:
- ✅ Panel öffnet
- ✅ Checkboxen funktionieren
- ✅ Werte werden gespeichert

**Status**: ⏳ Zu testen

---

#### Test 1.4: Export SWAP-Datei
**Schritte**:
1. 3MF-Datei laden
2. "Export SWAP" klicken
3. Datei wird generiert

**Erwartung**:
- ✅ Export startet
- ✅ Fortschrittsanzeige
- ✅ Download erfolgt
- ✅ Datei hat .swap.3mf Extension

**Status**: ⏳ Zu testen

---

#### Test 1.5: AMS Slot Remapping
**Schritte**:
1. 3MF mit mehreren Farben laden
2. Filament-Swatch klicken
3. Anderen Slot wählen
4. Export

**Erwartung**:
- ✅ Slot-Wechsel funktioniert
- ✅ UI zeigt neue Zuordnung
- ✅ GCODE enthält geänderte M620/M621

**Status**: ⏳ Zu testen

---

### 2. Core-Package Test (Priorität: MITTEL)

#### Test 2.1: Package-Build
```bash
cd "c:/Users/guble/OneDrive/3d Print/Diverse Utility für Printer/Swapmod/swapmod-monorepo/packages/core"
pnpm build
```

**Erwartung**:
- ✅ Kompiliert ohne Errors
- ✅ dist/ Ordner erstellt
- ✅ .js und .d.ts Dateien vorhanden

**Status**: ✅ Erfolgreich

---

#### Test 2.2: Exports testen
```bash
cd packages/core
node -e "const core = require('./dist/index.js'); console.log(Object.keys(core));"
```

**Erwartung**:
- ✅ Alle Exports verfügbar
- ✅ Types exportiert
- ✅ GCODE-Funktionen exportiert

**Status**: ⏳ Zu testen

---

### 3. Monorepo-Build Test (Priorität: NIEDRIG)

#### Test 3.1: Root-Build
```bash
cd swapmod-monorepo
pnpm install
pnpm build
```

**Erwartung**:
- ✅ Dependencies installiert
- ✅ Core kompiliert
- ✅ Web kompiliert (mit warnings ok)

**Status**: ⏳ Zu testen

---

## 🐛 Bekannte Issues (OK für Phase 1)

### 1. Web nutzt noch alte Imports
**Issue**: Web-Package importiert noch von `../gcode/` statt `@swapmod/core`

**Status**: ✅ ERWARTBAR - Phase 2 wird das fixen

**Impact**: Web läuft mit altem Code (funktioniert)

---

### 2. applySwapRules.ts fehlt in Core
**Issue**: Zu viele Dependencies, nicht migriert

**Status**: ✅ ERWARTBAR - bleibt in Web bis buildGcode.ts refactored

**Impact**: Kein - Web nutzt lokale Version

---

### 3. Line-Endings (CRLF Warnings)
**Issue**: Git warnt wegen LF → CRLF Konvertierung

**Status**: ✅ NORMAL auf Windows

**Impact**: Kein - rein kosmetisch

---

## 📊 Test-Ergebnisse

| Test | Status | Notizen |
|------|--------|---------|
| **1.1** Dev-Server | ⏳ Läuft | Port 5173 |
| **1.2** 3MF laden | ⏳ | - |
| **1.3** Settings | ⏳ | - |
| **1.4** Export | ⏳ | - |
| **1.5** AMS Remap | ⏳ | - |
| **2.1** Core Build | ✅ | Erfolgreich |
| **2.2** Core Exports | ⏳ | - |
| **3.1** Root Build | ⏳ | - |

---

## 🎯 Success Criteria

### Minimum (Für Commit OK):
- ✅ Core-Package kompiliert
- ⏳ Web-App lädt und zeigt UI
- ⏳ Keine kritischen Console-Errors

### Nice-to-Have:
- ⏳ 3MF Import funktioniert
- ⏳ Export funktioniert
- ⏳ Settings funktionieren

---

## 🚀 Nächste Schritte (nach erfolgreichem Test)

### Option A: Phase 2 starten (buildGcode.ts)
- Settings refactoren
- Web-Adapter erstellen
- Ziel: 60% Code-Sharing

### Option B: Desktop-App beginnen
- Tauri Setup
- Core-Package nutzen (45% sharing ok)
- Später buildGcode.ts refactoren

### Option C: Push & Pause
- Commits zu GitHub pushen
- Dokumentation reviewen
- Später weitermachen

---

## 📝 Test-Notizen

**Browser-Console öffnen**: F12 → Console-Tab

**Häufige Checks**:
1. Console-Errors? (rot)
2. Network-Tab: 404 Fehler?
3. UI lädt vollständig?
4. Buttons reagieren?

**Bei Problemen**:
1. Browser-Cache leeren (Ctrl+Shift+R)
2. Dev-Server neustarten
3. Console-Log prüfen

---

**Bereit zum Testen!** Browser zu http://localhost:5173 öffnen 🚀
