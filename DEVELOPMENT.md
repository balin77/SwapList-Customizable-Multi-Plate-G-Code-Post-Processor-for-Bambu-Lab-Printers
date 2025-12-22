# 🚀 SwapMod - Development & Deployment Guide

Vollständige Anleitung für Entwicklung, Versionierung und Deployment von SwapMod Web und Desktop.

---

## 📋 Inhaltsverzeichnis

1. [Repository-Übersicht](#repository-übersicht)
2. [Entwicklungs-Workflow](#entwicklungs-workflow)
3. [Versionierung](#versionierung)
4. [Desktop App Build](#desktop-app-build)
5. [GitHub Repositories & Updates](#github-repositories--updates)
6. [Troubleshooting](#troubleshooting)

---

## 📦 Repository-Übersicht

SwapMod besteht aus **4 GitHub Repositories**:

### 1. **SwapMod Web** (Haupt-Repository)
- **GitHub:** `https://github.com/balin77/SwapList-Customizable-Multi-Plate-G-Code-Post-Processor-for-Bambu-Lab-Printers`
- **Lokaler Pfad:** `c:\Users\guble\OneDrive\3d Print\Diverse Utility für Printer\Swapmod\Swapmod Website\`
- **Branch:** `main`
- **Beschreibung:** Web-Anwendung (Master-Code)
- **Verwendet von:**
  - Website (swapmod.com)
  - Desktop-App (als Basis)

### 2. **SwapMod Core**
- **GitHub:** `https://github.com/balin77/swapmod-core`
- **Lokaler Pfad:** `swapmod-monorepo\packages\core\`
- **Branch:** `main`
- **Beschreibung:** Geteilte Logik (GCODE-Processing, Export, etc.)
- **Verwendet von:**
  - Web-App
  - Desktop-App

### 3. **SwapMod Desktop**
- **GitHub:** `https://github.com/balin77/swapmod-desktop`
- **Lokaler Pfad:** `swapmod-monorepo\packages\desktop\`
- **Branch:** `master`
- **Beschreibung:** Tauri Desktop Anwendung
- **Verwendet von:** Desktop-Installer (Windows, macOS, Linux)

### 4. **SwapMod Monorepo** (Optional/Organisatorisch)
- **GitHub:** Noch nicht separat - kann erstellt werden
- **Lokaler Pfad:** `swapmod-monorepo\`
- **Beschreibung:** Umbrella-Projekt für Core + Desktop

---

## 💻 Entwicklungs-Workflow

### **Hauptentwicklung: IMMER im "Swapmod Website" Ordner!**

```
c:\Users\guble\OneDrive\3d Print\Diverse Utility für Printer\Swapmod\Swapmod Website\
```

**Das ist dein Master-Code! Hier entwickelst du ALLES:**
- ✅ Neue Features
- ✅ Bug Fixes
- ✅ UI-Änderungen
- ✅ Code-Refactoring

### **Workflow Schritt-für-Schritt:**

#### 1. **Entwickeln & Testen (Web)**

```bash
# Im "Swapmod Website" Ordner:
cd "c:\Users\guble\OneDrive\3d Print\Diverse Utility für Printer\Swapmod\Swapmod Website"

# Development Mode starten (mit Live-Reload):
npm run dev

# Browser öffnet automatisch auf http://localhost:...
# Änderungen werden automatisch neu geladen
```

#### 2. **Code Committen (Automatische Versionierung)**

```bash
# Änderungen hinzufügen:
git add .

# Commit mit Versionierungs-Konvention (siehe unten):
git commit -m "feat: neue Export-Funktion hinzugefügt"

# Zu GitHub pushen:
git push
```

**Die Version wird AUTOMATISCH erhöht basierend auf deiner Commit-Message!**

#### 3. **Desktop App testen (Optional)**

```bash
# Zum Desktop-Package wechseln:
cd "c:\Users\guble\OneDrive\3d Print\Diverse Utility für Printer\Swapmod\swapmod-monorepo\packages\desktop"

# Web-Code in Desktop kopieren:
npm run prepare

# Desktop-App starten (mit Live-Reload):
npm run dev

# Tauri-Fenster öffnet sich mit der App
```

#### 4. **Production Build (Desktop)**

```bash
# Im Desktop-Package:
cd "c:\Users\guble\OneDrive\3d Print\Diverse Utility für Printer\Swapmod\swapmod-monorepo\packages\desktop"

# Production Build mit Code-Obfuscation:
npm run build:production

# Installer wird erstellt:
# src-tauri/target/release/bundle/nsis/SwapMod_3.0.0_x64-setup.exe
```

---

## 🔢 Versionierung

### **Automatische Versionierung via GitHub Actions**

SwapMod verwendet ein vollautomatisches Versionierungssystem. Die Version wird bei jedem Push zu GitHub automatisch erhöht.

### **Versionsformat**

```
Version: 3.0.0 (major.minor.patch)
Build:   1
```

**Im UI angezeigt:** `SwapMod Version V3.0`

### **Commit-Message-Konventionen**

Die Version wird **automatisch** basierend auf deiner Commit-Message erhöht:

| Commit-Typ | Version Bump | Beispiel |
|------------|--------------|----------|
| `feat:` neue Features | **Minor** | 3.0.0 → 3.1.0 |
| `fix:` Bugfixes | **Patch** | 3.0.0 → 3.0.1 |
| `BREAKING CHANGE:` | **Major** | 3.0.0 → 4.0.0 |
| Alles andere | **Build** | Build 1 → 2 |

### **Beispiele:**

```bash
# Neues Feature (Minor):
git commit -m "feat: neue AMS-Optimierung hinzugefügt"
# Ergebnis: 3.0.0 → 3.1.0

# Bugfix (Patch):
git commit -m "fix: Export-Fehler behoben"
# Ergebnis: 3.0.0 → 3.0.1

# Breaking Change (Major):
git commit -m "refactor: neue API-Struktur

BREAKING CHANGE: alte API nicht mehr kompatibel"
# Ergebnis: 3.0.0 → 4.0.0

# Normale Änderung (Build):
git commit -m "chore: Code-Formatierung"
# Ergebnis: 3.0.0 (build 1) → 3.0.0 (build 2)

# Versionierung überspringen:
git commit -m "docs: README aktualisiert [skip-version]"
# Ergebnis: Keine Änderung
```

### **Manuelle Versionierung (lokal)**

Falls du die Version manuell erhöhen möchtest:

```bash
# Im "Swapmod Website" Ordner:

# Build-Nummer erhöhen:
npm run version:bump

# Patch erhöhen (3.0.0 → 3.0.1):
npm run version:patch

# Minor erhöhen (3.0.0 → 3.1.0):
npm run version:minor

# Major erhöhen (3.0.0 → 4.0.0):
npm run version:major
```

### **Betroffene Dateien:**

Bei jeder Versionsänderung werden automatisch aktualisiert:
- ✅ `version.json` - Zentrale Versionsdatei
- ✅ `assets/js/i18n/locales/de.json` - Deutsche Sprachdatei
- ✅ `assets/js/i18n/locales/en.json` - Englische Sprachdatei
- ✅ `index.html` - Version im Info-Bereich

---

## 🖥️ Desktop App Build

### **Development Build (mit Debugging)**

```bash
cd "swapmod-monorepo\packages\desktop"

# Web-Code kopieren:
npm run prepare

# App starten:
npm run dev
```

### **Production Build (für Kunden)**

```bash
cd "swapmod-monorepo\packages\desktop"

# Production Build mit Code-Obfuscation:
npm run build:production
```

**Installer wird erstellt in:**
```
src-tauri\target\release\bundle\nsis\SwapMod_3.0.0_x64-setup.exe  (NSIS - empfohlen)
src-tauri\target\release\bundle\msi\SwapMod_3.0.0_x64_en-US.msi   (MSI)
```

### **Version in Desktop-Installer aktualisieren**

Die Desktop-Version muss manuell in `tauri.conf.json` synchronisiert werden:

1. **Aktuelle Web-Version prüfen:**
   ```bash
   cat "c:\Users\guble\OneDrive\3d Print\Diverse Utility für Printer\Swapmod\Swapmod Website\version.json"
   ```

2. **Desktop-Version aktualisieren:**
   ```bash
   # Datei öffnen:
   # swapmod-monorepo\packages\desktop\src-tauri\tauri.conf.json

   # Version ändern (Zeile 4):
   "version": "3.0.0",  # ← auf Web-Version aktualisieren
   ```

3. **Änderungen committen:**
   ```bash
   cd "swapmod-monorepo\packages\desktop"
   git add src-tauri/tauri.conf.json
   git commit -m "chore: bump version to 3.0.0"
   git push
   ```

### **Automatisierung (TODO):**

Es könnte ein Script erstellt werden, das die Version automatisch von `version.json` übernimmt:

```bash
# Zukünftiges Script (noch nicht implementiert):
npm run sync-version  # Würde version.json → tauri.conf.json übertragen
```

---

## 🔄 GitHub Repositories & Updates

### **Repository-Struktur:**

```
┌─────────────────────────────────────────────────────┐
│ SwapMod Web                                         │
│ github.com/balin77/SwapList-...                     │
│ ├── Master-Code (Entwicklung)                      │
│ ├── Automatische Versionierung                     │
│ └── Wird kopiert → Desktop                         │
└─────────────────────────────────────────────────────┘
                    │
                    │ (npm run prepare)
                    ▼
┌─────────────────────────────────────────────────────┐
│ SwapMod Core                                        │
│ github.com/balin77/swapmod-core                     │
│ ├── Geteilte GCODE-Logik                          │
│ ├── Export-Funktionen                             │
│ └── Wird verwendet von Web & Desktop              │
└─────────────────────────────────────────────────────┘
                    │
                    │ (npm link / import)
                    ▼
┌─────────────────────────────────────────────────────┐
│ SwapMod Desktop                                     │
│ github.com/balin77/swapmod-desktop                  │
│ ├── Tauri-App (Rust + Web)                        │
│ ├── Native File Dialogs                           │
│ └── Installer-Generation                          │
└─────────────────────────────────────────────────────┘
```

### **Update-Workflow:**

#### **1. Web-Code auf GitHub pushen:**

```bash
cd "c:\Users\guble\OneDrive\3d Print\Diverse Utility für Printer\Swapmod\Swapmod Website"

# Änderungen committen:
git add .
git commit -m "feat: neue Funktion"
git push

# Version wird automatisch erhöht!
```

#### **2. Desktop-App aktualisieren:**

```bash
cd "swapmod-monorepo\packages\desktop"

# Web-Code kopieren:
npm run prepare

# Testen:
npm run dev

# Wenn OK, committen:
git add .
git commit -m "chore: update frontend from web repo"
git push
```

#### **3. Core-Package aktualisieren (falls Core geändert wurde):**

```bash
cd "swapmod-monorepo\packages\core"

# Änderungen committen:
git add .
git commit -m "feat: neue GCODE-Funktion"
git push
```

### **Alle Repos auf einmal aktualisieren:**

```bash
# Web:
cd "c:\Users\guble\OneDrive\3d Print\Diverse Utility für Printer\Swapmod\Swapmod Website"
git pull

# Core:
cd "swapmod-monorepo\packages\core"
git pull

# Desktop:
cd "swapmod-monorepo\packages\desktop"
git pull
```

---

## 🛠️ Troubleshooting

### **Problem: Version wird nicht automatisch erhöht**

**Lösung:**
1. Prüfe GitHub Actions: `github.com/balin77/SwapList-.../actions`
2. Prüfe Branch: Muss `main` sein (`git branch`)
3. Prüfe Commit-Message: Sollte Konvention folgen

**Manuelle Alternative:**
```bash
npm run version:bump
git add .
git commit -m "chore: manual version bump"
git push
```

### **Problem: Desktop-Installer hat falsche Version**

**Ursache:** Version in `tauri.conf.json` nicht aktualisiert

**Lösung:**
```bash
# 1. Web-Version prüfen:
cat version.json

# 2. Desktop-Version aktualisieren:
# swapmod-monorepo\packages\desktop\src-tauri\tauri.conf.json
# Zeile 4: "version": "3.0.0"  ← ändern

# 3. Neu builden:
npm run build:production
```

### **Problem: Desktop-App zeigt alten Code**

**Ursache:** Frontend wurde nicht kopiert

**Lösung:**
```bash
cd "swapmod-monorepo\packages\desktop"

# Web-Code neu kopieren:
npm run prepare

# App neu starten:
npm run dev
```

### **Problem: Git Push wird rejected**

**Ursache:** Lokaler Code ist veraltet

**Lösung:**
```bash
# Änderungen von GitHub holen:
git pull --rebase

# Dann erneut pushen:
git push
```

---

## 📚 Wichtige Befehle - Quick Reference

### **Web Development:**
```bash
npm run dev              # Development Server starten
npm run build            # Production Build (ohne Obfuscation)
npm run build:production # Production Build (mit Obfuscation)
npm run typecheck        # TypeScript Type Checking
```

### **Versionierung:**
```bash
npm run version:bump     # Build +1
npm run version:patch    # Patch erhöhen (3.0.0 → 3.0.1)
npm run version:minor    # Minor erhöhen (3.0.0 → 3.1.0)
npm run version:major    # Major erhöhen (3.0.0 → 4.0.0)
```

### **Desktop:**
```bash
npm run prepare          # Web-Code kopieren (ohne Obfuscation)
npm run prepare:production # Web-Code kopieren (mit Obfuscation)
npm run dev              # Desktop-App starten (Dev-Mode)
npm run build            # Installer bauen (ohne Obfuscation)
npm run build:production # Installer bauen (mit Obfuscation)
npm run clean            # Build-Cache löschen
```

### **Git:**
```bash
git add .                                    # Alle Änderungen stagen
git commit -m "feat: neue Funktion"         # Committen (Minor bump)
git commit -m "fix: Fehler behoben"         # Committen (Patch bump)
git commit -m "docs: Doku [skip-version]"   # Committen (kein bump)
git push                                     # Zu GitHub pushen
git pull --rebase                            # Von GitHub holen
```

---

## ✨ Zusammenfassung

### **Dein Standard-Workflow:**

1. **Code schreiben** in `Swapmod Website/`
2. **Testen** mit `npm run dev`
3. **Committen** mit guter Message: `git commit -m "feat: ..."`
4. **Pushen**: `git push`
5. **Fertig!** Version wird automatisch erhöht

### **Desktop-Installer erstellen:**

1. **Web-Code aktualisieren** (siehe oben)
2. **Version synchronisieren** in `tauri.conf.json`
3. **Desktop-Build**: `npm run build:production`
4. **Installer verteilen**: `SwapMod_3.0.0_x64-setup.exe`

---

**Viel Erfolg bei der Entwicklung! 🚀**

*Für weitere Fragen: Siehe GitHub Issues oder VERSIONING.md*
