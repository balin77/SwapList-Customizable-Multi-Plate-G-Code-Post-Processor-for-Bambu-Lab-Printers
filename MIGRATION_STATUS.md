# Migration Status - SwapMod Monorepo

**Letzte Aktualisierung**: 2025-12-22

## ✅ Abgeschlossene Phasen

### Phase 0: Vorbereitung ✅
- [x] Git-Tag erstellt: `v1.0-pre-migration`
- [x] pnpm global installiert (v10.26.1)
- [x] package.json Backup erstellt
- ⚠️ Rust-Installation manuell erforderlich (für Phase 4: Desktop)

### Phase 1: Monorepo-Struktur ✅
- [x] Monorepo erstellt unter `../swapmod-monorepo/`
- [x] Package-Ordner: `packages/core`, `packages/web`, `packages/desktop`
- [x] Root `package.json` mit workspace scripts
- [x] `pnpm-workspace.yaml` konfiguriert
- [x] `tsconfig.base.json` für gemeinsame TS-Konfiguration
- [x] `.gitignore` für Monorepo

### Phase 2: Core Package (Minimale Version) ✅
**Anpassung vom Original-Plan**:
- Nur UI-unabhängiger Code im Core-Package
- IO/GCODE/Commands bleiben im Web-Package (haben UI-Dependencies)

**Was ist im Core**:
- ✅ `types/` - Alle TypeScript Type Definitions
- ✅ `config/filamentConfig/` - Filament Presets (757 Presets)
- ✅ `utils/` - Reine Utility-Funktionen (colors, time, regex, amsUtils)
- ✅ Erfolgreich kompiliert nach `dist/`

**Was NICHT im Core ist** (bleibt in web/desktop):
- ❌ `io/` - Benötigt DOM/State/Progressbar
- ❌ `gcode/` - Benötigt State Management
- ❌ `commands/` - Benötigt UI-Callbacks
- ❌ `config/materialConfig.ts` - Benötigt DOM-Zugriff

**Exports**:
```typescript
export * from './types/index.js';
export { PRESET_INDEX } from './config/filamentConfig/index.js';
export * from './utils/amsUtils.js';
export * from './utils/colors.js';
export * from './utils/time.js';
export * from './utils/regex.js';
```

### Phase 3: Web Package ✅
- [x] Vollständige Code-Kopie von altem Projekt
- [x] Ordnerstruktur:
  - `src/` - TypeScript Source (komplett)
  - `public/` - Static Assets (HTML, CSS, Icons)
  - `public/dist/` - Build Output
  - `scripts/` - Build & Dev Scripts
- [x] `package.json` mit workspace dependency `@swapmod/core`
- [x] Build-Scripts angepasst (`src/index.ts` → `public/dist/bundle.js`)
- [x] Dependencies installiert (jszip, spark-md5, etc.)
- [x] **Erfolgreich gebaut** (bundle.js: 3.8MB)

**Build-Befehle**:
```bash
pnpm build       # Production Build
pnpm dev         # Dev Server mit Hot Reload auf Port 5173
pnpm typecheck   # TypeScript Type Check
```

## 🚧 Ausstehende Phasen

### Phase 4: Tauri Desktop App ⏳
**Status**: Noch nicht begonnen

**Voraussetzungen**:
- Rust muss installiert sein
- Download: https://rustup.rs/ (Windows)
- Nach Installation: `rustup update`

**Nächste Schritte**:
1. Tauri Projekt initialisieren in `packages/desktop/`
2. Frontend mit Vite konfigurieren
3. UI von Web-Package kopieren/anpassen
4. Tauri-spezifische Features (File Dialogs, Native Menus)
5. Desktop-App bauen und testen

### Phase 5: Git Migration & Deployment ⏳
- [ ] Git History migrieren (optional)
- [ ] GitHub Repository erstellen
- [ ] README.md für Monorepo
- [ ] CI/CD Workflows (.github/workflows/)
- [ ] Web Deployment (Netlify/Vercel)
- [ ] Desktop Releases (GitHub Actions)

## 📊 Projekt-Struktur (Aktuell)

```
swapmod-monorepo/
├── packages/
│   ├── core/              ✅ Kompiliert
│   │   ├── src/
│   │   │   ├── types/
│   │   │   ├── config/filamentConfig/
│   │   │   ├── utils/
│   │   │   └── index.ts
│   │   ├── dist/          (Build Output)
│   │   ├── package.json
│   │   └── tsconfig.json
│   │
│   ├── web/               ✅ Kompiliert
│   │   ├── src/           (Kompletter Source Code)
│   │   ├── public/        (Static Assets + Build Output)
│   │   ├── scripts/       (Build Scripts)
│   │   ├── package.json
│   │   └── tsconfig.json
│   │
│   └── desktop/           ⏳ Noch nicht erstellt
│
├── package.json           ✅ Workspace Root
├── pnpm-workspace.yaml    ✅
├── tsconfig.base.json     ✅
└── .gitignore             ✅
```

## 🎯 Web-Package Status

### Funktionalität
- ✅ Build läuft erfolgreich
- ⏳ Runtime-Test ausstehend (im Browser öffnen)
- ⏳ Feature-Test ausstehend (3MF/GCODE Import)

### Bekannte Unterschiede zum Original
- **Core-Package**: Nur minimale Exports (Types + Utils)
- **Keine Code-Änderungen**: Alle Funktionen bleiben im Web-Package
- **Import-Pfade**: Unverändert (keine @swapmod/core Imports im Code)

## 🔄 Nächste Schritte

1. **Web-Package testen** (prioritär)
   ```bash
   cd packages/web
   pnpm dev
   # Browser öffnen: http://localhost:5173
   # 3MF-Datei testen
   ```

2. **Rust installieren** (für Desktop)
   - Windows: https://rustup.rs/
   - Nach Installation testen: `rustc --version`

3. **Desktop Package erstellen**
   ```bash
   cd packages/desktop
   pnpm create tauri-app .
   ```

4. **Git initialisieren**
   ```bash
   cd swapmod-monorepo
   git init
   git add .
   git commit -m "feat: initial monorepo setup with web package"
   ```

## 📝 Lessons Learned

### Was gut lief:
- pnpm workspace funktioniert einwandfrei
- TypeScript-Konfiguration mit Project References
- Minimaler Core-Package Ansatz (kein Over-Engineering)

### Was angepasst wurde:
- **Original-Plan**: Core mit IO/GCODE/Commands
- **Realität**: Zu viele UI-Dependencies
- **Lösung**: Core nur mit Types + Utils, Rest bleibt in web/desktop

### Empfehlungen:
- Bei zukünftiger Refactoring: UI-Logik schrittweise von Business-Logik trennen
- Dependency Injection nutzen (State/Callbacks als Parameter)
- Eventuell UI-Framework (React/Vue) für bessere Code-Sharing

## 🚀 Deployment Ziele

### Web (Netlify/Vercel)
- Build Command: `cd packages/web && pnpm build`
- Output Directory: `packages/web/public`
- URL: TBD

### Desktop (GitHub Releases)
- Plattformen: Windows, macOS, Linux
- Auto-Updates via Tauri Updater
- Release via GitHub Actions

## ⏱️ Zeitaufwand

| Phase | Geplant | Tatsächlich | Status |
|-------|---------|-------------|--------|
| Phase 0 | 1-2h | ~30min | ✅ |
| Phase 1 | 2-3h | ~30min | ✅ |
| Phase 2 | 4-6h | ~1.5h | ✅ (vereinfacht) |
| Phase 3 | 3-4h | ~1h | ✅ |
| **Total** | 10-15h | **~3.5h** | ✅ |

Phase 4-9 noch ausstehend (geschätzt: ~25h)

## 📞 Support & Fragen

Bei Problemen mit:
- **Build-Errors**: Prüfe `pnpm install` in Root & Package
- **Import-Errors**: Prüfe `pnpm build` in `packages/core` zuerst
- **Port-Konflikte**: Dev-Server Port in `scripts/dev.mjs` ändern

---

**Status-Legende**:
- ✅ Abgeschlossen
- 🚧 In Arbeit
- ⏳ Ausstehend
- ⚠️ Benötigt Aufmerksamkeit
- ❌ Nicht geplant/Entfernt
