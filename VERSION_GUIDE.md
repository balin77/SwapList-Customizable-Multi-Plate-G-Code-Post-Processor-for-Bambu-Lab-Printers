# AutoEject - Automatisches Versionierungssystem

Dieses Projekt verwendet ein automatisches Versionierungssystem, das die Version bei jedem GitHub-Commit automatisch aktualisiert.

## 📦 Wie es funktioniert

Die Version wird zentral in der Datei `version.json` gespeichert und automatisch in folgende Dateien übertragen:
- `assets/js/i18n/locales/de.json`
- `assets/js/i18n/locales/en.json`
- `index.html`

## 🔢 Versionsformat

- **Version**: `1.4.0` (major.minor.patch)
- **Build Number**: Automatisch erhöht bei jedem Commit
- **Anzeige**: `AutoEject Version V1.4`

## 🚀 Manuelle Versionsaktualisierung

Du kannst die Version manuell über npm-Scripts aktualisieren:

```bash
# Build-Nummer erhöhen (z.B. 1.4.0 build 5 → build 6)
npm run version:bump

# Patch-Version erhöhen (z.B. 1.4.0 → 1.4.1)
npm run version:patch

# Minor-Version erhöhen (z.B. 1.4.0 → 1.5.0)
npm run version:minor

# Major-Version erhöhen (z.B. 1.4.0 → 2.0.0)
npm run version:major
```

## 🤖 Automatische Versionsaktualisierung via GitHub

Bei jedem Push auf `main` oder `master` wird die Version automatisch erhöht, basierend auf deiner Commit-Message:

### Commit-Message-Konventionen

| Commit Message | Version Bump | Beispiel |
|----------------|--------------|----------|
| `feat: neue Funktion` | **minor** | 1.4.0 → 1.5.0 |
| `fix: Bugfix` | **patch** | 1.4.0 → 1.4.1 |
| `BREAKING CHANGE: ...` | **major** | 1.4.0 → 2.0.0 |
| `chore: Aufräumarbeiten` | **build** | build +1 |
| Normale Commits | **build** | build +1 |

### Spezielle Commit-Flags

- **`[major]`**: Erzwingt major version bump (z.B. `refactor: große Änderungen [major]`)
- **`[minor]`**: Erzwingt minor version bump (z.B. `chore: neue Komponente [minor]`)
- **`[patch]`**: Erzwingt patch version bump (z.B. `docs: fix typo [patch]`)
- **`[skip-version]`**: Überspringt automatische Versionierung (z.B. `chore: README update [skip-version]`)

### Beispiele

```bash
# Minor-Version wird erhöht (1.4.0 → 1.5.0)
git commit -m "feat: neue AMS-Optimierung hinzugefügt"

# Patch-Version wird erhöht (1.4.0 → 1.4.1)
git commit -m "fix: Fehler beim Export behoben"

# Major-Version wird erhöht (1.4.0 → 2.0.0)
git commit -m "refactor: komplettes UI-Redesign

BREAKING CHANGE: alte Einstellungen nicht mehr kompatibel"

# Nur Build-Nummer wird erhöht
git commit -m "chore: Code-Formatierung verbessert"

# Keine Versionierung
git commit -m "docs: README aktualisiert [skip-version]"
```

## 📝 Workflow

1. **Änderungen machen**: Code bearbeiten
2. **Committen**: Mit aussagekräftiger Message committen
3. **Pushen**: `git push` - Version wird automatisch erhöht
4. **Fertig**: Die GitHub Action erstellt einen automatischen Commit mit der neuen Version

## 🛠️ Setup

Das System ist bereits eingerichtet und benötigt keine weitere Konfiguration. Die GitHub Action läuft automatisch bei jedem Push.

### Voraussetzungen
- Node.js (für lokale Versionsaktualisierung)
- GitHub Repository mit Actions aktiviert

## 📂 Dateien

- `version.json` - Zentrale Versionsdatei
- `scripts/update-version.js` - Script zur Versionsaktualisierung
- `.github/workflows/version-bump.yml` - GitHub Action für automatische Versionierung

## 🔧 Troubleshooting

### Version wird nicht automatisch erhöht

1. Prüfe, ob GitHub Actions aktiviert sind
2. Prüfe, ob der Commit die richtigen Keywords enthält
3. Prüfe die Action-Logs in GitHub unter "Actions"

### Lokale Versionsaktualisierung funktioniert nicht

```bash
# Script ausführbar machen (Unix)
chmod +x scripts/update-version.js

# Manuell ausführen
node scripts/update-version.js build
```

## 📚 Weitere Infos

Bei Fragen oder Problemen, erstelle ein Issue im GitHub Repository.
