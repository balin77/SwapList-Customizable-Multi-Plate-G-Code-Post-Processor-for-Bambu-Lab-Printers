# 🚀 AutoEject - Automatische Versionierung

Dieses Dokument beschreibt das automatische Versionierungssystem für AutoEject.

---

## 📋 Inhaltsverzeichnis

1. [Übersicht](#übersicht)
2. [Schnellstart](#schnellstart)
3. [Versionsformat](#versionsformat)
4. [Manuelle Versionierung](#manuelle-versionierung)
5. [Automatische Versionierung](#automatische-versionierung)
6. [Commit-Message-Konventionen](#commit-message-konventionen)
7. [Beispiele](#beispiele)
8. [Troubleshooting](#troubleshooting)

---

## 📖 Übersicht

AutoEject verwendet ein intelligentes Versionierungssystem, das automatisch die Version bei jedem GitHub-Commit aktualisiert. Die Version wird zentral in `version.json` gespeichert und automatisch in alle relevanten Dateien übertragen.

### Betroffene Dateien:
- ✅ `version.json` - Zentrale Versionsdatei
- ✅ `assets/js/i18n/locales/de.json` - Deutsche Sprachdatei
- ✅ `assets/js/i18n/locales/en.json` - Englische Sprachdatei
- ✅ `index.html` - Hauptseite (Version im Info-Bereich)

---

## ⚡ Schnellstart

### Lokal (auf deinem Computer):

```bash
# Build-Nummer erhöhen (schnellster Weg)
npm run version:bump

# Patch-Version erhöhen
npm run version:patch

# Minor-Version erhöhen
npm run version:minor

# Major-Version erhöhen
npm run version:major
```

### Automatisch (via GitHub):

Einfach committen und pushen - die Version wird automatisch basierend auf deiner Commit-Message erhöht!

```bash
git add .
git commit -m "feat: neue Export-Funktion"
git push
```

---

## 🔢 Versionsformat

### Struktur
```
Version: 1.4.0 (major.minor.patch)
Build:   23
```

### Anzeige im Interface
```
AutoEject Version V1.4
```

**Hinweis:** Im Interface wird nur `major.minor` angezeigt (z.B. V1.4), die vollständige Version steht in `version.json`.

### Was bedeutet was?

| Teil | Wann erhöhen? | Beispiel |
|------|---------------|----------|
| **Major** | Breaking Changes, große Änderungen | 1.4.0 → 2.0.0 |
| **Minor** | Neue Features, keine Breaking Changes | 1.4.0 → 1.5.0 |
| **Patch** | Bugfixes, kleine Verbesserungen | 1.4.0 → 1.4.1 |
| **Build** | Jeder andere Commit | Build 23 → 24 |

---

## 🖥️ Manuelle Versionierung

Du kannst die Version jederzeit manuell über npm-Scripts aktualisieren:

### Befehle

```bash
# Build-Nummer erhöhen
npm run version:bump
# Beispiel: 1.4.0 (build 5) → 1.4.0 (build 6)

# Patch-Version erhöhen
npm run version:patch
# Beispiel: 1.4.0 → 1.4.1 (build 0)

# Minor-Version erhöhen
npm run version:minor
# Beispiel: 1.4.0 → 1.5.0 (build 0)

# Major-Version erhöhen
npm run version:major
# Beispiel: 1.4.0 → 2.0.0 (build 0)
```

### Was passiert beim Ausführen?

1. ✅ `version.json` wird aktualisiert
2. ✅ Beide Sprachdateien werden aktualisiert
3. ✅ `index.html` wird aktualisiert
4. 📋 Du bekommst eine Zusammenfassung und Commit-Vorschlag

### Beispiel-Output:
```
🔄 Updating version...

Current version: 1.4.0 (build 5)
New version: 1.4.0 (build 6)
Display string: "AutoEject Version V1.4"

✓ Updated version.json to 1.4.0 (build 6)
✓ Updated de.json
✓ Updated en.json
✓ Updated index.html

✅ Version update complete!

Next steps:
  git add .
  git commit -m "chore: bump version to 1.4.0"
  git push
```

---

## 🤖 Automatische Versionierung

Bei jedem Push auf `main` oder `master` wird die Version **automatisch** erhöht!

### Wie funktioniert es?

1. Du machst einen Commit mit aussagekräftiger Message
2. Du pushst zu GitHub
3. GitHub Action analysiert deine Commit-Message
4. Version wird automatisch erhöht
5. Änderungen werden automatisch committed und gepusht

### GitHub Action läuft bei:
- ✅ Push auf `main` Branch
- ✅ Push auf `master` Branch
- ❌ NICHT bei Änderungen an `version.json` (verhindert Endlosschleife)
- ❌ NICHT bei Commits mit `[skip-version]`

---

## 📝 Commit-Message-Konventionen

Die Art der Versionserhöhung wird **automatisch** anhand deiner Commit-Message erkannt:

### Konventionen-Tabelle

| Commit enthält | Version Bump | Beispiel |
|----------------|--------------|----------|
| `feat:` oder `[minor]` | **Minor** | 1.4.0 → 1.5.0 |
| `fix:` oder `[patch]` | **Patch** | 1.4.0 → 1.4.1 |
| `BREAKING CHANGE:` oder `[major]` | **Major** | 1.4.0 → 2.0.0 |
| `[skip-version]` | **Keine** | - |
| Alles andere | **Build** | build +1 |

### Spezielle Keywords

#### Automatische Erkennung:
- `feat:` - Neues Feature → Minor bump
- `fix:` - Bugfix → Patch bump
- `BREAKING CHANGE:` - Breaking Change → Major bump

#### Manuelle Steuerung:
- `[major]` - Erzwingt Major bump
- `[minor]` - Erzwingt Minor bump
- `[patch]` - Erzwingt Patch bump
- `[skip-version]` - Überspringt Versionierung komplett

---

## 💡 Beispiele

### Beispiel 1: Neues Feature (Minor)
```bash
git commit -m "feat: neue AMS-Optimierung hinzugefügt"
git push
```
**Ergebnis:** 1.4.0 → 1.5.0 ✅

---

### Beispiel 2: Bugfix (Patch)
```bash
git commit -m "fix: Fehler beim Export von 3MF-Dateien behoben"
git push
```
**Ergebnis:** 1.4.0 → 1.4.1 ✅

---

### Beispiel 3: Breaking Change (Major)
```bash
git commit -m "refactor: komplettes UI-Redesign

BREAKING CHANGE: alte Einstellungen nicht mehr kompatibel"
git push
```
**Ergebnis:** 1.4.0 → 2.0.0 ✅

---

### Beispiel 4: Normale Änderung (Build)
```bash
git commit -m "chore: Code-Formatierung verbessert"
git push
```
**Ergebnis:** 1.4.0 (build 5) → 1.4.0 (build 6) ✅

---

### Beispiel 5: Manuelles Forcing (Minor)
```bash
git commit -m "refactor: große Umstrukturierung des Codes [minor]"
git push
```
**Ergebnis:** 1.4.0 → 1.5.0 ✅

---

### Beispiel 6: Ohne Versionierung
```bash
git commit -m "docs: README aktualisiert [skip-version]"
git push
```
**Ergebnis:** Keine Änderung ✅

---

### Beispiel 7: Mehrere Änderungen
```bash
git commit -m "feat: neue Features

- Export-Funktion verbessert
- UI-Performance optimiert
- Neue Drucker-Profile hinzugefügt"
git push
```
**Ergebnis:** 1.4.0 → 1.5.0 ✅

---

### Beispiel 8: Kritischer Hotfix
```bash
git commit -m "fix: kritischer Fehler beim Datei-Upload [patch]"
git push
```
**Ergebnis:** 1.4.0 → 1.4.1 ✅

---

## 🔧 Troubleshooting

### Problem: Version wird nicht automatisch erhöht

**Mögliche Ursachen:**

1. **GitHub Actions nicht aktiviert**
   - Prüfe: GitHub Repository → Settings → Actions → Allow all actions

2. **Branch stimmt nicht**
   - Automatik läuft nur auf `main` oder `master`
   - Prüfe deinen aktuellen Branch: `git branch`

3. **Commit enthält `[skip-version]`**
   - Entferne das Flag aus der Commit-Message

4. **Nur Markdown-Dateien geändert**
   - Die Action ignoriert `.md` Dateien standardmäßig

**Lösung:**
```bash
# Prüfe GitHub Actions Status
# Gehe zu: github.com/dein-username/dein-repo/actions

# Oder manuell ausführen:
npm run version:bump
git add .
git commit -m "chore: manuelle Versionsaktualisierung"
git push
```

---

### Problem: Script funktioniert lokal nicht

**Fehlermeldung:**
```
Error: Cannot find module 'update-version.js'
```

**Lösung:**
```bash
# Stelle sicher, dass die .mjs Datei existiert
ls scripts/update-version.mjs

# Falls nicht, erstelle sie neu oder hole sie aus dem Repo
git checkout scripts/update-version.mjs
```

---

### Problem: Falscher Version Bump

**Beispiel:** Du wolltest Minor, aber es wurde nur Build erhöht.

**Lösung:**
```bash
# Manuell korrigieren
npm run version:minor

# Commit mit spezifischem Flag
git add .
git commit -m "chore: korrekte Version [minor]"
git push
```

---

### Problem: Version in Dateien nicht aktualisiert

**Prüfe:**
```bash
# Version in version.json
cat version.json

# Version in Sprachdateien
grep -r "AutoEject Version" assets/js/i18n/locales/
```

**Lösung:**
```bash
# Script nochmal ausführen
npm run version:bump
```

---

## 📚 Weitere Informationen

### Dateien im System

```
📁 Projekt-Root
├── 📄 version.json                      # Zentrale Versionsdatei
├── 📄 VERSIONING.md                     # Diese Dokumentation
├── 📁 .github/
│   └── 📁 workflows/
│       └── 📄 version-bump.yml          # GitHub Action
├── 📁 scripts/
│   └── 📄 update-version.mjs            # Versionierungs-Script
├── 📁 assets/
│   └── 📁 js/
│       └── 📁 i18n/
│           └── 📁 locales/
│               ├── 📄 de.json           # Deutsche Versionsstrings
│               └── 📄 en.json           # Englische Versionsstrings
└── 📄 index.html                        # Version im Info-Bereich
```

### Best Practices

1. **Immer aussagekräftige Commit-Messages schreiben**
   ```bash
   ✅ "feat: neue Export-Funktion für GCODE"
   ❌ "update"
   ```

2. **Bei Breaking Changes immer `BREAKING CHANGE:` verwenden**
   ```bash
   git commit -m "refactor: neue API-Struktur

   BREAKING CHANGE: alte API-Endpoints entfernt"
   ```

3. **[skip-version] für Dokumentationsänderungen**
   ```bash
   git commit -m "docs: Tippfehler korrigiert [skip-version]"
   ```

4. **Regelmäßig die Version prüfen**
   ```bash
   cat version.json
   ```

---

## 🎯 Quick Reference

### Commit-Präfixe

| Präfix | Bedeutung | Version Bump |
|--------|-----------|--------------|
| `feat:` | Neues Feature | Minor |
| `fix:` | Bugfix | Patch |
| `docs:` | Dokumentation | Build |
| `style:` | Formatierung | Build |
| `refactor:` | Code-Umstrukturierung | Build |
| `perf:` | Performance-Verbesserung | Build |
| `test:` | Tests | Build |
| `chore:` | Wartung | Build |

### Flags

| Flag | Wirkung |
|------|---------|
| `[major]` | Major bump erzwingen |
| `[minor]` | Minor bump erzwingen |
| `[patch]` | Patch bump erzwingen |
| `[skip-version]` | Versionierung überspringen |

---

## ✨ Zusammenfassung

Das Versionierungssystem ist **vollautomatisch** und erfordert keine manuelle Pflege. Schreibe einfach gute Commit-Messages und die Version wird automatisch aktualisiert!

**Einfachster Workflow:**
```bash
# 1. Änderungen machen
# 2. Committen mit gutem Message
git add .
git commit -m "feat: tolle neue Funktion"

# 3. Pushen
git push

# 4. Fertig! Version wurde automatisch erhöht 🎉
```

---

**Fragen oder Probleme?** Erstelle ein Issue im GitHub Repository oder melde dich beim Entwickler-Team.

---

*Erstellt für AutoEject v1.4 - Automatisches 3D-Druck-Workflow-Tool*
